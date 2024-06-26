import os                                               
import sys
from glob import glob
import numpy as np

sys.path.append('/home/van/Scripts/bin')
from topandas import mbar2df

import matplotlib.pyplot as plt                         

plt.rcParams['figure.constrained_layout.use'] = True
plt.rcParams['figure.figsize'] = (5, 3.33)
plt.rcParams['figure.dpi'] = 200
plt.rcParams['axes.labelsize'] = 12
plt.rcParams['axes.linewidth'] = 1
plt.rcParams['axes.grid'] = True
plt.rcParams['grid.linestyle'] = '--'
plt.rcParams['grid.alpha'] = 0.4
plt.rcParams['axes.xmargin'] = 0.1
plt.rcParams['axes.ymargin'] = 0.25

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

def quickmbar(outdir, ref=None):
    """
    Plot free energy profiles

    Need to correct 'time' variable... legend etc.
    """
    
    fnames = sorted(glob(f'{outdir}/*'))

    if ref is not None:
        arr = ref + fnames
    else:
        arr = fnames


    time = []
    dg = []
    colors = []
    for i in range(len(arr)):
        initial = np.loadtxt(arr[i])

        # name = arr[i].split('_')[2]
        # t0 = name.split('-')[0]
        # ti = name.split('-')[1]
        # lab = str('%s - %s ps' % (t0, ti))
        time.append(i) 
        fe = float(initial[:,1].max() - initial[:10,1].min())
        er = float(initial[initial[:,1].argmax()][2])
        dg.append(str('%.1f ± %.1f' % (fe,er)))

        plt.errorbar(initial[:,0], initial[:,1] - initial[:10,1].min(), yerr=initial[:,2])
        # colors.append(np.array(plt.color_sequences)[i])

    # plt.legend(ncol=1, bbox_to_anchor = (1.3, 0.6), loc='center right', frameon=False, alignment='left')
    plt.xlabel("d1 - d2 (Å)")
    plt.ylabel("Potential of Mean Force (kcal/mol)")
    plt.savefig(f'{outdir}/pmf-sliding.png')
    
    # Save table
    mbar2df(outdir=f'{outdir}', time=time, dg=dg)

