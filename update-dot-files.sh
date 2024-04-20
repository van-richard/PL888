#!/bin/bash

FILEDIR="dotfiles"                                      # Directory name 
BASEDIR=$(realpath .)                                   # Path to this directory
DOTFILES=$(ls ${FILEDIR}/* | awk -F '/' '{print $2}')   # List of dotfiles

cd ${HOME}

for file in ${DOTFILES}; do

    printf "${file}\t"    
    file1="${BASE}/dotfiles/${file}"                    # Reference dotfile
    file2=".${file}"                                    # Output dotfile
    if [ ! -f ${file2} ]; then
        printf "Writing ${file2}"
        ln -sf ${file1} ${file2}                        # Symbolic link as hidden file
    elif [ ${file1} -nt ${file2} ]; then                  # if newer than ...
        printf "Updating ${file2} !!!"
        ln -sf ${file1} ${file2}                        # Symbolic link as hidden file
    elif [ -L ${file2} ]; then 
        # if same or symlink ...                        # if symblink ...
        printf "Nothing to update !!!\n\n"
    fi
done | column -t                                        # stdout column format
