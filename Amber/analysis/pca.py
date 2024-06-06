#!/usr/bin/env python
import os
from glob import glob
import pytraj as pt
import numpy as np
import matplotlib.pyplot as plt

analysis="combine-all"
prm="../input/step3_pbcsetup.parm7"
crd="combine-nc/all.nc"
# Atom mask selection
ambermask='@CA'

os.makedirs('img', exist_ok=True)
os.makedirs('raw_data', exist_ok=True)

"""
Pytraj template for MD trajectory analysis
"""

traj = pt.iterload([crd], top=prm)
# RMSF Analysis (_trajectory is(are) trajectory file(s), _mask is the Amber format selection mask)
data = pt.pca(traj, mask=ambermask, n_vecs=10)

# Projection Data
_data = data[0]
pc1_data = data[1][0]                                       # Eiganvalues for first mode (percent)
pc2_data = data[1][0]                                       # Eiganvalues for second mode (percent)

# Percent Variance
x_label = (pc1_data[0] / np.sum(pc1_data[:])) * 100
y_label = (pc2_data[1] / np.sum(pc2_data[:])) * 100

flip1 = 1                                                   # Flip the sign of the eigenvector if necessary (1 or -1)
flip2 = 1                                                   # Flip the sign of the eigenvector if necessary (1 or -1)
x_data = _data[0] * flip1
y_data = _data[1] * flip2

plt.scatter(x_data, y_data, marker='o', c=range(traj.n_frames), alpha=0.5)

plt.xlabel(f"PC1 ({ str(np.round(x_label, 1)) } %)")        # Label x-axis
plt.ylabel(f"PC2 ({ str(np.round(y_label, 1)) } %)")        # Label y-axis

axis_lim = 10                                               # Set axis limit
plt.xlim(-axis_lim, axis_lim)                               # Set x-axis limit
plt.ylim(-axis_lim, axis_lim)                               # Set y-axis limit
cbar = plt.colorbar()                                       # Show colorbar
cbar.set_label('Frame Number')                              # Label colorbar
plt.grid(linestyle='--', alpha=0.2)
plt.savefig(f"img/pca-{ analysis }.png")                        # Save plot
