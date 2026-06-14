--- Variables
local PkgDir = "/home/van/Programs"
local Pkg = "sander26"
local Base = tostring(pathJoin(PkgDir, Pkg))

local TargetCompiler = 'gnu7/7.3.0'
local TargetMPI      = 'openmpi3/3.1.0'

--- Load 
load(TargetCompiler)
load(TargetMPI)
load('openblas/0.2.20')
load('share_modules/FFTW/3.3.8_gcc_dp')
load('boost/1.67.0')
load('share_modules/NETCDF/NETCDF4')
load('share_modules/HDF5/1.10.5_gcc')
load('qmhub2')

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
setenv(         "AMBERHOME"         , Base)
prepend_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "lib"))
prepend_path(   "PATH"              , pathJoin(Base, "bin"))
setenv(         "QUICK_BASIS"       , pathJoin(Base, "AmberTools/src/quick/basis"))

--- From `env-gnu.sh`
setenv(         "CC"                  , "/opt/ohpc/pub/compiler/gcc/7.3.0/bin/gcc")
setenv(         "CXX"                 , "/opt/ohpc/pub/compiler/gcc/7.3.0/bin/g++")
setenv(         "FC"                  , "/opt/ohpc/pub/compiler/gcc/7.3.0/bin/gfortran")
pushenv(        "OPENBLAS_NUM_THREADS", "1")

--- unload
if (mode() == "unload") then
    unsetenv(    "AMBERHOME")
    remove_path( "LD_LIBRARY_PATH"      , pathJoin(Base, "lib"))
    remove_path( "PATH"                 , pathJoin(Base, "bin"))
    unsetenv(    "QUICK_BASIS")
    unsetenv(    "CC")
    unsetenv(    "CXX")
    unsetenv(    "FC")
    unsetenv(    "OPENBLAS_NUM_THREADS")
end

--- Description of software (`module whatis [module name]`)
whatis('\
Name: Patched ambertools26 for QM/MM (Dr. Pan) \
Description: \
')


--- Examples: How to use package (`module help [module name]`)
help([[
Example usage (Note: Only in `interactive` or SLURM script!):

]])

family('amber')
