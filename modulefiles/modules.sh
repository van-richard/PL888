#!/bin/bash

# Path to custom modules
MF="/home/van/modulefiles"

# Aliases
alias mlav='module --default available' # Only show default modules

# Prepend new modules to $MODULEPATH 
#   1) /home/van/modulefiles/conda_environments
#       - Similar to `conda activate [environment name]`. Should work with your existing conda...
#   2) /home/van/modulefiles/softwares
#       - CCATS research group softwares. Programs can be stacked (see examples in /home/van/examplesfiles/modulefiles/)

if [[ "${MODULEPATH}" == "*/home/van/modulefiles/softwares*" ]] | [[ "${MODULEPATH}" == "*/home/van/modulefiles/conda_environments*" ]]; then
    # Don't need this if my modules found in $MODULEPATH 
    continue
else
    # Copy of original modulepath, and prepend new modules 
    export original_MODULEPATH=$(env | grep "^MODULEPATH=" | awk -F "=" '{print $2}')   # Save original $MODULEPATH
    module use ${MF}/conda_environments                                                 # Shared conda environments
    module use ${MF}/softwares                                                          # Shared softwares
fi






##############################################################################
# Need to work on lua spider cache
# Update module spider cache
#export LMOD_CACHED_LOADS=yes

#for luafiles in "softwares" "conda_environments"; do
#    $LMOD_DIR/update_lmod_system_cache_files \
#        -d ${MF}/${luafiles}/.cache \
#        -t ${MF}/${luafiles}/.cache/timestamp \
#        ${MF}/${luafiles}
#    echo $(date +%s) > ${MF}/${luafiles}/.cache/timestamp
#done

# if [ ! -f "$HOME/.lmodrc.lua" ]; then
#     echo "scDescriptT = { 
#     { 
#         ["dir"] = "/home/van/modulefiles/softwares/.cache", 
#         ["timestamp"] = "/home/van/modulefiles/softwares/.cache/timestamp", 
#     },
#     { 
#         ["dir"] = "/home/van/modulefiles/conda_environments/.cache", 
#         ["timestamp"] = "/home/van/modulefiles/conda_environments/.cache/timestamp", 
#     }
# }" > $HOME/.lmodrc.lua
# fi
