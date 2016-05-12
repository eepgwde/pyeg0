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

.sys.qreloader enlist "jr-f.q"

/// Calculate total across all on each day
n0: count .sf.folios
p00: select sum p00 by dt0 from data0
p00: update p00:p00 % count .sf.folios from p00

data1: .m0.p00[data0; `KA; p00]

/// One folio removed - KF
// Change this every time
.sf.chg: first 1?.sf.folios 

n0: (count .sf.folios) - 1
p01: select sum p00 by dt0 from data0 where not(folio0 in enlist .sf.chg)

p01: update p00:p00 % n0 from p01

data1: .m0.p00[data1; `KB; p01]

/// Double one folio - uses pj plus-join and has to raze

n0: (count .sf.folios) + 1
p02: select sum p00 by dt0 from data0
p02: p02 pj select p00 by dt0 from data1 where folio0 = .sf.chg
p02: update p00: raze p00 by dt0 from p02

p02: update p00:p00 % n0 from p02

data1: .m0.p00[data1; `KC; p02]

// Update r00 for the synthetic aggregate portfolios

data1: .m0.r00[data1;`KA]
data1: .m0.r00[data1;`KB]
data1: .m0.r00[data1;`KC]

// Additional metrics - q/kdb+ only has simple moving averages built in.

data1: update r05: 5 mavg r00 by folio0 from data1
data1: update r20: 20 mavg r00 by folio0 from data1

data1: update s05: 5 mdev r00 by folio0 from data1
data1: update s20: 20 mdev r00 by folio0 from data1

// EWMA at 0.60 and 0.95 are comparable to the r05 and r20
// EWMA smooth well but lag less and don't alias like as MA.

x.lambda:0.60
data1: update e05:.f00.ewma1[r00;x.lambda] by folio0 from data1

x.lambda:0.95
data1: update e20:.f00.ewma1[r00;x.lambda] by folio0 from data1

// RSI

data1: update u00:{ $[0 < x; x; 0f] } each deltas p00  by folio0 from data1
data1: update d00:abs { $[0 > x; x; 0f] } each deltas p00  by folio0 from data1

data1: update u00:0f, d00:0f by folio0 from data1 where dt0 = 1

x.lambda: 0.60
data1: update u05:.f00.ewma1[u00;x.lambda] by folio0 from data1
data1: update d05:.f00.ewma1[d00;x.lambda] by folio0 from data1
data1: update y05:u05 % d05 from data1
data1: update z05:100 - 100 % 1 + y05 from data1

x.lambda:0.95
data1: update u20:.f00.ewma1[u00;x.lambda] by folio0 from data1
data1: update d20:.f00.ewma1[d00;x.lambda] by folio0 from data1
data1: update y20:u20 % d20 from data1

data1: update z20:100f - 100f % 1f + y20 from data1

data1: update fz05:`stable, fz20:`stable from data1

data1: update fz05:`over from data1 where z05 >= 70f
data1: update fz05:`under from data1 where z05 <= 20f

data1: update fz20:`over from data1 where z20 >= 70f
data1: update fz20:`under from data1 where z20 <= 20f

// Cardwell's trend indicators on RSI

data1: update fc05:`stable, fc20:`stable, fd05:`stable, fd20:`stable from data1

data1: update fc05:`bull from data1 where (z05 >= 40),(z05 <= 80)
data1: update fc20:`bull from data1 where (z20 >= 40),(z20 <= 80)

data1: update fd05:`bear from data1 where (z05 >= 20),(z05 <= 60)
data1: update fd20:`bear from data1 where (z20 >= 20),(z20 <= 60)

/// Calibration marks
// I want to make a GARCH estimation of volatility over last 20 days
// GARCH is very slow, so I'll re-calibrate when the RSI states change.
// I'll mark the dates by folio and add other calibration marks

.sf.marks: asc distinct data1.dt0
.sf.marks: .sf.marks where not "b"$.sf.marks mod 20
.sf.marks: (type data1[;`dt0])$.sf.marks

data1: update l20:1b by folio0 from (update l20:0b from data1) where dt0 in .sf.marks

/// Trading signals
/// State machines on signals.

.sf.tr0: `null0`short0`long0`hold0`drop0
.sf.tr1: `null1`short1`long1`hold1`drop1

data2: update ft01:`null0 from data1

// Using near/far: as under/over/stable fz05/fz20, bull/stable fc05/fc20, bear/stable fd05/fd20

// Safe is:
// if near over and was near stable, then if not far under and not far bull -> short

data3: update fl01:`short0 by folio0 from data2 where ((({last prev x};fz05) fby fz05) in enlist `stable),(fz20 <> `under),(fc20 <> `bull)
data1x: `folio0`dt0 xasc data3
data1x: delete from data1x where folio0 in `KA`KB`KC
data1y: `folio0`dt0 xasc ungroup select p00, fl01 by folio0,dt0 from data1x

select i from data1y where fl01 in enlist `short0

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

