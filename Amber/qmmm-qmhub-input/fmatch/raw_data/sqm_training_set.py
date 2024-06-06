import sys
import os
import shutil
import uuid
import subprocess as sp
from multiprocessing import Pool
from pathlib import Path
from string import Template

import numpy as np


AMBER_HARTREE_TO_EV = 27.21
AMBER_EV_TO_KCAL= 23.061
AMBER_HARTREE_TO_KCAL = AMBER_HARTREE_TO_EV * AMBER_EV_TO_KCAL
AMBER_BOHR_TO_A = 0.529177249


sqm_rem = """\
&qmmm
 qm_theory= ${method},
 qmmm_int = 7,
 qmcharge = ${charge},
 spin     = ${mult},
 !parameter_file='param.dat',
 maxcyc   = 0,
 verbosity= 5,
 /
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


def get_sqm_input(sqm_inp, qm_pos, qm_elem_num, mm_pos, mm_charge, charge, mult, method=None, param=None):
    assert len(qm_pos) == len(qm_elem_num)
    assert len(mm_pos) == len(mm_charge)
    qm_element = get_element_symbols(qm_elem_num)
    method = method or "PM3"
    with open(sqm_inp, 'w') as f:
        f.write(Template(sqm_rem).substitute(charge=charge, mult=mult, method=method))
        for i in range(len(qm_pos)):
            f.write("".join([" %-4d" % qm_elem_num[i],
                             "%-3s" % qm_element[i],
                             "%21.16f" % qm_pos[i, 0],
                             "%21.16f" % qm_pos[i, 1],
                             "%21.16f" % qm_pos[i, 2], "\n"]))
        f.write("#EXCHARGES\n")
        for i in range(len(mm_pos)):
            f.write("".join([" %-4d" % 1,
                             "%-3s" % "H",
                             "%21.16f" % mm_pos[i, 0],
                             "%21.16f" % mm_pos[i, 1],
                             "%21.16f" % mm_pos[i, 2],
                             "%21.16f" % mm_charge[i], "\n"]))
        f.write("#END" + "\n")
    if param is not None:
        with open(Path(sqm_inp).parent.joinpath("param.dat"), 'w') as f:
            f.write(param)


def _get_qm_energy(output):
    """Get QM energy from output of QM calculation."""

    output = Path(output).read_text().split("\n")

    for line in output:
        if "QMMM: SCF Energy" in line:
            return float(line.split()[4]) / AMBER_HARTREE_TO_KCAL


def _get_qm_energy_gradient(output, n_atoms):
    output = Path(output).read_text().split("\n")

    for i in range(len(output)):
        if "Forces on QM atoms from SCF calculation" in output[i]:
            gradient = np.empty((n_atoms, 3), dtype=float)
            for j in range(n_atoms):
                line = output[i + j + 1]
                gradient[j, 0] = float(line[18:38])
                gradient[j, 1] = float(line[38:58])
                gradient[j, 2] = float(line[58:78])
            return gradient / (AMBER_HARTREE_TO_KCAL / AMBER_BOHR_TO_A)


def _get_mm_esp(output, n_mm_atoms):
    """Get electrostatic potential at MM atoms in the near field from QM density."""
    output = Path(output).read_text().split("\n")

    mm_esp = np.zeros(n_mm_atoms)
    mm_esp_grad = np.zeros((n_mm_atoms, 3))

    for i in range(len(output)):
        if "Electrostatic potential and field on MM atoms from QM Atoms" in output[i]:
            for j in range(n_mm_atoms):
                line = output[i + j + 1]
                mm_esp[j] = float(line[18:38])
                mm_esp_grad[j, 0] = -float(line[38:58])
                mm_esp_grad[j, 1] = -float(line[58:78])
                mm_esp_grad[j, 2] = -float(line[78:98])
            break

        if i == len(output) - 1:
            raise ValueError("Can not find MM electrostatic potential and field.")

    mm_esp /= AMBER_HARTREE_TO_KCAL
    mm_esp_grad /= (AMBER_HARTREE_TO_KCAL / AMBER_BOHR_TO_A)
    return mm_esp, mm_esp_grad


def get_sqm_force(qm_pos, qm_elem_num, mm_pos, mm_charge, charge, mult, method=None, param=None):
    #cwd = "/dev/shm/run_" + str(uuid.uuid4())
    cwd = "sqmfmatch/" + str(uuid.uuid4())
    if not os.path.exists(cwd):
        os.mkdir(cwd)
    get_sqm_input(cwd + "/sqm.inp", qm_pos, qm_elem_num, mm_pos, mm_charge, charge, mult, method, param)

    cmdline = f"cd {cwd}; "
    cmdline += "sqm -O -i sqm.inp -o sqm.out"
    proc = sp.Popen(args=cmdline, shell=True)
    proc.wait()

    energy = _get_qm_energy(cwd + "/sqm.out")
    qm_grad = _get_qm_energy_gradient(cwd + "/sqm.out", len(qm_pos))
    mm_esp, mm_esp_grad = _get_mm_esp(cwd + "/sqm.out", len(mm_pos))

    shutil.rmtree(cwd)

    return energy, qm_grad, mm_esp, mm_esp_grad


def get_sqm_force_batch(qm_coords, qm_elem_nums, mm_coords, mm_charges, charge=0, mult=1, method=None, param=None):
    if qm_elem_nums.ndim == 1:
        qm_elem_nums = np.tile(qm_elem_nums, (len(qm_coords), 1))
    args = ((qm_pos, qm_elem_num, mm_pos, mm_charge, charge, mult, method, param) for qm_pos, qm_elem_num, mm_pos, mm_charge in zip(qm_coords, qm_elem_nums,  mm_coords, mm_charges))
    with Pool() as p:
        res = p.starmap(get_sqm_force, args)
    energy = np.zeros(len(qm_coords))
    qm_grad = np.zeros_like(qm_coords)
    mm_esp = np.zeros_like(mm_charges)
    mm_esp_grad = np.zeros_like(mm_coords)
    for i, r in enumerate(res):
        energy[i] = r[0]
        qm_grad[i] = r[1]
        mm_esp[i] = r[2]
        mm_esp_grad[i] = r[3]
    return energy, qm_grad, mm_esp, mm_esp_grad


if __name__ == "__main__":
    import numpy as np

    qm_coords = np.load("qm_coord.npy")
    qm_elems = np.loadtxt("qm_elem.txt", dtype=int)
    mm_coords = np.load("mm_coord.npy")
    mm_charges = np.load("mm_charge.npy")
    energy, qm_grad, mm_esp, mm_esp_grad = get_sqm_force_batch(qm_coords, qm_elems, mm_coords, mm_charges, charge=0, mult=1, method="PM3")

    np.save("energy_sqm", energy)
    np.save("qm_grad_sqm", np.array(qm_grad, dtype='float32'))
    np.save("mm_esp_sqm", np.array(mm_esp, dtype='float32'))
    np.save("mm_esp_grad_sqm", np.array(mm_esp_grad, dtype='float32'))
