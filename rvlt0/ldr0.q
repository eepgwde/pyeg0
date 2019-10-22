// weaves
// @file ldr0.q

// Using q/kdb+ for the db.

// Some inspection and correction and rekeying.

// -- Key against users

.sys.qloader enlist "csvdb"

// Make users a keyed table
users0: select by userid from users

// Clone transactions and cast the users key
trns: value select by i from transactions
update userid:`users0$userid from `trns

devs: value select by i from devices
update userid:`users0$userid from `devs

ntfs: value select by i from notifications
update userid:`users0$userid from `ntfs

// Quick check that the foreign key works

select count i by userid.ctry from trns

// and save these new keyed tables.

save `:./trns
save `:./users0
save `:./ntfs
save `:./devs

\

/  Local Variables: 
/  mode: q
/  q-prog-args: "-p 4445 -c 200 120 -C 2000 2000 -load csvdb help.q  -verbose -halt -quiet"
/  fill-column: 75
/  comment-column: 50
/  comment-start: "/  "
/  comment-end: ""
/  End:
