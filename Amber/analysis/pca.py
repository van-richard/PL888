#!/usr/bin/env python
import os
import pytraj as pt
import matplotlib.pyplot as plt

# Topology file
pname="../step3_pbcsetup"
pformat="parm7"

# Trajectory file 
tname='../prod*'
tformat='nc'

# Atom mask selection
atommask='@CA'

parm = f'{pname}.{pformat}'
cord = f'{tname}.{tformat}'

os.makedirs('img', exist_ok=True)
os.makedirs('raw_data', exist_ok=True)

"""
Pytraj template for MD trajectory analysis
"""

{% include 'set_pytraj_import.j2' %}

{% include 'set_pytraj_input.j2' %}

# RMSF Analysis (_trajectory is(are) trajectory file(s), _mask is the Amber format selection mask)
data = pt.pca(_trajectory, mask=ambermask, n_vecs=10)

# Projection Data
_data = data[0]
pc1_data = data[1][0]                                       # Eiganvalues for first mode (percent)
pc2_data = data[1][1]                                       # Eiganvalues for second mode (percent)

# Percent Variance
x_label = pc1_data / np.sum(data[1][:])) * 100
x_label = pc2_data / np.sum(data[1][:])) * 100

flip1 = 1                                                   # Flip the sign of the eigenvector if necessary (1 or -1)
flip2 = 1                                                   # Flip the sign of the eigenvector if necessary (1 or -1)
x_data = _data[0] * flip1
y_data = _data[1] * flip2

plt.scatter(x_data, y_data, marker='o', c=range(traj.n_frames), alpha=0.5)

plt.xlabel(f"PC1 ({ str(np.round(pc1_data, 1) } %)")        # Label x-axis
plt.ylabel(f"PC2 ({ str(np.round(pc2_data, 1) } %)")        # Label y-axis

axis_lim = 60                                               # Set axis limit
plt.xlim(-axis_lim, axis_lim)                               # Set x-axis limit
plt.ylim(-axis_lim, axis_lim)                               # Set y-axis limit
cbar = plt.colorbar()                                       # Show colorbar
cbar.set_label('Frame Number')                              # Label colorbar
plt.savefig(f'img/{ analysis }.png')                        # Save plot
