* Control

weaves

Jnygre.Q.Rnirf@tznvy.pbz

This document is now superceded by the PowerPoint presentation, see the
Folder Contents following.

* Folder Contents

* Overview

This is a predictor for consumer spending within an economy (Indonesia, as
of 2015 with forecasts for 2016.) It contains spending by decile from the
COICIP classifications for consumer expenditure.

* Preparation

** CSV and preparation

*** Formatting - ./bak

By hand, load as CSV, format numeric columns to not have comma.
Re-export to CSV as IndonesiaData1.csv

Apply the bak/Makefile (simplifies some strings) to get hexp-065.csv

** GNU R - pru0.R

This loads and pre-processes for q/kdb+.

*** Totals

The totals are occasionally incorrect. And often wrongly scaled.  Because
they are mostly correct, and it does say decile, we can assume they should
be right.

See hexp-065-r.xlsx for discussion of scaling wrt to per capita and household-size.

**** inc.ds0

This shows that some of the years are incorrect totals.
The total income is out by a factor of 10.

** Excel - Pivot tables and charts

See the PowerPoint presentation. 

* Analyses

** Metrics

Corrected data has been passed from pru0.R to q/kdb+ database and then
loaded and processed using q with hexp01.q.

*** proportions x2tp

For the totals for each year, for each of the classifications, I've added
its proportion as x2tp.

*** rates 

**** r0

For the percentage rate of change of the absolute amount from year-to-year
(YoY)

**** r1 

For the percentage rate of change of the proportion.

*** GNU-R

pru2.R load x2tp and r1 and produces a good explanatory plot ul-001.jpeg

*** Excel hexp-065-x2tp and Pivot Table

The data for the chart is pivoted and you can get a good idea of the
movements by consumers from one category to another.

** Methodology

*** Issues

It's multi-variate. From the ul-001.jpeg plot, it's pretty clear that most
volatility has left the economy, but the economy will respond to shocks.

The only methodology I can think of (apart from the obvious ones of
regression and vector auto-regression) is to use Gibbs sampling and
Monte-Carlo/Genetic Algorithm.

I simplified the deciles to just upper and lower. I could change the
categories to inferior, superior goods. But I would still have to provide a
four-way response.

I think Gibbs sampling would be unavoidable. It's what I've usually had to do.

So not as easy as it looked!

*** Issues (reprise)

I believe I can use my own boot-strapping method. All I really need to
input is a new annual GDP growth rate into the test sample, and some
plausible values for the expenditures (they must sum to one) and train and
predict each expenditure in turn.

**** Incremental predictions under statistical learning

It should be possible to incrementally extend the sample set with its own
predictions. The operating convention here would be to predict the most
stable categories and deciles first and then add those to the sample set
and to predict the next category and decile. In this way, one could use
a statistical learning method.

If one were to cross-validate by changing the order of prediction, (most
volatile first) hopefully they would converge. It is a variant of ensemble learning.

12 categories, 10 deciles is 120 factors/predictions - with, usually, a few minutes
per run.

**** Progress

I've implemented part of that. It runs suspiciously quickly. There's a test
branch (pru1) where I'm not using their forecasts for the test sample. 

*** Technologies

Vector auto-regression is the technique usually used. It would be possible
to augment the samples by adding WDIndicators. 

A statistical learning method would be a better choice. Unfortunately,
regression is not well-served (binary predictors are easier); time-series
methods are limited in choice; multi-variate time series even less so.

*** Macro-economics

I've looked at the WDI stats for Indonesia. Very interesting. I've looked
up some good demographics. There's a separate PowerPoint presentation
(suffix -WDI.) The charts are in the attic in attic/ind.zip.

*** Progress - finally found the PLS multiple response implementation

Vastly superior to ARIMA() and Vector Auto-Regression.
It's a quirky use of the R I() operator that makes it possible.
Works well with the upper-lower data.

Another package plsreg2 from Gaston Sanchez is a very good charter. I've
included that: very clear correlation relationships.

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
