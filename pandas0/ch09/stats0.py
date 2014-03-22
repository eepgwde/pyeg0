import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
import q
from qc import Client

# Load data
url = 'http://vincentarelbundock.github.io/Rdatasets/csv/HistData/Guerry.csv'
dat = pd.read_csv(url)

# Fit regression model (using the natural log of one of the regressors)
results = smf.ols('Lottery ~ Literacy + np.log(Pop1831)', data=dat).fit()

# Inspect the results
print results.summary()

c = Client(port=5003)
t0=c("t0")

dft0 = pd.DataFrame(data=list(t0.bid0), index=t0.tm0)
dft0.plot()

c('t:([]a:();b:())')
c("insert", 't', (1,'x'))
c.insert('t', (2,'y'))
x = c("insert", 't', (3,'z'))
c("select sum a from t")


