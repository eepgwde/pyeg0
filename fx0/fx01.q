// @author weaves
//
// @file fx01.q
// Sub-script for tbls.q

.Q.view 1#.t.ts

.t.tbls: .t.tbls0

show select max dt0, min dt0 from ftbl[ .t.tbls[0] ]
