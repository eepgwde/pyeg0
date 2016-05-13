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

/// Safety info
.sf.folios: distinct data0.folio0

/// Functions used by all
.sys.qreloader enlist "jr-f.q"

/// Synthetics
.sys.qreloader enlist "jr2a.q"

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

/// Apply trading strategy.
/// This generates a state machine table: state0
/// @class state0
.sys.qreloader enlist "jr2c.q"

/// Calculate profits and losses on each trade.
/// This generates plwa05
/// @class plwa05
.sys.qreloader enlist "jr2d.q"


\

data1x: `folio0`dt0 xasc data3
data1x: delete from data1x where folio0 in `KA`KB`KC
data1y: `folio0`dt0 xasc ungroup select p00, s05, fl01, fz05, fz20, fc05, fc20, fd05, fd20 by folio0,dt0 from data1x

select count i by folio0,fl01 from data1y where fl01 in  `short0`drop0

/// Tidy up - keep the RSI in, the quantitative changes may help

delete u00, d00, u05, d05, y05, u20, d20, y20 from `data1 

/// Easy view using data2

data1x: `folio0`dt0 xasc data1
data1x: delete from data1x where folio0 in `KA`KB`KC

select count i by folio0,in0,fz05 from data1
select count i by folio0,in0,fz20 from data1

\

/// Validation
/// But only by eye.

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

