#!/usr/bin/env python
# coding: utf-8

# In[33]:


import os

from datetime import datetime
from dateutil import parser

from twython import Twython
import pandas as pd
import numpy as np

import json

get_ipython().run_line_magic('load_ext', 'autoreload')
get_ipython().run_line_magic('autoreload', '2')


# In[25]:


with open('credentials.json', 'r') as jf:
    creds = json.load(jf)
creds


# In[26]:


client = Twython(creds['consumer_key'],
                  creds['consumer_secret'],
                  creds['access_token'],
                  creds['access_token_secret'])


# In[31]:


result = client.show_user(screen_name=creds['screen_name'])
result


# In[30]:


result = client.show_user(screen_name='indigolfc')
result


# In[32]:


xtime = parser.parse(result['created_at']).timestamp()
tsecs = datetime.now().timestamp() - xtime
tdays = tsecs / (60 * 60 * 24)
result['statuses_count'] / tdays


# In[ ]:




