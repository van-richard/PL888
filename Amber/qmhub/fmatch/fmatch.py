#!/usr/bin/env python
import sys
import logging

import numpy as np
from scipy import optimize

from training_set_sqm import get_sqm_force_batch, get_element_symbols

sys.path.append("/scratch/van/Scripts/")
#from training_set_sqm import get_sqm_force_batch, get_element_symbols
from sqm_param2 import SQM_PARAM


def mse(energy, qm_grad, mm_esp, mm_esp_grad, ref_energy, ref_qm_grad, ref_mm_esp, ref_mm_esp_grad, weights=None, logger=None):
    x2_energy = np.mean(((energy - energy.mean()) - (ref_energy - ref_energy.mean()))**2 / np.var(ref_energy))
    x2_qm_grad = np.mean((np.linalg.norm(qm_grad - ref_qm_grad, axis=2)**2) / np.mean(np.linalg.norm(ref_qm_grad, axis=2)**2))
    x2_mm_esp = np.mean((mm_esp - ref_mm_esp)**2 / np.var(ref_mm_esp))
    x2_mm_esp_grad = np.mean((np.linalg.norm(mm_esp_grad - ref_mm_esp_grad, axis=2)**2) / np.mean(np.linalg.norm(ref_mm_esp_grad, axis=2)**2))
    if logger is not None:
        logger.info(f"energy: {x2_energy}, qm_grad: {x2_qm_grad}, mm_esp: {x2_mm_esp}, mm_esp_grad: {x2_mm_esp_grad}")
    return np.average([x2_energy, x2_qm_grad, x2_mm_esp, x2_mm_esp_grad], weights=weights)


class FMatch(object):
    def __init__(self, method, elements, charge=0, mult=1):
        self.method = method
        self.elements = elements
        self.charge = charge
        self.mult = mult
        self.params = SQM_PARAM(get_element_symbols(elements), method)

    def run(self, batch, pert=None):
        if pert is not None:
            param = self.params.pert_params(pert)
        else:
            param = None

        return get_sqm_force_batch(*batch, charge=self.charge, mult=self.mult, method=self.method, param=param)

    def objective_function(self, batch, training_data, penalty=1e-5):
        def func(pert, logger=None):
            res = self.run(batch, pert)
            obj = mse(*res, *training_data, logger=logger)
            reg = penalty * np.linalg.norm(pert)**2
            if logger is not None:
                logger.info(f"L2 penalty: {reg}")
            return obj + reg
        return func

    def get_jac(self, func, delta=1e-6, mode='two'):
        def jac(pert):
            derivparams = []
            if mode.lower() == 'one':
                derivparams.append(pert)
                for i in range(len(pert)):
                    copy = np.array(pert)
                    copy[i] += delta
                    derivparams.append(copy)
            elif mode.lower() == 'two':
                for i in range(len(pert)):
                    copy = np.array(pert)
                    copy[i] += delta
                    derivparams.append(copy)
                for i in range(len(pert)):
                    copy = np.array(pert)
                    copy[i] -= delta
                    derivparams.append(copy)
            else:
                raise ValueError("Mode should be 'one' or 'two'.")

            obj = np.zeros(len(derivparams))
            for i, pert in enumerate(derivparams):
                obj[i] = func(pert)

            if mode.lower() == 'one':
                res = (obj[1:] - obj[0]) / delta
            elif mode.lower() == 'two':
                res = (obj[:len(pert)] - obj[len(pert):]) / (2.0 * delta)
            else:
                raise ValueError("Mode should be 'one' or 'two'.")

            return res
        return jac


if __name__ == "__main__":
    import logging
    from scipy import optimize

    fmatch = FMatch("PM3", [1, 6, 7, 8, 12, 15], charge=0, mult=1)

    qm_coord = np.load("raw_data/qm_coord.npy")
    qm_element = np.loadtxt("raw_data/qm_elem.txt", dtype=int)
    mm_coord = np.load("raw_data/mm_coord.npy")
    mm_charge = np.load("raw_data/mm_charge.npy")

    energy = np.load("raw_data/energy.npy")
    qm_grad = np.load("raw_data/qm_grad.npy")
    mm_esp = np.load("raw_data/mm_esp.npy")
    mm_esp_grad = np.load("raw_data/mm_esp_grad.npy")
    
#     qm_coord = np.load("raw_data/qm_coord.npy")[:22000:100]
#     qm_element = np.loadtxt("raw_data/qm_elem.txt", dtype=int)
#     mm_coord = np.load("raw_data/mm_coord.npy")[:22000:100]
#     mm_charge = np.load("raw_data/mm_charge.npy")[:22000:100]
# 
#     energy = np.load("raw_data/energy.npy")[:22000:100]
#     qm_grad = np.load("raw_data/qm_grad.npy")[:22000:100]
#     mm_esp = np.load("raw_data/mm_esp.npy")[:22000:100]
#     mm_esp_grad = np.load("raw_data/mm_esp_grad.npy")[:22000:100]

    batch = (qm_coord, qm_element, mm_coord, mm_charge)
    training_data = (energy, qm_grad, mm_esp, mm_esp_grad)

    func = fmatch.objective_function(batch, training_data, penalty=1e-5)
    jac = fmatch.get_jac(func)
    x0 = np.zeros(len(fmatch.params))
    #x0 = np.load('checkpoint.npy')

    logger = logging.getLogger('FMatch')
    logger.setLevel(logging.INFO)
    ch = logging.StreamHandler()
    logger.addHandler(ch)
    logger.info("FMatch starts...")

    def callback(xk):
        # print(xk)
        np.save("checkpoint", xk)
        logger.info(f"Objective function: {func(xk, logger=logger)}")

    res = optimize.minimize(func, x0, method="BFGS", jac=jac, options={'disp': True, 'maxiter': 120, 'gtol': 1e-6},  callback=callback)
    print(res)
    np.save("checkpoint", res['x'])
    #x0 = res['x']
    #x0 = np.load("checkpoint.npy")
    #fmatch.params.write_params(".", pert=x0)
