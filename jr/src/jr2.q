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

.sf.tr0: `null0`short0`long0`hold0`drop0
.sf.tr1: `null1`short1`long1`hold1`drop1

data2: update ft01:`null0 from data1

// Using near/far: as under/over/stable fz05/fz20, bull/stable fc05/fc20, bear/stable fd05/fd20

// Safe is:
// if near over and was near stable, then if not far under and not far bull -> short
// if near stable or over or bull and was far stable or was far bull -> drop0

data3: update fl01:`short0 by folio0 from data2 where ((({last prev x};fz05) fby fz05) in enlist `stable),(fz20 <> `under),(fc20 <> `bull)

data3: update fl01:`drop0 by folio0 from data3 where ((({last prev x};fz20) fby fz20) in enlist `stable),((({last prev x};fc20) fby fc20) in enlist `bull),(fz05 in `stable`over),(fc05 = `bull)

data1x: `folio0`dt0 xasc data3
data1x: delete from data1x where folio0 in `KA`KB`KC
data1y: `folio0`dt0 xasc ungroup select p00, fl01 by folio0,dt0 from data1x

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

