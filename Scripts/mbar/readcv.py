import os
import sys
import argparse


def parse_inputs():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--path', type=str)
    parser.add_argument('-w', '--window', type=str, required=True)
    return parser.parse_args()

def parse_cvrst(filename):
    rsts_list = []
    with open(filename, 'r') as file:
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

def get_params():
    args = parse_inputs()
    if args.path is not None and args.window is not None:
        filename = f'{args.path}/{args.window}/cv.rst'
    elif args.window is not None:
        filename = f'{args.window}/cv.rst'
        print(filename)
    else:
        filename=path
    return parse_cvrst(filename)[0]

def get_force_constant(window, filename):
    params = parse_cvrst(filename)[0]
    if params['rk2'] == params['rk3']:
        force_constant = float(params['rk2'])
    return force_constant

def get_cv_value(window, filename):
    params = parse_cvrst(filename)[0]
    if params['r2'] == params['r3']:
        cv_value = float(params['r2'])
    return cv_value



if __name__ == '__main__':
    params = get_params()
    cv = get_cv_value(params)
    fc = get_force_constant(params)
    print(f'CV: {cv}')
    print(f'FC: {fc}')