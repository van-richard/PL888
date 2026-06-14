--- Point to package 
local Base = pathJoin("/home/van/Programs/qchem")
local Version = "5.2"

local TargetCompiler = 'gnu7/7.3.0'
local TargetMPI      = 'openmpi3/3.1.0'

--- Load 
load(TargetCompiler)
load(TargetMPI)
load('share_modules/FFTW/3.3.8_gcc_dp')
load('boost/1.67.0')
load('share_modules/NETCDF/NETCDF4')
load('share_modules/HDF5/1.10.5_gcc')

--- From setqc.sh
setenv(        "QC", pathJoin(Base, Version))
setenv(     "QCAUX", pathJoin(Base, "qcaux"))
setenv("QCPLATFORM", "LINUX_Ix86_64")
setenv( "QCSCRATCH", pathJoin("/tmp", os.getenv("USER")))
setenv(    "RUNCPP", pathJoin("lib", "cpp"))

--- from qchem.setup.sh
prepend_path("PATH", pathJoin(Base, Version, "bin"        ))
prepend_path("PATH", pathJoin(Base, Version, "bin/perl"   ))
prepend_path("PATH", pathJoin(Base, Version, "bin/mpi"    ))
prepend_path("PATH", pathJoin(Base, Version, "exe"        ))
prepend_path("PATH", pathJoin(Base, Version, "util"       ))

set_alias(     "qc", "cd $QC")
set_alias("aimdman", "cd $QC/aimdman")
set_alias( "drvman", "cd $QC/drvman")
set_alias( "libgen", "cd $QC/libgen")
set_alias( "libint", "cd $QC/libint")
set_alias( "liblas", "cd $QC/liblas")
set_alias( "oepman", "cd $QC/oepman")
set_alias("progman", "cd $QC/progman")
set_alias( "scfman", "cd $QC/scfman")
set_alias( "setman", "cd $QC/setman")

cmd = "unset QC; unset QCAUX; unset QCPLATFORM; unset QCSCRATCH; unset RUNCPP" 
execute{cmd=cmd, modeA={"unload"}}

if (mode() == "unload") then
    remove_path("PATH", pathJoin(Base, Version, "bin"        ))
    remove_path("PATH", pathJoin(Base, Version, "bin/perl"   ))
    remove_path("PATH", pathJoin(Base, Version, "bin/mpi"    ))
    remove_path("PATH", pathJoin(Base, Version, "exe"        ))
    remove_path("PATH", pathJoin(Base, Version, "util"       ))
end



--- Description of software (`module whatis [module name]`)
whatis('QChem 5.2')
whatis('Compiled for QM/MM Simulations with sander26')


--- Examples: How to use package (`module help [module name]`)
help([[

Examples

Running QChem    
    qchem -nt 8 qchem.inp qchem.out

Save scratch files:
    qchem -nt 8 qchem.inp qchem.out scratch

]])

family('qchem')
