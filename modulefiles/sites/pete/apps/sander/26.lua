--- Variables
local PkgDir = "/scratch/van/Programs"
local Pkg = "sander26"
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
pushenv(         "I_MPI_PMI_LIBRARY"  , "/usr/lib64/libpmi.so")
pushenv(         "I_MPI_THREAD_YIELD" , "3")
pushenv(         "I_MPI_THREAD_SLEEP" , "200")

-- Do not force process-global MKL preloads: they override Torch's own BLAS
-- symbols and break the GPU MLPUI profile. Sander's native ELF linkage and this
-- compiler/MPI stack already supply its required MKL runtime libraries.
--- CPU counts describe work available to one task; MPI ranks are not threads.
local allocated = os.getenv("SLURM_CPUS_PER_TASK") or "1"
if not allocated:match("^%d+$") or tonumber(allocated) < 1 then
    allocated = "1"
end
local thread_default = os.getenv("QCTHREADS") or allocated
-- Always evaluate pushenv so Lmod restores prior values during unload too.
pushenv("OMP_NUM_THREADS", os.getenv("OMP_NUM_THREADS") or thread_default)
pushenv("MKL_NUM_THREADS", os.getenv("MKL_NUM_THREADS") or thread_default)

--- unload
if (mode() == "unload") then
    unsetenv( "AMBERHOME")
    remove_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "lib"))
    remove_path(   "LD_LIBRARY_PATH"   , pathJoin(Base, "opt/intel/oneapi/mkl/2021.2.0/lib/intel64"))
    remove_path(   "PATH"              , pathJoin(Base, "bin"))
    remove_path(         "PERL5LIB"          , pathJoin(Base, "lib/perl"))
    remove_path(         "MKLROOT"           , "/opt/intel/oneapi/mkl/2021.2.0")
    remove_path(         "I_MPI_PMI_LIBRARY"  , "/usr/lib64/libpmi.so")
    remove_path(         "I_MPI_THREAD_YIELD" , "3")
    remove_path(         "I_MPI_THREAD_SLEEP" , "200")
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
