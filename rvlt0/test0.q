// weaves
// @file test0.q
// Using q/kdb+ for the db.
// Testing the new date functions for day-of-week and week-of-year methods.

.sys.qloader enlist "csvdb"

.sys.qloader enlist "time0.q"

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
