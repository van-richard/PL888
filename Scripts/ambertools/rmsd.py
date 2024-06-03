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
ambermask='@CA'

parm = join(pname, '.', pformat)
cord = join(tname, '.', tformat)

os.makedirs('img', exist_ok=True)
os.makedirs('raw_data', exist_ok=True)
figname="rmsd.png"

# Load trajectory
traj = pt.iterload(cord, top=parm)

data = pt.rmsd(traj, mask=ambermask)

# Plot Simulation Time vs RMSD
plt.plot(data)
plt.xlabel('Residue Number')
plt.ylabel('RMSD (Å)')

plt.savefig('img/%s' % figname, dpi=300)
