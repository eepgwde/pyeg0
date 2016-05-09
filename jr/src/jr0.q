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

first (.sys.qpath.list`)

// Make file name in the first directory and save a copy to it.
.sch.mimefile[`data1;"qdb";first (.sys.qpath.list`)] set data1

// drop from namespace and reload
delete data1 from `.

.sys.qreloader enlist "data1.qdb"

count data1

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

// Run data-checks if required, but as noted there. These metrics are all MAs.
// .sys.qreloader enlist "jr1.q"

// Enough for now
// Write out to a CSV for R. 
// [Ed: Do you remember when you could use q/kdb+ as a remote data table?]

.sch.t2csv[`data1]

// And split them up, I must use a global here, so put it into a temporary workspace 
// Note the trick with value in this function. Never found a better way.

.t.t0:()

{ nm:(string x),"0"; .t.t0:select from data1 where folio0 = x; value nm,":.t.t0"; .sch.t2csv[`$nm] } each distinct data1.folio0

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load csvdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
