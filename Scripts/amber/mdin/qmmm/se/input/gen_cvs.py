#!/scratch/van/shared_envs/ambertools23/bin/python
import os
import sys
import numpy as np
import pytraj as pt


# label, atom mask 1 , atom mask 2, state A bond distance, state B bond ditance
masks = np.array([
    ['BB', ':332&@NZ', ':471&@H6'],
    ['BF', ':471&@O3', ':471&@H6'],
])

n_windows = 40

parm = 'step3_pbcsetup.parm7'
cord = 'step3_pbcsetup.ncrst'
traj = pt.load(cord, parm)

for n in range(n_windows):
    fname = "../%02d/cv.rst" % n
    with open(fname, 'w') as f:
        for mask in masks:
            mlabel = mask[0]
            mask1 = mask[1]
            mask2 = mask[2]
            dist1 = float(mask[3])
            dist2 = float(mask[4])

            atm1 = traj.top.select(mask1)[0] + 1 
            atm2 = traj.top.select(mask2)[0] + 1 
        
            f.write(f'# {mlabel} {mask1} {mask2}\n')
            f.write(f' &rst\n')
            f.write(f'  iat={atm1},{atm2},\n')
            f.write(f'  r1=0, r2={REST:.2f}, r3={REST:.2f}, r4=10,\n')                
            f.write(f'  rk2=150.0, rk3=150.0,\n')
            f.write(f'  rk2=150.0, rk3=150.0,\n')
            f.write(f' &end\n')
