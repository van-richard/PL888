--- Point to package 
local PkgDir = pathJoin("/scratch", "van", "Programs")
local Pkg    = "amber24"
local Base   = tostring(pathJoin(PkgDir, Pkg))

--- environment
local TargetGCC     = "gcc/11.2.0"
local TargetINTEL   = "intel/2021.2.0"
local TargetMPI     = "impi/2021.2.0"

--- Set up environment
load(TargetINTEL)
load(TargetMPI)
load(TargetGCC)

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
---setenv(         "FFTW_ROOT"             , pathJoin("/opt", "fftw", "3.3.10"))
setenv(         "MKLROOT"               , pathJoin("/opt", "intel", "oneapi", "mkl", "2021.2.0"))
setenv(         "LD_PRELOAD"            , pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_sequential.so"))
prepend_path(   "LD_PRELOAD"            , pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_core.so"))
setenv(         "I_MPI_PMI_LIBRARY"     , pathJoin("/usr", "lib64", "libpmi.so"))
setenv(         "I_MPI_THREAD_YIELD"    , tostring("3"))
setenv(         "I_MPI_THREAD_SLEEP"    , tostring(200))

setenv(         "AMBERHOME"             , Base)
prepend_path(   "LD_LIBRARY_PATH"       , pathJoin(Base, "lib"))
prepend_path(   "PATH"                  , pathJoin(Base, "bin"))
prepend_path(   "PERL5LIB"              , pathJoin(Base, "lib/perl"))
pushenv(        "PYTHONPATH"            , pathJoin(Base, "lib/python3.12/site-packages"))
setenv(         "QUICK_BASIS"           , pathJoin(Base, "AmberTools/src/quick/basis"))

if (mode() == "unload") then
    unsetenv(    "FFTW_ROOT"            , pathJoin("/opt", "fftw", "3.3.10"))
    unsetenv(    "MKLROOT"              , pathJoin("/opt", "intel", "oneapi", "mkl", "2021.2.0"))
    remove_path("LD_PRELOAD"            , pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_core_so:"))
    remove_path("LD_PRELOAD"            , pathJoin(os.getenv("MKLROOT"), "lib/intel64/libmkl_sequential.so"))
    unsetenv(   "LD_PRELOAD")
    unsetenv(   "I_MPI_PMI_LIBRARY"     , pathJoin("/usr", "lib64", "libpmi.so"))
    unsetenv(   "I_MPI_THREAD_YIELD"    , tostring("3"))
    unsetenv(   "I_MPI_THREAD_SLEEP"    , tostring(200))
    unsetenv(   "AMBERHOME"             , Base)
    remove_path("LD_LIBRARY_PATH"       , pathJoin(Base, "lib"))
    remove_path("PATH"                  , pathJoin(Base, "bin"))
    remove_path("PERL5LIB"              , pathJoin(Base, "lib/perl"))
    unsetenv(   "PYTHONPATH"            , pathJoin(Base, "lib/python3.12/site-packages"))
    unsetenv(   "QUICK_BASIS"           , pathJoin(Base, "AmberTools/src/quick/basis"))
end

--- Description of software (`module whatis [module name]`)
whatis('\
\
Description: \
\
Assisted Model Building with Energy Refinement (AMBER) \
\
Perform classical MD simulations on CPU (serial/MPI) or GPU (cuda) \
\
More info: https://ambermd.org \
')


--- Examples: How to use package (`module help [module name]`)
help([["mpirun -np $SLURM_NTASKS_PER_NODE"]])

family('amber')

