/// @author weaves
///
/// Validation and prototyping code for jr2.q

// Copy by value
data2: select by i from data1
data2: .m0.r00[data2;`KA]

// Check

data1: update p00: p00 % count .sf.cols by dt0 from data1 where folio0 =`KA
data1: update r00: log ratios p00 by folio0 from data1 where folio0 = `KA
data1: update r00:0f from data1 where (folio0 = `KA),(dt0 = 1)

(raze value flip select[10] p00 from data2) ~ (raze value flip select[10] p00 from data1)


show .m0.p00[data0; `KB; p00]