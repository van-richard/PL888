import os
import sys
import argparse
from glob import glob

def whereami():
    current_wdir = os.path.abspath(os.getcwd())
    project_path = os.path.dirname(current_wdir)
    #print('Current directory: {current_wdir}')
    #print('Project directory: {project_path}')
    return current_wdir, project_path



def mkdir(dirname):
    os.makedirs(dirname, exist_ok=True)
    os.chdir(dirname)

def count_name(name):
    """ 
    Create a new directory to save the results. Index directories by number of runs.
    """
    number = len(glob(f'{name}*'))
    name_number = f'{name}{number}'
    return name_number

def parse_input():
    # print(sys.argv)
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--parm', type=str, default='step3_pbcsetup')
    parser.add_argument('-x', '--nc', type=str, default='prod')
    parser.add_argument('-m', '--mask', type=str, default='@CA')
    return parser.parse_args()
