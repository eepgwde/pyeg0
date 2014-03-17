import pandas as pd
import pandas.io.data as web

data = web.get_data_yahoo(['SPY', 'AAPL'], '2006-01-01')
data

def to_index(rets):
    """Convert a daily returns sequence to a rolling index.

    By index, it is meant a stock market index, something that goes up
    and down reflecting the price. This one has a base of 1.

    It's calculated by a cumulative product and setting the first valid entry to 1.
    """
    index = (1 + rets).cumprod()
    first_loc = max(index.notnull().argmax() - 1, 0)
    index.values[first_loc] = 1
    return index

def trend_signal(rets, lookback, lag):
    """Apply some smoothing on a sum over lookback returns.

    This implementation doesn't scale down the sum.
    """
    signal = pd.rolling_sum(rets, lookback, min_periods=lookback - lag)
    return signal.shift(lag) 

returns = data['Adj Close']['AAPL'].pct_change()

# I think he is trying to describe a strategy that we hold onto a stack of shares
# for a hundred days

signal = trend_signal(returns, 100, 3)
trade_friday = signal.resample('W-FRI').resample('B', fill_method='ffill')
trade_rets = trade_friday.shift(1) * returns

# We can then convert the strategy returns to a return index and plot
# them (see Figure 11-1):

to_index(trade_rets).plot()
