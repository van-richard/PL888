# tcl script for backmapping with VMD

# load topology file
#mol new step3_pbcsetup.parm7 
# load trajectory
#mol addfile prod??.nc waitfor all

# load sirah tools from container environment
source /opt/conda/envs/ambertools23/dat/SIRAH/tools/sirah_vmdtk.tcl

# assign secondary structure 
sirah_ss 

# load secondary structure information
sirah_ss mol 0 load ss.mtx

# backmap
# sirah_backmap now
# sirah_backmap frames {0 1 2}
sirah_backmap each 5

quit
