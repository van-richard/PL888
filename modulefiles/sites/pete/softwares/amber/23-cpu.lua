--- Point to package 
local Base = pathJoin("/scratch/van/.Programs/23GPU")

--- Environment
local TargetCompiler = "gcc/11.2.0"
local TargetMPI      = "mvapich2-2.2-psm/gcc"

--- Set up environment
load(TargetCompiler)
load(TargetMPI)

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
setenv(      "AMBERHOME"       , Base)
prepend_path("LD_LIBRARY_PATH" , pathJoin(Base, "lib"))
prepend_path("PATH"            , pathJoin(Base, "bin"))
pushenv(     "PERL5LIB"        , pathJoin(Base, "lib/perl"))
pushenv(     "PYTHONPATH"      , pathJoin(Base, "lib/python3.9/site-packages"))

if (mode() == "unload") then
    unsetenv(   "AMBERHOME")
    remove_path("LD_LIBRARY_PATH" , pathJoin(Base, "lib"))
    remove_path("PATH"            , pathJoin(Base, "bin"))
    remove_path("PYTHONPATH"      , pathJoin(Base, "lib/python3.9/site-packages"))
end

--- Description of software (`module whatis [module name]`)
whatis('Amber23')
whatis('Compiled for classical MD simulations on CPU / GPU')

--- Examples: How to use package (`module help [module name]`)
help([[

1) CPU - `sander` / `pmemd` - Serial Jobs 

# Typically only needed for simple minimization jobs with `sander` or `pmemd` 
sander -O -i min.mdin -p step3_pbcsetup.parm7 -c step3_pbcsetup.rst7 -o min.mdout -r min.rst7 -inf min.mdinfo
pmemd -O -i min.mdin -p step3_pbcsetup.parm7 -c step3_pbcsetup.rst7 -o min.mdout -r min.rst7 -inf min.mdinfo

2) CPU+MPI - `sander.MPI` or `pmemd.MPI`

# Make sure you have this SLURM directive set to the number of cores needed (2,4,..32)
#SBATCH --ntasks-per-node=32` 

# QM/MM
mpirun -n ${SLURM_NTASKS_PER_NODE} sander.MPI -O -i min.mdin -p step3_pbcsetup.parm7 -c step3_pbcsetup.rst7 -o min.mdout -r min.rst7 -inf min.mdinfo
# Classical
mpirun -n ${SLURM_NTASKS_PER_NODE} pmemd.MPI -O -i min.mdin -p step3_pbcsetup.parm7 -c step3_pbcsetup.rst7 -o min.mdout -r min.rst7 -inf min.mdinfo

3) On GPUs - `pmemd.cuda` 

# Make sure you have these SLURM directives !
#SBATCH -p bullet
#SBATCH -N 1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=5G
#SBATCH -gres=gpu:1

# Classical + large systems
pmemd.cuda -O -i min.mdin -p step3_pbcsetup.parm7 -c step3_pbcsetup.rst7 -o min.mdout -r min.rst7 -inf min.mdinfo

]])

family('amber')

