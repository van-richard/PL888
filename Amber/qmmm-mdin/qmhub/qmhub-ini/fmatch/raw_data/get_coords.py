#!/usr/bin/env python
import numpy as np

qm_atoms = 73
n_windows = 42

for i in range(n_windows):
    qm_coords = []
    for j in range(0, 500, 2):
        f = np.loadtxt('../../%02d/qmhub/qmmm.inp_%04d' % (i,j), skiprows=1, usecols=(0,1,2), max_rows=73)
        qm_coords.append(f)
        
    np.save('../../%02d/qm_coords.npy' % i, qm_coords)
