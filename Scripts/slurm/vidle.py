#!/usr/bin/python3
import sys
import subprocess

cmd = 'sinfo | grep idle'

subprocess.run(cmd, shell=True, executable='/bin/bash')
