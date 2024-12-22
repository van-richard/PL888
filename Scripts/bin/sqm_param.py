import os
from string import Template
from collections import OrderedDict
from itertools import chain
import numpy as np


pm3_tmpl_H = """\
USS H ${USS_H}D0
s_orb_exp H ${s_orb_exp_H}D0
betas H ${betas_H}D0
FN11 H ${FN11_H}D0
FN21 H ${FN21_H}D0
FN31 H ${FN31_H}D0
FN12 H ${FN12_H}D0
FN22 H ${FN22_H}D0
FN32 H ${FN32_H}D0
NUM_FN H 2
"""

pm3_tmpl_C = """\
USS C ${USS_C}D0
UPP C ${UPP_C}D0
betas C ${betas_C}D0
betap C ${betap_C}D0
s_orb_exp C ${s_orb_exp_C}D0
p_orb_exp C ${p_orb_exp_C}D0
FN11 C ${FN11_C}D0
FN21 C ${FN21_C}D0
FN31 C ${FN31_C}D0
FN12 C ${FN12_C}D0
FN22 C ${FN22_C}D0
FN32 C ${FN32_C}D0
NUM_FN C 2
"""

pm3_tmpl_N = """\
USS N ${USS_N}D0
UPP N ${UPP_N}D0
betas N ${betas_N}D0
betap N ${betap_N}D0
s_orb_exp N ${s_orb_exp_N}D0
p_orb_exp N ${p_orb_exp_N}D0
FN11 N ${FN11_N}D0
FN21 N ${FN21_N}D0
FN31 N ${FN31_N}D0
FN12 N ${FN12_N}D0
FN22 N ${FN22_N}D0
FN32 N ${FN32_N}D0
NUM_FN N 2
"""

pm3_tmpl_O = """\
USS O ${USS_O}D0
UPP O ${UPP_O}D0
betas O ${betas_O}D0
betap O ${betap_O}D0
s_orb_exp O ${s_orb_exp_O}D0
p_orb_exp O ${p_orb_exp_O}D0
FN11 O ${FN11_O}D0
FN21 O ${FN21_O}D0
FN31 O ${FN31_O}D0
FN12 O ${FN12_O}D0
FN22 O ${FN22_O}D0
FN32 O ${FN32_O}D0
NUM_FN O 2
"""

pm3_tmpl_Cl = """\
USS Cl ${USS_Cl}D0
UPP Cl ${UPP_Cl}D0
betas Cl ${betas_Cl}D0
betap Cl ${betap_Cl}D0
s_orb_exp Cl ${s_orb_exp_Cl}D0
p_orb_exp Cl ${p_orb_exp_Cl}D0
FN11 Cl ${FN11_Cl}D0
FN21 Cl ${FN21_Cl}D0
FN31 Cl ${FN31_Cl}D0
FN12 Cl ${FN12_Cl}D0
FN22 Cl ${FN22_Cl}D0
FN32 Cl ${FN32_Cl}D0
NUM_FN Cl 2
"""

pm3_param_H = OrderedDict([
    ('USS_H',          -13.0733210),
    ('s_orb_exp_H',      0.9678070),
    ('betas_H',         -5.6265120),
    ('FN11_H',           1.1287500),
    ('FN21_H',           5.0962820),
    ('FN31_H',           1.5374650),
    ('FN12_H',          -1.0603290),
    ('FN22_H',           6.0037880),
    ('FN32_H',           1.5701890)])

pm3_param_C = OrderedDict([
    ('USS_C',          -47.2703200),
    ('UPP_C',          -36.2669180),
    ('betas_C',        -11.9100150),
    ('betap_C',         -9.8027550),
    ('s_orb_exp_C',      1.5650850),
    ('p_orb_exp_C',      1.8423450),
    ('FN11_C',           0.0501070),
    ('FN21_C',           6.0031650),
    ('FN31_C',           1.6422140),
    ('FN12_C',           0.0507330),
    ('FN22_C',           6.0029790),
    ('FN32_C',           0.8924880)])

pm3_param_N = OrderedDict([
    ('USS_N',          -49.3356720),
    ('UPP_N',          -47.5097360),
    ('betas_N',        -14.0625210),
    ('betap_N',        -20.0438480),
    ('s_orb_exp_N',      2.0280940),
    ('p_orb_exp_N',      2.3137280),
    ('FN11_N',           1.5016740),
    ('FN21_N',           5.9011480),
    ('FN31_N',           1.7107400),
    ('FN12_N',          -1.5057720),
    ('FN22_N',           6.0046580),
    ('FN32_N',           1.7161490)])

pm3_param_O = OrderedDict([
    ('USS_O',          -86.9930020),
    ('UPP_O',          -71.8795800),
    ('betas_O',        -45.2026510),
    ('betap_O',        -24.7525150),
    ('s_orb_exp_O',      3.7965440),
    ('p_orb_exp_O',      2.3894020),
    ('FN11_O',          -1.1311280),
    ('FN21_O',           6.0024770),
    ('FN31_O',           1.6073110),
    ('FN12_O',           1.1378910),
    ('FN22_O',           5.9505120),
    ('FN32_O',           1.5983950)])

pm3_param_Cl = OrderedDict([
    ('USS_Cl',        -100.6267470),
    ('UPP_Cl',         -53.6143960),
    ('betas_Cl',       -27.5285600),
    ('betap_Cl',       -11.5939220),
    ('s_orb_exp_Cl',     2.2462100),
    ('p_orb_exp_Cl',     2.1510100),
    ('FN11_Cl',         -0.1715910),
    ('FN21_Cl',          6.0008020),
    ('FN31_Cl',          1.0875020),
    ('FN12_Cl',         -0.0134580),
    ('FN22_Cl',          1.9666180),
    ('FN32_Cl',          2.2928910)])

pm3_tmpl = {'H': pm3_tmpl_H, 
            'C': pm3_tmpl_C,
            'N': pm3_tmpl_N,
            'O': pm3_tmpl_O,
            'Cl': pm3_tmpl_Cl}

pm3_param = {'H': pm3_param_H, 
             'C': pm3_param_C,
             'N': pm3_param_N,
             'O': pm3_param_O,
             'Cl': pm3_param_Cl}


am1_tmpl_H = """\
USS H ${USS_H}D0
s_orb_exp H ${s_orb_exp_H}D0
betas H ${betas_H}D0
FN11 H ${FN11_H}D0
FN21 H ${FN21_H}D0
FN31 H ${FN31_H}D0
FN12 H ${FN12_H}D0
FN22 H ${FN22_H}D0
FN32 H ${FN32_H}D0
FN13 H ${FN13_H}D0
FN23 H ${FN23_H}D0
FN33 H ${FN33_H}D0
NUM_FN H 3
"""

am1_tmpl_C = """\
USS C ${USS_C}D0
UPP C ${UPP_C}D0
betas C ${betas_C}D0
betap C ${betap_C}D0
s_orb_exp C ${s_orb_exp_C}D0
p_orb_exp C ${p_orb_exp_C}D0
FN11 C ${FN11_C}D0
FN21 C ${FN21_C}D0
FN31 C ${FN31_C}D0
FN12 C ${FN12_C}D0
FN22 C ${FN22_C}D0
FN32 C ${FN32_C}D0
FN13 C ${FN13_C}D0
FN23 C ${FN23_C}D0
FN33 C ${FN33_C}D0
FN14 C ${FN14_C}D0
FN24 C ${FN24_C}D0
FN34 C ${FN34_C}D0
NUM_FN C 4
"""

am1_tmpl_N = """\
USS N ${USS_N}D0
UPP N ${UPP_N}D0
betas N ${betas_N}D0
betap N ${betap_N}D0
s_orb_exp N ${s_orb_exp_N}D0
p_orb_exp N ${p_orb_exp_N}D0
FN11 N ${FN11_N}D0
FN21 N ${FN21_N}D0
FN31 N ${FN31_N}D0
FN12 N ${FN12_N}D0
FN22 N ${FN22_N}D0
FN32 N ${FN32_N}D0
FN13 N ${FN13_N}D0
FN23 N ${FN23_N}D0
FN33 N ${FN33_N}D0
NUM_FN N 3
"""

am1_tmpl_O = """\
USS O ${USS_O}D0
UPP O ${UPP_O}D0
betas O ${betas_O}D0
betap O ${betap_O}D0
s_orb_exp O ${s_orb_exp_O}D0
p_orb_exp O ${p_orb_exp_O}D0
FN11 O ${FN11_O}D0
FN21 O ${FN21_O}D0
FN31 O ${FN31_O}D0
FN12 O ${FN12_O}D0
FN22 O ${FN22_O}D0
FN32 O ${FN32_O}D0
NUM_FN O 2
"""

am1_tmpl_Cl = """\
USS Cl ${USS_Cl}D0
UPP Cl ${UPP_Cl}D0
betas Cl ${betas_Cl}D0
betap Cl ${betap_Cl}D0
s_orb_exp Cl ${s_orb_exp_Cl}D0
p_orb_exp Cl ${p_orb_exp_Cl}D0
FN11 Cl ${FN11_Cl}D0
FN21 Cl ${FN21_Cl}D0
FN31 Cl ${FN31_Cl}D0
FN12 Cl ${FN12_Cl}D0
FN22 Cl ${FN22_Cl}D0
FN32 Cl ${FN32_Cl}D0
NUM_FN Cl 2
"""

am1_param_H = OrderedDict([
    ('USS_H',          -11.3964270),
    ('s_orb_exp_H',      1.1880780),
    ('betas_H',         -6.1737870),
    ('FN11_H',           0.1227960),
    ('FN21_H',           5.0000000),
    ('FN31_H',           1.2000000),
    ('FN12_H',           0.0050900),
    ('FN22_H',           5.0000000),
    ('FN32_H',           1.8000000),
    ('FN13_H',          -0.0183360),
    ('FN23_H',           2.0000000),
    ('FN33_H',           2.1000000)])

am1_param_C = OrderedDict([
    ('USS_C',          -52.0286580),
    ('UPP_C',          -39.6142390),
    ('betas_C',        -15.7157830),
    ('betap_C',         -7.7192830),
    ('s_orb_exp_C',      1.8086650),
    ('p_orb_exp_C',      1.6851160),
    ('FN11_C',           0.0113550),
    ('FN21_C',           5.0000000),
    ('FN31_C',           1.6000000),
    ('FN12_C',           0.0459240),
    ('FN22_C',           5.0000000),
    ('FN32_C',           1.8500000),
    ('FN13_C',          -0.0200610),
    ('FN23_C',           5.0000000),
    ('FN33_C',           2.0500000),
    ('FN14_C',          -0.0012600),
    ('FN24_C',           5.0000000),
    ('FN34_C',           2.6500000)])

am1_param_N = OrderedDict([
    ('USS_N',          -71.8600000),
    ('UPP_N',          -57.1675810),
    ('betas_N',        -20.2991100),
    ('betap_N',        -18.2386660),
    ('s_orb_exp_N',      2.3154100),
    ('p_orb_exp_N',      2.1579400),
    ('FN11_N',           0.0252510),
    ('FN21_N',           5.0000000),
    ('FN31_N',           1.5000000),
    ('FN12_N',           0.0289530),
    ('FN22_N',           5.0000000),
    ('FN32_N',           2.1000000),
    ('FN13_N',          -0.0058060),
    ('FN23_N',           2.0000000),
    ('FN33_N',           2.4000000)])

am1_param_O = OrderedDict([
    ('USS_O',          -97.8300000),
    ('UPP_O',          -78.2623800),
    ('betas_O',        -29.2727730),
    ('betap_O',        -29.2727730),
    ('s_orb_exp_O',      3.1080320),
    ('p_orb_exp_O',      2.5240390),
    ('FN11_O',           0.2809620),
    ('FN21_O',           5.0000000),
    ('FN31_O',           0.8479180),
    ('FN12_O',           0.0814300),
    ('FN22_O',           7.0000000),
    ('FN32_O',           1.4450710)])

am1_param_Cl = OrderedDict([
    ('USS_Cl',        -111.6139480),
    ('UPP_Cl',         -76.6401070),
    ('betas_Cl',       -24.5946700),
    ('betap_Cl',       -14.6372160),
    ('s_orb_exp_Cl',     3.6313760),
    ('p_orb_exp_Cl',     2.0767990),
    ('FN11_Cl',          0.0942430),
    ('FN21_Cl',          4.0000000),
    ('FN31_Cl',          1.3000000),
    ('FN12_Cl',          0.0271680),
    ('FN22_Cl',          4.0000000),
    ('FN32_Cl',          2.1000000)])

am1_tmpl = {'H': am1_tmpl_H, 
            'C': am1_tmpl_C,
            'N': am1_tmpl_N,
            'O': am1_tmpl_O,
            'Cl': am1_tmpl_Cl}

