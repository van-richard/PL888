#!/usr/bin/env python
import sys

import numpy as np

sys.path.append("/scratch/van/Scripts/")
from sqm_param2 import SQM_PARAM


x = np.load(sys.argv[1])
params = SQM_PARAM(["H", "C", "N", "O", "Mg", "P"], "PM3")
params.write_params(".", pert=x)
# Uncomment to get default parameters
#params.write_params(".")
