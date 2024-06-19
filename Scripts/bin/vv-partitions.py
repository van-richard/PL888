#!/usr/bin/python3

import sys,os,subprocess,shlex,math

try:
    SHELLCMD =['scontrol','-o','show','partition']
    STDOUT = subprocess.PIPE

    proc = subprocess.Popen(SHELLCMD, stdout=STDOUT, universal_newlines=True)

except:
    exit

else:
    cols = ['PartitionName', 'State', 'TotalNodes', 
            'TotalCPUs', 'DefMemPerCPU', 'MaxTime']
    
    widths = [15, 7, 12,
              11, 14, 14]

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
                 
