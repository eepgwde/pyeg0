// weaves

// Using q/kdb+ for the data.
// Some cleaning and simplifying for R.

// Make a RAM copy of disk table.
count hexp
hexp0: value select by i from hexp

// Remove a column
delete id from `hexp0

c0: cols hexp0

/// Recalculate totals from items and check for errors

hexpt: 3!delete decile from select total:first raze X by Categories,time,type0,decile from hexp0 where null decile

// get items and remove totals
hexp1: 0!select x0:first raze X by Categories,time,type0,decile from delete from hexp0 where null decile

// calculate totals from items, x0 is true total
hexpt0: hexpt lj select sum x0 by Categories,time,type0 from hexp1
// calculate difference
update d0:total - x0 from `hexpt0;

// halt is unknown, invoke it on error.
if[0 <> count select from hexpt0 where 1 < abs d0; halt[]]

// and drop the inexact values and the indicator.
delete total, d0 from `hexpt0;

// put annual total into the items table as 'total' and calculate a ratio
update total: hexpt0[([]Categories;time;type0);`x0] by Categories,time,type0,decile from `hexp1
update p0: x0 % total from `hexp1

/// Total processing
// Prototype elasticity metrics for just the totals.

// Calculate year to year percentage increment, r0 - a rate

/// Convention we start at 0 growth, initially.
update r0: (deltas x0) % x0 by type0,Categories from `hexpt0;
update r0:0f from `hexpt0 where r0 >= 1;

/// x2tp: proportion of x to annual total for each Category 

// make a lookup table of annual totals
hexpt1t: select sum x0 by type0,time from hexpt0

// calculate the ratio for each category against the annual total
update x2tp: x0 % hexpt1t[([]type0;time);`x0] by Categories,type0,time from `hexpt0

// assert: sums are all 1
if[any 1 <> value exec sum x2tp by type0,time from hexpt0; halt[]]

// sort these
`type0`Categories`time xasc `hexpt0;

// elasticities (of spending) will be the change in percentage from year to year

update r1: (deltas x2tp) % x2tp by type0,Categories from `hexpt0;
update r1:0f from `hexpt0 where r1 >= 1;

.sch.t2csv[`hexpt0]

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load csvdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
