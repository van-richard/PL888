--- Point to package 
local PkgDir   = "/home/van/Programs"
local Pkg    = "pmemd25"
local Base   = tostring(pathJoin(PkgDir, Pkg))
local USR = "/usr/local"

setenv( "CUDA_HOME", pathJoin(USR, "cuda"))
prepend_path( "PATH", pathJoin(USR, "cuda", "bin"))
append_path( "LD_LIBRARY_PATH", pathJoin(USR, "cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"))
setenv( "XLA_TARGET", "cuda120")
setenv( "XLA_FLAGS", "--xla_gpu_cuda_data_dir=/usr/local/cuda")


if (mode() == "unload") then
    remove_path("LD_LIBRARY_PATH"       , pathJoin(USR, "cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"))
    remove_path("CUDA_HOME"              , pathJoin(Base, "cuda"))
    remove_path("PATH"                  , pathJoin(USR, "cuda", "bin"))
    unsetenv( "XLA_TARGET", "cuda120")
    unsetenv( "XLA_FLAGS", "--xla_gpu_cuda_data_dir=/usr/local/cuda")
end

--- Description of software (`module whatis [module name]`)
whatis('CUDA 12.8')

--- Examples: How to use package (`module help [module name]`)
help([[
nvidia-smi
]])

family('cuda')

