--- Point to package
local PkgDir = "/scratch/van/Programs"
local Pkg    = "plumed-2.9.4"
local Base   = tostring(pathJoin(PkgDir, Pkg))

local BinDir     = pathJoin(Base, "bin")
local LibDir     = pathJoin(Base, "lib")
local IncludeDir = pathJoin(Base, "include")
local DataDir    = pathJoin(LibDir, "plumed")
local PlumedLib  = pathJoin(LibDir, "libplumed.so")
local KernelLib  = pathJoin(LibDir, "libplumedKernel.so")

local TargetCompiler = "intel/2021.2.0"
local TargetMPI      = "impi/2021.2.0"

--- Load the compiler/MPI stack used by sander/26 and qchem/5.2.
load(TargetCompiler)
load(TargetMPI)

--- From `plumed.sh`
setenv(         "PLUMED_ROOT"           , DataDir)
setenv(         "PLUMED_LIBRARY"        , PlumedLib)
setenv(         "PLUMED_KERNEL_LIBRARY" , KernelLib)
setenv(         "PLUMED_KERNEL"         , KernelLib)
setenv(         "PLUMED_VIMPATH"        , pathJoin(LibDir, "plumed", "vim"))
prepend_path(   "PATH"                  , BinDir)
prepend_path(   "LD_LIBRARY_PATH"       , LibDir)
prepend_path(   "LIBRARY_PATH"          , LibDir)
prepend_path(   "CPATH"                 , IncludeDir)
prepend_path(   "INCLUDE"               , IncludeDir)
prepend_path(   "PKG_CONFIG_PATH"       , pathJoin(LibDir, "pkgconfig"))

if (mode() == "unload") then
    unsetenv(   "PLUMED_ROOT"           , DataDir)
    unsetenv(   "PLUMED_LIBRARY"        , PlumedLib)
    unsetenv(   "PLUMED_KERNEL_LIBRARY" , KernelLib)
    unsetenv(   "PLUMED_KERNEL"         , KernelLib)
    unsetenv(   "PLUMED_VIMPATH"        , pathJoin(LibDir, "plumed", "vim"))
    remove_path("PATH"                  , BinDir)
    remove_path("LD_LIBRARY_PATH"       , LibDir)
    remove_path("LIBRARY_PATH"          , LibDir)
    remove_path("CPATH"                 , IncludeDir)
    remove_path("INCLUDE"               , IncludeDir)
    remove_path("PKG_CONFIG_PATH"       , pathJoin(LibDir, "pkgconfig"))
end

--- Description of software (`module whatis [module name]`)
whatis('PLUMED 2.9.4')
whatis('Molecular dynamics plugin for enhanced sampling and free-energy calculations')


--- Examples: How to use package (`module help [module name]`)
help([[
plumed --help
]])

family('plumed')
