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

// More useful stuff

/ The evaluation mode is described as "left-of-right." Meaning apply the 
/ operator on the left to the result of the evaluation on the right.

// Attributes
/ unique sorted parted grouped
/ parted means unique clusters of the key
/ grouped means a separate index is kept

// Verb Duals
/ In q, a verb means a dyadic function: subject action object.
/ Some are like duals in that one is the inverse of the other.

// Dual: _ # are drop/cut and take respectively.

/ A negative number means from the end.
/ take has the feature that if the index is greater than the number of 
/ entries in the list, it will repeat the list.

// Dual: . @ as indexing 

/ verb-infix-------prefix
/ s:x  gets     :x idem
/ i+i  plus     +l flip
/ i-i  minus    -i neg
/ i*i  times    *l first
/ f%f  divide   %f reciprocal
/ a&a  and      &B where
/ a|a  or       |l reverse
/ a^a  fill     ^a null
/ a=a  equal    =l group
/ a<a  less     <l iasc     <s(hopen)
/ a>a  more     >l idesc    >i(hclose)
/ c$a  cast s$  $a string   h$a "C"$C `$C
/ l,l  cat      ,x enlist
/ i#l  take     #l count
/ i_l  drop     _a floor    sc(lower)
/ x~x  match    ~a not      ~s(hdelete)
/ l!l  xkey     !d key      !i (s;();S):!s
/ A?a  find     ?l distinct rand([n]?bxhijefcs)
/ x@i  at   s@  @x type          trap amend(:+-*%&|,)
/ x.l  dot  s.  .d value    .sCL trap dmend(:+-*%&|,)
/ A bin a;a in A;a within(a;a);sC like C;sC ss sC
/ {sqrt log exp sin cos tan asin acos atan}f
/ last sum prd min max avg wsum wavg xbar
/ exit getenv
/ 
/ dependency::expression (when not in function definition)


/ The basic factorial
/ Remember til is up to but not including so add one.
/ Drop the first two because 0 and 1 are destructive and 
/ redundant respectively.
/ Then use the dyadic over / with a verb 
/ You can use dyadic scan \ to see the intermediate results.

fact0: {(*/)2_til x+1 }
fact1: {(*\)2_til x+1 }


/ Similarly, you can do fibonacci

fibonacci: { {x,sum -2#x} / [x;0 1] }

0 1 1 2 3 5 8 13 21 34 55 89

// @}

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5003 -halt -verbose -load fx0"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
