#!/bin/bash

me () {
    # Check SLURM queue for user
    local username=$USER
    local iterate=0
    
    while getopts 'uir:v' OPTARG; do
        case "${OPTARG}" in 
            u|user) username=${OPTARG} ;;
            i|iter) iterate=${OPTARG} ;;
        esac
    done
    squeue --format='%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R' --user=${id}
}


