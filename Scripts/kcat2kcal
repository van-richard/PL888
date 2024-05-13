#!/usr/bin/python3
"""
Estimate free energy barrier from kcat value
If no value is given,  kcat=1.0 s^-1

Usage:
    
    ./kcat2kcal [value]
"""

import sys

if len(sys.argv) == 2:
    kcat = float(sys.argv[1])
    if "e" in sys.argv[1]:
        f_kcat = f"{kcat:8.1e}" # scientific notation
else:
    kcat = 1.0
    
f_kcat = f"{kcat:8.2f}" # scientific notation
Boltzman = 1.3806452e-23 # J / K
Planck = 6.6260701e-34 # J / s
T = 298 # K
Gas = 8.314 # J / (mol * K)

Joules_to_cal = 4.184

def tokcal(J):
    J = float(J)
    return J / Joules_to_cal / 1000 

def ln(x):
    n = 1000.0
    return n * ((x ** (1/n)) - 1)

def kcat2dG(kcat):
    kB = tokcal(Boltzman)
    h  = tokcal(Planck)
    R  = tokcal(Gas)
    return ln( (kcat * h) / (kB * T) ) * R * T

dG = kcat2dG(kcat)

print(
    f"\n\t            kcat (/s): {f_kcat}",
    f"\tdG Barrier (kcal/mol): {dG:8.2f}\n",
    sep="\n",
    )


