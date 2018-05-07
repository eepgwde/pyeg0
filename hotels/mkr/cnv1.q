// weaves
// @file cnv1.q

// Make submissions similar to sales and join use null sales (or date)
// as the key.
submission1: value select by i from submission where not null hotel
update transdate:0Nd, sales:0n from `submission1 ;

submission1: (cols sales) xcols submission1

sales1: value select by i from sales where not null hotel

sales2: submission1, sales1

// For hotels, add a new key field

hotels1: value select by i from hotels 
hotels1: select by hotel:hotelid from hotels1

// For sales, we key to that.
update hotelid:hotel from `sales2 where hotel in exec distinct hotelid from hotels1 ;

update hotelid:`hotels1$hotelid from `sales2 ;

// Are there sales that have no hotel record.

.htl.sales1: exec distinct hotel from sales2
.htl.sales2: exec distinct hotel from hotels1

// Hotels with no sales
.htl.htlnosales: .htl.sales2 except .htl.sales1
.htl.salesnohtl: .htl.sales1 except .htl.sales2

// So delete from sales the entries with no hotel information.
// We can get sales by date but nothing else from these.
delete from `sales2 where hotel in .htl.salesnohtl ;

// Now mark in hotels1 those records that are to be predicted.

.htl.sales: exec distinct hotel from sales
.htl.nosales: exec distinct hotel from submission1

update sales0:0b, sales1:0b from `hotels1 ;

update sales0:1b from `hotels1 where hotelid in .htl.sales ;
update sales1:1b from `hotels1 where hotelid in .htl.nosales ;

// These have no sales and are not being predicted.
// So no use unless we want to impute.
// They are the same as .htl.salesnohtl
count select from hotels1 where (not sales0), (not sales1)

// Submission currencies

.htl.subcurrencies: exec distinct hotelid.currency from sales2 where null sales

`n xdesc select sum sales, n:count hotelid by `month$transdate, hotelid.currency, hotelid.country from sales2 where not null sales

`n xdesc select n:count i by currency, country from hotels where hotelid in exec distinct hotel from submission

// Destination cities

.htl.subcities: exec distinct hotelid.city from sales2 where null sales

bookings: `hotel xdesc select sum not null hotelid.hotel, sum not null distinct hotelid.hotel, sum sales by `month$transdate, hotelid.currency, hotelid.city from sales2 where (not null sales), (hotelid.city in .htl.subcities)

update transdate:-1 + `date$(1 + transdate) from `bookings

// Write out

save `:./hotels1
save `:./sales2

`:./wshtl set get `.htl 

\

.sys.exit[0]

/  Local Variables: 
/  mode: kdbp 
/  q-prog-args: "-p 4444 -c 200 120 -C 2000 2000 -load ../cache/csvdb help.q -verbose -halt -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
