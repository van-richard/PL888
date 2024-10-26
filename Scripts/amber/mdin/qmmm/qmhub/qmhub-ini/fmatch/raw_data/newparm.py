from parmed.tools import change
from parmed.amber import AmberParm

parm = AmberParm('step3_pbcsetup.orig.parm7')

action = change(parm, '@1-280610', 'charge', 0, 'quiet')

action.execute()

parm.save('step3_pbcsetup.0.parm7')

