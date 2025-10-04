--- Point to package 
local PkgDir   = "/home/van/Programs"
local Pkg    = "pmemd24"
local Base   = tostring(pathJoin(PkgDir, Pkg))


--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
---setenv(         "FFTW_ROOT"             , pathJoin("/opt", "fftw", "3.3.10"))
setenv(         "PMEMDHOME"             , Base)
prepend_path(   "LD_LIBRARY_PATH"       , pathJoin(Base, "lib"))
prepend_path(   "PATH"                  , pathJoin(Base, "bin"))

if (mode() == "unload") then
    unsetenv(   "PMEMDHOME"             , Base)
    remove_path("LD_LIBRARY_PATH"       , pathJoin(Base, "lib"))
    remove_path("PATH"                  , pathJoin(Base, "bin"))
end

--- Description of software (`module whatis [module name]`)
whatis('Amber24')
whatis('Compiled on CPU')


--- Examples: How to use package (`module help [module name]`)
help([[
mpirun -n $SLURM_NTASKS_PER_NODE sander.MPI
]])

family('amber')

