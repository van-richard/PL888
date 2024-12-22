#!/usr/bin/python3
import sys
import argparse
import math

"""
Estimate free energy barrier from kcat value
If no value is given,  kcat=1.0 s^-1

Usage:
    
    ./kcat2kcal [value]
"""

Boltzman = 1.3806452e-23 # J / K
Planck = 6.6260701e-34 # J / s
T = 298 # K
Gas = 8.314 # J / (mol * K)
Joules_to_cal = 4.184

parser = argparse.ArgumentParser()
parser.add_argument('--kcat','-kc', type=float, default=1.0,
                   help='Value for kcat - rate constant. (float)')
parser.add_argument('--unit','-u', choices=['s','min'], default='s',
                    help='Units for rate: per second (s), or per minute (min)')
args = parser.parse_args()


def persecond(val, units):
    if units == 's':
        u = val
    elif units == 'min':
        u = val / 60
    return u



def write_scinotation(val):
    return f"{val:8.2f}" # scientific notation

def Joulestokcal(J):
    J = float(J)
    return J / Joules_to_cal / 1000 

def ln(x):
    n = 1000.0
    return n * ((x ** (1/n)) - 1)

def kcat2dG(kcat):
    kB = Joulestokcal(Boltzman)
    h  = Joulestokcal(Planck)
    R  = Joulestokcal(Gas)

    num = kcat * h
    den = kB * T
    return ln(num/den) * R * T

if __name__ == '__main__':
    kcat = persecond(args.kcat, args.unit)
    f_kcat = write_scinotation(args.kcat)
    dG = kcat2dG(args.kcat)

    print(f"\n\t            kcat (/s): {f_kcat}",
          f"\tdG Barrier (kcal/mol): {dG:8.2f}\n",
          sep="\n",
          )


