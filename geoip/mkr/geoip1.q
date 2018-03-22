// weaves
// @file dfct1.q

kipv4: select nm:first geonameid, cnm:first registeredcountrygeonameid by nw:network from ipv4

update nw1: { x0:"/" vs string x } each nw from `kipv4 ;

update msk0: { "H"$x[1] } each nw1 from `kipv4 ;

update nw2: { "H"$"." vs x[0] } each nw1 from `kipv4 ;

update nw3: { 0x0 sv "x" $ "H"$"." vs x[0] } each nw1 from `kipv4 ;

update nw4: `boolean${ .sch.rebase0[x; 2] } each nw3 from `kipv4 ;

kipv4: update msk1: `boolean${ .sch.rebase0[x; 2] } each msk1 from update msk1: floor 2 xexp msk0 from select msk1:0N by msk0 from kipv4

\

// Write out

save `:./dfct1
save `:./dfct2

// Save the error workspace for reference.

`:./wsdfct set get `.dfct

// And load it again like this.
// `.dfct set get `:./csvdb/wsdfct

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
