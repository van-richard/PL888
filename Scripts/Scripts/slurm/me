#!/usr/bin/python3
import os
import sys
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--username', '-u', 
        type=str, default=os.getenv('USER'),
        help='HPC username')
parser.add_argument(        '--repeat', '-r', 
        type=int, default=0,
        help='run command every "-s" seconds')
args = parser.parse_args()

# SLURM squeue format
q_fmt = f'%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R'

# shell command
command = f'squeue --format="{q_fmt}" --user={args.username}'

# do not repeat command if set to default (0)
if args.repeat != 0:
    iterate = f' --iterate={args.repeat}'
    command = command + iterate

# execute in bash shell
subprocess.run(command, shell = True, executable="/bin/bash")

