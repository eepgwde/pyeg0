// weaves
// @file ldr0.q

// Using q/kdb+ for the db.

// SQL queries have been prototyped in k-sql for q/kdb+
// The q/kdb+ platform supports a functional language called q. This will be used to
// calculate parameters.
//
// Tables in q/kdb+ are created in memory from disk. The update operation on a table only updates
// the memory copy of the table.
//
// k-sql uses:
//  the "by" operator for "group by"
//  the "fby" operator for "having"

// The q language is peculiar in that operation precedence is strictly
// right to left evaluated, so brackets might appear in atypical places.

// -- Using table that have been keyed against users

// Load the tables
.sys.qloader enlist "csvdb"
// Load the time0 and date0 libraries
.sys.qloader enlist "time0.q"

// Raise the HTTP server port to view tables
\p 4444

select count i by userid.ctry from trns

// Weekly signups by country
// Use the dt0 (createddate) from users0

// Update the users0 to have a week-number. Use the ISO-8601 standard (see README) - part 4 of the
// underlying date representation.

update woy:.date0.xparts[`date$dt0;4] from `users0;

// Useful count of signups by country, year and week descended sort.
`n xdesc select n:count i by ctry,yy:`year$dt0,woy from users0

// Question 1: signups over all weeks (over all years) average, standard deviation, median
// I've added the max and min and used the auto-labelling features.

q1:`n2 xdesc select avg n, sdev n, med n, max n, min n by ctry from select n:count i by ctry,woy from users0

// Question 2:

// Build a year's range from the mininum
// This uses q's functional programming. I get the max and min using table access rather than a
// query. Use yr0 to be the minimum. Then form a vector of the year + 1, the month and the day.
// convert to strings and convert to a date and form a tuple called yrs0.
yrs: { (min x; max x) } @ `date$trns[;`dt0]
yr0:yrs[0]
yr1: "D"$"." sv string each (1 + `year$yr0; `mm$yr0; `dd$yr0)
yrs0: (yr0;yr1)
// Similarly, build a range from the maximum.
yrs: { (min x; max x) } @ `date$trns[;`dt0]
yr1:yrs[1]
yr0: "D"$"." sv string each (-1 + `year$yr1; `mm$yr1; `dd$yr1)
yrs1: (yr0;yr1)


// Create a new analysis table with a filtration of the main transactions and then extend this.
// note: no need to create a view. I have checked that the direction is always OUTBOUND
trns1: select by tid from trns where (tstype = `CARD_PAYMENT),(tsstate = `COMPLETED)
// For age calculations we need today's year
// .z.D is a system variable of the q/kdb+ runtime environment.
.tmp.yr: `year$.z.D
// note: the apostrophe before the table name means is update in place.
// note: the use of the foreign key to refer to a field in the users0 table.
update age:.tmp.yr - userid.yob from `trns1;
// This is by year and month.
q2a:`mm xasc select ntrns:count i, sum usd by mm:`month$dt0,10 xbar age from trns1

// A calendar year from the date of the first transaction - ie. yrs0
q2b:`mm xasc select ntrns:count i, sum usd by mm:`month$dt0,10 xbar age from trns1 where (`date$dt0) within yrs0

