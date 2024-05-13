import numpy as np
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import RBF, ConstantKernel as C
import pymbar
from pymbar import timeseries
from pymbar.utils import kn_to_n
from IPython import embed


class mbar_pmf(object):
    """Postprocess umbrella sampling simulations with MBAR."""
    def __init__(self, val_kn, val0_k, K_k, temperature, tol=1.0e-8, u_kn=None, u_kln=None):
        """Postprocess umbrella sampling simulations with MBAR.

        Keyword arguments:
        val_kn -- val_kn[k] is collective variables (in A) for umbrella simulation k
        val_0 -- val_0[k] is the spring center location (in A) for umbrella simulation k
        K --  K[k] is the spring constant (in kcal/mol/A**2) for umbrella simulation k
        temperature -- temperature in Kelvin
        """

        kB = 1.38064852e-23 * 6.022140857e23 / 1000.0 / 4.184 # Boltzmann constant in kcal/mol/K
        # kB = 0.001982923700 # Grossfield's Wham
        self.temperature = temperature
        self.beta = 1.0 / (kB * self.temperature) # inverse temperature of simulations (in 1/(kcal/mol))

        self.val0_k = val0_k
        self.K_k = K_k

        self.K = len(val_kn)
        self.N_k = np.array([len(val) for val in val_kn], int)
        self.N_max = np.max(self.N_k)

        try:
            self.dim = val0_k.shape[1]
        except IndexError:
            self.dim = 1

        self.val_kn = np.zeros((self.K, self.N_max, self.dim), float)
        mask = np.arange(self.N_max) < np.array(self.N_k)[:,None]
        self.val_kn[mask] = np.concatenate(val_kn)
        self._u_kn = np.zeros((self.K, self.N_max))

        if u_kn is not None:
            self._u_kn0 = u_kn * self.beta
        else:
            self._u_kn0 = np.zeros((self.K, self.N_max))

        if u_kln is not None:
            self._u_kln = u_kln * self.beta
            self._u_kn0 = np.zeros((self.K, self.N_max))
        else:
            self._u_kln = np.zeros([self.K, self.K, self.N_max], float)

        # Evaluate reduced energies in all umbrellas
        for k in range(self.K):
            for n in range(self.N_k[k]):
                for l in range(self.K):
                    # Compute deviation from umbrella center l
                    dval = self.val_kn[k,n] - self.val0_k[l]

                    # Compute energy of snapshot n from simulation k in umbrella potential l
                    self._u_kln[k,l,n] += self._u_kn0[k,n] + self.beta * ((self.K_k[l]/2.0) * dval**2).sum()

            self._u_kn[k] = self._u_kln[k, k]

        self.mbar = pymbar.MBAR(self._u_kln, self.N_k, verbose=True, initialize='BAR', relative_tolerance=tol)

    def get_pmf(self, val_min, val_max, nbins, u_kn=None, **kargs):
        bin_edges = np.linspace(val_min, val_max, nbins+1)
        bin_centers = np.zeros(nbins)
        for i in range(nbins):
            bin_centers[i] = (bin_edges[i] + bin_edges[i+1]) / 2.0
        bin_kn = np.digitize(self.val_kn[:, :, 0], bin_edges) - 1
        # for i in range(nbins):
        #     print(bin_centers[i], np.sum(bin_kn==i))
        if u_kn is None:
            _u_kn = self._u_kn0
        else:
            _u_kn = u_kn * self.beta
        (f_i, df_i) = self.mbar.computePMF(_u_kn, bin_kn, nbins, **kargs)

        Log_W_n = self.mbar._computeUnnormalizedLogWeights(kn_to_n(self._u_kn, N_k=self.N_k))
        W_n = np.exp(Log_W_n)
        W_n /= W_n.sum()
        bin_n = kn_to_n(bin_kn, N_k=self.N_k)
        du_n = kn_to_n((_u_kn - _u_kn.min()) - (self._u_kn0 - self._u_kn0.min()), N_k=self.N_k)

        reweighting_entropy = np.zeros_like(f_i)
        for i in range(nbins):
            P = W_n[bin_n==i] * np.exp(-1*du_n[bin_n==i])
            P /= P.sum()
            reweighting_entropy[i] = -1 * (P * np.log(P)).sum() / np.log(len(P))

        return bin_centers, (f_i - f_i.min())/self.beta, df_i/self.beta, reweighting_entropy

    def get_reweighted_tp(self, bin_centers, f_i, reweighting_entropy, alpha=1.0):
        x = bin_centers.reshape(-1, 1)
        y = f_i.reshape(-1, 1)
        _alpha = alpha / np.exp(-1 * reweighting_entropy)

        kernel = C(1.0, (1e-5, 1e5)) * RBF(10, (1e-5, 1e5))
        gp = GaussianProcessRegressor(kernel=kernel, alpha=_alpha, n_restarts_optimizer=100)

        gp.fit(x, y)
        y_pred, sigma = gp.predict(x, return_std=True)
        
        # return y_pred - y_pred.min(), sigma
        return y_pred, sigma, gp.log_marginal_likelihood_value_
