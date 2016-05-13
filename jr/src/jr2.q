/// weaves

/// Using the database file from jr0.q

.sys.qreloader enlist "data1.qdb"

cols data1

/// We only have a price signal, yes really, the rest are moving averages
/// folio0 was stored as a string, convert back to a symbol.

x.cols: (cols data1) @ where (string each cols data1) like "x??"

data: ![data1;();0b;x.cols]
data.folio0: `$data.folio0

/// Add an absolute price signal - all based on a 1000

data0: update p00:exp r00  by folio0 from data 
data0: update p01:prds p00  by folio0 from data0
data0: update p01:p01 * 1000  by folio0 from data0
data0: update p00:p01 by folio0 from data0
data0: delete p01 from data0

// Safety info
.sf.folios: distinct data0.folio0

// Functions used by all
.sys.qreloader enlist "jr-f.q"

// Synthetics
.sys.qreloader enlist "jr2a.q"

// Metrics and Technical Analytics
.sys.qreloader enlist "jr2b.q"

/// Trading signals
/// State machines on signals.

// Wilder
.sf.tr0: `null`short`long`hold`close

.sf.tr1: `null1`short1`long1`hold1`close1

// State machine table
state0: ungroup select dt0, p00, fz05, fz20, fc05, fc20, fd05, fd20, lfz05:prev fz05, lfz20:prev fz20, lfc05:prev fc05, lfc20:prev fc20, lfd05:prev fd05, lfd20:prev fd20 by folio0 from (`folio0`dt0 xasc 0!delete from data1 where folio0 in `KA`KB`KC)

delete from `state0 where dt0 < 20

state0: `folio0`dt0`p00`fz05`lfz05`fz20`lfz20`fc05`lfc05`fc20`lfc20`fd05`lfd05`fd20`lfd20 xcols state0

// Using near/far: as under/over/stable fz05/fz20, bull/stable fc05/fc20, bear/stable fd05/fd20

// Wilder's under/stable/over: variant a
// if under -> long
// if over -> short
// if stable -> close

update wa05:`long from `state0 where (fz05 = `under),(not lfz05 = `under)
update wa05:`short from `state0 where (fz05 = `over),(not lfz05 = `over)

update wa05:`close from `state0 where (fz05 = `stable),(lfz05 = `stable)

update wa20:`long from `state0 where (fz20 = `under),(not lfz20 = `under)
update wa20:`short from `state0 where (fz20 = `over),(not lfz20 = `over)

update wa20:`close from `state0 where (fz20 = `stable),(lfz20 = `stable)

// Profit and loss calculation.

// Get the trades - for inspection to check plwa05
plwa05a: ungroup select p00, wa05 by folio0,dt0 from state0 where not null wa05

// Pair them up
plwa05: ungroup select ldt0:prev dt0, dt0, lp00: prev p00, p00, lwa05: prev wa05, wa05 by folio0 from plwa05a

// Drop the first pair: it will be the first leg of the first trade, so null in ldt0
delete from `plwa05 where null ldt0

// Drop the trades that start with a close, they're half the last trade and half of the next
delete from `plwa05 where lwa05 = `close

// long to short is close the long, open a short, so treat as a long close, because a short 
// is the next trade. It's all those cases where wa05 isn't the same lwa05.

update wa05:`close from `plwa05 where (wa05 <> lwa05)

// Only the long-long and the short-short to do.
// We have to take the long-long price and put it where the following long-close price is.
// assign an index to close (cidx) using the virtural row number, this leaves null for 
// long-long and short-short 
// Fill back, select just the long-long and short-short, first price and last date with a key to 
// left join to the main table.
// And then delete them to give just the closed trades table.

t0: 0!(select by folio0,dt0 from plwa05) lj 2!ungroup select cidx:i by folio0,dt0 from select by folio0,dt0 from plwa05 where wa05 = `close

t0:update cidx:reverse fills reverse cidx from t0

t0: 2!value select first folio0, ldt0:last dt0, first lp00 by cidx from t0 where (lwa05 = wa05)
plwa05: delete from (plwa05 lj t1) where (lwa05 = wa05)

t0:()
delete t0 from `.

// See how much I made.

select sum[lp00 - p00] from plwa05 where lwa05 = `short
select sum[p00 - lp00] from plwa05 where lwa05 = `long

\

data1x: `folio0`dt0 xasc data3
data1x: delete from data1x where folio0 in `KA`KB`KC
data1y: `folio0`dt0 xasc ungroup select p00, s05, fl01, fz05, fz20, fc05, fc20, fd05, fd20 by folio0,dt0 from data1x

select count i by folio0,fl01 from data1y where fl01 in  `short0`drop0

// Tidy up - keep the RSI in, the quantitative changes may help

delete u00, d00, u05, d05, y05, u20, d20, y20 from `data1 

// Easy view using data2

data1x: `folio0`dt0 xasc data1
data1x: delete from data1x where folio0 in `KA`KB`KC

select count i by folio0,in0,fz05 from data1
select count i by folio0,in0,fz20 from data1

\

/// Validation
// But only by eye.

show .t00.count @ data1

show select last p00 by folio0 from data1

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load data1.qdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:

