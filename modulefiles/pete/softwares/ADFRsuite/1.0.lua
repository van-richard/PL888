--- Point to package 
local PkgDir = "/scratch/van/Programs"
local Pkg    = "autodock"
local Base   = tostring(pathJoin(PkgDir, Pkg))
--- local Miniforge = "/home/van/.Programs/miniforge3"
--- local CondaEnv = "vina"

load("vina")


prepend_path( "PATH"             , pathJoin(Base, "bin"))
prepend_path( "LD_LIBRARY_PATH"  , pathJoin(Base, "lib"))


if (mode() == "unload") then
    remove_path("PATH", pathJoin(Base, "bin"))
    remove_path("LD_LIBRARY_PATH", pathJoin(Base, "lib"))
end

--- Description of software (`module whatis [module name]`)
whatis('\
    Name: ADFR Suite for Molecular Docking\
    Description: \
')


--- Examples: How to use package (`module help [module name]`)
help([[
Example usage (Note: Only in `interactive` or SLURM script!):

To load the module:

1) `interactive` 

$ module load 

2) SLURM 

module load 

-----------------------------------------------------------------------

After loading the module, you can run commands, such as:

]])


