// @author weaves
//
// @file fx01.q
// Sub-script for tbls.q uses .t.tbl to pass

.Q.view 1#.t.ts

.t.tbls: .t.tbls0

show select max dt0, min dt0 from ftbl[ .t.tbls[0] ]

// Concatenate a set of tables together.
// This is a list way of doing this using raze.

.t.tbl: raze ftbl each .t.tbls
 



