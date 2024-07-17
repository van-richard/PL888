#!/bin/bash
# Write input file and setup simulation parameters
# Make sure `input` directory is here
# Check reference mdin files for MD settings (input/step5.00_equilibration.mdin and input/step6.00_equilibration.mdin)

#############################################################################
# CHANGE THESE VARIABLES FOR YOUR SYSTEM !!!
#############################################################################
#   Select QM region using AMBER mask format,
#       Since we are using this to replace a value, 
#       make sure symbols have a "\" before them,
#       like "@CA" should be "\@CA"
QMMASK=':1'
QMCHARGE="-2"                   # Net charge of QM subsystem
QMTHEORY="EXTERN"               # Either semi-empirical (PM3, AM1/d) or DFT (EXTERN)
simulation="ind"                # Options:  ind = independent trajectories, rem = replica exchange
thermostat="lang"               # Options: lang = langevin, sinr = sinr (use only with MTS)
total_windows="10"              # Total number of umbrella windows (directory will start zero)
cwd=$(realpath .)               # Get absolute path to current directory
inp_dir="${cwd}/input"          # Get absolute path to input directory (make sure this exists!)
init="step3_pbcsetup"           # Name of topology file (parm7)
init_restart="prod.ncrst"       # Name & format of restart file (typically from MD)

#############################################################################
# Check for templates
#############################################################################
if [ ! -d "${cwd}/input" ]; then
    # Check if 'input' directory exist
    echo "NOT FOUND: 'input' directory with template files !!!"
    exit 1
fi

if ! ls ${inp_dir} | egrep -q "parm7|mdin|cv.rst"; then
    # Check for template files
    echo "Possibly some templates are missing !!!"
    exit 1
fi

#############################################################################
# Make 
#############################################################################
# For consistency, windows are listed in text file,
#   and only 'list' will be read
seq -w 0 $(echo "${total_windows} - 1" | bc ) > list     #  Create `list` file for list of window
windows=($(cat list))                       # Convert list to bash array 

for window in "${windows[@]}"; do

    # Prepare directory for umbrella sampling
    mkdir -p $window
    cd $window

    ln -sf ${inp_dir}/${init}.parm7 .    # Point to topology file in 'input' directory
    cp ${inp_dir}/step5.00_equilibration.mdin . # step5.00 template (some values have placeholders)
    cp ${inp_dir}/step6.00_equilibration.mdin . # step6.00 template (some values have placeholders)

    # Symlink initial coordinates for QM/MM simulations. 
    #   If inital coordinates from prior MD run, change "step3_pbcsetup.ncrst" to NCRST of MD
    if [ ${window} == "00" ]; then
        ln -sf ${inp_dir}/${init_restart} step5.00_equilibration_inp.ncrst
        IREST=0
        NTX=1
    else
        IREST=1
        NTX=5
    fi
    
    # Replace placeholder values (__IREST__ & __NTX__) in step5.00
    sed -i "s/__IREST__/${IREST}/;s/__NTX__/${NTX}/" step5.00_equilibration.mdin
    
    # Set QM parameters in reference MDIN file: EXTERN = QChem / DFT
    #   Otherwise, use default AMBER QM engine (PM3, AM1/d)
    if [ $QMTHEORY == "EXTERN" ]; then
        if [ ! -f "${inp_dir}/qmhub.ini" ]; then
            echo "NOT FOUND: Missing qmhub.ini !!!"
            exit 1
        fi

        # Requires QMHub input
        ln -sf ${inp_dir}/qmhub.ini .

        # For QMHub - QM/MM-AC:
        #   set 'basedir' to write QCSCRATCH, 
        #       make sure this value is different between replicates or umbrella windows
        QMHUBSCRATCH="\/tmp\/${USER}\/$(basename ${cwd})\/${QMTHEORY}\/${window}\/qmhub"
        QMSHAKE=0
        QMCUT="999.0"
        QMEWALD=0
        QMPME=0
        QMSWITCH=0
    else
        # AMBER engine, generally for semi-empirical QM/MM simulations (PM3/AM1/d)
        QMSHAKE=1
        QMCUT="10.0"
        QMEWALD=1
        QMPME=1
        QMSWITCH=1
    fi

    # Replace QM parameters in created step5.00 / step6.00 
    for STEP in "step5.00" "step6.00"; do
        sed -i "\
            s/__QMMASK__/${QMMASK}/;\
            s/__QMCHARGE__/${QMCHARGE}/;\
            s/__QMTHEORY__/${QMTHEORY}/;\
            s/__QMSHAKE__/${QMSHAKE}/;\
            s/__QMCUT__/${QMCUT}/;\
            s/__QMEWALD__/${QMEWALD}/;\
            s/__QMPME__/${QMPME}/;\
            s/__QMSWITCH__/${QMSWITCH}/;\
            s/__QMHUBSCRATCH__/${QMHUBSCRATCH}/" ${STEP}_equilibration.mdin
    done

    # At this point, MDIN files should contain desired settings
    #   New mdin files like a backwards pull (step5.01) or additional sampling (step6.01)
    #   can be made by replacing the filename of cv file 
    if [ ${window} == "00" ]; then 
        # Only for window 00 because step5.00 was IREST=0 & NTX=1
        sed -i "\
            s/0/${IREST}/;s/1/${NTX}/;\
            s/step5.00/step5.01/" step5.00_equilibration.mdin > step5.01_equilibration.mdin
    else
        sed -i "\
            s/step5.00/step5.01/" step5.00_equilibration.mdin > step5.01_equilibration.mdin
    fi
   
    if [ ${simulation} == "rem" ]; then
        # For replica exchange, files require path
        #   set DISANG=$window/cv.rst & DUMPAVE=$window/..._equilibration.cv
        sed -i "s/__WINDOW__/${window}/" step6.00_equilibration.mdin
    fi
    
    cd ${cwd}                       # Return to project directory
    #echo "Returning to: $(pwd)"     # Uncomment to print .. sanity check...

done

printf "\n\t%s\n" \
    "This script only prepares aa few MD parameters, please check the template mdin if they are right for you !!!"
printf "\n\t%s" \
    "Next, generate restraint files: bash gen_cv.sh"

