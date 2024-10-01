#!/scratch/van/shared_envs/ambertools23/bin/python
"""
EXPERIMENTAL: Written for Evan Jones aldol reaction
"""
import os
import sys
import numpy as np
import pytraj as pt


# label, atom mask 1 , atom mask 2, state A bond distance, state B bond ditance
masks = np.array([
    ['PA1', ':332&@NZ', ':471&@H6', 5.00, 1.00, 4.50],
    ['PL1', ':471&@O3', ':471&@H6', 1.00, 1.00, 5.00],
    [  'A', ':471&@C6', ':471&@C7', 1.00, 1.00, 5.00],
    ['PA2', ':471&@N3',':13574&@H2', 3.00, 1.00, 5.00],
    ['PL2', ':13574&@O',':13574&@H2', 1.00, 3.50, 1.00],
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
            dist3 = float(mask[5])

            if dist1 == dist2 and mlabel in ['PL1', 'A']:
                REST = np.linspace(dist1, dist3, n_windows)[n]
            elif dist1 != dist2 and n <= 19 and mlabel in ['PA1', 'PA2', 'PL2']:
                REST = np.linspace(dist1, dist2, 20)[n]
            elif dist1 != dist2 and n >= 20 and mlabel in ['PA1', 'PA2', 'PL2']:
                REST = np.linspace(dist2, dist3, 20)[n-20]

            atm1 = traj.top.select(mask1)[0] + 1 
            atm2 = traj.top.select(mask2)[0] + 1 
        
            f.write(f'# {mlabel} {mask1} {mask2}\n')
            f.write(f' &rst\n')
            f.write(f'  iat={atm1},{atm2},\n')
            f.write(f'  r1=0, r2={REST:.2f}, r3={REST:.2f}, r4=10,\n')                
            f.write(f'  rk2=150.0, rk3=150.0,\n')
            f.write(f' &end\n')
