import numpy as np
import sys

total=10500
perW=150

energy1 = np.empty([total])
mm_efield1 = np.empty([total, 800, 3])
mm_esp1 = np.empty([total, 800])
qm_grad1 = np.empty([total, 73, 3])

for i in range(38):
    energy1s = np.load('../%02d/energy.npy' %i)
    energy1_slice = energy1s
    energy1[i*perW:(i+1)*perW] = energy1_slice
    
    mm_efield1s = np.load('../%02d/mm_esp_grad.npy' %i)
    mm_efield1_slice = mm_efield1s
    mm_efield1[i*perW:(i+1)*perW,:] = mm_efield1_slice
    
    mm_esp1s = np.load('../%02d/mm_esp.npy' %i)
    mm_esp1_slice = mm_esp1s
    mm_esp1[i*perW:(i+1)*perW,:] = mm_esp1_slice

    qm_grad1s = np.load('../%02d/qm_grad.npy' %i)
    qm_grad1_slice = qm_grad1s
    qm_grad1[i*perW:(i+1)*perW,:] = qm_grad1_slice
    
np.save("energy", energy1)
np.save("mm_esp_grad", mm_efield1)
np.save("mm_esp", mm_esp1)
np.save("qm_grad", qm_grad1)
