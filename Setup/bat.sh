#!/bin/bash

url="https://github.com/sharkdp/bat/releases/download/v0.24.0"
fname="bat-v0.24.0-i686-unknown-linux-musl"
cmd="bat"

if ! echo "$(which ${bat})"| grep -q "${bat}"; then
    echo "missing: bat !!!"
    

    wget ${url}/${fname}.tar.gz -P /tmp
    tar xf /tmp/${fname}.tar.gz -C /tmp
    
    mv /tmp/${fname}/bat ${_vlocal}/bin
    
    mkdir -p ${_vlocal}/autocomplete/bat
    mv /tmp/${fname}/autocomplete ${_vlocal}/autocomplete/${cmd}
fi

printf "\nadd one of the following to your ~/.bashrc file"
printf "\nalias cat='${_vlocal}/bin/bat"
printf "\n\tor"
printf "\nexport PATH='${_vlocal}/bin:\${PATH}'"
printf "\nexport PATH='${_vlocal}/share:\${PATH}'"

rm -rf /tmp/${fname}.tar.gz /tmp/${fname}

unset url fname cmd
