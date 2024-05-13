"""
Run this in mbar directory

Help organize freefile_mbar files
"""

from glob import glob
import sys
import os

wdir = os.getcwd()
n_dirs = os.listdir()

if 'mbar' not in n_dirs:
    os.makedirs('mbar')


os.makedirs("results", exist_ok=True)

folders = sorted(glob("results/run??"))

if len(folders) == 0:
    run_number = 0
else:
    run_number = len(folders)

os.makedirs("results/run%02d" % run_number)

