#!/bin/bash

init="step3_pbcsetup"
icoord="ncrst" # rst7 or ncrst
stepi="step5"
stepj="step6"

n_windows=$(seq -f"%02g" 0 39)
for n in ${n_windows}; do
    mkdir -p ${n} 
    cd ${n}

    ln -s ../input/${init}.parm7 .
    ln -s ../input/${init}.${icoord}
    cp ../input/cv.rst .
#    ln -s ../input/qmhub.ini . # QM/MM with QMHub
#    ln -s ../input/param.dat . # Reparameterized values for SE
    
    for i in `seq -f"%02g" 0 1`; do
        if [ "${n}" == "00" ] && [ "${i}" == "00" ]; then
            sed "s/_IREST_/0/;s/_NTX_/1/" ../input/${istepi}.${i}_equilibration.mdin > ${istep}.${i}_equilibration.mdin
        else
            sed "s/_IREST_/1/;s/_NTX_/5/" ../input/${istepi}.${i}_equilibration.mdin > ${istep}.${i}_equilibration.mdin
        fi
    done

    for j in `seq -f"%02g" 0 2`; do
        sed "s/__REP__/${n}/g" ../input/${stepj}.${j}_equilibration.mdin > step6.${j}_equilibration.mdin
    done
    cd ..
done


# for i in `seq 0 39`; do
#     dir=$(printf "%02d" $i)
#     (( n = i + 2 ))
#     d1c=`sed "${n}!d" guess | awk '{print $1}'`
#     d2c=`sed "${n}!d" guess | awk '{print $2}'`
#     d3c=`sed "${n}!d" guess | awk '{print $3}'`
#     d4c=`sed "${n}!d" guess | awk '{print $4}'`
#     d5c=`sed "${n}!d" guess | awk '{print $5}'`
#     d6c=`sed "${n}!d" guess | awk '{print $6}'`
#     d7c=`sed "${n}!d" guess | awk '{print $7}'`
#     d8c=`sed "${n}!d" guess | awk '{print $8}'`
#     d9c=`sed "${n}!d" guess | awk '{print $9}'`
#     d10c=`sed "${n}!d" guess | awk '{print $10}'`
#     # d11c=`sed "${n}!d" guess | awk '{print $11}'`
#     # d12c=`sed "${n}!d" guess | awk '{print $12}'`
#     # d13c=`sed "${n}!d" guess | awk '{print $13}'`
#     # d14c=`sed "${n}!d" guess | awk '{print $14}'`
#     # d15c=`sed "${n}!d" guess | awk '{print $15}'`
#     # d16c=`sed "${n}!d" guess | awk '{print $16}'`
#     sed -i "s/__D1C__/$d1c/g" $dir/cv.rst
#     sed -i "s/__D2C__/$d2c/g" $dir/cv.rst
#     sed -i "s/__D3C__/$d3c/g" $dir/cv.rst
#     sed -i "s/__D4C__/$d4c/g" $dir/cv.rst
#     sed -i "s/__D5C__/$d5c/g" $dir/cv.rst
#     sed -i "s/__D6C__/$d6c/g" $dir/cv.rst
#     sed -i "s/__D7C__/$d7c/g" $dir/cv.rst
#     sed -i "s/__D8C__/$d8c/g" $dir/cv.rst
#     sed -i "s/__D9C__/$d9c/g" $dir/cv.rst
#     sed -i "s/__D10C__/$d10c/g" $dir/cv.rst
#     # sed -i "s/__D11C__/$d11c/g" $dir/cv.rst
#     # sed -i "s/__D12C__/$d12c/g" $dir/cv.rst
#     # sed -i "s/__D13C__/$d13c/g" $dir/cv.rst
#     # sed -i "s/__D14C__/$d14c/g" $dir/cv.rst
#     # sed -i "s/__D15C__/$d15c/g" $dir/cv.rst
#     # sed -i "s/__D16C__/$d16c/g" $dir/cv.rst
# done
# 
# seq -w 0 39 | while read i; do
# cd $i
# sed "s/=150.0/=0.0/g" cv.rst > cv2.rst
# cd ..
# done

