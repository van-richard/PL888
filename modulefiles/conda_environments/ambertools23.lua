local base = pathJoin("/home", "van", "miniforge3")
local env  = tostring(myModuleName())

--- load 
cmd=table.concat({"source ", pathJoin(base, "bin/activate "..env)})
execute{cmd=cmd, modeA={"load"}}

--- unload
if (mode() == "unload") then
    remove_path("PATH", pathJoin(base, "condabin"))
end

cmd = "conda deactivate; "..
    "unset CONDA_EXE; "..
    "unset CONDA_PYTHON_EXE; "..
    "unset CONDA_SHLVL; "..
    "unset _CE_CONDA"
execute{cmd=cmd, modeA={"unload"}}

family('conda')
extensions('amberutils/21.0, edgembar/0.2, mmpbsa-py/16.0, packmol-memgen/2023.2.24, pdb4amber/22.0, pymsmt/22.0, pytraj/2.0.6, parmed/4.2.2, pymsmt/22.0, sander/22.0')
