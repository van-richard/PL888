#!/usr/bin/env python
import os       
import re
from glob import glob                               
import pytraj as pt                  

# class anlys():
#     def __init__(self, parm, trajectory, data):
#         self.parm = None
#         self.trajectory = None
#         self.data = None

#     def load_trajectory(self, self.parm, self.trajectory):
#         self.data = pt.iterload(self.trajectory, top=self.parm)


# def load_trajectory(trajectory, parm):
#    return pt.iterload(trajectory, top=parm)

def load_trajectory(verbose=True):

   workdir = os.path.abspath(os.path.dirname(os.getcwd()))
   
   if verbose == True:
      traj_name = input('trajectory filename (prod, step5): ')
      parm_name = input('topology filename: ')

      trajectory = sorted(glob(f'{traj_name}*.nc'))
      parm=f'{workdir}/{parm_name}.parm7'

      if len(trajectory) == 0:
         print('Traj not found: ', trajectory)
         exit()
      
      if os.path.isfile(parm) == False:
            print('Parm not found: ', parm)
            exit()

   else:
      trajectory = sorted(glob(f'prod*.nc'))
      parm = 'step3_pbcsetup.parm7'
   
   pt.iterload(trajectory, top=parm)

