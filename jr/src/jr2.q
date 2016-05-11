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
.sf.cols: distinct data0.folio0

.sys.qreloader enlist "jr-f.q"

/// Calculate total across all on each day
n0: count .sf.cols
p00: select sum p00 by dt0 from data0
p00: update p00:p00 % count .sf.cols from p00

data1: .m0.p00[data0; `KA; p00]

/// Missing one folio

n0: (count .sf.cols) - 1
p01: select sum p00 by dt0 from data0 where not(folio0 in enlist `KF)

p01: update p00:p00 % n0 from p01

data1: .m0.p00[data1; `KB; p01]

/// Double one folio - uses pj plus-join and has to raze

n0: (count .sf.cols) + 1
p02: select sum p00 by dt0 from data0
p02: p02 pj select p00 by dt0 from data1 where folio0 = `KF
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

/// Validation
// But only by eye.

show .t00.count @ data1

show select last p00 by folio0 from data1

\

// EWMA



\

t0: select from data0 where in0

// Try a market as a whole metric

t0: data0

select count i by folio0, in0 from data1

// copy off one column
t1: select by dt0,folio0 from data0 where folio0 = `KF
t1: update folio0:`KA, p00:0n from t1

t2: (0!select by dt0, folio0 from data0),(0!t1)

t1: select by dt0,folio0 from data0 where folio0 = `KA

t0: select by dt0 from data0


\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load data1.qdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:

