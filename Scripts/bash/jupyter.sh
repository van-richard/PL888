#!/bin/bash

# get tunneling info
XDG_RUNTIME_DIR=""
node=$(hostname -s)
user=$(whoami)
port=6969
TOKE="f9a3bd4e9f2c3be01cd629154cfb224c2703181e050254b5"


# print tunneling instructions jupyter-log
instructions="

jupyter tunneling instructions

1. Create ssh tunnel:
    a. Open a new terminal tab/window on your computer (DO NOT SSH YET)
    b. Run the ssh command with tunnel options There should be no output!
    c. Keep this tab/window running when tunneling.
        - Minimize the window or return to tab where you sbatch jupyter.slurm
      - Close when done

    ####################################################################
    #### Copy this line into a new terminal on our _local_ computer ####
    ####################################################################
    
sh -N -L ${port}:${node}:${port} ${user}@${node}


2. Use a Browser on your local machine to go to:
    a. Open the SLURM %j.err file
    b. Find the line that contains the URL with - https://127.0.0.1:${port}...
    c. Copy the URL to your favorite browser
        - if you are running ubuntu, you can 'right-click' and 'open link'

    ####################################################################
    #### Copy this line into a new terminal on our _local_ computer ####
    ####################################################################

http://127.0.0.1:${port}/lab?token=${TOKE}

"

echo -e "${instructions}"

#   Start jupyterlab in $HOME
cd $HOME

# load modules  here
eval "$(/home/van/miniforge3/bin/conda shell.bash hook)"
conda activate 

# Run Jupyter
jupyter lab --no-browser --port=${port} --ip=${node} --ServerApp.token=${TOKE}

