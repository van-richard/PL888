--- conda
depends_on("miniforge3/24.4.0")

--- python
cmd = "conda activate qmhub"
execute{cmd=cmd, modeA={"load"}}

if (mode() == "unload") then
    cmd = "conda activate base"
    execute{cmd=cmd, modeA={"unload"}}
end

family('pyenv')
