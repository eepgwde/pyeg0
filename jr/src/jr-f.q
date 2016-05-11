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
	  t1: update p00: p00 % count .sf.cols by dt0 from t1 where folio0 = f0;
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


