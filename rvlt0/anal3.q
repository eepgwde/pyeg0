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

// For the transactions we introduce a rolling count of transaction days.
// First filter down the transactions remove DECLINED and others
trns1: delete from trns where tsstate <> `COMPLETED
// Make this a daily table

trns2: select tcnt:1i, first dt0, nt:count i by userid, dt1:`date$dt0 from trns1

update sums tcnt by userid from `trns2 ;

select sum tcnt by userid,dt0 from trns2 where userid = 0i

update tcnt:1i by dt0


\

// Save our workspace parameters
`:./wsusers0 set get `.users0
// collate some tables to output
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
