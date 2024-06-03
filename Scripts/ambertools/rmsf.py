import os
import pytraj as pt
import matplotlib.pyplot as plt

# Topology file
pname="step3_pbcsetup"
pformat="parm7"

# Trajectory file 
tname='prod'
tformat='nc'

# Atom mask selection
atommask='@CA'

parm = join(pname, '.', pformat)
cord = join(tname, '.', tformat)

os.makedirs('img', exist_ok=True)
os.makedirs('raw_data', exist_ok=True)
figname="rmsf.png"

# Load trajectory
traj = pt.iterload(cord, top=parm)

# Superimpose to 1st frame and alpha carbons
pt.superpose(traj, ref=0, mask=ambermask)

data = pt.rmsf(traj, mask=ambermask)

resnum = len(data.T[0]) + 1
xdata = np.arange(1, resnum)
ydata = data.T[1]

# Plot Simulation Time vs RMSD
plt.plot(xdata, ydata)
plt.xlabel('Residue Number')
plt.ylabel('RMSF (Å)')

plt.savefig('img/%s' % figname, dpi=300)
