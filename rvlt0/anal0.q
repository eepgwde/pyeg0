// weaves
// @file ldr0.q

// Using q/kdb+ for the db.

// Some inspection and correction and rekeying.

// -- Key against users

.sys.qloader enlist "csvdb"

select count i by userid.ctry from trns

// Day of week

yrs: 1900.01.01 1901.01.01 1904.01.01 1999.01.01 2000.01.01 2100.01.01

dt0: 2001.01.01

.dtg.parts each yrs

{ .dtg.leap @ .dtg.parts[x][0] } each yrs



\

/  Local Variables: 
/  mode: q
/  q-prog-args: "-p 4445 -c 200 120 -C 2000 2000 -load csvdb help.q  -verbose -halt -quiet"
/  fill-column: 75
/  comment-column: 50
/  comment-start: "/  "
/  comment-end: ""
/  End:
