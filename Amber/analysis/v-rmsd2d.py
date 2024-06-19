#!/usr/bin/env python
import os
import pytraj as pt
import matplotlib.pyplot as plt


def rmsd(traj, ambermask='@CA'):
    return pt.rmsd(traj, mask=ambermask)

def pairwise_rmsd(traj, ambermask='@CA'):
    return pt.pairwise_rmsd(traj, mask=ambermask)

def pca(traj,ambermask, num_vecs):
    results = pt.pca(traj, mask=ambermask, n_vecs=num_vecs)
    
#     data = results[0]
#     pc1_proj = data[1][0]
#     pc2_proj= data[1][1]
# 
#    pc1_var = pc1_proj[0] / np.sum(pc1_proj[:]) 
#    pc2_var = pc2_proj[0] / np.sum(pc2_proj[:]) 
   return results


