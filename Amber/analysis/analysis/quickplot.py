#!/usr/bin/env python
import os                                               
import matplotlib.pyplot as plt                         
import numpy as np


def quickplot(xdata, ydata, xlabel, ylabel, name=None):
    fig, ax = plt.subplots()

    ax.plot(xdata, ydata)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    
    if name is not None:
        plt.savefig(f'{name}.png')

def quickmatplot(mat, xlabel, ylabel, name=None):
    fig, ax = plt.subplots()

    axis_label = "Frame Number"
    colormap = "jet"
    rmsd_max = 3.0 

    im = plt.imshow(mat, cmap=colormap,vmax=rmsd_max)
    plt.colorbar(im, fraction=0.046, pad=0.04, label='2D-RMSD')

    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.gca().invert_yaxis()        

    if name is not None:
        plt.savefig(f'{name}.png')



def quicksubplot(xdata, ydata):
    fig, axes = plt.subplots(nrows=1, ncols=1)

    for ax in axes.flat:
        ax.plot(xdata, ydata)
        
    plt.savefig('name.png')

def quickpcaplot(mat, xlabel, ylabel, name=None):
    fig, ax = plt.subplots()

    plt.scatter(x_data, y_data, marker='o', c=range(traj.n_frames), alpha=0.5)

    cbar = plt.colorbar()                                       
    cbar.set_label('Frame Number')                                                  
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)      

    if name is not None:
        plt.savefig(f'{name}.png')

