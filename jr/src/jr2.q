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
.sf.cols: cols data0
.sf.cols: distinct data0.folio0

/// Calculate total across all
p00: select sum p00 by dt0 from data0
p01: raze value flip value p00

// Add a blank dataset KA for a total.
t1: select by dt0,folio0 from data0 where folio0 = `KF
t1: update folio0:`KA, p00:0n from t1

// Back to a dictionary and replace the sum values, flip back to a table and append
t2: flip 0!t1
t2[`p00]: p01
t3: flip t2

// Append tables and set the price to the average and generate r00
data1: (0!select by dt0, folio0 from data0),(0!t3)
data1: update p00: p00 % count .sf.cols by dt0 from data1 where folio0 =`KA
data1: update r00: log ratios p00 by folio0 from data1 where folio0 = `KA
data1: update r00:0f from data1 where (folio0 = `KA),(dt0 = 1)

// Additional metrics

data1: update r05: 5 mavg r00 by folio0 from data1

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

