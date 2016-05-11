/// @author weaves
///
/// Validation and prototyping code for jr2.q

/// You need the data for this section

// Copy by value
data2: select by i from data1
data2: .m0.r00[data2;`KA]

// Check

data1: update p00: p00 % count .sf.cols by dt0 from data1 where folio0 =`KA
data1: update r00: log ratios p00 by folio0 from data1 where folio0 = `KA
data1: update r00:0f from data1 where (folio0 = `KA),(dt0 = 1)

(raze value flip select[10] p00 from data2) ~ (raze value flip select[10] p00 from data1)
delete .cmp from `.x00
.sys.qreloader enlist "jr-f.q"

.t00.count @ .m0.p00[data0; `KB; p00]

.x00.cmp[p00;p01]
.x00.cmp[p00;p02]

.t00.count @ data1


/  Local Variables: 
/  mode:q 
/  q-prog-args: "-load help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:


