#!/usr/bin/env python
import os
import pytraj as pt
import matplotlib.pyplot as plt


# In[2]:


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

# Load trajectory
traj = pt.iterload(cord, top=parm)

mat = pt.pairwise_rmsd(traj, mask=atommask)

# Plotting
axis_label = "Frame Number"
colormap = "jet"
rmsd_max = 3.0 

im = plt.imshow(mat, cmap=colormap,vmax=rmsd_max)
plt.colorbar(im, fraction=0.046, pad=0.04, label='2D-RMSD')

plt.xlabel('Frame Number')
plt.ylabel('Frame Number')
plt.gca().invert_yaxis()
plt.savefig('img/rmsd2d.png', dpi=300)

