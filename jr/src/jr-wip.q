/// @author weaves
///
/// Validation and prototyping code for jr2.q

/// R gives two implementations, both can start at the initial value
// These are there impulse responses.
/  > sprintf("%.5f", ewma(xin,x.lambda))
/   [1] "1.00000" "0.40000" "0.16000" "0.06400" "0.02560" "0.01024" "0.00410"
/   [8] "0.00164" "0.00066" "0.00026" "0.00010" "0.00004" "0.00002" "0.00001"
/  [15] "0.00000" "0.00000" "0.00000" "0.00000" "0.00000" "0.00000" "0.00000"
/  > library(fTrading)
/  > sprintf("%.5f", EWMA(xin, x.lambda, startup=1) )
/   [1] "1.00000" "0.40000" "0.16000" "0.06400" "0.02560" "0.01024" "0.00410"
/   [8] "0.00164" "0.00066" "0.00026" "0.00010" "0.00004" "0.00002" "0.00001"
/  [15] "0.00000" "0.00000" "0.00000" "0.00000" "0.00000" "0.00000" "0.00000"
/  > 

.sys.qreloader enlist "jr-f.q"

x.lambda: 0.60
in0:(1,20#0)
y0: .f00.ewma1[ in0 ; x.lambda ]
first where y0 <= 0.01
count y0
y0

in0:(1,20#0)
y0: .f00.ewma1[ in0 ; -1 + 2 % x.lambda ]
first where y0 <= 0.01
count y0
y0

in0:(1,20#1)
y0: .f00.ewma1[ in0 ; x.lambda ]
first where y0 <= 0.01
count y0
y0

\

f0: { [n;p;a] n*a + (1 - a)*p }

l0: { [x;y;z] show type x; enlist(x,y) }[;;x.lambda] scan 1 + til 9

{ x0:$[0 > type x; x; 1 _ x[0]]; x0:raze x0  } each l0

fact: { [n] $[1 = n; 1; n*fact[n-1]] }
fact[3]

\

{ [x;y;z] idx:$[0 > type x; 1; (1 _ x[0]) + 1];
 ; idx) } [;;x.lambda] scan in0


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


