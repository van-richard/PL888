--- Point to package 
local Base   = pathJoin("/scratch/van/Programs/24-gpu")

--- environment
load("gcc/11.2.0")
load("openmpi-4.1.1/gcc")
load("intel/2021.2.0")
load("impi/2021.2.0")
load("cuda/12.1")

--- From `amber.sh` ($LMOD_DIR/sh_to_modulefile /path/to/amber.sh > 23.lua)
setenv(         "AMBERHOME"       , Base)
prepend_path(   "LD_LIBRARY_PATH" , pathJoin(Base, "lib"))
prepend_path(   "PATH"            , pathJoin(Base, "bin"))
pushenv(         "PERL5LIB"       , pathJoin(Base, "lib/perl"))
pushenv(         "QUICK_BASIS"       , pathJoin(Base, "/AmberTools/src/quick/basis"))

if (mode() == "unload") then
    unsetenv(   "AMBERHOME")
    remove_path("LD_LIBRARY_PATH" , pathJoin(Base, "lib"))
    remove_path("PATH"            , pathJoin(Base, "bin"))
    unsetenv(         "PERL5LIB"       , pathJoin(Base, "lib/perl"))
    unsetenv(         "QUICK_BASIS"       , pathJoin(Base, "/AmberTools/src/quick/basis"))
end

--- Description of software (`module whatis [module name]`)
whatis('Amber24')
whatis('Compiled for classical MD simulations on GPU / CPU ')


--- Examples: How to use package (`module help [module name]`)
help([[
pmemd.cuda

]])

family('amber')

