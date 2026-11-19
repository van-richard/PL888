--- Variables
local PkgDir = "/scratch/van/Programs"
local Pkg = "sander26"
local Base = tostring(pathJoin(PkgDir, Pkg))
local CompatDir = "/scratch/van/Programs/sander26-compat/20261119/lib"

-- GPU nodes omit these older ABIs. Use the exact CPU-validated runtime copies,
-- isolated from the Sander tree and Conda environments; never alias newer ABIs.
if mode() == "load" then
    for _, soname in ipairs({"libnetcdf.so.7", "libgsl.so.0", "libgslcblas.so.0"}) do
        if not isFile(pathJoin(CompatDir, soname)) then
            LmodError("Sander CPU/GPU compatibility library is missing: " .. pathJoin(CompatDir, soname))
        end
    end
end

local TargetCompiler = "intel/2021.2.0"
local TargetMPI = "impi/2021.2.0"

-- Lmod's pushenv stack normalizes an originally empty value to unset. Retain
-- that one state separately so unloading also restores explicitly empty exports.
local function rememberEmpty(name)
    local flag = "_SANDER26_WAS_EMPTY_" .. name
    local restoreEmpty = os.getenv(flag) == "1"
    pushenv(flag, os.getenv(name) == "" and "1" or "0")
    if mode() == "unload" and restoreEmpty then
        execute{cmd = "export " .. name .. "=''", modeA = {"unload"}}
    end
end
-- Keep a preloaded compiler/MPI stack on unload; remove dependencies loaded
-- only for Sander. Remember caller values before dependencies can replace them.
for _, name in ipairs({"LD_LIBRARY_PATH", "AMBERHOME", "PERL5LIB", "MKLROOT",
    "I_MPI_PMI_LIBRARY", "I_MPI_THREAD_YIELD", "I_MPI_THREAD_SLEEP",
    "OMP_NUM_THREADS", "MKL_NUM_THREADS"}) do
    rememberEmpty(name)
end
local originalOMP = os.getenv("OMP_NUM_THREADS")
local originalMKL = os.getenv("MKL_NUM_THREADS")
local restoreCompiler = os.getenv("_SANDER26_RESTORE_INTEL") == "1"
pushenv("_SANDER26_RESTORE_INTEL",
    isloaded(TargetCompiler) and not isloaded(TargetMPI) and "1" or "0")
depends_on(TargetCompiler)
depends_on(TargetMPI)

--- From amber.sh, without process-global BLAS overrides.
pushenv("AMBERHOME", Base)
prepend_path("LD_LIBRARY_PATH", pathJoin(Base, "lib"))
prepend_path("LD_LIBRARY_PATH", pathJoin(Base, "opt/intel/oneapi/mkl/2021.2.0/lib/intel64"))
prepend_path("LD_LIBRARY_PATH", CompatDir)
prepend_path("PATH", pathJoin(Base, "bin"))
pushenv("PERL5LIB", pathJoin(Base, "lib/perl"))
pushenv("MKLROOT", "/opt/intel/oneapi/mkl/2021.2.0")
pushenv("I_MPI_PMI_LIBRARY", "/usr/lib64/libpmi.so")
pushenv("I_MPI_THREAD_YIELD", "3")
pushenv("I_MPI_THREAD_SLEEP", "200")

-- Forced MKL LD_PRELOAD entries override Torch's BLAS symbols and break MLPUI.
-- Sander's ELF linkage and the declared Intel stack provide its MKL libraries.
-- CPUs per task describe thread capacity; MPI rank counts must not set threads.
local allocated = os.getenv("SLURM_CPUS_PER_TASK") or "1"
if not allocated:match("^%d+$") or tonumber(allocated) < 1 then
    allocated = "1"
end
local threadDefault = os.getenv("QCTHREADS") or allocated
pushenv("OMP_NUM_THREADS", originalOMP or threadDefault)
pushenv("MKL_NUM_THREADS", originalMKL or threadDefault)

-- OSU's legacy Tcl IMPI module unconditionally unloads Intel, even when Intel
-- belonged to the caller. Repair only an explicit Sander unload; a purge, swap,
-- or explicit compiler unload must still honor the user's requested operation.
-- execute runs in the module shell function, where "$@" retains that operation.
if mode() == "unload" and restoreCompiler then
    local restoreCommand = table.concat({
        "_sander26_restore_compiler=no;",
        "for _sander26_arg in \"$@\"; do case \"$_sander26_arg\" in",
        "unload|rm) _sander26_restore_compiler=yes ;;",
        "purge|reset|restore|swap|switch|intel|intel/*) _sander26_restore_compiler=no; break ;;",
        "esac; done;",
        "if [ \"$_sander26_restore_compiler\" = yes ]; then module load intel/2021.2.0; fi;",
        "unset _sander26_restore_compiler _sander26_arg",
    }, " ")
    execute{cmd = restoreCommand, modeA = {"unload"}}
end

-- Lmod reverses the declarations above; manual unset/remove calls would erase
-- values restored by pushenv or dependencies belonging to the caller.
whatis("OSU Sander 26: QMHub binary/FIFO; Intel 2021.2; Torch-compatible linkage; CPU/GPU ABI runtime 20261119")
help([[
Patched AmberTools 26 Sander for QMHub on OSU Pete.
Use Bash and Lmod inside a Slurm allocation:
    module load sander/26 qchem/6.3 qmhub2-mlpui
    # Or select the baseline Python stack with module load qmhub2.

Explicit OMP_NUM_THREADS and MKL_NUM_THREADS are preserved. Defaults use
QCTHREADS or SLURM_CPUS_PER_TASK, falling back to one thread. Loading this module
does not inject MKL LD_PRELOAD entries. Unloading restores prior settings and
retains compiler/MPI modules that were already loaded.
The immutable sander26-compat/20261119 runtime supplies libnetcdf.so.7,
libgsl.so.0 and libgslcblas.so.0 on CPU and GPU nodes without changing existing
installations.
Exact empty-export and legacy compiler restoration are supported in Bash.
]])
family("amber")
