#!/bin/bash

BASE="${HOME}/modulefiles" # Path to custom modules
HOSTNAME=$(hostname)       # Computer 

alias mlav='module --default available' # Only show default modules

module unuse /usr/share/modules/modulefiles # examples

if [[ "${HOSTNAME}" == "lynnx" ]]; then
    # Prepend new modules to $MODULEPATH 
    if [[ "${MODULEPATH}" == "*/${BASE}/lynnx*" ]]; then
        continue
    else
        module use ${BASE}/${HOSTNAME}/conda
        module use ${BASE}/${HOSTNAME}/apps
    fi
elif [[ "${HOSTNAME}" != "lynnx" ]]; then
    if [[ "${MODULEPATH}" == "*/${BASE}/softwares*" ]] | [[ "${MODULEPATH}" == "*/${BASE}/conda_environments*" ]]; then
        continue # Don't need this if my modules found in $MODULEPATH 
    else
        module use ${BASE}/pete/conda_environments                   # Shared conda environments
        module use ${BASE}/pete/softwares                            # Shared softwares
    fi
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
