/// weaves

/// Demonsrating rserve.q and using the Rserver

wde.rs.j1: `:192.168.145.145:6311

/ -------------------------
/ dict of all types:
t:`$'"bgxhijefcspmdznuvt" ,' string (til 20) except 0 3
a:"p"$1234567890123456j*2 3 0N 0w -0w 5
d:t!(
 011101b;
 6?0Ng;
 "x"$"abcdef";
 2 3 0N 0w -0w 5h;
 20 30 0N 0W -0W 50i;
 (0N 0w -0wj,1 2 3 * 123456789123j)3 4 0 1 2 5;
 2.2 3.34 0N 0w -0w 5.567e;
 2.2 0.076923 0n 0w -0w 3.14159;
 "ab cef";
 `aapl`goog``ibm`msft`orcl;
 a;
 "m"$a;
 "d"$a;
 "Z"$(23&count each z)#'z:string each a;
 (24D*1 1 0 0 0 1)+"n"$a;
 "u"$a;
 "v"$a;
 "t"$a)

/ -------------------------
/ demos (change Ropen argument as required)
.rs.Ropen0 wde.rs.j1
.rs.Rclose wde.rs.j1

@[.rs.Ropen0;getenv `QRSRV;(`errRserve;)]

.rs.Ropen `

.rs.Rcmd "a=0.123*2:7"

.rs.Rget "a"
.rs.Rset["abc";2 3 7i]
.rs.Rget "abc"
{ .rs.Rset["a";x]; .rs.Rget"a" } each value d

.rs.Rclose `

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load rserve.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:

