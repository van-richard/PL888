import sys
import os
import shutil
import uuid
import subprocess as sp
from multiprocessing import Pool

import numpy as np


qc_rem = """
$rem
JOBTYPE force
SYMMETRY false
SYM_IGNORE true
QM_MM true
BASIS 6-31G*
SCF_CONVERGENCE 7
METHOD b3lyp
SKIP_CHARGE_SELF_INTERACT true
SOLVENT_METHOD pcm
$end
"""


ELEMENTS = ["None", 'H', 'He',
            'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Ne',
            'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl', 'Ar',
            'K', 'Ca', 'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn', 'Ga', 'Ge', 'As', 'Se', 'Br', 'Kr',
            'Rb', 'Sr', 'Y', 'Zr', 'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn', 'Sb', 'Te', 'I', 'Xe',
            'Cs', 'Ba', 'La', 'Ce', 'Pr', 'Nd', 'Pm', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm', 'Yb',
            'Lu', 'Hf', 'Ta', 'W', 'Re', 'Os', 'Ir', 'Pt', 'Au', 'Hg', 'Tl', 'Pb', 'Bi']


def get_element_symbols(atomic_number):
    try:
        return [ELEMENTS[i] for i in atomic_number]
    except TypeError:
        return ELEMENTS[atomic_number]


def get_qchem_input(qc_inp, qm_pos, qm_elem_num, charge, mult):
    assert len(qm_pos) == len(qm_elem_num)
    qm_element = get_element_symbols(qm_elem_num)
    with open(qc_inp, 'w') as f:
        f.write("$molecule\n")
        f.write("%d %d\n" % (charge, mult))
        for i in range(len(qm_pos)):
            f.write("".join(["%-3s" % qm_element[i],
                             "%25.16f" % qm_pos[i, 0],
                             "%25.16f" % qm_pos[i, 1],
                             "%25.16f" % qm_pos[i, 2], "\n"]))
        f.write("$end" + "\n\n")

        f.write(qc_rem + "\n")


def get_qchem_force(qm_pos, qm_elem_num, charge, mult):
    cwd = "qchem-pcm/" + str(uuid.uuid4())
    if not os.path.exists(cwd):
        os.makedirs(cwd)
    get_qchem_input(cwd + "/qchem.inp", qm_pos, qm_elem_num, charge, mult)

    cmdline = f"cd {cwd}; "
    cmdline += f"QCSCRATCH=`pwd` qchem qchem.inp qchem.out save > qchem_run.log"
    proc = sp.Popen(args=cmdline, shell=True)
    proc.wait()

    energy = np.fromfile(cwd + "/save/99.0", dtype="f8", count=2)[1]
    qm_grad = np.fromfile(cwd + "/save/131.0", dtype="f8").reshape(-1, 3)

    shutil.rmtree(cwd)

    return energy, qm_grad


def get_qchem_training_set(qm_coords, qm_elem_num, charge, mult):
    # args = ((qm_pos, qm_elem_num, charge, mult) for qm_pos in zip(qm_coords))
    args = ((qm_pos, qm_elem_num, charge, mult) for qm_pos in qm_coords)
    with Pool() as p:
        res = p.starmap(get_qchem_force, args)
    energy = np.zeros(len(qm_coords))
    qm_grad = np.zeros_like(qm_coords)
    for i, r in enumerate(res):
        energy[i] = r[0]
        qm_grad[i] = r[1]
    return energy, qm_grad


if __name__ == "__main__":
    import sys
    import numpy as np

    qm_coords = np.load("qm_coords.npy")
    qm_elems = np.loadtxt("qm_elem.txt", dtype=int)
    energy, qm_grad, = get_qchem_training_set(qm_coords, qm_elems, 0, 1)

    np.save("qmmm_energy_pcm", energy)
    np.save("qmmm_grad_pcm", np.array(qm_grad, dtype='float32'))