// A calendar year from the date of the last transaction - ie. yrs1
q2c:`mm xasc select ntrns:count i, sum usd by mm:`month$dt0,10 xbar age from trns1 where (`date$dt0) within yrs1

// Question 3: 
// "Write a query to show the number of days where the average card payments
// volume of non-standard users is less than standard users."

// Check the types of plan available.

select count i by plan from users0
// Introduce a flag for STANDARD reset it globally and then set it for STANDARD users.
// And update the users0 table
update isstd:0b from `users0;
update isstd:1b from `users0 where plan = `STANDARD;

// A percentage is useful. It's easy to get the sum of users, it's a keyed table so a
// unique count. We use a temporary table t0 for a ratio.
.tmp.nusers: count users0
t0:select count i, r0: 100 * (count i) % .tmp.nusers by isstd from users0
s2ns: last ratios asc value t0[;`x]

// The process here is to get all the dates on which there are any transactions
// Calculate the metrics for the standard users, then for the non-standard.
// Join each of those to the dates table - taking care to rename the columns.
// I've also added the number of distinct users for both classes.

// snagging below suggests we should round to avoid floating point arithmetic quirks.
// Round the input values and not the final sum - the errors will already have propagated.
// Some rounding functions: rh is 2 decimal places, ri is round to integer where I introduce a cast.
// rx is a pointer to a function
rh:{0.01*floor 0.5+x*100}
ri:{`int$floor 0.5+x}
rx: ri

// When we invoke rounding, the right to left evaluation of "sum rx @ usd" can be interpreted
// like this.
// apply rounding function rx to each and ever element of usd
// sum all the elements resulting from the above.
// And the operator @ means that f @ x is equivalent to f[x]

x0:select n: count i, v0: sum rx @ usd, nu: count distinct userid by `date$dt0 from trns1

x1: select ns: count i, v0s: sum rx @ usd, nus: count distinct userid by `date$dt0 from trns1 where userid.isstd
x2: select nns: count i, v0ns: sum rx @ usd, nuns: count distinct userid by `date$dt0 from trns1 where not userid.isstd

// Use a sequence of complete left joins.
tnuns: (x0 lj x1) lj x2

// From the sanity checks, I can see that nulls needs to be replaced. The coalesce operator is ^
// I will unkey the table and apply coalesce for each type. This can be done by hand, but this is
// a programmatic way.
// This is the unkeying.
tnuns0: 0!tnuns

// The type data for the table is a dictionary generated by the the meta command.
// It will be used programmatically.
.tmp.typ0: meta tnuns0
// This function to return the correctly typed 0 for the column's underlying data type is zerof
// The parameter is sc0, which means, the symbol for the column
zerof: { [sc0] .tmp.typ0[sc0][`t]$0 }

// Get the column names except the date dt0
cs: (cols tnuns0) except `dt0

// Apply a lambda function that will assign the coalesced column back to the table.
// we get the zero value for the column using the function. We operate on the table in
// caller'sr scope by using the :: operator.
{ [x0] tnuns0[;x0]::zerof[x0]^tnuns0[;x0] } each cs

// And we can re-key the table and run through to the sanity checks.
tnuns: 1!tnuns0

// Sanity checks
// we expect the n = ns + nns, v0 = v0s + v0ns - the nu, nus and nuns are sub-additive

// add the number of standard users to the number of non-standard and then compare if
// equal to the total, similarly for the value (or the volume if preferred.)
.t.x0: ungroup select n:n = (ns + nns), v:v0 = (v0s + v0ns) by dt0 from tnuns
.t.x0

// These can use an assert if needed.
count select from .t.x0 where not n
count select from .t.x0 where not v

// We apply the scalar s2ns and use it to produce nns1 and v1ns in the
// table. These are scale-adjusted values, based on an assumption: were the
// number of non-standard users the same as the the number of standard
// users, what would the volume of their transactions be?
update nns1: s2ns * nns, v1ns: s2ns * v0ns from `tnuns;
// And store to a table.
tnunsX0: select ns, nns1, v0s, v1ns from tnuns where v1ns < v0s
0N!("all-days: ", string count tnunsX0);

// If we ignore days where there were no non-standard transactions
tnunsX1: select from tnuns where (nns > 0),v1ns < v0s
0N!("all-ns-active-days: ", string count tnunsX1);

// Most of them fall in 2018.01

// Put some results on CSV for some charting.
.csv.d0: (raze value "\\pwd"),"/../cache/out"
.csv.t2csv: .sch.t2csv2[;"csv";.csv.d0]

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
