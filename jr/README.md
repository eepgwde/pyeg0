* Contol

weaves

Jnygre.Q.Rnirf@tznvy.pbz

* Overview

This is timeseries financial data. 20 portfolios, 800 in-sample points, 200
out.

* Data organization

I've used q/kdb+ to reshape the data and add some extra variables.  Mostly,
I renamed to lower-case and padded with zeros, x01. I added some ratios
dx01 and some moving averages m5x01.

Split up to different portfolios.

* Analyses

** Timeseries, auto- and cross-correlations to Return.

Short data-set of last 40 and some correlations are on the full set.

All these are in JPEG. And it looks like there is nothing more to this data
than a set of various SMA and EWMA.

*** Portfolio KF0

**** Variables by eye

***** x01

On the short data-set, one day lag is clearly visible from time-series and
acf. 

ccf with results shows appearance of a trivial 9 day lag in the tail
data. Might be picking weekly activity?

ccf on full data, show -ve to the day, +ve to the previous and may a
fortnightly -ve.

***** x02 and others

Suspiciously similar to x01. Short data shows 2 day lags for acf.

These all appear suspiciously similar. 

***** No Volumes, No total trades, No VWAP

These are all so similar, that I might have to reconstitute the price
signal and go and get the real data from Yahoo!

*** More Checking

I'll cross-correlate the metrics to one another to see if anything isn't an
MA.

No, all MAs.

** Improvements

*** Technicals

I don't have any volume data, so bit limited what I can add

RSI is a good one.

http://www.investopedia.com/terms/r/rsi.asp

Price volatility, of course. Draw-down. 

Fibonacci retracement - support and resistance. I can do some level
spotting.

Wavelet transformations can give good trend predictors.

GARCH can be used, three years is enough data.

ARIMA is not known to be too successful, but maybe with some machine
learning there can be something.

*** Strategies

No sophisticated trader just takes a wild punt on a technical. Some hedging
strategies are needed: market neutral.

They have 20 portfolios, I can easily do a binary classifier and do a
120-20, or 130-30 as it is now.

https://en.wikipedia.org/wiki/130%E2%80%9330_fund

Pairs trading is big with Citibank, if I can find some strong correlations,
I can try that.

I don't know the market time-frame, so I can't use the NYSE futures as the
R_b.

But I can use the portfolios as a whole and do a Markowitz optimization,
predict the proportions to hold for the next period.

Calculate the risk and return empirically for a trading window, and from
the technicals predict what they could be in the next, then find the
proportions to optimize for the next.

** To do

I'll reconstitute the market price (100 base for each), calculate some
technicals. 130-30 looks easiest to do. It's a scaled-down Markowitz.

* Notes

** Software

I've used GNU R, I haven't got a full Python sci-kit learning setup on my
home machine. GNU R machine and timeseries tools are the basis of what is
developed for Python.



** This file's Emacs file variables

[  Local Variables: ]
[  mode:text ]
[  mode:outline-minor ]
[  mode:auto-fill ]
[  fill-column: 75 ]
[  coding: iso-8859-1-unix ]
[  comment-column:50 ]
[  comment-start: "[  "  ]
[  comment-end:"]" ]
[  End: ]
