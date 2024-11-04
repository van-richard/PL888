cd $1
vmd -dispdev text -e ../input/colvar.tcl step3_pbcsetup.parm7 step7.${2}_equilibration.nc -args step7.${2}_equilibration.cv2

cd step7.${2}_equilibration
rm ene_pm3.dat ene_b3lyp.dat ene_wb97xd.dat
for i in `seq -f"%04g" 0 999`; do
    # grep "Heat of formation" ${i}/sqm.out | awk '{print $5}' >> ene_pm3.dat
    grep " SCF   energy in the final basis set" ${i}/qc_job.out | sed -n '1p' | awk '{print $9}' >> ene_b3lyp.dat
    # grep " SCF   energy in the final basis set" ${i}/qc_job.out | sed -n '2p' | awk '{print $9}' >> ene_b3lyp.dat
    grep " SCF   energy in the final basis set" ${i}/qc_job2.out | sed -n '1p' | awk '{print $9}' >> ene_wb97xd.dat
    # grep " SCF   energy in the final basis set" ${i}/qc_job2.out | sed -n '2p' | awk '{print $9}' >> ene_wb97xd.dat
    # rm ${i}/runQChem.py ${i}/qmhub.inp ${i}/qc_job.inp ${i}/qc_job2.inp
done
echo "#PM3             B3LYP           WB97XD" > ../step7.${2}_equilibration.ene
grep "PM3ESCF" ../step8.${2}_equilibration.mdout | awk {'print $3'} > ../step8.${2}_equilibration.ene
paste ../step8.${2}_equilibration.ene ene_b3lyp.dat ene_wb97xd.dat >> ../step7.${2}_equilibration.ene
rm ene_pm3.dat ene_b3lyp.dat ene_wb97xd.dat
# cd ..
# rm -rf step7.${2}_equilibration
# cd ..

#AMBER 627.509469433584999
#QMHUB 627.5094737775374
