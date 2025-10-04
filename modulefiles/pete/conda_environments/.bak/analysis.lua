--- conda
depends_on("miniforge3/24.4.0")

--- python
cmd = "conda activate analysis"
execute{cmd=cmd, modeA={"load"}}

if (mode() == "unload") then
    cmd = "conda activate base"
    execute{cmd=cmd, modeA={"unload"}}
end

family('pyenv')
