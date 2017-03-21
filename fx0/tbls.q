// @file commander.q
// @author weaves
// @brief Loadable file invokes a function on a named host and port
//
// commander can be invoked with
// @code
// Qp commander.q -rhost ubu -rport 14901 -hsym :ubu:14901 -cmd .sys.exit 0
// @endcode
// It will invoke sys_exit() on the host on a machine called ubu at port 14901.

// @addtogroup commanders Managers
// The commander.q script. This can be used to 
// send a single command to named host on port with -cmd
// Instructs a remote load of a script with -rload.
// It can be passed -rhost, -port or -hsym :host:port to specify the host.
// It supports the switch -async to send the command asynchronously.

// @{


.sys.exit: {[x] 2 "fail"; if[not .sys.is_arg`halt; exit x]; :: }

if[.sys.is_arg`verbose; show .sys.i.args]

.t.usage: { [m;v] 2 m; .sys.exit[v] }

.sys.assert: { [x] if[ -1h <> type x; .sys.exit 3]; if[not x; .sys.exit 2]; :: }

\c 200 200

.t.tbls: tables `.

.sys.assert 0 < count .t.tbls
  
.t.tbls: string each .t.tbls

.sys.assert 0 < count .t.tbls

.sys.assert 0 < sum .t.tbls like "???0???"

.t.tbls: .t.tbls where .t.tbls like "???0???" 

.t.tbls0: .t.tbls / a backup


// Filtering the table.

// Each day may have records time-stamped from the previous.
// And we remove dull days ie. next to no records.
// @param x table name (string)
// @param y number of records required (int)
ftbl0: { [x;y] t: select from (value x) where dt0 = (max;dt0) fby date;
	$[y < count t; t; 0#t] }

ftbl: ftbl0[;1]

/
Iterate over the days

I'll use a script because it's easier to edit.
\

.Q.view[]
.t.ts: date

.t.tbl0: ()

while[ 0 < count .t.ts;
      .Q.view[];
      value "\\l fx01.q";
      .t.tbl0: $[0 < count .t.tbl0; .t.tbl0,.t.tbl; .t.tbl] ;
      .t.ts: .t.ts except date ]

.Q.view[]

show select max dt0, min dt0 from .t.tbl0

.t.tbl: .t.tbl0
.t.tbl0: ()

2 ":" sv ("t.tbl"; string count .t.tbl; string "\n");

show select count i by dt0,sym0 from .t.tbl


\

fx0:value select by i from .t.tbl

asc select n:count i by sym0,dt0 from .t.tbl

\


if[(not .sys.is_arg`cmd) and (not .sys.is_arg`rload);
   .t.usage["no -cmd or -rload given";1] ]


// @brief Produces the string to send to the remote host.
// 
// It uses sys_qreloader() if --rload was given, otherwise
// the command alone.
.t.cmd: $[.sys.is_arg`rload;
	  (".sys.qreloader"; "enlist"; .Q.s1 first .sys.arg`rload);
	  .sys.arg`cmd ]

// @brief Verifies a host and port were given or an hsym argument.
.t.host: $[not .sys.is_arg`hsym;
	   [ if[not .sys.is_arg`rhost; .t.usage["no -rhost given";1] ];
	    if[not .sys.is_arg`rport; .t.usage["no -rport given";1] ];
	    hsym `$(":", ":" sv (first .sys.arg`rhost;first .sys.arg`rport)) ];
	   `$(first .sys.arg`hsym) ]

if[.sys.is_arg`verbose; show .t.host]

.t.cmd: " " sv .t.cmd

if[.sys.is_arg`verbose; show .t.cmd]

.t.h: @[hopen;.t.host;`failed]

if[-11h = type .t.h; .t.usage[(": " sv ("server not open";string .t.host)); 2] ]

.t.h: $[.sys.is_arg`async; neg .t.h; .t.h]
 
.t.status: @[.t.h;.t.cmd; `$"incomplete call"]

if[not .sys.is_arg`verbose; .t.status]

.t.status

.sys.exit 0

// @}

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-halt -verbose -load /opt/src/db"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:

