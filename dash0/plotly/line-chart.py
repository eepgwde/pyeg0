# Find your api_key here: https://plot.ly/settings/api

import plotly
import plotly.plotly as py
import plotly.graph_objs as go

import pandas as pd
import numpy as np

N = 500
x = np.linspace(0, 1, N)
y = np.random.randn(N)
df = pd.DataFrame({'x': x, 'y': y})
df.head()

data = [
    go.Scatter(
        x=df['x'], # assign x as the dataframe column 'x'
        y=df['y']
    )
]
# IPython notebook
# py.iplot(data, filename='pandas/basic-line-plot')


url = plotly.offline.plot(data, filename='line-graph.html')