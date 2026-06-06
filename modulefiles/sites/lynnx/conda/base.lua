local base = pathJoin("/home/van/Programs/miniforge3")

--- load 
execute{cmd=table.concat({"source ", pathJoin(base, "bin/activate ''")}), modeA={"load"}}

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
