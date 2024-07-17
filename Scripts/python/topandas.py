import pandas as pd
import numpy as np

    
def to_series(data, name):
    return pd.Series(data, name=name, dtype='float32')

def matrix2dataframe(data):
    mat = np.matrix(data)
    return pd.DataFrame(mat, dtype='float32')

def mbar2df(outdir, time, dg):
    df = pd.DataFrame(
            {
                'Time (ps)': np.array(time),
                'Barrier (kcal/mol)': np.array(dg),
                }
            )
    df.to_csv(f'{outdir}/pmf-dataframe.csv')
