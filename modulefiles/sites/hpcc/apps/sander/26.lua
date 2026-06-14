--- Variables
local PkgDir = "/home/van/Programs"
local Pkg = "sander26"
local Base = tostring(pathJoin(PkgDir, Pkg))

local TargetCompiler = 'gnu7/7.3.0'
local TargetMPI      = 'openmpi3/3.1.0'
local SanderNTasks   = os.getenv("SLURM_NTASKS_PER_NODE") or "${SLURM_NTASKS_PER_NODE}"

--- Load 
load(TargetCompiler)
load(TargetMPI)
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
setenv(         "OMPI_MCA_mpi_yield_when_idle", "1")
setenv(         "OMPI_MCA_btl"                 , "self,vader,tcp")
setenv(         "OMPI_MCA_pml"                 , "ob1")
setenv(         "OMPI_MCA_mtl"                 , "^psm,psm2")
setenv(         "PMIX_MCA_pnet"                , "^opa")
setenv(         "OMPI_MCA_oob"                 , "^ud")
setenv(         "OMPI_MCA_btl_base_warn_component_unused", "0")
pushenv(        "OMP_NUM_THREADS"              , "1")
pushenv(        "OPENBLAS_NUM_THREADS", "1")
setenv(         "QCTHREADS"                    , "16")
setenv(         "OMP_PROC_BIND"                , "false")
setenv(         "SANDER"                       , "mpirun --bind-to none --map-by slot -np " .. SanderNTasks .. " sander.MPI")

--- unload
if (mode() == "unload") then
    unsetenv(    "AMBERHOME")
    remove_path( "LD_LIBRARY_PATH"      , pathJoin(Base, "lib"))
    remove_path( "PATH"                 , pathJoin(Base, "bin"))
    unsetenv(    "QUICK_BASIS")
    unsetenv(    "CC")
    unsetenv(    "CXX")
    unsetenv(    "FC")
    unsetenv(    "OMPI_MCA_mpi_yield_when_idle")
    unsetenv(    "OMPI_MCA_btl")
    unsetenv(    "OMPI_MCA_pml")
    unsetenv(    "OMPI_MCA_mtl")
    unsetenv(    "PMIX_MCA_pnet")
    unsetenv(    "OMPI_MCA_oob")
    unsetenv(    "OMPI_MCA_btl_base_warn_component_unused")
    unsetenv(    "OMP_NUM_THREADS")
    unsetenv(    "OPENBLAS_NUM_THREADS")
    unsetenv(    "QCTHREADS")
    unsetenv(    "OMP_PROC_BIND")
    unsetenv(    "SANDER")
end

--- Description of software (`module whatis [module name]`)
whatis('\
Name: Patched ambertools26 for QM/MM (Dr. Pan) \
Description: \
')


--- Examples: How to use package (`module help [module name]`)
help([[
Example usage (Note: Only in `interactive` or SLURM script!):

export QCTHREADS=16
export SANDER="mpirun --bind-to none --map-by slot -np ${SLURM_NTASKS_PER_NODE} sander.MPI"
$SANDER -O -i mdin -o mdout -p prmtop -c inpcrd -r restrt

]])

family('amber')
