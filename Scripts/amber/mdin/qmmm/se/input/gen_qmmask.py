#!/scratch/van/shared_envs/ambertools23/bin/python
import os
import sys
import numpy as np
import pytraj as pt

mask = [
    [ 'MG', ':367'],
    ['ALA', ':301'],
    ['ASN', ':322'],
    ['WAT', ':607'],
    ['WAT', ':617'],
    ['WAT', ':619'],
    ['WAT', ':607'],
    [ 'DA',  ':12'],
    [ 'DG',  ':13']
]

