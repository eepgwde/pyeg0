/// @file jr2c.q
/// @author weaves
/// @brief Part of jr.
/// Trading signals
/// State machines on signals.

/// RSI Wilder

/// State machine table - put the prev value in their own column prefix 'l' for lag
/// Delete the synthetics 
state0: ungroup select dt0, p00, fz05, fz20, fc05, fc20, fd05, fd20, lfz05:prev fz05, lfz20:prev fz20, lfc05:prev fc05, lfc20:prev fc20, lfd05:prev fd05, lfd20:prev fd20 by folio0 from (`folio0`dt0 xasc 0!delete from data1 where folio0 in `KA`KB`KC)

delete from `state0 where dt0 < 20

state0: `folio0`dt0`p00`fz05`lfz05`fz20`lfz20`fc05`lfc05`fc20`lfc20`fd05`lfd05`fd20`lfd20 xcols state0

// Using near/far: as under/over/stable fz05/fz20, bull/stable fc05/fc20, bear/stable fd05/fd20

// Wilder's under/stable/over: variant a
// if under -> long
// if over -> short
// if stable -> close

update wa05:`long from `state0 where (fz05 = `under),(not lfz05 = `under)
update wa05:`short from `state0 where (fz05 = `over),(not lfz05 = `over)

update wa05:`close from `state0 where (fz05 = `stable),(lfz05 = `stable)

update wa20:`long from `state0 where (fz20 = `under),(not lfz20 = `under)
update wa20:`short from `state0 where (fz20 = `over),(not lfz20 = `over)

update wa20:`close from `state0 where (fz20 = `stable),(lfz20 = `stable)

