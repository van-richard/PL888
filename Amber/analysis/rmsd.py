# Importing libraries, modules, and functions
import os                                               # File system operations
import pytraj as pt                                     # Trajectory analysis
import matplotlib.pyplot as plt                         # Plotting
import seaborn as sb                                    # Plotting  

# Input parameters
os.makedirs('img', exist_ok=True)                       # Make directory for images             

# Load topology: `prmtop` or `parm7` format
parm_file = "step3_pbcsetup"

# Coordinate file(s): `rst7` or `nc` format
cord_file = "prod00.nc"

# Atom mask for selection
ambermask = "@CA"

# Load trajectory
_trajectory = pt.iterload([cord_file], top=parm_file) 

# RMSD Analysis (_trajectory is(are) trajectory file(s), _mask is the Amber format selection mask)
_data = pt.rmsd(_trajectory, mask=ambermask)

time = len(_data) + 1                             # FIXTHIS: Total simulation time      
x_data = np.arange(1, time)                      # Time values
y_data = data                                    # RMSF values

x_label="Residue Number"                         # X-axis label
y_label="RMSF ($mathrm{\AA}$)"                   # Y-axis label

# Plot Residue # vs RMSF
plt.plot(x_data, y_data)                                    # Plot 
plt.xlabel(x_label)                                         # Label x-axis
plt.ylabel(x_label)                                         # Label ydata
plt.savefig(f'img/rmsd.png')                                # Save plot

