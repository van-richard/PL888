#!/scratch/van/shared_envs/mbar/bin/python
import os
import sys
import argparse
from glob import glob
import numpy as np
sys.path.append('/home/van/Scripts/mbar')
import readcv
from organize import whereami, count_name

def concatenate_arrays(windows, fname, start, end):
    """
    Concatenate arrays and return a slice of the concatenated array.
    """
    val_kn=[]
    for window in windows:
        path = f'{window}/{fname}'
        fnames = sorted(glob(path))
        array = [np.loadtxt(f, usecols=1)[::] for f in fnames[:]]
        if end == 0:
            val_kn.append(np.concatenate(array)[:])
        else:
            val_kn.append(np.concatenate(array)[start:end])
    return val_kn

def length_of_arrays(arrays):
    """
    Count number CV values and find the window with least CVs. This will be the cutoff for windows that are a few steps ahead 
    """
    length = []
    for i in arrays:
        length.append(len(i))
    return min(length)


def main():
    if args.slideby == 0:
        # Option 1
        val_kn = concatenate_arrays()
        bc, fi, dfi, re = run_mbar(val_kn)

    else:
        # Option 2 
        # Convert ps to step, adjust for number of CV values in *.cv
        slide = int(args.slideby / args.timestep / args.savefreq) 

       # Get smallest number of CV values for analysis
        max_length=length_of_arrays(concatenate_arrays())
#[np.concatenate(load_cvs_from(w)) for w in list_windows()])
        for j in range(0, max_length, slide):
            val_kn = concatenate_arrays(start=j, step=j+slide)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--step', type=str, default='step6')
    parser.add_argument('-idx', '--index', type=str, default='0\?')
    parser.add_argument('-strt', '--start', type=int, default='0')
    parser.add_argument('-end', '--end', type=int, default='0')
    parser.add_argument('--output', type=str, default='results')
    args = parser.parse_args()
    windows, n_windows = get_windows()
    args = parse_input()
    

