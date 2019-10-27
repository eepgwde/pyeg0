// weaves
// @file anal1.q

// Using q/kdb+ for the db.

// Engaged and unengaged users: frequency of use regression and classification
//
// Prepare user transaction activity to fit to a distribution and get some statistics: mean/median
// and standard deviation to justify a threshold for engaged/unengaged.
//
// I develop other metrics as well as the one I will fit to. The metric I will use is tdays0.
// I use q/kdb+ live to adjust the data-set from within Python anal1.ipynb.
// I then use the mean/media and std deviation to classify the users. I store their ids to a
// workspace for later use. I classify to 3 sets. never-active, inactive and inactive1.

// -- Using tables that have been keyed against users

// Load the tables
.sys.qloader enlist "csvdb"

// CSV output
.csv.d0: (raze value "\\pwd"),"/../cache/out"
.csv.t2csv: .sch.t2csv2[;"csv";.csv.d0]

// Raise the HTTP server port to view tables
\p 4444

// User activity generally.

// Drop a couple of zero-variance and/or irrelevant fields 
delete uscrypt0, city, nrefls, nsrefls from `users0;

// A transaction rate: transactions per day isn't quite right for banking.
// People usually have more than one transaction on any one day.
// So days with transactions is better - a transactions-day. Then days between transactions
// is a good measure of activity. It should be exponentially distributed for each account.
// And a sum of exponentials is a gamma.
//
// Add some other metrics: user account age is today's date and the date account created.
// and age user age in years.

.tmp.yr: `year$.z.D
update acnd0:.z.D - (`date$dt0), age0: .tmp.yr - yob from `users0;

// From transactions add the current number of transactions and the transaction rate

t0: select actv:1b by userid,`date$dt0 from trns
t0: select sum actv by userid from t0
users0: users0 lj t0

t0: select trate: first n % userid.acnd0, nt: first n by userid from select n:count i by userid from trns
users0: users0 lj t0

// Some coalescing
users0[;`actv]:0^users0[;`actv]
users0[;`nt]:0^users0[;`nt]
users0[;`trate]:0.0f^users0[;`trate]

// * Metric tdays0 is days between any two days that have any number of transactions.
// drate is a ratio of days active to days as customer.
// reciprocal is days between transactions.
update drate: actv % acnd0 from `users0 where 1 <= actv;
update tdays0: reciprocal drate from `users0;

// sort by drate and the never-active accounts are followed by the least active.
t0: `drate xasc users0

// Collect some things: inactive users: tdays0 > 365
// inactivity one transaction a year
.users0.tdays0: 365.0f
// store their type too.
.users0.neveractive: exec userid from users0 where (nt = 0)
.users0.inactive: exec userid from users0 where (nt > 0),(tdays0 > .users0.tdays0)

uneveractive: select from users0 where userid in .users0.neveractive
uinactive: select from users0 where userid in .users0.inactive

// write these to CSV and delete from workspace and heap just in case RAM is running short.
tbls: `uneveractive`uinactive
{ 0N!x; .csv.t2csv @ x  } each tbls
// the first is for the garbage collector, the second deletes from the workspace.
uneveractive:uinactive:()
delete uneveractive, uinactive from `.;

// remove two classes from users0 and from trns
trns1: delete from trns where userid in .users0.neveractive
users1: delete from users0 where userid in .users0.neveractive

// and re-key trns1 to use users1
update userid:`users1$`int$userid from `trns1;

// Deduce a probability distribution.

// rounding functions: 2 d.p and round up
rh:{0.01*floor 0.5+x*100} 
ri:{floor 0.5+x}
// Get the range of tdays0  - just for a sanity check
r0: { { "f"$x } each ri @ (min x; max x) } @ exec tdays0 from users1

// See if we can determine a distribution and find a mean and variance.
// This is the input file to the fils.
ttdays0: select count i by 1 xbar tdays0 from users1
ttdays0
count ttdays0
// And anal1.ipynb suggests a good distribution is the Wald. Not because it is the best fit, but
// because it has finite mean and variance. And it gives a sensible result 33 days. Call it 30.

.users0.tdays01: 30.0f // so 30 days to a year
.users0.inactive1: exec userid from users1 where tdays0 within (.users0.tdays01; .users0.tdays0)

users2: select by userid from users1
update dt0:`date$dt0 from `users2;
delete trate from `users2;

// notifications
ntfs0: `n xdesc select n:count i by reason from ntfs

// Seems to be a business process: every 30 days is some kind of threshold.
// sort by date and see what patterns there is over each month
ntfs: `dt0 xasc ntfs

ntfs1: select n: count i by mm:`month$dt0,userid.ctry,reason from ntfs

// Save our workspace parameters

`:./wsusers0 set get `.users0

// collate some tables to output

.csv.d0: (raze value "\\pwd"),"/../cache/out"
.csv.t2csv: .sch.t2csv2[;"csv";.csv.d0]

tbls: `ttdays0`users2`ntfs0`ntfs1

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
