/// @author weaves
///
/// Validation and prototyping code for jr2.q

// EWMA
n0:20
lambda: 1 % 3

x0:1, (n0 # 0)
count x0

/// This is the startup is one version.
x1:enlist x0[0]
x2:enlist (lambda*x0[1] + (1 - lambda)*x1[0] )
x3:enlist (lambda*x0[2] + (1 - lambda)*x2[0] )

raze (x1;x2;x3)

/// Exponentially weighted moving average
/// Always some debate about this. This is the starting value is one version.
/// 1 st value to have percentage % is where lambda = 2 / (N + 1)

{ lambda*y + (1-lambda)*x } scan x0

.sys.qreloader enlist "jr-f.q"

in0:(1,20#0)
y0: .f00.ewma1[ in0 ; 1 - 0.60 ]
first where y0 <= 0.01
count y0
y0

in0:(1,20#0)
y0: .f00.ewma1[ in0 ; 2.333 ]
first where y0 <= 0.01
count y0
y0


\

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


