--- Point to package 
local PkgDir = "/projects/ok001/Programs/"
local Pkg    = "ADFRsuite"
local Base   = tostring(pathJoin(PkgDir, Pkg))
local Miniforge = "/home/van/.Programs/miniforge3"
local CondaEnv = "vina"

prepend_path( "PATH"             , pathJoin(Base, "bin"))
prepend_path( "LD_LIBRARY_PATH"  , pathJoin(Base, "lib"))


-- python
conda_sh = pathJoin(Miniforge, "etc", "profile.d", "conda.sh")
cmd = "source "..conda_sh.."; conda activate "..CondaEnv
execute{cmd=cmd, modeA={"load"}}

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


