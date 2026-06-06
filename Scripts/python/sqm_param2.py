import os
import sys
from copy import copy
from string import Template
# from collections import OrderedDict
from itertools import chain
import numpy as np

sys.path.append("/home/panxl/scripts/")
from param_pm3 import pm3_tmpl, pm3_param
from param_am1 import am1_tmpl, am1_param
from param_pddgpm3 import pddgpm3_tmpl, pddgpm3_param
from param_pddgpm3_08 import pddgpm3_08_tmpl, pddgpm3_08_param
from param_pm6 import pm6_tmpl, pm6_param


class SQM_PARAM(object):

    def __init__(self, elem, method='pm3', ref=None):
        if method.lower() == 'pm3':
            self._tmpl = Template("".join([pm3_tmpl[e] for e in elem]) + "END")
            self._params = dict(chain.from_iterable(pm3_param[e].items() for e in elem)) 
        elif method.lower() == 'am1':
            self._tmpl = Template("".join([am1_tmpl[e] for e in elem]) + "END")
            self._params = dict(chain.from_iterable(am1_param[e].items() for e in elem)) 
        elif method.lower() == 'pddgpm3':
            self._tmpl = Template("".join([pddgpm3_tmpl[e] for e in elem]) + "END")
            self._params = dict(chain.from_iterable(pddgpm3_param[e].items() for e in elem)) 
        elif method.lower() == 'pddgpm3_08':
            self._tmpl = Template("".join([pddgpm3_08_tmpl[e] for e in elem]) + "END")
            self._params = dict(chain.from_iterable(pddgpm3_08_param[e].items() for e in elem)) 
        elif method.lower() == 'pm6':
            _elem = copy(elem)
            for i, e in enumerate(elem):
                for j in range(i + 1):
                    _elem.append(e + elem[j])
            self._tmpl = Template("".join([pm6_tmpl[e] for e in _elem]) + "END")
            self._params = dict(chain.from_iterable(pm6_param[e].items() for e in _elem)) 
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

    def pert_params(self, pert, percent=None):
        assert len(pert) == len(self._params)
        if percent is None:
            percent = 0.05

        params = dict()
        for i, key in enumerate(self._params):
            params[key] = self._params[key] * (1.0 + percent * pert[i])

        return self._tmpl.substitute(params)

    def write_params(self, path, pert=None, percent=None, comment=None):
        fin = os.path.join(path, "param.dat")

        # if percent is None:
        #     percent = 0.05

        # params = dict()
        # for i, key in enumerate(self._params):
        #     params[key] = self._params[key] * (1.0 + percent * self.ref[i])

        if pert is not None:
            out = self.pert_params(pert, percent)
        else:
            out = self.params
        #     assert len(pert) == len(self._params)
        #     for i, key in enumerate(self._params):
        #         params[key] *= 1.0 + percent * pert[i]

        with open(fin, 'w') as f:
            f.write(out)

            if comment is not None:
                f.write("\n" + comment)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("method", help="SQM Method")
    parser.add_argument("path", help="Path to write param.dat file")
    args = parser.parse_args()

    # params = SQM_PARAM(['H', 'C', 'N', 'O', 'HH', 'HC', 'HO', 'CC', 'CO', 'OO'], args.method)
    # params = SQM_PARAM(['H', 'C', 'N', 'O'], args.method)
    params = SQM_PARAM(['H', 'C', 'N', 'O'], args.method)
    params.write_params(args.path)
