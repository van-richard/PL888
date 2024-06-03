#!/bin/bash
#SBATCH --partition=batch
##SBATCH --partition=bigmem
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=50G
##SBATCH --exclusive
#SBATCH --output=%j.out
#SBATCH --error=%j.err
#SBATCH --time=18:00:00
#SBATCH --job-name=jupyter

# get tunneling info
XDG_RUNTIME_DIR=""
node=$(hostname -s)
user=$(whoami)
cluster="pete"
port=8988

# print tunneling instructions jupyter-log
echo -e "
Command to create ssh tunnel:
ssh -N -L ${port}:${node}:${port} ${user}@${cluster}.hpc.okstate.edu

Use a Browser on your local machine to go to:
localhost:${port}  (prefix w/ https:// if using password)
"

# load modules  here
shopt -s expand_aliases
source ~/.bash_aliases
myconda
#panconda

# Run Jupyter
jupyter lab --no-browser --port=${port} --ip=${node}
