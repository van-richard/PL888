--- Variables
local PkgDir = "/scratch/van/Programs"
local Pkg = "rosetta"
local Base = tostring(pathJoin(PkgDir,Pkg))

local TargetCompiler = "gcc/13.2.0"
local TargetPython   = "pyrosetta"

--- Load 
load(TargetCompiler)
load(TargetPython)

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
prepend_path(   "PATH"              , pathJoin(Base, "bin"))


if (mode() == "unload") then
    remove_path("PATH", pathJoin(Base, "bin"))
end

--- Description of software (`module whatis [module name]`)
whatis('rosetta')

--- Examples: How to use package (`module help [module name]`)
help([[
Example usage (Note: Only in `interactive` or SLURM script!):

]])

family("rosetta")
