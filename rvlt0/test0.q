// weaves
// @file test0.q
// Using q/kdb+ for the db.
// Testing the new date functions for day-of-week and week-of-year methods.

.sys.qloader enlist "csvdb"

.sys.qloader enlist "time0.q"

show t:([] ti:10:01:01 10:01:03 10:01:04;sym:`msft`ibm`ge;qty:100 200 150)
show q:([] ti:10:01:00 10:01:01 10:01:01 10:01:02;sym:`ibm`msft`msft`ibm;px:100 99 101 98)

aj[`sym`ti;t;q]

show t:([]sym:3#`aapl;time:09:30:01 09:30:04 09:30:08;price:100 103 101)

show q:([] sym:8#`aapl; time:09:30:01+(til 5),7 8 9; ask:101 103 103 104 104 103 102 100; bid:98 99 102 103 103 100 100 99)

w:-2 1+\:t `time
c:`sym`time

// wj[w;c;t;(q;(f0;c0);(f1;c1))]

wj[w;c;t;(q;(::;`ask);(::;`bid))]


// -- Keyed against users
select count i by userid.ctry from trns

yrs: 1900.01.01 1901.01.01 1904.01.01 1999.01.01 2000.01.01 2100.01.01

dt0: 2001.01.01

.date0.parts each yrs

.date0.leap each yrs

dt0: 2000.01.01T08:11:23.4560
dt0

raze ( .date0.parts @ `date$dt0 ; .time0.parts @ `time$dt0 )

dt1: .datetime0.parts @ dt0

x0: .date0.strftime[dt1;0;"%x - %I:%M%p %V %u"]
x0

.date0.strftime[dt1;0;"%u"]

select dow: { .date0.xparts[x;0] } each `date$dt0 from users0

.t.ty: 2
n0:distinct raze value exec woy: { .date0.xparts[x;.t.ty] } each `date$dt0 from users0
{ (min x; max x) } @ n0

.t.ty: 3
n0:distinct raze value exec woy: { .date0.xparts[x;.t.ty] } each `date$dt0 from users0
{ (min x; max x) } @ n0

.t.ty: 4
n0:distinct raze value exec woy: { .date0.xparts[x;.t.ty] } each `date$dt0 from users0
{ (min x; max x) } @ n0

.t.ty: 5
n0:distinct raze value exec woy: { .date0.xparts[x;.t.ty] } each `date$dt0 from users0
{ (min x; max x) } @ n0

select dow:.date0.xparts[`date$dt0;0] from users0

n0:distinct raze value exec woy:.date0.xparts[`date$dt0;4] from users0
{ (min x; max x) } @ n0

\

/  Local Variables: 
/  mode: q
/  q-prog-args: "-p 4445 -c 200 120 -C 2000 2000 -load csvdb help.q  -verbose -halt -quiet"
/  fill-column: 75
/  comment-column: 50
/  comment-start: "/  "
/  comment-end: ""
/  End:
