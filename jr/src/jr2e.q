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
/// In this iteration, just do the same ft05.
/// I hope to add the opposite too.

x.cd: select ft05, dt0, dt1:(type data1[;`dt0])$dt0 + h05  from data1 where not null ft05

/// Empty template table, get column order
t0: 0#select folio0, ft05, dt0, dt1:dt0 from data1
x.cols: cols t0

/// Create a new table for each folio

t1s: { t1: x.cols xcols update folio0:x from x.cd } each x.folios

/// Insert to the empty one.
{ `t0 insert x } each t1s


/// Use lookup to find the prices
x.data1: select by folio0,dt0 from data1

t1:update lp00:x.data1[([]folio0;dt0);`p00], p00:x.data1[([]folio0;dt0:dt1);`p00] from t0

t1: update v00:p00-lp00

\

// A forward lookup

futdt0: raze value flip key select by dt0 from plwa05
curdt0: raze value flip key select by ldt0 from plwa05

futp00: 2!ungroup select dt0, p00 by folio0 from data1 where dt0 in futdt0
curp00: 2!ungroup select dt0, lp00:p00 by folio0 from data1 where dt0 in curdt0
