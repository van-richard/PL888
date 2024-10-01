#!/scratch/van/shared_envs/ambertools23/bin/python
"""
Get number of frames from Amber trajectory (.nc)
"""
import os
import sys
from glob import glob
import pytraj as pt

"""
Count the total number of frames from Amber NC files

./n_frames.py [PARMFILENAME].parm7 [PRODFILENAME]
"""

PARM = sys.argv[1]  # First option is Amber PARM7 filename (step3_pbcsetup.parm7)
PROD= sys.argv[2]   # Second option is Amber NC filename (prod)

TRAJ = sorted(glob(f'{PROD}*.nc'))

traj = pt.iterload(TRAJ, PARM)

print(f'PARM7: {PARM}')
print(f'NC: {TRAJ}')
print(f'Number of frames: {traj.n_frames}')
