/// @author weaves
///
/// Validation and prototyping code for jr2.q

// More things you never knew you could do with q/kdb+

\l /opt/src/db/

t:([] name:(); iq:())
`t insert (`Dent;98)

// Example functions

// A factorial of all integers up to 8, or use prd

{ (*) over 1 + til x } each til 8

{ prd 1 + til x } each til 8

// First 10 fibonacci numbers.
// This uses "repeat": x f/y apply f to y x times.
10 {x,sum -2#x}/ 1 1

# From zero as a function
fibonacci:{x,sum -2#x}/[;0 1]

fibonacci 10

fibonacci1: { last fibonacci x } 

fibonacci1 10

// raised to the power a^b using scan, b must be integer
// normally use xexp
{[a;b] (*\) b#a }[3;10]

// For just the last use over
// note the default for integers is now long 
x0:{[a;b] (*/) b#a }[3;10]
type x0

type `long$3 xexp 10 

 // String formatting of numbers
 // cut by 3 and take account of negatives
 
x1:-100000.01

 s1:signum x1
 x1:abs x1

 x0:{ $[3 = count x; x,","; x] } each 3 cut reverse string x1
x3: reverse raze x0
x3: $[x3[0] = ","; 1_x3; x3]
 x3
 s1
 x3: $[0 > s1; "-";""],x3
 x3

// Using each prior

({(x;y)}':) 1 2 3 4

batch:{[rt;tn;recs] hsym[`$rt,"/",tn,"/"] upsert .Q.en[hsym `$rt;] recs}

dayrecs:{([] dt:x; ti:asc 100?24:00:00; sym:100?`ibm`aapl; qty:100*1+100?1000)}

appday:batch["./db";"t";]

appday dayrecs 2015.01.01

appday dayrecs 2015.01.02

appday dayrecs 2015.01.03

\l ./db
select from t
_

\


// directory, partition, field, table
.Q.dpft

// Quick factorial

fact0: { [n] 1*/1 + til n }

// Using a dictionary for memoize
// then this will delete key `a from a dict abc, enlist `a _ abc


memoize: { [d;l;r] d[l] :: }

// Initialize the memo table 
if[.sys.undef . `.memo`fact0; .memo.fact0: (`long$())!`long$() ]

fact1: { [n] $[null r:.memo.fact0[n]; { r:fact0[x]; .memo.fact0[x]::r; r }[n]; r] }

n: 3

fact1[n]

.memo.fact0

x:10; while[x-:1; fact1[x]]

.memo.fact0

\

select count i by folio0 from data1 where null wapnl05 
select count i by folio0 from data1 where null fp05

/// Joining in holding times and pnl lookup

.sys.qreloader enlist "jr-f.q"

t4: .f00.pnl[plwa05]

\

// A forward lookup - unused

futdt0: raze value flip key select by dt0 from plwa05
curdt0: raze value flip key select by ldt0 from plwa05

futp00: 2!ungroup select dt0, p00 by folio0 from data1 where dt0 in futdt0
curp00: 2!ungroup select dt0, lp00:p00 by folio0 from data1 where dt0 in curdt0

\

.t.t0: 0!data1
.sch.t2str[`.t.t0]

// Make file name in the first directory and save a copy to it.
.sch.mimefile[`data2;"qdb";first (.sys.qpath.list`)] set .t.t0 

// Assign a close number

t0: 0!(select by folio0,dt0 from plwa05) lj 2!ungroup select cidx:i by folio0,dt0 from select by folio0,dt0 from plwa05 where wa05 = `close

t0:update cidx:reverse fills reverse cidx from t0

t1: 2!value select first folio0, ldt0:last dt0, first lp00 by cidx from t0 where (lwa05 = wa05)
plwa05: delete from (plwa05 lj t1) where (lwa05 = wa05)

\

distinct state0[;`fl05]

select count i by folio0,fl05 from state0 where not null fl05

/// R gives two implementations, both can start at the initial value
// These are there impulse responses. x.lambda is 0.6
/  > library(fTrading)
/  > sprintf("%.5f", EWMA(xin, x.lambda, startup=1) )
/   [1] "1.00000" "0.40000" "0.16000" "0.06400" "0.02560" "0.01024" "0.00410"
/   [8] "0.00164" "0.00066" "0.00026" "0.00010" "0.00004" "0.00002" "0.00001"
/  [15] "0.00000" "0.00000" "0.00000" "0.00000" "0.00000" "0.00000" "0.00000"
/  > 

.sys.qreloader enlist "jr-f.q"

x.lambda: 0.60

in0:(1,20#0)
y0: .f00.ewma1[ in0 ; -1 + 2 % x.lambda ]
first where y0 <= 0.01
count y0
y0

in0:(1,20#0)
y0: .f00.ewma1[ in0 ; x.lambda ]
first where y0 <= 0.01
count y0
y0

in0:(1,20#1)
y0: .f00.ewma1[ in0 ; x.lambda ]
first where y0 <= 0.01
count y0
y0

\

## Checking market as a whole.

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