am1_param = {'H': am1_param_H, 
             'C': am1_param_C,
             'N': am1_param_N,
             'O': am1_param_O,
             'Cl': am1_param_Cl}


pddgpm3_tmpl_H = """\
USS H ${USS_H}D0
s_orb_exp H ${s_orb_exp_H}D0
betas H ${betas_H}D0
FN11 H ${FN11_H}D0
FN21 H ${FN21_H}D0
FN31 H ${FN31_H}D0
FN12 H ${FN12_H}D0
FN22 H ${FN22_H}D0
FN32 H ${FN32_H}D0
NUM_FN H 2
PDDGC1 H ${PDDGC1_H}D0
PDDGC2 H ${PDDGC2_H}D0
PDDGE1 H ${PDDGE1_H}D0
PDDGE2 H ${PDDGE2_H}D0
"""

pddgpm3_tmpl_C = """\
USS C ${USS_C}D0
UPP C ${UPP_C}D0
betas C ${betas_C}D0
betap C ${betap_C}D0
s_orb_exp C ${s_orb_exp_C}D0
p_orb_exp C ${p_orb_exp_C}D0
FN11 C ${FN11_C}D0
FN21 C ${FN21_C}D0
FN31 C ${FN31_C}D0
FN12 C ${FN12_C}D0
FN22 C ${FN22_C}D0
FN32 C ${FN32_C}D0
NUM_FN C 2
PDDGC1 C ${PDDGC1_C}D0
PDDGC2 C ${PDDGC2_C}D0
PDDGE1 C ${PDDGE1_C}D0
PDDGE2 C ${PDDGE2_C}D0
"""

pddgpm3_tmpl_N = """\
USS N ${USS_N}D0
UPP N ${UPP_N}D0
betas N ${betas_N}D0
betap N ${betap_N}D0
s_orb_exp N ${s_orb_exp_N}D0
p_orb_exp N ${p_orb_exp_N}D0
FN11 N ${FN11_N}D0
FN21 N ${FN21_N}D0
FN31 N ${FN31_N}D0
FN12 N ${FN12_N}D0
FN22 N ${FN22_N}D0
FN32 N ${FN32_N}D0
NUM_FN N 2
PDDGC1 N ${PDDGC1_N}D0
PDDGC2 N ${PDDGC2_N}D0
PDDGE1 N ${PDDGE1_N}D0
PDDGE2 N ${PDDGE2_N}D0
"""

pddgpm3_tmpl_O = """\
USS O ${USS_O}D0
UPP O ${UPP_O}D0
betas O ${betas_O}D0
betap O ${betap_O}D0
s_orb_exp O ${s_orb_exp_O}D0
p_orb_exp O ${p_orb_exp_O}D0
FN11 O ${FN11_O}D0
FN21 O ${FN21_O}D0
FN31 O ${FN31_O}D0
FN12 O ${FN12_O}D0
FN22 O ${FN22_O}D0
FN32 O ${FN32_O}D0
NUM_FN O 2
PDDGC1 O ${PDDGC1_O}D0
PDDGC2 O ${PDDGC2_O}D0
PDDGE1 O ${PDDGE1_O}D0
PDDGE2 O ${PDDGE2_O}D0
"""

pddgpm3_tmpl_Cl = """\
USS Cl ${USS_Cl}D0
UPP Cl ${UPP_Cl}D0
betas Cl ${betas_Cl}D0
betap Cl ${betap_Cl}D0
s_orb_exp Cl ${s_orb_exp_Cl}D0
p_orb_exp Cl ${p_orb_exp_Cl}D0
FN11 Cl ${FN11_Cl}D0
FN21 Cl ${FN21_Cl}D0
FN31 Cl ${FN31_Cl}D0
FN12 Cl ${FN12_Cl}D0
FN22 Cl ${FN22_Cl}D0
FN32 Cl ${FN32_Cl}D0
NUM_FN Cl 2
PDDGC1 Cl ${PDDGC1_Cl}D0
PDDGC2 Cl ${PDDGC2_Cl}D0
PDDGE1 Cl ${PDDGE1_Cl}D0
PDDGE2 Cl ${PDDGE2_Cl}D0
"""

