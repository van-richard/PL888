#!/bin/bash
# download pdb/url using wget or curl
#

opts="pdb url"

function vget () {
    local item
    local rcsb="https://files.rcsb.org/download"
    local pdbid 
    local link
    local pathout
    local vreply

    if $(compgen -c | grep -q "wget"); then
        vreply="wget"
    elif $(compgen -c | grep "curl"); then
        vreply="curl"
    fi


    if [ "${2}" == "pdb" ]; then
        if [ -z "${2}" ]; then
            echo "missing: pdbid !!!"
        fi
        pdbid=$(echo $2 | awk '{print tolower($0)}')
        link="${rcsb}/${pdbid}.pdb"

    elif [ "${1}" == "url" ]; then
        if [ -z "${2}" ]; then
            echo "missing: url !!!"
        fi
        link=$(echo ${2})

    elif [ -z "${@}" ]; then
        echo "vget [pdb|url] [pdbid|link] [OPTIONAL:output path]"

    else
        if [ ! -z "${3}" ]; then
            pathout="-P ${3}"
        fi

        ${vreply} ${link} ${pathout}
    fi
    
}

complete -W "${opts}" vget

