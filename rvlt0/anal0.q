// weaves
// @file ldr0.q

// Using q/kdb+ for the db.

// Some inspection and correction and rekeying.

// -- Key against users

// Load the tables
.sys.qloader enlist "csvdb"
// Load the time0 and date0 libraries
.sys.qloader enlist "time0.q"

// Raise the HTTP server port to view tables
\p 4444

select count i by userid.ctry from trns

// Weekly signups by country
// Use the dt0 (createddate) from users0

// Update the users0 to have a week-number. Use the ISO-8601 standard (see README)

update woy:.date0.xparts[`date$dt0;4] from `users0;

// Useful, count of signups by country, year and week descended sort.
`n xdesc select n:count i by ctry,yy:`year$dt0,woy from users0

`n2 xdesc select avg n, sdev n, med n by ctry from select n:count i by ctry,woy from users0



\

/  Local Variables: 
/  mode: q
/  q-prog-args: "-p 4445 -c 200 120 -C 2000 2000 -load csvdb help.q  -verbose -halt -quiet"
/  fill-column: 75
/  comment-column: 50
/  comment-start: "/  "
/  comment-end: ""
/  End:
