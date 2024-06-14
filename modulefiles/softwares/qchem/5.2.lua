--- Point to package 
local Base = pathJoin("/scratch/van/Programs/qchem")
local Version = "5.2"

local TargetCompiler = "intel/2021.2.0"
local TargetMPI      = "impi/2021.2.0"

-- Set environment
load(TargetCompiler)
load(TargetMPI)

--- From setqc.sh
setenv(        "QC", pathJoin(Base, "trunk2"))
setenv(     "QCAUX", pathJoin(Base, "qcaux"))
setenv("QCPLATFORM", "LINUX_Ix86_64")
setenv( "QCSCRATCH", pathJoin("/tmp", os.getenv("USER")))
setenv(    "RUNCPP", pathJoin("lib", "cpp"))

--- from qchem.setup.sh
prepend_path("PATH", pathJoin(Base, "trunk2/bin"        ))
prepend_path("PATH", pathJoin(Base, "trunk2/bin/perl"   ))
prepend_path("PATH", pathJoin(Base, "trunk2/bin/mpi"    ))
prepend_path("PATH", pathJoin(Base, "trunk2/exe"        ))
prepend_path("PATH", pathJoin(Base, "trunk2/util"       ))

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


if (mode() == {'unload'}) then
    cmd = "unset QC; unset QCAUX; unset QCPLATFORM; unset QCSCRATCH; unset RUNCPP" 
    execute{cmd=cmd, modeA={"unload"}}
    remove_path("PATH", pathJoin(Base, "trunk2/bin"        ))
    remove_path("PATH", pathJoin(Base, "trunk2/bin/perl"   ))
    remove_path("PATH", pathJoin(Base, "trunk2/bin/mpi"    ))
    remove_path("PATH", pathJoin(Base, "trunk2/exe"        ))
    remove_path("PATH", pathJoin(Base, "trunk2/util"       ))
end



--- Description of software (`module whatis [module name]`)
whatis('QChem 5.2')
whatis('Compiled for QM/MM Simulations with Amber23')


--- Examples: How to use package (`module help [module name]`)
help([[

Examples

Running QChem    
    qchem -nt 8 qchem.inp qchem.out

Save scratch files:
    qchem -nt 8 qchem.inp qchem.out scratch

]])

family('qchem')
