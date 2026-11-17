-- HPCC-only QM/MM compatibility policy; preserve standalone Q-Chem 6.1.
if mode() == "load" and (isloaded("qchem/6.1")) then
    LmodError("HPCC Q-Chem 6.1 is unsupported for QM/MM: this installed build lacks native scalar ESP file 1521.0 required by QMHub. Use qchem/6.3 with sander/26 and qmhub2; keep 6.1 for standalone Q-Chem.")
end
conflict("qchem/6.1")
whatis("HPCC QM/MM policy: incompatible with qchem/6.1; use qchem/6.3.")
help([[HPCC Q-Chem 6.1 is unsupported for QM/MM: this installed build lacks native scalar ESP file 1521.0 required by QMHub. Use qchem/6.3 with sander/26 and qmhub2; keep 6.1 for standalone Q-Chem.]])

--- Variables
local PkgDir = "/home/van/Programs"
local Pkg = "sander26"
local Base = tostring(pathJoin(PkgDir, Pkg))

local TargetCompiler = 'gnu7/7.3.0'
local TargetMPI      = 'openmpi3/3.1.0'
local SanderNTasks   = os.getenv("SLURM_NTASKS_PER_NODE") or "${SLURM_NTASKS_PER_NODE}"
-- Q-Chem/OpenMP threads follow allocated CPUs per task, never MPI rank counts.
local cpusPerTask = os.getenv("SLURM_CPUS_PER_TASK") or ""
local ThreadDefault = "1"
if cpusPerTask:match("^%d+$") and tonumber(cpusPerTask) > 0 then
    ThreadDefault = cpusPerTask
end

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
-- Lmod 7.8 collapses empty pushenv stack entries to unset. Save just that
-- distinction and use fixed exports, never shell text derived from user values.
local emptyExports = {
    OMP_NUM_THREADS = "export OMP_NUM_THREADS=''",
    OPENBLAS_NUM_THREADS = "export OPENBLAS_NUM_THREADS=''",
    QCTHREADS = "export QCTHREADS=''",
    OMP_PROC_BIND = "export OMP_PROC_BIND=''",
}
local function pushThreadSetting(name, value)
    local flag = "_SANDER26_WAS_EMPTY_" .. name
    local restoreEmpty = os.getenv(flag) == "1"
    pushenv(flag, os.getenv(name) == "" and "1" or "0")
    pushenv(name, value)
    if value == "" then
        execute{cmd=emptyExports[name], modeA={"load"}}
    end
    if mode() == "unload" and restoreEmpty then
        execute{cmd=emptyExports[name], modeA={"unload"}}
    end
end

-- Preserve explicit user settings; pushenv restores their prior values on unload.
pushThreadSetting("OMP_NUM_THREADS"              , os.getenv("OMP_NUM_THREADS") or ThreadDefault)
pushThreadSetting("OPENBLAS_NUM_THREADS"           , os.getenv("OPENBLAS_NUM_THREADS") or ThreadDefault)
pushThreadSetting("QCTHREADS"                    , os.getenv("QCTHREADS") or ThreadDefault)
pushThreadSetting("OMP_PROC_BIND"                , os.getenv("OMP_PROC_BIND") or "false")
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

export QCTHREADS=${SLURM_CPUS_PER_TASK:-1}
export SANDER="mpirun --bind-to none --map-by slot -np ${SLURM_NTASKS_PER_NODE} sander.MPI"
$SANDER -O -i mdin -o mdout -p prmtop -c inpcrd -r restrt

]])

family('amber')
