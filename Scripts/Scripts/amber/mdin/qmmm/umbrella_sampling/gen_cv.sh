#!/bin/bash
# Write input file and setup simulation parameters

cv="-1.975" # Restraint value for window 00
step="0.05" # Change in restraint value between windows

if [ ! -f list ]; then
    # Requires file containing list of windows 
    echo "NOT FOUND: File containing list of windows !!!"
    exit 1
fi

windows=($(cat list))   # Read in list of windows
cwd=$(realpath .)       # Absolute path to current working directory
inp_dir="${cwd}/input"  # Path to reference files

for window in "${windows[@]}"; do
    
    # Create directory, go inside, and copy reference cv file 
    mkdir -p $window
    cd $window
    cp ${inp_dir}/cv.rst .

    # Format $cv 
    cv_f=$(printf "%.3f" "${CV_i}")     
    
    # Replace placeholder value (_REST_) to true value
    sed -i "s/_REST_/${cv_f}/g" cv.rst  
    
    # Increase  $cv by adding $step for next window
    cv=$(echo "${cv} + ${step}" | bc)

    # Return home
    cd $cwd
done
    
