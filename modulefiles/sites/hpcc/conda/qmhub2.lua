-- HPCC-only QM/MM compatibility policy; preserve standalone Q-Chem 6.1.
if mode() == "load" and (isloaded("qchem/6.1")) then
    LmodError("HPCC Q-Chem 6.1 is unsupported for QM/MM: this installed build lacks native scalar ESP file 1521.0 required by QMHub. Use qchem/6.3 with sander/26 and qmhub2; keep 6.1 for standalone Q-Chem.")
end
conflict("qchem/6.1")
whatis("HPCC QM/MM policy: incompatible with qchem/6.1; use qchem/6.3.")
help([[HPCC Q-Chem 6.1 is unsupported for QM/MM: this installed build lacks native scalar ESP file 1521.0 required by QMHub. Use qchem/6.3 with sander/26 and qmhub2; keep 6.1 for standalone Q-Chem.]])

help([[
QMHub from the tested vibing source in the HPCC qmhub2 environment.

Deactivate any Conda environment and unload other environment modules first.
This module selects executables through PATH without Conda activation hooks.
It declares the GNU7/OpenMPI3 FFTW dependency required by this host's existing
helPME binary. Thread choices remain under the job script's control. Unloading
restores Python search settings; Sander and Q-Chem remain separate selections.
]])
whatis("QMHub vibing: HPCC qmhub2 executable selector")
conflict("qmhub2-mlpui", "qmhub", "base", "ambertools23", "mbar", "webdev", "conda")

local prefix = "/home/van/Programs/miniforge3/envs/qmhub2"
if mode() == "load" then
    if (os.getenv("CONDA_PREFIX") or "") ~= "" then
        LmodError("Deactivate the active Conda environment before loading qmhub2.")
    end
    if not isFile(pathJoin(prefix, "bin", "python")) then
        LmodError("The qmhub2 Python environment is missing: " .. prefix)
    end
end

-- The host-native helPME binary needs this exact FFTW soname, not a copied binary.
depends_on("gnu7/7.3.0", "openmpi3/3.1.0", "fftw/3.3.7")
-- Lmod 7.8 loses originally empty values in pushenv's base64 stack. Keep only
-- that state separately; fixed literal exports repair it after normal unload.
local emptyExports = {
    PYTHONPATH = "export PYTHONPATH=''",
    PYTHONNOUSERSITE = "export PYTHONNOUSERSITE=''",
}
local function pushPythonSetting(name, value)
    local flag = "_QMHUB2_WAS_EMPTY_" .. name
    local restoreEmpty = os.getenv(flag) == "1"
    pushenv(flag, os.getenv(name) == "" and "1" or "0")
    pushenv(name, value)
    if mode() == "unload" and restoreEmpty then
        execute{cmd=emptyExports[name], modeA={"unload"}}
    end
end

-- Avoid activation hooks and library overrides beyond declared native dependencies.
prepend_path("PATH", pathJoin(prefix, "bin"))
pushPythonSetting("PYTHONNOUSERSITE", "1")
-- false unsets PYTHONPATH while retaining its previous value for module unload.
pushPythonSetting("PYTHONPATH", false)
family('conda')
