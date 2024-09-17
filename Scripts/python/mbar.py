#!/usr/bin/bash

istep=$1
n_windows=$2
val_min=$3
val_max=$4

apptainer exec ~/Programs/apptainer/apps/miniforge3/mbar.sif python -c "
import sys
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator, LogLocator, NullFormatter
from glob import glob
from sklearn.utils import resample

import pymbar
from pymbar import mbar_pmf 

step = sys.argv[1]
n_windows = sys.argv[2]
val_min = sys.argv[3]
val_max = sys.argv[4]

val_kn = []
for i in range(n_windows):
    fnames = sorted(glob('../%02d/%s_equilibration.cv' % (i, step)))
    arrays = [np.loadtxt(f, usecols=1)[::] for f in fnames[:]]
    val_kn.append(np.concatenate(arrays)[::])
val0_k = np.linspace(val_min, val_max, n_windows)
K_k = np.ones(n_windows) * 300.0
nbins = n_windows -1 

for i in range(n_windows):
    print('Window %02d:' % i, pymbar.timeseries.subsampleCorrelatedData(val_kn[i], conservative=True))

# mbar = mbar_pmf(val_kn, val0_k, K_k, 300.0, u_kn=np.array(ene_pm3))
mbar = mbar_pmf(val_kn, val0_k, K_k, 300.0)

# bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(val_min, val_max, nbins, u_kn=np.array(ene_pm3))
bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(val_min, val_max, nbins)
bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(val_min, val_max, nbins, uncertainties='from-specified', pmf_reference=f_i[:20].argmin())
np.savetxt('freefile_mbar', np.column_stack((bin_centers, f_i, df_i)))

initial = np.loadtxt('freefile_mbar')
print(round(initial[:,1].max() - initial[:10,1].min(),1), round(initial[initial[:,1].argmax()][2],1))
"
