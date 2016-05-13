/// \file   jr2e.q
/// \author Walter Eaves <weaves@localhost>
/// \date   Fri May 13 19:58:41 2016
/// \brief  Synthetic trades by holding time: part of jr.
///
/// Using the holding in data1 h05 find the profit or loss of the other portfolios
/// at the same times.

/// Have to use insert and do each folio0

x.folios: distinct data1[;`folio0]

/// Candidate actions
/// In this iteration, just do the same lwa05
/// I hope to add the opposite too.

x.cd: select lwa05, dt0:(type data1[;`dt0])$dt0 + h05, ldt0:dt0 from (`folio0`dt0 xasc 0!data1) where (not null lwa05),(not null h05)

x.cd1: select lwa05, dt0 + h05, ldt0:dt0 from data1 where (not null lwa05),(not null h05)

/// Empty template table, get column order
t0: 0#select folio0, lwa05, dt0, ldt0:dt0 from data1
x.cols: cols t0

/// Create a new table for each folio

t1s: { t1: x.cols xcols update folio0:x from x.cd } each x.folios

/// Insert to the empty one.
{ `t0 insert x } each t1s;

/// Use lookup to find the prices
x.data1: select by folio0,dt0 from data1

t1:update lp00:x.data1[([]folio0;dt0:ldt0);`p00], p00:x.data1[([]folio0;dt0);`p00] from t0

data2: data1 lj select by folio0,dt0 from .f00.pnl[t1]
update lwa05:`void from `data2 where null lwa05;

update fp05:pnl1, h05:ddt0 from `data2 where null fp05;

data2: ![data2;();0b;(cols data2) except (cols data1)]

data1: data2

\

// There are some unpriced trades. 

data3:x.data1
data4:select from data2 where null pnl1

bad0: (key select by folio0, dt0 from data4 where dt0 <> 1h)

// Not a problem with the source data.
data5: bad0 lj select by folio0,dt0 from data1

// missing from t1
bad0 lj select by folio0,dt0 from t1

// not in x.cd!
bad1: (distinct bad0[;`dt0]) 
bad1 in (distinct (`dt0 xasc  x.cd)[;`dt0])

select from x.cd where dt0 in bad1
select from x.cd1 where dt0 in "i"$bad1

/// Bad records
/// @todo
/// Unresolved

\

t1:t1s:()
delete t1, t1s from `.

