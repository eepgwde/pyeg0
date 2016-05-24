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

## Pandas plotting.
# Check the manual.
    
s = Series(np.random.randn(10).cumsum(), index=np.arange(0, 100, 10))
s.plot()

# Nice bimodal with a kernel distribution estimate overlaid.
comp1 = np.random.normal(0, 1, size=200) # N(0, 1)
comp2 = np.random.normal(10, 2, size=200) # N(10, 4)
values = Series(np.concatenate([comp1, comp2]))
values.hist(bins=100, alpha=0.3, color='k', normed=True)
values.plot(kind='kde', style='k--')

## Haiti crisis data

data = pd.read_csv('ch08/Haiti.csv')
data.describe()

data[['INCIDENT DATE', 'LATITUDE', 'LONGITUDE']][:10]

# Some cleaning

data = data[(data.LATITUDE > 18) & (data.LATITUDE < 20) &
            (data.LONGITUDE > -75) & (data.LONGITUDE < -70)
            & data.CATEGORY.notnull()]

# Mapping

def to_cat_list(catstr):
    stripped = (x.strip() for x in catstr.split(','))
    return [x for x in stripped if x]

def get_all_categories(cat_series):
    cat_sets = (set(to_cat_list(x)) for x in cat_series)
    return sorted(set.union(*cat_sets))

def get_english(cat):
    code, names = cat.split('.')
    if '|' in names:
        names = names.split(' | ')[1]
    return code, names.strip()

def get_code(seq):
    return [x.split('.')[0] for x in seq if x]

all_cats = get_all_categories(data.CATEGORY)

# Generator expression
english_mapping = dict(get_english(x) for x in all_cats)

english_mapping['2a']
english_mapping['6c']

all_codes = get_code(all_cats)
code_index = pd.Index(np.unique(all_codes))

# A set of indicator variables is prepared
dummy_frame = DataFrame(np.zeros((len(data), len(code_index))),
                        index=data.index, columns=code_index)

for row, cat in zip(data.index, data.CATEGORY):
    codes = get_code(to_cat_list(cat))
    dummy_frame.ix[row, codes] = 1

data0 = data.join(dummy_frame.add_prefix('category_'))
