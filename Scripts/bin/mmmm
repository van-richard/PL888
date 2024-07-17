#!/scratch/van/shared_envs/mbar/bin/python
import os
import sys
import argparse
from glob import glob
import numpy as np
import pandas as pd
from scipy import stats
from sklearn.utils import resample

import pymbar
from pymbar.mbar_pmf import mbar_pmf

sys.path.append('/home/van/Scripts/bin')
import readcv
from organize import whereami, count_name
from quickplot import quickmbar

def parse_input():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--stepfile', type=str, default='step6')
    parser.add_argument('-sb', '--slideby', type=int, default='0')
    #parser.add_argument('-sb', '--slideby', type=int, default='5')
    parser.add_argument('-f', '--freefile', type=str, default='freefile_mbar')
    parser.add_argument('-dt', '--timestep', type=float, default='0.001')
    parser.add_argument('-sf', '--savefreq', type=int, default='10')
    parser.add_argument('--ref', type=str, help='reference freefile')
    parser.add_argument('--output', type=str, default='results')
    return parser.parse_args()


def find_subdirectories(path):
    return next(os.walk(path))[1]

def list_windows():
    windows = []
    cwd, pd = whereami()
    subdirs = find_subdirectories(cwd)
    for subdir in subdirs:
        if len(subdir) == 2 and subdir.isdigit():
            windows.append(subdir)
    return sorted(windows)


def concatenate_arrays(start=0, stop=None):
    args = parse_input()
    """
    Concatenate arrays and return a slice of the concatenated array.
    """
    val_kn=[]
    for window in list_windows():
        path = f'{window}/{args.stepfile}*cv'
        fnames = sorted(glob(path))
        array = [np.loadtxt(f, usecols=1)[::] for f in fnames[:]]
        if args.slideby == 0:
            val_kn.append(np.concatenate(array)[:])
        else:
            val_kn.append(np.concatenate(array)[start:stop])
    return val_kn

def length_of_arrays(arrays):
    """
    Count number CV values and find the window with least CVs. This will be the cutoff for windows that are a few steps ahead 
    """
    length = []
    for i in arrays:
        length.append(len(i))
    return min(length)


def subsample_data(val_kn):    
    """
    Subsample correlated data using PyMBAR.
    """
    for i in range(len(val_kn)):
        print("Window %02d:" % i, pymbar.timeseries.subsampleCorrelatedData(val_kn[i], conservative=True))



def run_mbar(val_kn, frame_number=None):
    """
    Estimate the free energy profile using MBAR.

          val_kn (list of arrays )   : Array has shape  -- [ n_windows x CV values ]
          outdir (results directory) : Directory to save results, new folders are indexed
        filename (MBAR energies)     : NumPy file with MBAR energies / errors
    frame_number (integer or None)   : Frame number of start frame in sliding uncertainty calculation
    """
    args = parse_input()
    # Compute MBAR
    mbar = mbar_pmf(val_kn, val0_k, K_k, force_constant)
    bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(cv_min, cv_max, nbins)
    bin_centers, f_i, df_i, reweighting_entropy = mbar.get_pmf(cv_min, cv_max, nbins, uncertainties='from-specified', pmf_reference=f_i[:20].argmin())

    if frame_number is None:
        # Save freefile_mbar from all step6 trajectories 
        np.savetxt(f'{outdir}/{args.freefile}', np.column_stack((bin_centers, f_i, df_i)))
    else:
        # Save freefile_mbar[Start frame Number] from sliding uncertainty
        np.savetxt(f'{outdir}/{args.freefile}{frame_number}', np.column_stack((bin_centers, f_i, df_i)))
    return bin_centers, f_i, df_i, reweighting_entropy



def main():
    args = parse_input()
    """
    Two approaches:
        1. All trajectories (for each window) are concatenate and used to estimate the free energy profile
            - Set 'slide_by=0' to run analysis on all trajectories.
        2. Slide along a moving window (not umbrella window, but segment/portion of trajectory) to estimate the free energy profiles
            - See how free energy profile converges over simulation time
            - Set 'slide_by=5' to run analysis on sliding window of 5 ps.

      windows (integer)    : Total number of umbrella windows
     slide_by (picosecond) : Calculate MBAR via sliding window, e.g. calculate every 5 ps (segment) with entire trajectory
           dt (picosecond) : Integration timestep (usually 0.001 ps ~ 1 fs)
    save_freq (time-step)  : Saving frequency of CV values during simulation (usually 10 steps ~ 0.01 ps)
    """

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
            bc, fi, dfi, re = run_mbar(val_kn, frame_number='%04d' % j)

    quickmbar(outdir=f'{outdir}')


if __name__ == '__main__':
    # estimate_free_energy(n_windows, slide_by=5)
    n_windows = len(list_windows())
    cv_min = readcv.get_cv_value(window=list_windows()[0])
    cv_max = readcv.get_cv_value(window=list_windows()[-1])
    force_constant = readcv.get_force_constant() * 2.0

    # Reference restraint values
    val0_k = np.linspace(cv_min, cv_max, n_windows)

    # Restraint force values ('rk2'/'rk3')
    K_k = np.ones(n_windows) * force_constant        

    # Number of bins 
    nbins = n_windows - 1
    args = parse_input()
    outdir = count_name(f'{args.output}')
    os.makedirs(outdir, exist_ok=True)
    
    main()

