#!/bin/bash

# Usage: bash backmap.sh DIRNAME

project=$1
TCLdir="/home/van/Scripts/tcl"
SIFdir="/scratch/van"
# SIFdir="/projects/ok001/apptainer"

if [ -z "$1" ]; then
    echo "Missing project directory name !!!"
fi

sbatch <<_EOF
#!/bin/bash
#SBATCH -p bigmem
#SBATCH -t 5-00:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=20G
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -J ${project}

date

module load apptainer

# Apptainer performs poorly running on lustre
# Copy sif, parm, traj, and tcl files to /tmp on node

# path to project directory with trajctory files
cwd="\$(realpath .)/${project}" 

# create tmp directory on node 
tmpdir="/tmp/\${USER}/\${SLURM_JOBID}" 
mkdir -p \${tmpdir}
cd \${tmpdir}

# collect files to tmpdir
cp \${cwd}/step3_pbcsetup.parm7 \${tmpdir}
cp \${cwd}/prod*.nc \${tmpdir}
cp ${SIFdir}/vmd1.9.4a57.sif \${tmpdir}
cp ${TCLdir}/sirahbackmap.tcl \${tmpdir}

# Run service  
apptainer run vmd1.9.4a57.sif -f step3_pbcsetup.parm7 prod*.nc -e sirahbackmap.tcl
#apptainer run vmd1.9.4a57.sif -dispdev text -f step3_pbcsetup.parm7 prod*.nc -e sirahbackmap.tcl

# cleanup - copy back to project
rm step3_pbcsetup.parm7 prod*.mc vmd1.9.4a57.sif sirahbackmap.tcl
mv \${tmpdir} \${cwd}/backmap-\${SLURM_JOBID}

date

_EOF


