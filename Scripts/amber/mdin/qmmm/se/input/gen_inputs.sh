#!/bin/bash
# Prepare QMMM free energy simulations 
# Umbrella sampling 

MDRST="step3_pbcsetup.ncrst"
QMMASK='\(\:324,303\&\!\@N,H,CA,HA,C,O\)\|\(:14\&\@410-416\)|\(\:13\&\!\@378-384\)|\:371,611,612,601,729'
QMTHEORY="PM3" # EXTERN = QMHub .. or give semi-empirical method 
QMCHARGE="+1"
total_num_w=20

# Dont't change this
cwd=$(realpath ..)
inp_dir="${cwd}/input"
n_windows=$(echo "${total_num_w}-1" | bc)

cd ${cwd}
seq -w 0 ${n_windows} > list
windows=($(cat list))

for window in "${windows[@]}"; do
    mkdir -p $window
    cd $window
    ln -sf ${inp_dir}/step3_pbcsetup.parm7 .
    cp ${inp_dir}/step5.00_equilibration.mdin .
    cp ${inp_dir}/step6.00_equilibration.mdin .

    if [ ${window} == "00" ]; then
        ln -sf ${inp_dir}/${MDRST}  step5.00_equilibration_inp.ncrst
        IREST=0
        NTX=1
    else
        IREST=1
        NTX=5
    fi
    
    sed -i "s/__IREST__/${IREST}/;s/__NTX__/${NTX}/" step5.00_equilibration.mdin
    
    # Setup MD input for reverse 
    if [ ${window} == "00" ]; then
        sed "s/0/${IREST}/;s/1/${NTX}/;s/step5.00/step5.01/" step5.00_equilibration > step5.01_equilibration.mdin
    else
        sed "s/step5.00/step5.02/" step5.00_equilibration.mdin > step5.01_equilibration.mdin
    fi
    
    # Flags for QMHub / QChem
    if [ $QMTHEORY == "EXTERN" ]; then
        ln -sf ${inp_dir}/qmhub.ini .
        QMSHAKE=0
        QMCUT="999.0"
        QMEWALD=0
        QMPME=0
        QMSWITCH=0
        QMHUBSCRATCH="\/tmp\/${USER}\/$(basename ${cwd})\/${QMTHEORY}\/${window}\/qmhub"
    else
        QMSHAKE=1
        QMCUT="10.0"
        QMEWALD=1
        QMPME=1
        QMSWITCH=1
    fi

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

    cd $cwd
    echo $(pwd)
done

date
