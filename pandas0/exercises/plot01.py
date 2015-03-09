## Plotting
#
# Matplotlib is the most commonly used.
# It's Matlab-like.
#
# As noted above, you can plot simple charts using Pandas.
# So we usually capture those as subplots within a figure.
# That is how the Matlab plotting library works.

import matplotlib.pyplot as plt

# create figure
# add sub-plots

from datetime import datetime

# You can't have a blank line in there, the annotations must be
# processed in the same block.
fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
data = pd.read_csv('ch08/spx.csv', index_col=0, parse_dates=True)
spx = data['SPX']
spx.plot(ax=ax, style='k-')
crisis_data = [
    (datetime(2007, 10, 11), 'Peak of bull market'),
    (datetime(2008, 3, 12), 'Bear Stearns Fails'),
    (datetime(2008, 9, 15), 'Lehman Bankruptcy')
]
for date, label in crisis_data:
    ax.annotate(label, xy=(date, spx.asof(date) + 50),
                xytext=(date, spx.asof(date) + 200),
                arrowprops=dict(facecolor='black'),
                horizontalalignment='left', verticalalignment='top')
    # Zoom in on 2007-2010
    ax.set_xlim(['1/1/2007', '1/1/2011'])
    ax.set_ylim([600, 1800])
    ax.set_title('Important dates in 2008-2009 financial crisis')


