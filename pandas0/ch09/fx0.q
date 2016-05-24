// @file fx0.q
// @author weaves
// @brief 
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

if[not system "p"; system "p 5003"]

if[.sys.is_arg`verbose; show .sys.i.args]

.t.usage: { [m;v]
	   0N!m;
	   .sys.exit[v] }

if[(not .sys.is_arg`load);
   .t.usage["no -p port given for clients";1] ]

// @brief Produces the string to send to the remote host.
// 
// It uses sys_qreloader() if --rload was given, otherwise
// the command alone.

system "a"

.Q.view @ max date

tbls:system "a"

.fx.e: { () xkey select by tm0 from x where (not null bid0),(not null offer0) }
.fx.t: { t0:update offer1:offer1 % 1e6, bid1:bid1 % 1e6 from x;
	t0: delete from t0 where not type0 = "P";
	t0: delete date,dt0,type0 from t0;
	update mid0:((offer0*bid1) + (bid0*offer1)) % (bid1 + offer1) from t0 }

t0: { .fx.t .fx.e @ value x } each tbls
t1: first t0
while [ count t0 ; t1,: first t0:1 _ t0 ]

count t0

\

{ 0N!x; .fx.t .fx.e @ value x } each 1 _ tbls

t0:select by tm0 from aud0jpy where (not null bid0),(not null offer0)
update offer1:offer1 % 1000, bid1:bid1 % 1000 from `t0;
delete date from `t0;
update mid0:((offer0*bid1) + (bid0*offer1)) % (bid1 + offer1) from `t0;

// @}

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5003 -halt -verbose -load fx0"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
