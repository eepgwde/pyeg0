// weaves
// @file anal3.q

// Using q/kdb+ for the db.

// Engaged and unengaged users
//
// as-of transactions around notification REENGAGEMENT_ACTIVE_FUNDS
// we hope to show that the notification has triggered transactions after the
// date of the receipt of the notification

// -- Using tables that have been keyed against users

// Load the tables
.sys.qloader enlist "csvdb"

// This loads the parameters determined by anal1.q
`.users0 set get `:./wsusers0;

// Some CSV output methods.
.csv.d0: (raze value "\\pwd"),"/../cache/out"
.csv.t2csv: .sch.t2csv2[;"csv";.csv.d0]

// Raise the HTTP server port to view tables
\p 4444

// User activity generally.

// Drop a couple of zero-variance fields 
delete city, nrefls, nsrefls from `users0;

// Tag those users who have received the REENGAGEMENT_ACTIVE_FUNDS notification
// at least once. Ignore failed attempts.
// Filter the notifications table and add some derivative fields

ntfs1: delete from ntfs where not (reason = `REENGAGEMENT_ACTIVE_FUNDS)
delete from `ntfs1 where (status = `FAILED);
// derivatives
update dt1:`date$dt0, mm:`month$dt0 from `ntfs1;

.users0.ntfyXstart: min ntfs1[;`dt1]

// Use the new notifications table and tag the users.
users0: users0 lj select rafu:1b by userid from ntfs1
update rafu:0b from `users0 where null rafu;

// Interesting that over 11000 have received the notification.
select count i by rafu from users0

// Just check if there are multiple notifications
// Yes, quite a few. someone got 12.
select max x from select count i by userid from ntfs1
// check if they were on issued on specific dates
select count i by dt1 from ntfs1
select count i by mm from ntfs1
// so they've been sending over 2000 a month since 2018.08 and until 2019.02
// notifications sent throughout the month.
select distinct userid by `month$dt0 from ntfs 

// as-of join between transacations and notifications for just the flagged users.

// Notifications change points - date notification sent to user.
// Take the first timestamp on each day
ntfs2: `dt0 xasc select first dt0 by userid,dt1 from ntfs1
// move the date and userid to be the first two columns.
ntfs2: .sch.promote[`dt1`userid;0!ntfs2]

// For the transactions we introduce a rolling count of transaction days.
// First filter down the transactions remove DECLINED and others
trns1: delete from trns where tsstate <> `COMPLETED
// Make this a daily table, keep the first timestamp, store the number of
// transactions on the day, for checking.
trns1: select tcnt:1i, first dt0, nt:count i by userid, dt1:`date$dt0 from trns1
// make a running totatl of tcnt days (simple increment because it is 1)
// add a column to represent the delta of the dates, giving days between transaction-days.
update sums tcnt, ddt1:(1i,1_deltas dt1) by userid from `trns1 ;
// On each day, calculate some drate metrics: the number of days between transactions.
// drate over all days moves very slowly, so add a drate2 exponential weighted average.
// note this is across transaction days, not dates.
update drate:(sums ddt1) % tcnt by userid from `trns1;
update drate1:`float$.sch.ewma1[ddt1; 0.7f] by userid from `trns1;

// Organise the columns for as-of, sort and promote
trns1: `dt1`userid xasc 0!trns1
trns1: .sch.promote[`dt1`userid;trns1]

// Add a copy of the date column - the join overwrites columns with the same names.
// I'll add a row number for checking - nid.
update dt1n:dt1 from `ntfs2;
update nid:i from `ntfs2;
// rename the notification timestamp to avoid that being overwritten.
ntfs2: .sch.rename1[cols ntfs2;`dt0;`dt0n] xcol ntfs2
// Similarly for the transactions
update dt1t:dt1 from `trns1;
update tid:i from `trns1;
trns1: .sch.rename1[cols trns1;`dt0;`dt0t] xcol trns1

// The analogy is to last quote at time of trade
// Here notification is the trade and trns1 is the quote.
// Notification prior to the Transaction
// For the as-of we can delete all the transactions before the first notify, but I use them for
// the control group.
// delete from `trns1 where dt1 < .users0.ntfyXstart ;
npt: aj[`userid`dt1;trns1;ntfs2]

