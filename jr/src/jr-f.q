// weaves
// Functions

/// Column re-namer, adds a prefix, returns indices and new names.
ncols: { [tbl;prefx]
	c1: (cols t) where { x like "[rx]??"  } each string cols t;
	c2: { `$y, x }[;prefx] each string c1;
	(c1; c2) }

/// Column re-namer pads with zeroes.
pcols: { [c0;prefx]
	idx: where { (x like y,"*" )}[;prefx] string c0;
	c1: { (1 _ x) } each string c0 @ idx;
	c1: .sch.overlay[;3; "0"] each c1;
	c1: `${ y,(1 _ x) }[;prefx] each c1;
	c0[idx]: c1;
	c0 }


/// Calculate the day returns on the p00 column for given folio in given table 
.m0.r00: { [t1; f0] 
	  t1: update r00: log ratios p00 by folio0 from t1 where folio0 = f0;
	  t1: update r00:0f from t1 where (folio0 = f0),(dt0 = 1)	}

/// Return an extended table that is the given table with a price column 
/// added column set to the give price list.
///
/// p00: select sum p00 by dt0 from data0

.m0.p00: { [t0; f0; p0]
	  p1: raze value flip value p0;
	  // Arbitrarily use KF
	  t1: select by dt0,folio0 from t0 where folio0 = `KF;
	  t1: update folio0:f0, p00:0n from t1;
	  
	  // Back to a dictionary and replace the sum values
	  // flip back to a table and append
	  t2: flip 0!t1;
	  t2[`p00]: p1;
	  t3: flip t2;
	  
	  // Append tables and set the price to the average and generate r00;
	  (0!select by dt0, folio0 from t0),(0!t3) }


/// A comparor for keyed columns
.x00.cmp: {[x;y] 
	   x0: enlist 1b;
	   x0,: (count x) = (count y);
	   x0,:(raze value flip value x) ~ (raze value flip value y);
	   1 _ x0 }

.t00.count: { select count i by folio0, in0 from x }

/// Exponentially weighted moving average
/// Always some debate about this. This is the "starting value is one" version.
/// @note
/// In the use of scan, x is the prior and y the current. I've renamed them to make it
/// look like the Wikipedia, they call lambda alpha
/// @note
/// This doesn't work.

.f00.ewma1: { [s0; lambda] 
	     lambda: $[lambda >= 1; 2 % lambda + 1; lambda];
	     { [now0;past0;z] z*now0 + (1 - z)*past0 }[;;lambda] scan s0 }

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-load help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