pddgpm3_param_H = OrderedDict([
    ('USS_H',          -12.893272003385),
    ('s_orb_exp_H',      0.97278550084430),
    ('betas_H',         -6.1526542062173),
    ('FN11_H',           1.12224395962630),
    ('FN21_H',           4.70779030777590),
    ('FN31_H',           1.54709920873910),
    ('FN12_H',          -1.0697373657305),
    ('FN22_H',           5.85799464741120),
    ('FN32_H',           1.56789274832050),
    ('PDDGC1_H',         0.05719290135800),
    ('PDDGC2_H',        -0.0348228612590),
    ('PDDGE1_H',         0.66339504047230),
    ('PDDGE2_H',         1.08190071942210)])

pddgpm3_param_C = OrderedDict([
    ('USS_C',          -48.241240946951),
    ('UPP_C',          -36.461255999939),
    ('betas_C',        -11.952818190434),
    ('betap_C',         -9.9224112120852),
    ('s_orb_exp_C',      1.56786358751710),
    ('p_orb_exp_C',      1.84665852120070),
    ('FN11_C',           0.04890550330860),
    ('FN21_C',           5.76533980799120),
    ('FN31_C',           1.68223169651660),
    ('FN12_C',           0.04769663311610),
    ('FN22_C',           5.97372073873460),
    ('FN32_C',           0.89440631619350),
    ('PDDGC1_C',        -0.0007433618099),
    ('PDDGC2_C',         0.00098516072940),
    ('PDDGE1_C',         0.83691519687330),
    ('PDDGE2_C',         1.58523608520060)])

pddgpm3_param_N = OrderedDict([
    ('USS_N',          -49.454546358059),
    ('UPP_N',          -47.757406358412),
    ('betas_N',        -14.117229602371),
    ('betap_N',        -19.938508878969),
    ('s_orb_exp_N',      2.03580684361910),
    ('p_orb_exp_N',      2.32432725808280),
    ('FN11_N',           1.51332030575080),
    ('FN21_N',           5.90439402634500),
    ('FN31_N',           1.72837621719040),
    ('FN12_N',          -1.5118916914302),
    ('FN22_N',           6.03001440913320),
    ('FN32_N',           1.73410826456840),
    ('PDDGC1_N',        -0.0031600751673),
    ('PDDGC2_N',         0.01250092178130),
    ('PDDGE1_N',         1.00417177651930),
    ('PDDGE2_N',         1.51633618021020)])

pddgpm3_param_O = OrderedDict([
    ('USS_O',          -87.412505208248),
    ('UPP_O',          -72.183069806393),
    ('betas_O',        -44.874553472211),
    ('betap_O',        -24.601939339720),
    ('s_orb_exp_O',      3.81456531095080),
    ('p_orb_exp_O',      2.31801122165690),
    ('FN11_O',          -1.1384554300359),
    ('FN21_O',           6.00004254473730),
    ('FN31_O',           1.62236167639400),
    ('FN12_O',           1.14600702743950),
    ('FN22_O',           5.96349383486760),
    ('FN32_O',           1.61478803799000),
    ('PDDGC1_O',        -0.00099962677420),
    ('PDDGC2_O',        -0.00152161350520),
    ('PDDGE1_O',         1.36068502987020),
    ('PDDGE2_O',         1.36640659538530)])

pddgpm3_param_Cl = OrderedDict([
    ('USS_Cl',         -95.094434),
    ('UPP_Cl',         -53.921651),
    ('betas_Cl',       -26.913129),
    ('betap_Cl',       -14.991178),
    ('s_orb_exp_Cl',     2.548268),
    ('p_orb_exp_Cl',     2.284624),
    ('FN11_Cl',         -0.112222),
    ('FN21_Cl',          5.963719),
    ('FN31_Cl',          1.027719),
    ('FN12_Cl',         -0.013061),
    ('FN22_Cl',          1.999556),
    ('FN32_Cl',          2.286377),
    ('PDDGC1_Cl',       -0.016552),
    ('PDDGC2_Cl',       -0.016646),
    ('PDDGE1_Cl',        1.7276900),
    ('PDDGE2_Cl',        1.784655)])

pddgpm3_tmpl = {'H': pddgpm3_tmpl_H, 
               'C': pddgpm3_tmpl_C,
               'N': pddgpm3_tmpl_N,
               'O': pddgpm3_tmpl_O,
               'Cl': pddgpm3_tmpl_Cl}

pddgpm3_param = {'H': pddgpm3_param_H, 
                'C': pddgpm3_param_C,
                'N': pddgpm3_param_N,
                'O': pddgpm3_param_O,
                'Cl': pddgpm3_param_Cl}


