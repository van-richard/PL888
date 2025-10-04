--- Point to package 
local Base = pathJoin("/scratch/van/Programs/orca_6_0_1_linux_x86-64_shared_openmpi416")
local Version = "6.0.1"

local TargetMPI      = "openmpi-4.1.1/gcc"

-- Set environment
load(TargetMPI)

--- from qchem.setup.sh
prepend_path("PATH", pathJoin(Base))
prepend_path("LD_LIBRARY_PATH", pathJoin(Base))
---prepend_path("PATH", pathJoin(Base, "bin"        ))

---cmd = "unset QC; unset QCAUX; unset QCPLATFORM; unset QCSCRATCH; unset RUNCPP" 
---execute{cmd=cmd, modeA={"unload"}}

if (mode() == {'unload'}) then
    remove_path("PATH", pathJoin(Base))
    remove_path("LD_LIRBARY_PATH", pathJoin(Base))
    ---remove_path("PATH", pathJoin(Base, "bin"        ))
end
--- Description of software (`module whatis [module name]`)
whatis('ORCA 6.0.1')

--- Examples: How to use package (`module help [module name]`)
help([[]])

family('orca')
