// weaves

// Using q/kdb+ for the db.

// Some cleaning and simplifying for R.

count data

c0: cols data

data1: update in0:"b"$(sample0 = `In_Sample) from data

select count i by folio0,sample0 from data

select count i by folio0,in0 from data1

delete sample0 from `data1

// Use some functions
.sys.qreloader enlist "jr-f.q"

// Change the x<N> to x<0N>

t: data1
c0: cols t

c0: pcols[c0;"x"]
c0: pcols[c0;"r"]

data1: c0 xcol t

// Add some day-to-day ratios
// Like these

select x01, ratios x01 from data1 where folio0 = `KF

t: data1

c12: ncols . (t; "d")
a0: c12[1;]!({ (ratios;x) } each c12[0;])

// By folio0

c:()
b:(enlist `folio0)!enlist `folio0
a:a0

t: ![t;c;b;a]

// Add some MACD

c12: ncols . (t; "m5")
a0: c12[1;]!({ ( { 5 mavg x };x) } each c12[0;])

c:()
b:(enlist `folio0)!enlist `folio0
a:a0

t: ![t;c;b;a]

data1: t


// Re-order the columns

data1: t

c0: cols t
c1: string c0 @ where { x like "*[rx]*" } string c0 

tcols: ([] n0:`$c1; t0:"I"${ -2 # x} each c1)

`t0 xasc `tcols

c1: (c0 except tcols.n0),tcols.n0

data1: c1 xcols t

///* Check I haven't broken anything.

show "checking: "

(count data) = (count data1)

// check: sum the columns.

t:data 

t0:meta t
c0: raze value flip select c from t0 where t = "f"

a0: c0!({ (sum;x) } each c0)

c:()
b:0b
a:a0

sdata: ?[t;c;b;a]
sdata: `fcst`r0`x1`x2`x3`x4`x5`x6`x7`x8`x9`x10`x11`x12`x13`x14`x15`x16`x17`x18`x19`x20`x21`x22`x23`x24 xcols sdata

sdata: flip sdata

// And again

t:data1

t0:meta t
c0: raze value flip select c from t0 where (t = "f"),(c like "[rxf]*")

a0: c0!({ (sum;x) } each c0)

c:()
b:0b
a:a0

sdata1: flip ?[t;c;b;a]

( value sdata1 ) ~ ( value sdata )

data1[;`folio0] ~ data[;`folio0]

data1[;`dt0] ~ data[;`dt0]

chk.data: 0!select count i by folio0, sample0 from data
chk.data1: 0!select count i by folio0, in0 from data1

delete sample0 from `chk.data
delete in0 from `chk.data1

`folio0`x xasc `chk.data
`folio0`x xasc `chk.data1

chk.data[;(`folio0;`x)] ~ chk.data1[;(`folio0;`x)] 

// Enough for now
// Write out to a CSV for R. 
// Do you remember when you could use q/kdb+ as a remote data table?

.sch.t2csv[`data1]

// And split them up.

{ nm:(string x),"0"; t0:select from data1 where folio0 = x; value nm,":t0"; .sch.t2csv[`$nm] } each distinct data1.folio0



\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load csvdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
