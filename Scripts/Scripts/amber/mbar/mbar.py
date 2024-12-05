#!/usr/bin/env python
# coding: utf-8

# # MBAR 
# 

# In[3]:


import sys
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator, LogLocator, NullFormatter
from glob import glob
from sklearn.utils import resample


# In[4]:


import pymbar
from pymbar.mbar_pmf import mbar_pmf


# In[5]:


pwd


# In[6]:


# from glob import glob
n_windows = 42
val_min = -1.90
val_max = 2.20
fc = 300.0
nbins = n_windows - 1


# In[7]:


val_kn = []
for i in range(n_windows):
    fnames = sorted(glob('../test/mbar/%02d/step6.0?_equilibration.cv' % i))
    arrays = [np.loadtxt(f, usecols=1)[::] for f in fnames[:]]
    val_kn.append(np.concatenate(arrays))
val0_k = np.linspace(val_min, val_max, n_windows)
K_k = np.ones(n_windows) * fc


# In[8]:


for i in range(n_windows):
    print("Window %02d:" % i, pymbar.timeseries.subsampleCorrelatedData(val_kn[i], conservative=True))


# In[9]:


# mbar = mbar_pmf(val_kn, val0_k, K_k, 300.0, u_kn=np.array(ene_pm3))
mbar = mbar_pmf(val_kn, val0_k, K_k, fc)


# In[10]:


bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(val_min, val_max, nbins)
bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(val_min, val_max, nbins, uncertainties='from-specified', pmf_reference=f_i[:20].argmin())
np.savetxt("freefile_mbar", np.column_stack((bin_centers, f_i, df_i)))


# In[11]:


initial = np.loadtxt("freefile_mbar")
plt.xlabel("R1 - R2 (Å)")
plt.ylabel("Potential of Mean Force (kcal/mol)")

plt.errorbar(initial[:,0], initial[:,1] - initial[:10,1].min(), yerr=initial[:,2], linewidth=1, label="DFT")

plt.legend(loc=2)
plt.savefig("pmf.png", dpi=300)
plt.show()

print(round(initial[:,1].max() - initial[:10,1].min(),1), round(initial[initial[:,1].argmax()][2],1))


# In[ ]:




