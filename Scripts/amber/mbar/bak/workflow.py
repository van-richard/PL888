#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import os, sys
sys.path.append('/home/van/Scripts/mbar')

def find_subdirectories():
    return next(os.walk(f'{path}'))[1]

def find_windows():
    windows = []
    subdirs = find_subdirectories()
    for subdir in subdirs:
        if len(subdir) == 2 and subdir.isdigit():
            sim_dirs.append(subdir)
    return sorted(windows)

def find_cv_rst(path):
    cv_params = []
    with open (f'{path}/cv.rst', 'r') as file:
        cv_items = file.read().split()
        for item in cv_items:
            if '=' in item:
                cv_params.append(item)
    return cv_params[:8] # first rest estting

def make_cv_dict():
    


# In[ ]:


def read_cv(dirname):
    cv_params = []
    with open (f'{path}/{dirname}/cv.rst', 'r') as file:
        cv_items = file.read().split()
        for item in cv_items:
            if '=' in item:
                cv_params.append(item)
    return cv_params[:8] # first rest estting

def from_cv(dirname):
    d = {}
    contents = read_cv(dirname)
    for content in contents:
        (key, val) = content.split('=')
        d[key] = val
    return d
    
def read_parameter(windows):
    rst_dict = {}
    rst_dict['n_windows'] = len(windows)

    cv_min = from_cv(window[0])
    return rst_dict 
    


# In[ ]:


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




