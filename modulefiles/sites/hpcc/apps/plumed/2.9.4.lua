--- Point to package
local PkgDir = "/home/van/Programs"
local Pkg    = "plumed-2.9.4"
local Base   = tostring(pathJoin(PkgDir, Pkg))

local BinDir     = pathJoin(Base, "bin")
local LibDir     = pathJoin(Base, "lib")
local IncludeDir = pathJoin(Base, "include")
local PlumedLib  = pathJoin(LibDir, "libplumed.so")
local KernelLib  = pathJoin(LibDir, "libplumedKernel.so")


--- From `plumed.sh`
setenv(         "PLUMED_ROOT"           , Base)
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
prepend_path(   "PYTHONPATH"            , pathJoin(LibDir, "plumed", "python"))

if (mode() == "unload") then
    unsetenv(   "PLUMED_ROOT"           , Base)
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
    remove_path("PYTHONPATH"            , pathJoin(LibDir, "plumed", "python"))
end

--- Description of software (`module whatis [module name]`)
whatis('PLUMED 2.9.4')
whatis('Molecular dynamics plugin for enhanced sampling and free-energy calculations')


--- Examples: How to use package (`module help [module name]`)
help([[
plumed --help
]])

family('plumed')
