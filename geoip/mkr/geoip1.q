// weaves
// @file geoip1.q

\l geoip.q

// Key the locations table
ken: `geonameid xkey value select by i from en

// Add a null record with geonameid of 0i
// These are sym symbols, ie. -20h, so just use the blanks.
pdomain: first 0!1#ken

pdomain[`geonameid]: 0i
pdomain[`localecode]:  `C
pdomain[`continentcode]:  `
pdomain[`continentname]:  `
pdomain[`countryisocode]:  `
pdomain[`countryname]:  `
pdomain[`subdivision1isocode]: `
pdomain[`subdivision1name]:  `
pdomain[`subdivision2isocode]: `
pdomain[`subdivision2name]:  `
pdomain[`cityname]:  `
pdomain[`metrocode]:  " "
pdomain[`timezone]:  `
pdomain[`isineuropeanunion]:  0b

`ken upsert value pdomain

// Add the private networks to kipv4

// 10.0.0.0/8
// 172.16.0.0/12
// 192.168.0.0/16

// Convert the network from the sym -20h type

kipv4: select nm:first geonameid, cnm:first registeredcountrygeonameid by nw:`$string network from ipv4

`kipv4 upsert (`$"10.0.0.0/8";0i;0i)
`kipv4 upsert (`$"172.16.0.0/12";0i;0i)
`kipv4 upsert (`$"192.168.0.0/16";0i;0i)

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
