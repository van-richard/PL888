"""
save all flags from cv rat file to datafram
header = atom, shaoe of potential (r1, r2 ... etc, force contant
data = rst1
        rat2
        ... etc

"""

def parse(file='cv.rst'):
    cv_params = []
    with open (f'{file}', 'r') as file:
        cv_items = file.read().split()
        for item in cv_items:
            if '=' in item:
                cv_params.append(item)
    return cv_param
## first rest estting
    
def to_dataframe(params):
    options = ('iat','r1', 'r2', 'r3'. 'r4', 'rk2', 'rk3')
    paramdict = dict.fromkeys(options)
    for param in params:
        (key, val) = param.split('=')
        paramdict[key].qppend(val)
    return pd.from_dict(paramdict)

def get_rst_force():
    if d['rk2'] == d['rk3'] and not in ['0','0.0']:
        restraint_force = d['rk2']

def get_rst_value():
    if d['r2'] == d['r3']:
        value = d['r2']



def init_project(path):
    project_path = glob(f'{path}')

    windows = get_umbrella_windows()
    
    rst_dict = read_parameters(windows)
    
    n_windows = rst_dict['n_windows']
    cv_min = rst_dict[windows[0]]
    cv_max = rst_dict[windows[-1]]
    rst_force = rst_dict['rst_f']


# In[ ]:


path = '/scratch/samitha/mt2-b3lyp'

n_windows, cv_min, cv_max, rst_force  = init_project(path)


# In[1]:


def find_project_path():
    return glob(f'{path}')

def count_subdirectory(path):
    return next(os.walk(f'{path}'))[1]


class system():
    def __init__(self, path):
        self.path = path
        # self.n_windows = n_windows
        # self.cv_min = cv_min
        # self.cv_max = cv_max
        # self.restraint_force = restraint_force

    # def find_windows(self):
    #     windows = []
    #     subdirs = get_subdirectories()
    #     for subdir in subdirs:
    #         if len(subdir) == 2 and subdir.isdigit():
    #             sim_dirs.append(subdir)
    #     windows = sorted(windows)
    #     self.n_windows = len(windows)


    


# In[2]:


path = '/scratch/samitha/mt2-b3lyp'

system(path)


# In[3]:


import pandas as pd


# In[19]:


cv_params = []
with open (f'{path}/00/cv.rst', 'r') as file:
    cv_items = file.read().split()
    for item in cv_items:
        if '=' in item:
            cv_params.append(item)
            


# In[25]:


cv = [param.split('=') for param in cv_params]
for i,j in cv:
    


# In[11]:


pd.DataFrame(d)


# In[12]:


d


# In[ ]:




