// @author weaves

// I always forget

// handle and name
Sub:(`int$())!`symbol$()

.u.sub: { show (.z.w;x); show (type x); Sub[.z.w]: x }

.u.pub: { [msj] who0:Sub[.z.w]; msj: (string who0), ": ", msj; show msj; 
         { (x)("0N!";y) } [;msj] each neg key Sub }

// Add the handlers
.z.po: { Sub[.z.w]:`unknown }
.z.pc: { (enlist x) _ Sub }

// More miscellaneous q notes

{} 0N! (til 4),\:/: til 4

{} 0N! cross[til 4; til 4]



/  Local Variables:
/  mode:q 
/  q-prog-args: "-p 4444 "
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
