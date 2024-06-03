--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
pushenv(         "MKLROOT"           , "/opt/intel/oneapi/mkl/2021.2.0")
prepend_path(    "LD_PRELOAD"        , tostring(pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_core.so")))
prepend_path(    "LD_PRELOAD"         , tostring(pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_sequential.so")))
pushenv(         "I_MPI_PMI_LIBRARY"  , "/usr/lib64/libpmi.so")
pushenv(         "I_MPI_THREAD_YIELD" , "3")
pushenv(         "I_MPI_THREAD_SLEEP" , "200")

--- Set threads for QMHub - QChem
if (os.getenv("SLURM_NTASKS_PER_NODE") == nil) or (os.getenv("SLURM_NTASKS") == nil) then
    pushenv("MKL_NUM_THREADS", "16")
    pushenv("OMP_NUM_THREADS", "16")
end

if (mode() == "unload") then
    cmd = "unset AMBERHOME; " ..
    "conda deactivate; unset CONDA_EXE; unset _CE_CONDA; unset _CE_M; " ..
    "unset -f __conda_activate; unset -f __conda_reactivate; " .. 
    "unset -f __conda_hashr; unset CONDA_SHLVL; unset _CONDA_EXE; " .. 
    "unset _CONDA_ROOT; unset -f conda"
    execute{cmd=cmd, modeA={"unload"}}
end

--- Description of software (`module whatis [module name]`)
whatis('\
Name: Patched Amber22 for QM/MM (Dr. Pan) \
Description: \
')


--- Examples: How to use package (`module help [module name]`)
help([[
Example usage (Note: Only in `interactive` or SLURM script!):

]])

family('amber')
family("amber")
