--- Variables
local PkgDir = "/home/van/.Programs"
local Pkg = "amber21"
local Base = tostring(pathJoin(PkgDir, Pkg))

local TargetCompiler = 'intel/2021.2.0'
local TargetMPI      = 'impi/2021.2.0'

--- Load 
load(TargetCompiler)
load(TargetMPI)

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
setenv(         "AMBERHOME"         , Base)
prepend_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "lib"))
prepend_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "opt/intel/oneapi/mkl/2021.2.0/lib/intel64"))
prepend_path(   "PATH"              , pathJoin(Base, "bin"))
pushenv(         "PERL5LIB"          , pathJoin(Base, "lib/perl"))
pushenv(         "MKLROOT"           , "/opt/intel/oneapi/mkl/2021.2.0")
prepend_path(    "LD_PRELOAD"        , tostring(pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_core.so")))
prepend_path(    "LD_PRELOAD"         , tostring(pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_sequential.so")))
pushenv(         "I_MPI_PMI_LIBRARY"  , "/usr/lib64/libpmi.so")
pushenv(         "I_MPI_THREAD_YIELD" , "3")
pushenv(         "I_MPI_THREAD_SLEEP" , "200")

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
    remove_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "opt/intel/oneapi/mkl/2021.2.0/lib/intel64"))
    remove_path(   "PATH"              , pathJoin(Base, "bin"))
    remove_path(         "PERL5LIB"          , pathJoin(Base, "lib/perl"))
    remove_path(         "MKLROOT"           , "/opt/intel/oneapi/mkl/2021.2.0")
    remove_path(    "LD_PRELOAD"        , tostring(pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_core.so")))
    remove_path(    "LD_PRELOAD"         , tostring(pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_sequential.so")))
    remove_path(         "I_MPI_PMI_LIBRARY"  , "/usr/lib64/libpmi.so")
    remove_path(         "I_MPI_THREAD_YIELD" , "3")
    remove_path(         "I_MPI_THREAD_SLEEP" , "200")
    remove_path("MKL_NUM_THREADS", "4")
    remove_path("OMP_NUM_THREADS", "4")
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
