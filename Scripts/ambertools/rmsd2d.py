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

# Load trajectory
traj = pt.iterload(cord, top=parm)

rmsd = pt.pairwise_rmsd(traj, mask=atommask)

# Plot Simulation Time vs RMSD
plt.plot(rmsd)
plt.xlabel('Time ')
plt.ylabel('RMSF (Å)')

plt.savefig('img/rmsd2d.png', dpi=300)
