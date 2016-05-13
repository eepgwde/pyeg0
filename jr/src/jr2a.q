

/// Calculate total across all on each day
n0: count .sf.folios
p00: select sum p00 by dt0 from data0
p00: update p00:p00 % count .sf.folios from p00

data1: .m0.p00[data0; `KA; p00]

/// One folio removed - KF
// Change this every time
.sf.chg: first 1?.sf.folios 

n0: (count .sf.folios) - 1
p01: select sum p00 by dt0 from data0 where not(folio0 in enlist .sf.chg)

p01: update p00:p00 % n0 from p01

data1: .m0.p00[data1; `KB; p01]

/// Double one folio - uses pj plus-join and has to raze

n0: (count .sf.folios) + 1
p02: select sum p00 by dt0 from data0
p02: p02 pj select p00 by dt0 from data1 where folio0 = .sf.chg
p02: update p00: raze p00 by dt0 from p02

p02: update p00:p00 % n0 from p02

data1: .m0.p00[data1; `KC; p02]

// Update r00 for the synthetic aggregate portfolios

data1: .m0.r00[data1;`KA]
data1: .m0.r00[data1;`KB]
data1: .m0.r00[data1;`KC]

