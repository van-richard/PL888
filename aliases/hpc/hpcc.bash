#!/usr/bin/env bash

# HPCC uses SLURM. Shared SLURM helpers are loaded from
# aliases/scheduler/slurm.bash when sbatch or squeue is available.
guest-compute() {
    command srun -p guest-compute -n 1 --ntasks=16 --cpus-per-task=1 \
        --mem=32G -t 8:00:00 --pty bash -l
}
