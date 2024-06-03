--- conda
---depends_on("miniforge3/24.4.0")
load("miniforge3/24.4.0")

--- python
cmd = "conda activate pyrosetta"
execute{cmd=cmd, modeA={"load"}}

---cmd = "conda deactivate 2>/dev/null"
---execute{cmd=cmd, modeA={"unload"}}

family('pyenv')
