// weaves
// @file geoip1.q

\l geoip.q

kipv4: select nm:first geonameid, cnm:first registeredcountrygeonameid by nw:network from ipv4

update nw1: { x0:"/" vs string x } each nw from `kipv4 ;

update msk0: { "H"$x[1] } each nw1 from `kipv4 ;

update nw2: { "H"$"." vs x[0] } each nw1 from `kipv4 ;

update nw3: { 0x0 sv "x" $ "I"$"." vs x[0] } each nw1 from `kipv4 ;

update nw4: { 0b vs x } each nw3 by nw3 from `kipv4 ;

// kipv4: update msk1: `boolean${ .sch.rebase0[x; 2] } each msk1 from

msks: update msk1: { `boolean$.sch.rebase0[x;2] } each floor 2 xexp 1 + 32 - msk0 from select msk1:0N by msk0 from kipv4
msks

mipv4: select msk1:{ (x[0]#1b),(x[1]#0b) } each flip (msk0;32-msk0) by msk0 from select msk1:0N by msk0 from kipv4

delete nw1, msk0, nw2 from `kipv4 ;

// Prepare for binary search
kipv4: `ip0 xasc `nw`nm`cnm`ip0`ip1 xcol kipv4

// Key the locations table
ken: `geonameid xkey value select by i from en

// Write out

save `:./kipv4
save `:./mipv4
save `:./ken

.sys.exit[0]

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load ../cache/csvdb help.q -verbose -halt -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