pddgpm3_08_tmpl_H = """\
USS H ${USS_H}D0
s_orb_exp H ${s_orb_exp_H}D0
betas H ${betas_H}D0
FN11 H ${FN11_H}D0
FN21 H ${FN21_H}D0
FN31 H ${FN31_H}D0
FN12 H ${FN12_H}D0
FN22 H ${FN22_H}D0
FN32 H ${FN32_H}D0
NUM_FN H 2
PDDGC1 H ${PDDGC1_H}D0
PDDGC2 H ${PDDGC2_H}D0
PDDGE1 H ${PDDGE1_H}D0
PDDGE2 H ${PDDGE2_H}D0
"""

pddgpm3_08_tmpl_C = """\
USS C ${USS_C}D0
UPP C ${UPP_C}D0
betas C ${betas_C}D0
betap C ${betap_C}D0
s_orb_exp C ${s_orb_exp_C}D0
p_orb_exp C ${p_orb_exp_C}D0
FN11 C ${FN11_C}D0
FN21 C ${FN21_C}D0
FN31 C ${FN31_C}D0
FN12 C ${FN12_C}D0
FN22 C ${FN22_C}D0
FN32 C ${FN32_C}D0
NUM_FN C 2
PDDGC1 C ${PDDGC1_C}D0
PDDGC2 C ${PDDGC2_C}D0
PDDGE1 C ${PDDGE1_C}D0
PDDGE2 C ${PDDGE2_C}D0
"""

pddgpm3_08_tmpl_N = """\
USS N ${USS_N}D0
UPP N ${UPP_N}D0
betas N ${betas_N}D0
betap N ${betap_N}D0
s_orb_exp N ${s_orb_exp_N}D0
p_orb_exp N ${p_orb_exp_N}D0
FN11 N ${FN11_N}D0
FN21 N ${FN21_N}D0
FN31 N ${FN31_N}D0
FN12 N ${FN12_N}D0
FN22 N ${FN22_N}D0
FN32 N ${FN32_N}D0
NUM_FN N 2
PDDGC1 N ${PDDGC1_N}D0
PDDGC2 N ${PDDGC2_N}D0
PDDGE1 N ${PDDGE1_N}D0
PDDGE2 N ${PDDGE2_N}D0
"""

pddgpm3_08_tmpl_O = """\
USS O ${USS_O}D0
UPP O ${UPP_O}D0
betas O ${betas_O}D0
betap O ${betap_O}D0
s_orb_exp O ${s_orb_exp_O}D0
p_orb_exp O ${p_orb_exp_O}D0
FN11 O ${FN11_O}D0
FN21 O ${FN21_O}D0
FN31 O ${FN31_O}D0
FN12 O ${FN12_O}D0
FN22 O ${FN22_O}D0
FN32 O ${FN32_O}D0
NUM_FN O 2
PDDGC1 O ${PDDGC1_O}D0
PDDGC2 O ${PDDGC2_O}D0
PDDGE1 O ${PDDGE1_O}D0
PDDGE2 O ${PDDGE2_O}D0
"""

pddgpm3_08_param_H = OrderedDict([
    ('USS_H',          -13.043714),
    ('s_orb_exp_H',      0.988391),
    ('betas_H',         -6.162383),
    ('FN11_H',           1.127822),
    ('FN21_H',           4.750023),
    ('FN31_H',           1.549373),
    ('FN12_H',          -1.074605),
    ('FN22_H',           5.870974),
    ('FN32_H',           1.566692),
    ('PDDGC1_H',         0.057812),
    ('PDDGC2_H',        -0.035533),
    ('PDDGE1_H',         0.683017),
    ('PDDGE2_H',         1.113826)])

pddgpm3_08_param_C = OrderedDict([
    ('USS_C',           -48.09596),
    ('UPP_C',           -36.38891),
    ('betas_C',         -11.76394),
    ('betap_C',         -9.883236),
    ('s_orb_exp_C',      1.565931),
    ('p_orb_exp_C',      1.840669),
    ('FN11_C',           0.051192),
    ('FN21_C',           5.762521),
    ('FN31_C',           1.706747),
    ('FN12_C',           0.0475),
    ('FN22_C',           6.034004),
    ('FN32_C',           0.932312),
    ('PDDGC1_C',        -0.0007433618099),
    ('PDDGC2_C',         0.00098516072940),
    ('PDDGE1_C',         0.83691519687330),
    ('PDDGE2_C',         1.58523608520060)])

