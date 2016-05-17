/// weaves

/// Using the database file from jr0.q

.sys.qreloader enlist "data1.qdb"

/// Because I'm going to be doing arithmetic on the dt0, I'm going to convert it to int.

cols data1

/// We only have a price signal, yes really, the rest are moving averages
/// folio0 was stored as a string, convert back to a symbol.

x.cols: (cols data1) @ where (string each cols data1) like "x??"

data: ![data1;();0b;x.cols]
data.folio0: `$data.folio0

/// Add an absolute price signal - all based on a 1000
/// Assume that it the day's close, so we must lag it

data0: update p00:exp r00  by folio0 from data 
data0: update p01:prds p00  by folio0 from data0
data0: update p01:p01 * 1000  by folio0 from data0
data0: update p00:p01 by folio0 from data0
data0: delete p01 from data0

/// Add lags - price and returns are now yesterday's close.
data0: update r00: prev r00 by folio0 from data0
data0: update p00: prev p00 by folio0 from data0

delete from `data0 where dt0 = 1;

/// Safety info
.sf.folios: distinct data0.folio0

/// Functions used by all
.sys.qreloader enlist "jr-f.q"

/// Synthetics introduce some bad values
.sys.qreloader enlist "jr2a.q"

data1: update r00:0f from data1 where (dt0 = 2),(folio0 in `KA`KB`KC)

/// Metrics and Technical Analytics
.sys.qreloader enlist "jr2b.q"

/// Before we apply a trading strategy choose a subset.
/// To check the in- or out- sample use one of these. Leave it undefined for all
/// In-sample
/// x.in0: 1b
/// Out-sample
/// x.in0: 0b
/// @note
/// There is an assign in this show.
show select count i by in0 from data1:$[ .sys.undef[`x;`in0]; data1; delete from data1 where in0 <> x.in0]

/// Remove the synthetic portfolios (for this design iteration.)
data1: 0!delete from data1 where folio0 in `KA`KB`KC

/// Apply trading strategy - it must operate on lagged data.
/// This generates a state machine table: state0
/// @class state0

.sys.qreloader enlist "jr2c.q"

/// Calculate profits and losses on each trade from the strategy table state0
/// This generates plwa05 and does not change any tables.
/// @class plwa05
.sys.qreloader enlist "jr2d.q"

/// Now join the trading signals to data1 with the marking they will be in profit or loss.
/// For this iteration, we are only concerned with profit and loss (a binary classifier)
/// @note Lags
/// We are joining back at the market date, so the strategy has been evaluated
/// using the past data. This means: we must lag everything for the learner wrt
/// to the outcomes, ie. fp05
update fcst:` from `data1;
data1: (select by folio0,dt0 from data1) lj (2!ungroup select lwa05, fp05:pnl1, h05:ddt0 by folio0,dt0:ldt0 from plwa05)

/// Add a marker that these are RSI fv05 v for veritable - nstrat is not strategy
update fv05:`nstrat from `data1
update fv05:`strat from `data1 where not null lwa05

/// Calculate profits and losses on synthetic trades
/// ie. take same position at same time, but not chosen by RSI
data1: 0!data1

.sys.qreloader enlist "jr2e.q"

/// Let R deal with the first blank values.

/// Some metrics comparing strategy to non-strategy
/// s2ns is improvement of strategy trades to non-strategy (by unit)
/// s2nst0 means is the strategy better (ie. wins more or loses less)

pnl.stratwa05: select strat:sum wapnl05 by folio0,in0 from data2 where fv05 = `strat
pnl.stratwa05: 0!pnl.stratwa05 lj select nstrat:sum wapnl05 by folio0,in0 from data2 where fv05 = `nstrat
update s2ns: strat - nstrat by folio0,in0 from `pnl.stratwa05;
update s2nst0: signum strat * (signum strat) = signum nstrat by folio0,in0 from `pnl.stratwa05;
update s2nst0: signum strat by folio0,in0 from `pnl.stratwa05 where (signum strat) < signum nstrat;
update s2nst0: signum strat by folio0,in0 from `pnl.stratwa05 where (signum strat) > signum nstrat;
update s: strat > 0 by folio0,in0 from `pnl.stratwa05;
update ns: nstrat > 0 by folio0,in0 from `pnl.stratwa05;
update n2ns: s2nst0 > 0 by folio0,in0 from `pnl.stratwa05;

// update s2nst1: (signum strat) > signum nstrat by folio0,in0 from `pnl.stratwa05;
// update s2ns1: strat > nstrat by folio0,in0 from `pnl.stratwa05 where 0 < abs s2ns0t;

show pnl.stratwa05

show select sum strat, sum nstrat, sum s2ns by folio0 from pnl.stratwa05
show select sum strat, sum nstrat, sum s2ns by in0 from pnl.stratwa05

\

/// Validation
/// But only by eye.

show .t00.count @ data1

show select last p00 by folio0 from data1

show select count i by folio0,in0,lwa05,fcst from data1

\

/// Archive to CSV and binary format.
/// If a dataset is good.

data2: 0!data1
.sch.t2csv[`data2]

.t.t0: 0!data1
.sch.t2str[`.t.t0]

// Make file name in the first directory and save a copy to it.
.sch.mimefile[`data2;"qdb";first (.sys.qpath.list`)] set .t.t0 

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load data1.qdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:

