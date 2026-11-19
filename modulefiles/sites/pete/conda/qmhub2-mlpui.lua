help([[OSU QMHub executable selector: qmhub2-mlpui.
QMHub 1.0.0+234.gb5c26ff; Python 3.12.13; Torch 2.6.0/CUDA 11.8.
Use inside a Slurm allocation, after deactivating any Conda environment:
    module load sander/26 qchem/6.3 qmhub2-mlpui

Sander and Q-Chem are selected separately. The ABI-matched helPME extension
retains /scratch/van/shared_envs/qmhub2/lib in its RPATH; keep that baseline
installation available. Unloading restores Python search settings.
GPU analytic validation does not certify a trained potential or production model.
]])
whatis("OSU QMHub qmhub2-mlpui: b5c26ff; Python 3.12; Torch 2.6/CUDA 11.8 executable selector")
conflict("qmhub", "qmhub2", "base", "conda", "ambertools23", "ambertools26", "mbar", "pyrosetta", "torchmdnet", "vina", "westpa")
local prefix = "/scratch/van/shared_envs/qmhub2-mlpui"
if mode() == "load" then
    if (os.getenv("CONDA_PREFIX") or "") ~= "" then
        LmodError("Deactivate the active Conda environment before selecting qmhub2-mlpui.")
    end
    if not isFile(pathJoin(prefix, "bin", "python")) then
        LmodError("QMHub environment is missing: " .. prefix)
    end
end

-- Preserve explicitly empty exports as well as unset/nonempty values; Lmod's
-- pushenv base64 stack otherwise loses the difference between empty and unset.
local function pushSetting(name, value)
    local flag = "_QMHUB2_MLPUI_WAS_EMPTY_" .. name
    local restoreEmpty = os.getenv(flag) == "1"
    pushenv(flag, os.getenv(name) == "" and "1" or "0")
    pushenv(name, value)
    if mode() == "unload" and restoreEmpty then
        execute{cmd = "export " .. name .. "=''", modeA = {"unload"}}
    end
end

-- Select executables without activation hooks or global library overrides that
-- could replace the Intel/MPI runtime used by Sander and Q-Chem.
prepend_path("PATH", pathJoin(prefix, "bin"))
pushSetting("PYTHONNOUSERSITE", "1")
pushSetting("PYTHONPATH", false)
-- Python neighbors avoid optional scatter/cluster ABI requirements on glibc 2.17.
pushSetting("MLPUI_NEIGHBORS", "python")
