// @author weaves
// @file geoip.q
// Utility methods for geoip


\d .geoip

str2ip2int: { [s1s] .sch.str2ip2int each s1s }

str2lcns0: { [l0;tblnw;tbllcn] hs: ([] host0:l0; ip0:.geoip.str2ip2int @ l0);
	    idx: tblnw[;`ip0] bin hs[;`ip0];
	    idx1: tblnw[idx;`nm];
	    hs[;`geonameid]: idx1;
	    hs lj tbllcn }

\d .

.geoip.str2lcns: .geoip.str2lcns0[;kipv4;ken]

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load ../cache/csvdb help.q -verbose -halt -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
