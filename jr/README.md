* Contol

weaves

Jnygre.Q.Rnirf@tznvy.pbz

* Overview

This is timeseries financial data. 20 portfolios, 800 in-sample points, 200
out.

First, I analyzed the existing metrics (Analyses:Variable by
eye). Discovered they were all moving averages (of some kind). No volume
data, no VWAP, no open/high/low just close.

I decided to not bother with these x01-x24 and added my own metrics.

In the Strategies section, I describe and develop a trading strategy. I've
re-used an Relative Strength Index metric based one following Caldwell.

* Data organization

I've used q/kdb+ to reshape the data and add some extra variables.  Mostly,
I renamed to lower-case and padded with zeros, x01. I added some ratios
dx01 and some moving averages m5x01.

Split up to different portfolios.

Later, in Strategies, I add trading metrics.

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

**** Metrics by eye (2)

***** p00 - good looking Brownians

I've added a portfolio that is the average price of all folios (on each
day, of course). Calculated in q/kdb+.

This performs badly, hovers around, but is very stable. Good example of
portfolio diversification reducing risk. In fact, it's so good, it's
suspicious. It may be that this is retro-generated data.

To see that, I've added two other synthetic portfolios that either remove
KF or have twice the amount.

I've had to split the plots up to make them more intelligible, so watch the
auto-scale on the axis.

***** r00 - looking at the last sixty days.

Looking directly at the returns, we can see some good correlations and
anti-correlations. 

KI to KG in the last 60 days. Many good pairs here. KN to KL. KQ to KS.

***** r05, r20 and others

Many good plots archived as jr2-syn.zip

These show some of my metrics see jr2.q for what they are, but r?? is
returns and r05 is 5 day moving average, r20 the 20 day.

s?? is standard deviation.

The synthetic portfolios are in there too. There's also a short data-set
(last sixty days) of MACD.

*** More Checking

I'll cross-correlate the metrics to one another to see if anything isn't an
MA.

No, all MAs. Some are EWMA, some MA. No indication of VWAP. Nothing.

** Improvements

*** Technicals

I don't have any volume data, so bit limited what I can add.

RSI is a good one.

http://www.investopedia.com/terms/r/rsi.asp

Price volatility, of course. Draw-down. 

Fibonacci retracement - support and resistance. I can do some level
spotting.

Wavelet transformations can give good trend predictors.

GARCH can be used, three years is enough data.

ARIMA is not known to be too successful, but maybe with some machine
learning there can be something.

**** kdb+

This has some simple metrics:

mdev is a standard deviation over a sliding window

mcount is a count over a window, so RSI can be done.

mavg

**** R

fTrading has many technicals and many ready to use packages.

r-cran-fextremes - GNU R package for financial engineering -- fExtremes
r-cran-fgarch - GNU R package for financial engineering -- fGarch
r-cran-fimport - GNU R package for financial engineering -- fImport
r-cran-fmultivar - GNU R package for financial engineering -- fMultivar
r-cran-fnonlinear - GNU R package for financial engineering -- fNonlinear
r-cran-foptions - GNU R package for financial engineering -- fOptions
r-cran-foreign - GNU R package to read/write data from other stat. systems
r-cran-fportfolio - GNU R package for financial engineering -- fPortfolio
r-cran-fregression - GNU R package for financial engineering -- fRegression
r-cran-ftrading - GNU R package for financial engineering -- fTrading

*** Strategies: General

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

*** Strategies: RSI trading with Mediation by Prediction

I'll use the same trading system I develope for the ETFs. Except now we I'm
not training on fundamentals and correlations, but trading signals from a
Technical Analytic.

**** RSI trading

I'll implement a Relative Strength Index trading system using Caldwell's
signals. This worked well for stocks on at bet365. Run it on the in-sample
data and "mark" it using a binary indicator: profit or loss.

**** Use this as the training set for a binary classifier

I'll then run a machine learning algorithm (probably the Gradient Boosting
Method) to derive a predictor using time-slice sampling with at least a
moving 20 day horizon.

I should only give the learning algorithm the information of when the trade
opened information and *not* when it was closed. That would be all the
other stuff that hasn't been used by the RSI metric.

**** Trade the Out-of-Sample Data: Generate Candidate Trade Opens and Mediate

Then run the out-of-sample data through the trading engine, generating the
candidate open decisions, for each one, as it occurs, I use the
predictor to determine if it will be a profit or a loss. If it is likely to
be profitable, the trading engine will open the trade. If not, it
doesn't. Let's call this method the "predictor-mediated" one, or simpler
still the Mediated trading strategy.

I then run the out-of-sample data to conclusion and compare the total
profit and loss for Not-Mediated and Mediated.

**** Discussion

The RSI is a trend metric. I'm going to base trades on that. I'm hoping
that other technical metrics can be inferred by the learner. Because the
learner has the moving averages on returns and on standard deviation, it
might apply it has the information to develop its own Bollinger bands.

So that should be enough.

** To do

I'll reconstitute the market price (1000 base for each), calculate some
technicals. 130-30 looks easiest to do. It's a scaled-down Markowitz.

Add more technicals in kdb.

Merge the unstacked data frames from kdb in R.

Apply R technicals.

130-30 looks easiest to do. It's a scaled-down Markowitz.


* Notes

** Software

I've used GNU R, I haven't got a full Python sci-kit learning setup on my
home machine. GNU R machine and timeseries tools are the basis of what is
developed for Python.

** ChangeLog

*** RSI Trading

Overall

t0    | n0   pnl0     n1   pnl1     n2      pnl2    
------| --------------------------------------------
loss  | 1671 9462.156 4896 21143.39 34.1299 44.75232
profit| 3225 11681.23 4896 21143.39 65.8701 55.24768

In-sample

t0    | n0   pnl0     n1   pnl1     n2       pnl2    
------| ---------------------------------------------
loss  | 1235 7350.494 3674 16865.96 33.61459 43.58183
profit| 2439 9515.465 3674 16865.96 66.38541 56.41817

Out-of-sample

t0    | n0  pnl0     n1   pnl1     n2       pnl2    
------| --------------------------------------------
loss  | 435 2126.526 1212 4279.741 35.89109 49.68819
profit| 777 2153.215 1212 4279.741 64.10891 50.31181

*** Original data

Snapshot the JPEG and tag the code now

branch jr1 - tag: x06-KT0

> names.xXX
[1] "x06"
> folio.name
[1] "KT0"

*** Prices

I've reconstituted the original price signal from the returns, and remove
all the MAs. Made some Brownian motions of the folio prices. Analysis above.

I've added a market price (all portfolios equally weighted).

Switched to jr2 branch to try the unstack merge.


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
