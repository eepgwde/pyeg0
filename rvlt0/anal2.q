// weaves
// @file anal2.q

// Using q/kdb+ for the db.

// Engaged and unengaged users
//
// Use of as-of joins around a notification. How many transactions were subsequent to the notification?

// -- Using tables that have been keyed against users

// Load the tables
.sys.qloader enlist "csvdb"
// Load the time0 and date0 libraries
.sys.qloader enlist "time0.q"

`.users0 set get `:./wsusers0;

.csv.d0: (raze value "\\pwd"),"/../cache/out"
.csv.t2csv: .sch.t2csv2[;"csv";.csv.d0]

// Raise the HTTP server port to view tables
\p 4445

// User activity generally.

// Drop a couple of annoying fields and use a derivative name
delete city, nrefls, nsrefls from `users0;

// A transaction rate: transactions per day isn't quite right for banking.
// People usually have more than one transaction on any one day.
// So days with transactions is better. Then days between transactions is a good measure of activity.
// User account age is today's date and the date account created.
// and age user age in years.

.tmp.yr: `year$.z.D
update age0: .tmp.yr - yob from `users0;

update push1:-1.0e from `users0 where null push1;
update email1:-1.0e from `users0 where null email1;

update push1:`int$push1, email1:`int$email1 from `users0;

// This sequence implements an indicator feature
// It can be implemented functionally, but there aren't many.

t0: select lost0:1b by userid from ntfs where reason = `LOST_CARD_ORDER
users0: users0 lj t0
update lost0:0b from `users0 where null lost0;

t0: select nico0:1b by userid from ntfs where reason = `NO_INITIAL_CARD_ORDER
users0: users0 lj t0
update nico0:0b from `users0 where null nico0;

t0: select nicu0:1b by userid from ntfs where reason = `NO_INITIAL_CARD_USE
users0: users0 lj t0
update nicu0:0b from `users0 where null nicu0;

t0: select nifpco0:1b by userid from ntfs where reason = `NO_INITIAL_FREE_PROMOPAGE_CARD_ORDER
users0: users0 lj t0
update nifpco0:0b from `users0 where null nifpco0;

t0: select otau0:1b by userid from ntfs where reason = `ONBOARDING_TIPS_ACTIVATED_USERS
users0: users0 lj t0
update otau0:0b from `users0 where null otau0;

// Notification push fail
t0: select pf0:1b by userid from ntfs where status = `FAILED
users0: users0 lj t0
update pf0:0b from `users0 where null pf0;

// Various non-completed transations
// tcncl tdecl tfail tpend trvrt

t0: select tcncl:1b by userid from trns where tsstate = `CANCELLED
users0: users0 lj t0
update tcncl:0b from `users0 where null tcncl;

t0: select tdecl:1b by userid from trns where tsstate = `DECLINED
users0: users0 lj t0
update tdecl:0b from `users0 where null tdecl;

t0: select tfail:1b by userid from trns where tsstate = `FAILED
users0: users0 lj t0
update tfail:0b from `users0 where null tfail;

t0: select tpend:1b by userid from trns where tsstate = `PENDING
users0: users0 lj t0
update tpend:0b from `users0 where null tpend;

t0: select trvrt:1b by userid from trns where tsstate = `REVERTED
users0: users0 lj t0
update trvrt:0b from `users0 where null trvrt;

// direction
t0: select inb:1b by userid from trns where direction = `INBOUND
users0: users0 lj t0
update inb:0b from `users0 where null inb;

// and the phone type
// forget to key devs on userid, so shuffle the columns with a select 
users0: users0 lj 1!0!select by userid from devs

// average transaction value
// watch out some of the declined transactions are huge.

rh:{0.01*floor 0.5+x*100} 
t0: select v:sum usd, n:count i by userid from trns where tsstate = `COMPLETED
// t0: `v xdesc t0
t0: delete n from update v:rh @ v % n by userid from t0
users0: users0 lj t0
update v:0.0f from `users0 where null v ;

// Outcomes
// Initialize as false
update nactive:0b, inactive:0b, inactive1:0b from `users0;
// Set using results from anal1.q
update nactive:1b from `users0 where userid in .users0.neveractive ;
update inactive:1b from `users0 where userid in .users0.inactive ;
update inactive1:1b from `users0 where userid in .users0.inactive1 ;

users1: delete yob, dt0 from users0

// Some sanity checks
// DECLINED should be excluded.
t0: `v xdesc users1

// how many zero averages there are.
select max v, count i by nactive from users1

// Last bit of data preparation convert booleans to strings.
// We use this b2sym function - vector conditional.
.sch.b2sym: { ?[x;(count x)#`True;(count x)#`False] }
// remove the key for now.
t0: 0!users1
// find the boolean columns
.tmp.bs: "b" = value (meta users1)[;`t] 
// get their names - this is a bit complicated, one can use (cols users1) where .tmp.bs
.tmp.cs: raze value flip (key (meta users1)) where .tmp.bs
// then use a functional update method with global amend on all those columns.
{ a:(enlist x)!enlist (.sch.b2sym;x); t0:: ![t0;();0b;a] } each .tmp.cs ;
// and back to users1

users1: 1!t0

// Save our workspace parameters

`:./wsusers0 set get `.users0

// collate some tables to output

.csv.d0: (raze value "\\pwd"),"/../cache/out"
.csv.t2csv: .sch.t2csv2[;"csv";.csv.d0]

tbls: `users1

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