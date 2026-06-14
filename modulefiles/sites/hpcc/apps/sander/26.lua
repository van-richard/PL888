--- Variables
local PkgDir = "/home/van/Programs"
local Pkg = "sander26"
local Base = tostring(pathJoin(PkgDir, Pkg))

local TargetCompiler = 'gnu7/7.3.0'
local TargetMPI      = 'openmpi3/3.1.0'

--- Load 
load(TargetCompiler)
load(TargetMPI)
load('share_modules/FFTW/3.3.8_gcc_dp')
load('boost/1.67.0')
load('share_modules/NETCDF/NETCDF4')
load('share_modules/HDF5/1.10.5_gcc')

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
setenv(         "AMBERHOME"         , Base)
prepend_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "lib"))
prepend_path(   "LD_LIBRARY_PATH"   , MklLibDir)
prepend_path(   "PATH"              , pathJoin(Base, "bin"))
pushenv(         "PERL5LIB"          , pathJoin(Base, "lib/perl"))

--- Set threads for QMHub - QChem
if (os.getenv('MKL_NUM_THREADS') == nil) and (os.getenv('OMP_NUM_THREADS') == nil) then
    if (os.getenv('SLURM_NTASKS')) then
        pushenv("MKL_NUM_THREADS", tostring(os.getenv('SLURM_NTASKS')))
        pushenv("OMP_NUM_THREADS", tostring(os.getenv('SLURM_NTASKS')))
    elseif (os.getenv('SLURM_NTASKS_PER_NODE')) then
        pushenv("MKL_NUM_THREADS", tostring(os.getenv('SLURM_NTASKS_PER_NODE')))
        pushenv("OMP_NUM_THREADS", tostring(os.getenv('SLURM_NTASKS_PER_NODE')))
    else
        pushenv("MKL_NUM_THREADS", "4")
        pushenv("OMP_NUM_THREADS", "4")
    end
end

--- unload
if (mode() == "unload") then
    unsetenv( "AMBERHOME")
    remove_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "lib"))
    remove_path(   "PATH"              , pathJoin(Base, "bin"))
    unsetenv(      "PERL5LIB")
    unsetenv(      "MKL_NUM_THREADS")
    unsetenv(      "OMP_NUM_THREADS")
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
