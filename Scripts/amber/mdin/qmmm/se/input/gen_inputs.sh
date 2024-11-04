#!/bin/bash
# Prepare QMMM free energy simulations 
# Umbrella sampling 


init="step3_pbcsetup_1264"
MDRST="prod00.rst7"
QMMASK="\(\:1010,1066,1081,1358\&\!\@N,H,CA,HA,C,O\)\|\(:1424\&\@24369-24375\)|\(\:1423,1498\&\!\@P,OP1,OP2,O5\'\)"
QMTHEORY="PM3" #= QMHub .. or give semi-empirical method 
QMCHARGE="-1"
total_num_w=40

# Dont't change this
cwd=$(realpath ../)
inp_dir="../input"
n_windows=$(echo "${total_num_w}-1" | bc)

# start
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
        ln -sf ${inp_dir}/${MDRST} step5.00_equilibration_inp.rst7
        IREST=0
        NTX=1
        sed -i "s/__IREST__/${IREST}/;s/__NTX__/${NTX}/" step5.00_equilibration.mdin
        sed "s/0/${IREST}/;s/1/${NTX}/;s/step5.00/step5.01/" step5.00_equilibration.mdin > step5.01_equilibration.mdin
    else
        IREST=1
        NTX=5
        sed -i "s/__IREST__/${IREST}/;s/__NTX__/${NTX}/" step5.00_equilibration.mdin
        sed "s/step5.00/step5.01/" step5.00_equilibration.mdin > step5.01_equilibration.mdin
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
        QMHUBSCRATCH="\/tmp\/${USER}\/$(basename ${cwd})\/${QMTHEORY}\/${window}\/qmhub"
    fi

    for STEP in "step5.00" "step5.01" "step6.00"; do
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
