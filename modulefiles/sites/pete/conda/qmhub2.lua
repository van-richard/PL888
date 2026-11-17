help([[OSU QMHub executable selector: qmhub2.
Deactivate Conda environments before loading. Sander and Q-Chem are selected
separately. The ABI-matched native extension retains the existing qmhub2 library
RPATH; keep that baseline installation available. Unloading restores Python paths.
]])
whatis("OSU QMHub qmhub2: pinned wheel executable selector")
conflict("qmhub", "qmhub2-mlpui", "base", "conda", "ambertools23", "ambertools26", "mbar", "pyrosetta", "torchmdnet", "vina", "westpa")
local prefix = "/scratch/van/shared_envs/qmhub2"
if mode() == "load" then
    if (os.getenv("CONDA_PREFIX") or "") ~= "" then
        LmodError("Deactivate the active Conda environment before selecting qmhub2.")
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
