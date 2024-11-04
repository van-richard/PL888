#!/scratch/van/shared_envs/mbar/bin/python
import os
import sys
    
def get_filepath(path, windowlist):
    if path != None and windowlist != None:
        fpaths = []
        for i in range(len(windowlist)):
            fpath = f'{args.path}/{windowlist[i]}/cv.rst'
            fpaths.append(fpath)
    else:
        fpaths = []
        for i in range(len(windowlist)):
            fpath = f'{windowlist[i]}/cv.rst'
            fpaths.append(fpath)
    return fpaths

def parse_cvrst(filepath):
    print(filepath)
    rsts_list = []
    with open(f'{filepath}', 'r') as file:
        block = []
        for line in file:
            line = line.strip()
            if line == '&rst':
                block = []
            elif line == '&end':
                params = {}
                for param in block:
                    if len(param.split()) > 1:
                        for p in param.split():
                            key, value = p.split('=')
                            params[key] = value.strip(',')
                    else:
                        key, value = param.split('=')
                        params[key] = value.strip(',')
                rsts_list.append(params)
            else:
                block.append(line)
    return rsts_list


def get_force_constant(params):
    if params['rk2'] == params['rk3']:
        force_constant = float(params['rk2'])
    return force_constant

def get_cv_value(params):
    if params['r2'] == params['r3']:
        cv_value = float(params['r2'])
    return cv_value

def get_cv(fpath, window):
    fpaths = get_filepath(fpath, window)
    params = parse_cvrst(fpaths)
    cv = get_cv_value(params)
    fc = get_force_constant(params)
    return cv, fc

if __name__ == '__main__':
    import sys
    import argparse
    sys.path.append('/home/van/Scripts/mbar')
    from get_windows import find_path, get_windows
    fpath = find_path()
    window = get_windows()
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--path', type=str, default=fpath)
    parser.add_argument('-w', '--window', type=str, default=window)
    args = parser.parse_args()
    
    cv, fc = get_cv(args.path, args.window)
    #print(f'CV: {cv}')
    #print(f'FC: {fc}')
