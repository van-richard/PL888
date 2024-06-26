#!/usr/bin/env python
import os                                      
from glob import glob
import pytraj as pt                  
import numpy as np


def calc_rmsd(trajectory, mask='@CA'):
    return pt.rmsd(trajectory, mask=mask)

def calc_rmsd2d(trajectory, mask='@CA'):
    return pt.pairwise_rmsd(trajectory, mask=mask)

def calc_rmsf(trajectory, mask='@CA'):
    traj = pt.superpose(trajectory, ref=0, mask=mask)
    return pt.rmsf(traj, mask=mask)
    
def calc_pca(trajectory, mask='@CA', vecs=10):
    return pt.pca(trajectory, mask=mask, n_vecs=vecs)
