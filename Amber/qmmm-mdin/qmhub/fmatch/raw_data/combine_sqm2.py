import numpy as np
import sys

total=24000
perW=600

energy_sqm = np.empty([total])
mm_efield_sqm = np.empty([total, 800, 3])
mm_esp_sqm = np.empty([total, 800])
qm_grad_sqm = np.empty([total, 73, 3])

for i in range(40):
    energy_sqms = np.load('../%02d/energy_sqm2.npy' %i)
    energy_sqmslice = energy_sqms
    energy_sqm[i*perW:(i+1)*perW] = energy_sqmslice
    
    mm_efield_sqms = np.load('../%02d/mm_esp_grad_sqm2.npy' %i)
    mm_efield_sqmslice = mm_efield_sqms
    mm_efield_sqm[i*perW:(i+1)*perW,:] = mm_efield_sqmslice
    
    mm_esp_sqms = np.load('../%02d/mm_esp_sqm2.npy' %i)
    mm_esp_sqmslice = mm_esp_sqms
    mm_esp_sqm[i*perW:(i+1)*perW,:] = mm_esp_sqmslice

    qm_grad_sqms = np.load('../%02d/qm_grad_sqm2.npy' %i)
    qm_grad_sqmslice = qm_grad_sqms
    qm_grad_sqm[i*perW:(i+1)*perW,:] = qm_grad_sqmslice
    
np.save("energy_sqm2", energy_sqm)
np.save("mm_esp_grad_sqm2", mm_efield_sqm)
np.save("mm_esp_sqm2", mm_esp_sqm)
np.save("qm_grad_sqm2", qm_grad_sqm)
