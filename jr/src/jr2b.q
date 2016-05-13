// Additional metrics - q/kdb+ only has simple moving averages built in.

data1: update r05: 5 mavg r00 by folio0 from data1
data1: update r20: 20 mavg r00 by folio0 from data1
data1: update s05: 5 mdev r00 by folio0 from data1

data1: update s20: 20 mdev r00 by folio0 from data1

// EWMA at 0.60 and 0.95 are comparable to the r05 and r20
// EWMA smooth well but lag less and don't alias like as MA.

x.lambda:0.60
data1: update e05:.f00.ewma1[r00;x.lambda] by folio0 from data1

x.lambda:0.95
data1: update e20:.f00.ewma1[r00;x.lambda] by folio0 from data1

// RSI

data1: update u00:{ $[0 < x; x; 0f] } each deltas p00  by folio0 from data1
data1: update d00:abs { $[0 > x; x; 0f] } each deltas p00  by folio0 from data1

data1: update u00:0f, d00:0f by folio0 from data1 where dt0 = 1

x.lambda: 0.60
data1: update u05:.f00.ewma1[u00;x.lambda] by folio0 from data1
data1: update d05:.f00.ewma1[d00;x.lambda] by folio0 from data1
data1: update y05:u05 % d05 from data1
data1: update z05:100 - 100 % 1 + y05 from data1

x.lambda:0.95
data1: update u20:.f00.ewma1[u00;x.lambda] by folio0 from data1
data1: update d20:.f00.ewma1[d00;x.lambda] by folio0 from data1
data1: update y20:u20 % d20 from data1

data1: update z20:100f - 100f % 1f + y20 from data1

data1: update fz05:`stable, fz20:`stable from data1

data1: update fz05:`over from data1 where z05 >= 70f
data1: update fz05:`under from data1 where z05 <= 20f

data1: update fz20:`over from data1 where z20 >= 70f
data1: update fz20:`under from data1 where z20 <= 20f

// Cardwell's trend indicators on RSI

data1: update fc05:`stable, fc20:`stable, fd05:`stable, fd20:`stable from data1

data1: update fc05:`bull from data1 where (z05 >= 40),(z05 <= 80)
data1: update fc20:`bull from data1 where (z20 >= 40),(z20 <= 80)

data1: update fd05:`bear from data1 where (z05 >= 20),(z05 <= 60)
data1: update fd20:`bear from data1 where (z20 >= 20),(z20 <= 60)

/// Calibration marks
// I want to make a GARCH estimation of volatility over last 20 days
// GARCH is very slow, so I'll re-calibrate when the RSI states change.
// I'll mark the dates by folio and add other calibration marks

.sf.marks: asc distinct data1.dt0
.sf.marks: .sf.marks where not "b"$.sf.marks mod 20
.sf.marks: (type data1[;`dt0])$.sf.marks

data1: update l20:1b by folio0 from (update l20:0b from data1) where dt0 in .sf.marks
