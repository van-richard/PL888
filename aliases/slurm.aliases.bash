#!/bin/bash

q () {
    squeue --format='%.12i %.10P %.14j %.8u %.12M %.10T %.4D  %R' ${@}
}

me () {
    # Check SLURM queue for user
    while getopts 'ui:v' OPTARG; do
        case "${OPTARG}" in 
            u) u=${OPTARG} ;;
            i) i=${OPTARG} ;;
        esac
    done

    if [ ! -z ${u} ]; then
        username="--user=$USER"
    else 
        username="--user=${u}"
    fi

    if [ -z ${iter} ]; then
        iterate="--iterate=${iter}"
    fi

    q $username $iterate ${@}
}