pddgpm3_08_param_N = OrderedDict([
    ('USS_N',          -49.42949),
    ('UPP_N',          -47.64097),
    ('betas_N',        -14.08164),
    ('betap_N',        -19.69538),
    ('s_orb_exp_N',      2.026598),
    ('p_orb_exp_N',      2.334183),
    ('FN11_N',           1.508427),
    ('FN21_N',           5.957281),
    ('FN31_N',           1.72277),
    ('FN12_N',          -1.508203),
    ('FN22_N',           6.025113),
    ('FN32_N',           1.731257),
    ('PDDGC1_N',        -0.003229),
    ('PDDGC2_N',         0.012714),
    ('PDDGE1_N',         1.007904),
    ('PDDGE2_N',         1.511671)])

pddgpm3_08_param_O = OrderedDict([
    ('USS_O',          -87.92097),
    ('UPP_O',          -72.4924),
    ('betas_O',        -44.6312),
    ('betap_O',        -24.71147),
    ('s_orb_exp_O',      3.811544),
    ('p_orb_exp_O',      2.302506),
    ('FN11_O',          -1.135968),
    ('FN21_O',           5.988441),
    ('FN31_O',           1.620971),
    ('FN12_O',           1.146007),
    ('FN22_O',           5.963494),
    ('FN32_O',           1.614788),
    ('PDDGC1_O',        -0.00099962677420),
    ('PDDGC2_O',        -0.00152161350520),
    ('PDDGE1_O',         1.36068502987020),
    ('PDDGE2_O',         1.36640659538530)])

pddgpm3_08_tmpl = {'H': pddgpm3_08_tmpl_H, 
               'C': pddgpm3_08_tmpl_C,
               'N': pddgpm3_08_tmpl_N,
               'O': pddgpm3_08_tmpl_O}

pddgpm3_08_param = {'H': pddgpm3_08_param_H, 
                'C': pddgpm3_08_param_C,
                'N': pddgpm3_08_param_N,
                'O': pddgpm3_08_param_O}


class SQM_PARAM(object):

    def __init__(self, elem, method='pm3', ref=None):
        if method.lower() == 'pm3':
            self._tmpl = Template("".join([pm3_tmpl[e] for e in elem]) + "END")
            self._params = OrderedDict(chain.from_iterable(pm3_param[e].items() for e in elem)) 
        elif method.lower() == 'am1':
            self._tmpl = Template("".join([am1_tmpl[e] for e in elem]) + "END")
            self._params = OrderedDict(chain.from_iterable(am1_param[e].items() for e in elem)) 
        elif method.lower() == 'pddgpm3':
            self._tmpl = Template("".join([pddgpm3_tmpl[e] for e in elem]) + "END")
            self._params = OrderedDict(chain.from_iterable(pddgpm3_param[e].items() for e in elem)) 
        elif method.lower() == 'pddgpm3_08':
            self._tmpl = Template("".join([pddgpm3_08_tmpl[e] for e in elem]) + "END")
            self._params = OrderedDict(chain.from_iterable(pddgpm3_08_param[e].items() for e in elem)) 
        else:
            raise ValueError("Unsupported method.")

        if ref is not None:
            self.ref = ref
        else:
            self.ref = np.zeros(len(self._params))

    def __len__(self):
        return len(self._params)

    @property
    def params(self):
        return self._tmpl.substitute(self._params)

    def write_params(self, path, pert=None, percent=None, comment=None):
        fin = os.path.join(path, "param.dat")

        if percent is None:
            percent = 0.05

        params = OrderedDict()
        for i, key in enumerate(self._params):
            params[key] = self._params[key] * (1.0 + percent * self.ref[i])

        if pert is not None:
            assert len(pert) == len(self._params)
            for i, key in enumerate(self._params):
                params[key] *= 1.0 + percent * pert[i]

        with open(fin, 'w') as f:
            f.write(self._tmpl.substitute(params))

            if comment is not None:
                f.write("\n" + comment)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("method", help="SQM Method")
    parser.add_argument("path", help="Path to write param.dat file")
    args = parser.parse_args()

    params = SQM_PARAM(['H', 'C', 'N', 'O', 'Cl'], args.method)
    params.write_params(args.path)