// delete all the unmatched and analyze the changes
npt1: delete from npt where or[(null tid);(null nid)]
// summary table of changes
tdrate1: `nid xasc select n:count i, first drate1, last drate1, first dt1n, first dt1t, last dt1t by userid,nid from npt1
// add a percentage change, negative is good, the days between transactions has reduced, the user is more active.
update rdrate1: (drate11 - drate1) % drate1 from `tdrate1 ;
// add a response days 
update ddt11: dt1t - dt1n from `tdrate1 ;

// A problem here is that some of the transactions are very much after the notification.
// I can filter these out 
.users0.ntfy0: 7

// Then we can simplify for a statistical test.
res0:0!select case0:`post.all, n:count i by signum rdrate1 from tdrate1

// apply a response days and do the same.
res0,:0!select case0:`post.near, n:count i by signum rdrate1 from tdrate1 where ddt11 <= .users0.ntfy0

// Notifications to which no response
// All the notification ids
n1s: ntfs2[;`nid]
insert[`res0;(0;`post.ntfy.all;count n1s)];
n1s1: exec nid from tdrate1
// no-response at all
.users0.ntfyXnoresponse0: n1s except n1s1
insert[`res0;(0;`post.ntfy.noresp.all;count .users0.ntfyXnoresponse0)];
// no-response within a window
n1s1: exec nid from tdrate1 where ddt11 <= .users0.ntfy0
// no-response
.users0.ntfyXnoresponse1: n1s except n1s1
insert[`res0;(0;`post.ntfy.noresp.near;count .users0.ntfyXnoresponse1)];

// Try for a control group.
//
// Take the users in tdrate1
u0s: exec distinct userid from tdrate1 where ddt11 <= .users0.ntfy0

// Get their activity the month before the notification.
// The date a month prior
d0: `date$-1 + `month$d1:min (0!tdrate1)[;`dt1n]
.users0.dt1s: asc (d0;d1)

t0:select from trns1 where (userid in u0s),(dt1  within .users0.dt1s)
tdrate2: select n:count i, first drate1, last drate1, first dt1, last dt1 by userid from t0
update dt1n: first .users0.dt1s from `tdrate2 ;

update rdrate2: (drate11 - drate1) % drate1 from `tdrate2 ;
// add a response days 

update ddt11: dt1 - dt1n from `tdrate2 ;

res0,:0!select case0:`pre.all, n:count i by rdrate1:signum rdrate2 from tdrate2
// apply a response days
res0,:0!select case0:`pre.near, n:count i by rdrate1:signum rdrate2 from tdrate2 where ddt11 <= .users0.ntfy0

// Get their activity three months before the notification.
// The date a month prior
d0: 10 + `date$-3 + `month$d1:min (0!tdrate1)[;`dt1n]
.users0.dt1s: asc (d0;d1)

t0:select from trns1 where (userid in u0s),(dt1  within .users0.dt1s)
tdrate2: select n:count i, first drate1, last drate1, first dt1, last dt1 by userid from t0
update dt1n: first .users0.dt1s from `tdrate2 ;

update rdrate2: (drate11 - drate1) % drate1 from `tdrate2 ;
// add a response days 

update ddt11: dt1 - dt1n from `tdrate2 ;

res0,:0!select case0:`pre.all.1, n:count i by rdrate1:signum rdrate2 from tdrate2
// apply a response days
res0,:0!select case0:`pre.near.1, n:count i by rdrate1:signum rdrate2 from tdrate2 where ddt11 <= .users0.ntfy0

// Some summary information
res0,:0!select case0:`users0.reengaged.notified, n:count i by rdrate1:`int$rafu from users0
insert[`res0;(0;`users0;count users0)];

// Save our workspace parameters
`:./wsusers0 set get `.users0
// collate some tables to output
tbls: `res0
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
