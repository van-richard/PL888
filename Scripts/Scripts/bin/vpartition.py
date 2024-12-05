#!/usr/bin/python3
import os
import sys
import argparse
import subprocess
import shlex
import math

parser = argparse.ArgumentParser()
parser.add_argument('options', 
        choices=['idle', 'info'],
        help='List partition information')
args = parser.parse_args()

if args.options == 'idle':
    cmd = 'sinfo | grep idle'
    subprocess.run(cmd, shell=True, executable='/bin/bash')


if args.options == 'info':
    try:
        cmd = ['scontrol','-o','show','partition']
        proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, universal_newlines=True)
    except:
        exit

    else:
        cols = ['PartitionName', 'State', 'TotalNodes', 'TotalCPUs', 'DefMemPerCPU', 'MaxTime']

        widths = [15, 7, 12,11, 14, 14]

        print()

        for c, w in zip(cols,widths): 
            print(f"{c:<{w}}", end = "")

        print()

        for line in proc.stdout:
            p = dict(s.split("=", 1) for s in shlex.split(line) if '=' in s)

            for c, w in zip(cols, widths): 
                print(f"{p[c]:<{w}}", end = "")

                if c == cols[-1]:       
                    print()

