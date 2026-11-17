help([[OSU QMHub executable selector: qmhub2-mlpui.
Deactivate Conda environments before loading. Sander and Q-Chem are selected
separately. The ABI-matched native extension retains the existing qmhub2 library
RPATH; keep that baseline installation available. Unloading restores Python paths.
]])
whatis("OSU QMHub qmhub2-mlpui: pinned wheel executable selector")
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
-- Select executables without activation hooks or global library overrides that
-- could replace the Intel/MPI runtime used by the existing Sander installation.
prepend_path("PATH", pathJoin(prefix, "bin"))
pushenv("PYTHONNOUSERSITE", "1")
pushenv("PYTHONPATH", false)
-- Use Python neighbors to avoid optional torch-scatter/cluster ABI requirements
-- with the pinned Torch2.6/CUDA11.8 profile on glibc2.17; restore on unload.
pushenv("MLPUI_NEIGHBORS", "python")
