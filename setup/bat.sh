#!/bin/bash


url="https://github.com/sharkdp/bat/releases/download/v0.24.0/"
fname="bat-v0.24.0-i686-unknown-linux-musl"
dirname="$HOME/.local"

wget ${url}/${fname}.tar.gz -P /tmp
tar xf /tmp/${fname}.tar.gz -C /tmp
mv /tmp/${fname}/bat ${dirname}/bin
mv /tmp/${fname}/autocomplete ${dirname}/share

printf "\nfiles are saved to: ${dirname}"
printf "\nadd one of the following to your ~/.bashrc file"
printf "\nalias cat='${dirname}/bin/bat"
printf "\n\tor"
printf "\nexport PATH='${dirname}/bin:\${PATH}'"
printf "\nexport PATH='${dirname}/share:\${PATH}'"

rm -rf /tmp/${fname}.tar.gz /tmp/${fname}
