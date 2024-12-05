#!/usr/bin/python3
import os
import sys
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--username', '-u', 
        type=str, default=os.getenv('USER'),
        help='HPC username')
parser.add_argument('--repeat', '-r', 
        type=int, default=0,
        help='re-run this command every "-s" seconds')
parser.add_argument('--get', '-g', 
        type=str,
        help='use `grep` to find job from input string')
args = parser.parse_args()

# squeue format
q_fmt = f'%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R'

command = f'squeue --format="{q_fmt}" --user={args.username}'

# do not repeat command if set to default (0)
if args.repeat != 0:
        iterate = f' --iterate={args.repeat}'
        command = command + iterate

# find string in squeue

if args.get:
    command = f'{command} | grep {args.get}'


# execute in bash shell
subprocess.run(command, shell = True, executable="/bin/bash")


