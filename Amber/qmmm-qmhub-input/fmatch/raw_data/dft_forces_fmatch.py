#!/usr/bin/env python
import sys
from pathlib import Path

import numpy as np

from qmhub import QMMM
from qmhub.units import CODATA08_BOHR_TO_A
import os

total_frames=500
qm_atoms=73
mm_atoms=800
cwdir = os.getcwd()

fin = (f"qmhub/qmmm.inp_{i:04d}" for i in range(0, total_frames, 2))

qmmm = QMMM(mode="text", driver="sander", cwd=Path(cwdir+'/qmhub2' ))
qmmm.io.cwd.mkdir(exist_ok=True)
qmmm.setup_simulation()

qm_coord = np.zeros((total_frames, qm_atoms, 3)) 
mm_coord = np.zeros((total_frames, mm_atoms, 3)) 
mm_charge = np.zeros((total_frames, mm_atoms))

for i, f in enumerate(fin):
	if i == 0:
		qmmm.load_system(f)
		qmmm.build_model(switching_type='lrec', cutoff=10., swdist=None, pbc=True)
		qmmm.add_engine(
			"qchem",
			options={
				"method": "b3lyp",
				"basis": "6-31gd",
				"scf_convergence": "9",
        			"scf_algorithm": "gdm_ls",
        			"max_scf_cycles": "1000",
				},
			)
	else:
		qmmm.io.load_system(f, system=qmmm.system)

	index = np.argsort(abs(qmmm.engine.mm_charges))[-mm_atoms:]
	mm_coord[i] = qmmm.engine.mm_positions.T[index]
	mm_charge[i] = qmmm.engine.mm_charges[index]
	qm_coord[i] = qmmm.engine.qm_positions.T
	print('Finished: Frame ' + str(f))

np.save("qm_coord", np.array(qm_coord, dtype="float32"))
np.save("mm_coord", np.array(mm_coord, dtype="float32"))
np.save("mm_charge", np.array(mm_charge, dtype="float32"))
