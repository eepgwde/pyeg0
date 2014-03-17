import matplotlib.pyplot as plt
import pandas as pd
import pandas.io.data as web

from collections import defaultdict

names = ['AAPL', 'GOOG', 'MSFT', 'DELL', 'GS', 'MS', 'BAC', 'C']

def get_px(stock, start, end):
    return web.get_data_yahoo(stock, start, end)['Adj Close']

#

px = pd.DataFrame({n: get_px(n, '1/1/2009', '6/1/2012') for n in names})

px = px.asfreq('B').fillna(method='pad')
rets = px.pct_change()

((1 + rets).cumprod() - 1).plot()

# For the portfolio construction, we’ll compute momentum over a
# certain lookback, then rank in descending order and standardize:

def calc_mom(price, lookback, lag):
    mom_ret = price.shift(lag).pct_change(lookback)
    ranks = mom_ret.rank(axis=1, ascending=False)
    demeaned = ranks - ranks.mean(axis=1)
    return demeaned / demeaned.std(axis=1)

# With this transform function in hand, we can set up a strategy
# backtesting function that computes a portfolio for a particular
# lookback and holding period (days between trading), returning the
# overall Sharpe ratio

compound = lambda x : (1 + x).prod() - 1
daily_sr = lambda x: x.mean() / x.std()

def strat_sr(prices, lb, hold):
    # Compute portfolio weights
    freq = '%dB' % hold
    port = calc_mom(prices, lb, lag=1)
    daily_rets = prices.pct_change()
    # Compute portfolio returns
    port = port.shift(1).resample(freq, how='first')
    returns = daily_rets.resample(freq, how=compound)
    port_rets = (port * returns).sum(axis=1)
    return daily_sr(port_rets) * np.sqrt(252 / hold)

strat_sr(px, 70, 30)

# From there, you can evaluate the strat_sr function over a grid of
# parameters, storing them as you go in a defaultdict and finally
# putting the results in a DataFrame:

lookbacks = range(20, 90, 5)
holdings = range(20, 90, 5)

dd = defaultdict(dict)
for lb in lookbacks:
    for hold in holdings:
        dd[lb][hold] = strat_sr(px, lb, hold)

ddf = pd.DataFrame(dd)
ddf.index.name = 'Holding Period'
ddf.columns.name = 'Lookback Period'

# To visualize the results and get an idea of what’s going on, here is
# a function that uses matplotlib to produce a heatmap with some
# adornments:

def heatmap(df, cmap=plt.cm.gray_r):
    fig = plt.figure()
    ax = fig.add_subplot(111)
    axim = ax.imshow(df.values, cmap=cmap, interpolation='nearest')
    ax.set_xlabel(df.columns.name)
    ax.set_xticks(np.arange(len(df.columns)))
    ax.set_xticklabels(list(df.columns))
    ax.set_ylabel(df.index.name)
    ax.set_yticks(np.arange(len(df.index)))
    ax.set_yticklabels(list(df.index))
    plt.colorbar(axim)

# Calling this function on the backtest results, we get Figure 11-3:
heatmap(ddf)
