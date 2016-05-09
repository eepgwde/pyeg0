/// weaves

/// Checks the final CSV is not different from the source.  After the
/// examination of the data in jr0.R, it appears they are all MAs.  So
/// very little use. There's no volatility, no volume. Nothing other
/// than the price in here.

///* Check I haven't broken anything.

show "checking: "

(count data) = (count data1)

// check: sum the columns.

t:data 

t0:meta t
c0: raze value flip select c from t0 where t = "f"

a0: c0!({ (sum;x) } each c0)

c:()
b:0b
a:a0

sdata: ?[t;c;b;a]
sdata: `fcst`r0`x1`x2`x3`x4`x5`x6`x7`x8`x9`x10`x11`x12`x13`x14`x15`x16`x17`x18`x19`x20`x21`x22`x23`x24 xcols sdata

sdata: flip sdata

// And again

t:data1

t0:meta t
c0: raze value flip select c from t0 where (t = "f"),(c like "[rxf]*")

a0: c0!({ (sum;x) } each c0)

c:()
b:0b
a:a0

sdata1: flip ?[t;c;b;a]

( value sdata1 ) ~ ( value sdata )

data1[;`folio0] ~ data[;`folio0]

data1[;`dt0] ~ data[;`dt0]

chk.data: 0!select count i by folio0, sample0 from data
chk.data1: 0!select count i by folio0, in0 from data1

delete sample0 from `chk.data
delete in0 from `chk.data1

`folio0`x xasc `chk.data
`folio0`x xasc `chk.data1

chk.data[;(`folio0;`x)] ~ chk.data1[;(`folio0;`x)] 
