help([[
Sets up OSCER QMMM environment equivalent to sourcing oscer.qmmm.env:
- Loads intel/2020a toolchain
- Sources Q-Chem env and Amber20 env
- Activates conda (base) from miniforge3
- Sets UCX/MPI tuning and threads from SLURM_NTASKS_PER_NODE
- Exposes SANDER launcher string

Usage in Slurm:
    module use $HOME/modulefiles
    module load 23-panxl
]])

whatis("QMMM stack: intel/2020a + Q-Chem + Amber20 + conda(base)")
whatis("Sets UCX/MPI knobs; threads from SLURM_NTASKS_PER_NODE")
whatis("Defines $SANDER launcher for sander.MPI via Slurm bootstrap")

-- ---- Constants / paths
local qc_set     = "/home/panxl/qchem/trunk2/setqc.sh"
local amber_sh   = "/home/panxl/amber20/amber.sh"
local conda_bin  = "/home/panxl/.local/opt/miniforge3/bin/conda"

-- ---- Compiler/toolchain
depends_on("intel/2020a")   -- mirrors: module load intel/2020a

-- ---- Q-Chem & Amber: import their env the right way
-- Why: Source shell scripts and import the resulting env changes.
source_sh("bash", qc_set)
source_sh("bash", amber_sh)

-- ---- Conda (base): activate via hook so PATH and env match 'conda activate'
-- Note: source_sh captures env deltas; no side-effects left behind.
local conda_cmd = [[eval $("]] .. conda_bin .. [[ shell.bash hook"); conda activate]]
source_sh("bash", conda_cmd)

-- ---- Fabric & MPI knobs
setenv("UCX_TLS", "all")
setenv("I_MPI_PIN", "0")
setenv("I_MPI_THREAD_YIELD", "3")
setenv("I_MPI_THREAD_SLEEP", "200")
setenv("I_MPI_OFI_PROVIDER", "verbs")

-- ---- Threads: follow the Slurm layout (fallback=1 if unset)
local nthreads = os.getenv("SLURM_NTASKS_PER_NODE") or "1"
setenv("MKL_NUM_THREADS", nthreads)
setenv("OMP_NUM_THREADS", nthreads)

-- ---- Convenience: SANDER launcher (string var)
local sander_cmd = "mpiexec.hydra -bootstrap slurm -n " .. nthreads .. " sander.MPI"
setenv("SANDER", sander_cmd)

-- ---- Friendly summary (load only)
if (mode() == "load") then
  execute{ cmd = "date", modeA = { "load" } }
  local msg = string.format([[
# of Threads:
    MKL: %s
    OMP: %s

sander: %s
]], nthreads, nthreads, sander_cmd)
  -- print to stderr so it shows in Slurm logs reliably
  io.stderr:write(msg .. "\n")
  execute{ cmd = "date", modeA = { "load" } }
end

