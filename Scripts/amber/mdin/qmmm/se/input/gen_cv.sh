#!/bin/bash
#input file and setup simulation parameters

CV_i=-1.9
step=0.1

cwd=$(realpath ..)
inp_dir="${cwd}/input"

cd $cwd
windows=($(cat list))

for window in "${windows[@]}"; do

    mkdir -p $window
    cd $window
    cp ${inp_dir}/cv.rst .

    nn=$(printf "%.3f" "${CV_i}")
    sed -i "s/__REST__/${nn}/g" cv.rst
    CV_i=$(echo $CV_i + $step | bc)
    cd $cwd
done
                            
