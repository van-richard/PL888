--- Point to package 
local Version = "6.2"
local Base = pathJoin("/scratch/chance/trunk_6.2")

local TargetCompiler = "intel/2021.2.0"

-- Set environment
load(TargetCompiler)

--- From setqc.sh
setenv(        "QC", pathJoin(Base))
setenv(     "QCAUX", pathJoin("/home", "chance", "software", "qcaux"))
setenv("QCPLATFORM", pathJoin(os.getenv("QC"), "bin/qcplatform"))
setenv( "QCSCRATCH", pathJoin("/tmp", os.getenv("USER")))
setenv(    "RUNCPP", pathJoin("lib", "cpp"))

--- from qchem.setup.sh
prepend_path("PATH", pathJoin(Base, "bin"        ))
prepend_path("PATH", pathJoin(Base, "bin/perl"   ))
prepend_path("PATH", pathJoin(Base, "bin/mpi"    ))
prepend_path("PATH", pathJoin(Base, "exe"        ))
prepend_path("PATH", pathJoin(Base, "util"       ))

set_alias(     "qc", "cd $QC")
set_alias("aimdman", "cd $QC/aimdman")
set_alias( "drvman", "cd $QC/drvman")
set_alias( "libgen", "cd $QC/libgen")
set_alias( "libint", "cd $QC/libint")
set_alias( "liblas", "cd $QC/liblas")
set_alias("progman", "cd $QC/progman")
set_alias( "scfman", "cd $QC/scfman")
set_alias( "setman", "cd $QC/setman")

if (mode() == {'unload'}) then
    cmd = "unset QC; unset QCAUX; unset QCPLATFORM; unset QCSCRATCH; unset RUNCPP" 
    execute{cmd=cmd, modeA={"unload"}}
    remove_path("PATH", pathJoin(Base, "bin"        ))
    remove_path("PATH", pathJoin(Base, "bin/perl"   ))
    remove_path("PATH", pathJoin(Base, "bin/mpi"    ))
    remove_path("PATH", pathJoin(Base, "exe"        ))
    remove_path("PATH", pathJoin(Base, "util"       ))
end
--- Description of software (`module whatis [module name]`)
whatis('QChem 6.2')
whatis('Compiled by Chance Lander')


--- Examples: How to use package (`module help [module name]`)
help([[Email Chance]])

family('qchem')
