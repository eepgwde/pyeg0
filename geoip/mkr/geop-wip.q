// weaves
// @file geoip1.q

\l geoip.q

.geoip.str2lcns: .geoip.str2lcns0[;kipv4;ken]

// Testing

host0: "193.62.22.98"
host1: "193.113.9.162"

l0: (host0;host1)

.geoip.str2lcns @ l0

host0: "10.0.0.1"
host1: "192.168.3.1"
host2: "172.16.2.1"

l0: (host0;host1;host2)

.geoip.str2lcns @ l0

\

"H"$"." vs host0

idx: kipv4[;`ip0] bin .sch.str2ip2int @ host0
idx1: kipv4[idx;`nm]

ken[idx1;]

// As lists

hs: ([] host0:l0; ip0:.geoip.str2ip2int @ l0)

idx: kipv4[;`ip0] bin hs[;`ip0]

idx1: kipv4[idx;`nm]

hs[;`geonameid]: idx1

hs lj ken

xs: ken ([] geonameid: idx1)

xs[;`host]: l0


// Only the en table is needed

gn0: exec distinct geonameid from ipv4

en0: exec distinct geonameid from en

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load ../cache/csvdb help.q -verbose -halt -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
