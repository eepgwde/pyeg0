// weaves
// @file ldr0.q

// Using q/kdb+ for the db.

// Engaged and unengaged users
//
// Use of as-of joins around a notification. How many transactions were subsequent to the notification?

// -- Using tables that have been keyed against users

// Load the tables
.sys.qloader enlist "csvdb"
// Load the time0 and date0 libraries
.sys.qloader enlist "time0.q"

// Raise the HTTP server port to view tables
\p 4444

// User activity generally.

// Drop a couple of annoying fields and use a derivative name
delete uscrypt0, city, nrefls, nsrefls from `users0;

// A transaction rate: transactions per day.
// User account age is today's date and the date account created.

update acnd0:.z.D - (`date$dt0) from `users0;

// From transactions add the current number of transactions and the transaction rate 
t0: select trate: first n % userid.acnd0, nt: first n by userid from select n:count i by userid from trns
users0: users0 lj t0

// Some coalescing
users0[;`nt]:0^users0[;`nt]
users0[;`trate]:0.0f^users0[;`trate]

t0: `trate xasc users0

// Collect some things: inactive users: trate more or less zero, or nt == 0
// inactivity one transaction a year
.users0.trate0: 1.0 % 365.0
// store their type too.
.users0.inactive: `users0$exec userid from users0 where (nt = 0) or (trate < .users0.trate0)

// remove them from users0 and from trns
trns1: delete from trns where userid in .users0.inactive
users1: delete from users0 where userid in .users0.inactive

// and re-key trns1 to use users1
update userid:`users1$`int$userid from `trns1;

// The trate is small try a days-to-trans

update tdays:reciprocal trate from `users1;

// some bins

// 2 d.p and round up
rh:{0.01*floor 0.5+x*100} 
ri:{floor 0.5+x}

r0: { { "f"$x } each ri @ (min x; max x) } @ exec tdays from users1

b0: first deltas desc r0
b0: b0 % 52

select count i by b0 xbar tdays from users1

\

// collate some tables to output

tbls: `tnunsX0`tnunsX1`q1`q2a`q2b`q2c

{ 0N!x; .csv.t2csv @ x  } each tbls


\

/  Local Variables: 
/  mode: q
/  q-prog-args: "-p 4445 -c 200 120 -C 2000 2000 -load csvdb help.q  -verbose -halt -quiet"
/  fill-column: 75
/  comment-column: 50
/  comment-start: "/  "
/  comment-end: ""
/  End:
