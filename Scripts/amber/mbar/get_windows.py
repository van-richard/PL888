#!/scratch/van/shared_envs/mbar/bin/python
import os
import sys

sys.path.append('/home/van/Scripts/mbar')
from organize import whereami, count_name

def find_path():
    path = os.getcwd()
    return f'{path[:]}'
def find_subdirectories():
    path = os.getcwd()
    return next(os.walk(path))[1]

def get_windows():
    windows = []
    cwd, pd = whereami()
    subdirs = find_subdirectories()
    for subdir in subdirs:
        if len(subdir) == 2 and subdir.isdigit():
            windows.append(subdir)
    return sorted(windows), len(windows)

def main():
    fpath = find_path()
    windowlist, n_windows = get_windows()
    return fpath, windowlist, n_windows

if __name__ == '__main__':
    fpath = find_path()
    windowlist, n_windows = get_windows()
