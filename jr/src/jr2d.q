/// \file   jr2d.q
/// \author Walter Eaves <weaves@localhost>
/// \date   Fri May 13 13:53:43 2016
/// \brief  Profit and Loss: part of jr.
///
/// Profit and loss calculation.
///
/// First we pair up the trades. 

/// Get the trades - for inspection to check plwa05
/// The null is the first for each folio.
plwa05a: ungroup select p00, wa05 by folio0,dt0 from state0 where not null wa05

/// Pair them up
/// @class plwa05
/// @brief Contains the paired-up trades.
/// This table contains the time, the price, and the Wilder trading signals and their lagged counter-parts
/// to form pairs.
/// @todo
/// This needs thorough re-checking. It has to be correct.
plwa05: ungroup select ldt0:prev dt0, dt0, lp00: prev p00, p00, lwa05: prev wa05, wa05 by folio0 from plwa05a

/// Drop the first pair: it will be the first leg of the first trade, so null in ldt0
/// This is the best table for checking the later logic, I'll snapshot it.
delete from `plwa05 where null ldt0
plwa05b: plwa05

/// Drop the trades that start with a close, they're half the last trade and half of the next
delete from `plwa05 where lwa05 = `close

/// long to short is close the long, open a short, so treat as a long close, because a short 
/// is the next trade. 
/// @note
/// It's now only those cases where wa05 isn't the same lwa05.

update wa05:`close from `plwa05 where (wa05 <> lwa05)

/// Only the long-long and the short-short to do. These should be interpreted as 'hold' signals.
/// And long-close and short-close are 'close' signals.
///
/// We have to take the first long-long price and put it where the following long-close price is.
/// 
/// To do that, I assign an id number (cidx derived from the virtural row number) to each trade.
/// I want to assign to the hold signals, the same id number as their final close.
/// 
/// To do that, I use fills but backwards.
/// First, I only assign to the close trades so that the holds are all null.
//
/// I then fills backwards. 
/// Then I select just the long-long and short-short, their first price and their last dates with a key to 
/// left join to the main table.
/// 
/// And then delete them to give just the closed trades table.

t0: 0!(select by folio0,dt0 from plwa05) lj 2!ungroup select cidx:i by folio0,dt0 from select by folio0,dt0 from plwa05 where wa05 = `close

t0:update cidx:reverse fills reverse cidx from t0

t0: 2!value select first folio0, ldt0:last dt0, first lp00 by cidx from t0 where (lwa05 = wa05)

/// @class plwa05
/// @brief The trade table.
plwa05: delete from (plwa05 lj t0) where (lwa05 = wa05)

t0:()
delete t0 from `.

/// See how much I made.
/// @note
/// I could add a transaction cost here.

update pnl0:lp00 - p00 from `plwa05 where lwa05 = `short
update pnl0:p00 - lp00 from `plwa05 where lwa05 = `long

update pnl1:`loss from `plwa05
update pnl1:`profit from `plwa05 where pnl0 > 0

update ddt0:dt0-ldt0 from `plwa05

/// Some totals
/// I've done this with joins, you can create intermediate tables or operate on the columns.

t0:value select idx:1h, n0:count i, abs sum pnl0 by pnl1 from plwa05
t1:select by idx from update idx:1h from select n1:count i, pnl1:abs sum abs pnl0 from plwa05

t2: t0 lj t1
t2: delete x from select by idx:i from t2

t3: value t2 lj 1!select idx:i, n2:100f * n0 % n1, pnl2:100f * pnl0 % pnl1 from t2 

pnl0: select by t0 from value (select by i from t3) uj select by i from ([] t0:`loss`profit)
show pnl0;

pnl1:t0:t1:t2:t3:t4:()
delete pnl1, t0, t1, t2, t3, t4 from `.;

