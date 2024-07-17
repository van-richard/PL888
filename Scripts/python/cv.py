#!/usr/bin/python3
import os
import sys
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--filename', '-f',
        type=str, default='step6',
        help='filename for step...')
parser.add_argument('--index', '-i',
        type=str, default='00',
        help='')
parser.add_argument('--windows', '-w',
        type=int, default=42,
        help='')
args = parser.parse_args()

# Print header for the output table
#printf "\nWindow\tSteps\tR1-R2\tR1\tR2\n"
filename = f'{args.filename}.{args.index}'

# Iterate through windows and print information
cmd = f'seq -w 0 {args.windows} | while read i_window; do; if [ -f \${i_window}/{args.filename} ]; then n_cvs=$(tail -n 1 ${i_window}/${filename} | column -t); printf "\t${i_window}\t${n_cvs}\n"; else; printf "${i_window}\tNo File!\tSimulation probably has not started..\n"; fi; done | pr -t -2'

for window in range(f'{args.windows}'):

subprocess.run(command, shell = True, executable="/bin/bash")
