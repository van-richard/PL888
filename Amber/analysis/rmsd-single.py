#!/usr/bin/env python

# Importing libraries, modules, and functions
import os                                               # File system operations
from glob import glob
import pytraj as pt                                     # Trajectory analysis
import matplotlib.pyplot as plt                         # Plotting
import numpy as np

plt.rcParams['figure.constrained_layout.use'] = True

# Input parameters
project_dir=os.getcwd().split('/')[-1]
os.makedirs('img', exist_ok=True)                       # Make directory for images

# Load topology: `prmtop` or `parm7` format
parm_file = "step3_pbcsetup"
parm_format = "parm7"

# Coordinate file(s): `rst7` or `nc` format
cord_file = "prod*"
cord_format = "nc"
cord_files = sorted(glob(f'{cord_file}.{cord_format}'))

# Atom mask for selection
ambermask = "@CA"

# Load trajectory
_trajectory = pt.iterload(cord_files, top=f'{parm_file}.{parm_format}')

# RMSD Analysis (_trajectory is(are) trajectory file(s), _mask is the Amber format selection mask)
_data = pt.rmsd(_trajectory, mask=ambermask)

time = len(_data)                                # FIXTHIS: Total simulation time
x_data = np.arange(time)                         # Time values
y_data = _data                                    # RMSF values

x_label="Time (ns)"                              # X-axis label
y_label="RMSD ($\mathrm{\AA}$)"                   # Y-axis label

# Plot 
plt.plot(x_data, y_data)                                    # Plot
plt.xlabel(x_label, fontsize=13)                            # Label x-axis
plt.ylabel(y_label, fontsize=13)                            # Label ydata
plt.grid(linestyle='--', alpha=0.2)
plt.savefig(f'img/rmsd-{project_dir}.png')                                # Save plot

# Save data
os.makedirs('data', exist=ok=True)
np.savetxt(f'data/rmsd-{project_dir}.txt', np.column_stack([x_data, y_data]), header=f"Time \t RMSD")


