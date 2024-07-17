#!/bin/bash

read -p "Enter source: " SRC
read -p "Enter destination: " DEST
read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

sbatch <<_EOF
#!/bin/bash
#SBATCH -p express
#SBATCH -t 00:30:00
#SBATCH -n 32
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -J nsync

# quickly sync hella directories

date

module load parallel


find $SRC -maxdepth 2 -type d | \
    parallel -j $SLURM_NTASKS -X \
    rsync -aHRdmui "${SRC}/{}" "${DEST}"

parallel -j $SLURM_NTASKS -X \
    rsync -avuim ${SRC}/ ${DEST}

date

