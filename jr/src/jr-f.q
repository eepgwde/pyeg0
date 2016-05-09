// weaves
// Functions

ncols: { [tbl;prefx]
	c1: (cols t) where { x like "[rx]??"  } each string cols t;
	c2: { `$y, x }[;prefx] each string c1;
	(c1; c2) }

pcols: { [c0;prefx]
	idx: where { (x like y,"*" )}[;prefx] string c0;
	c1: { (1 _ x) } each string c0 @ idx;
	c1: .sch.overlay[;3; "0"] each c1;
	c1: `${ y,(1 _ x) }[;prefx] each c1;
	c0[idx]: c1;
	c0 }
