// @author weaves
// @file dcover0.q
// Data coverage

// write a workspace to the cache directory for others.

\l hcc.q

// Get a list of tables now

tbls: tables `.

// Check data sets

`.poi set get `:./wspoi;

select count i by nbus:null nbus from .poi.tables0[0]


// Do the special reports

// * Data coverage reports

x00: 0!select src0:`dfct, n:count i, nassets:count distinct assetid by month0:`month$defectdate from dfct
x00,: 0!select src0:`clm1, n:count i, nassets:count distinct `$roadidfeatureid by month0:`month$lossdate from clm
x00,: 0!select src0:`permits, n:count i, nassets:count distinct usrn by month0:`month$noticeissuedate from permits
x00,: 0!select src0:`rci, n:count i, nassets:count distinct centralassetid by month0:`month$surveyfeatend0 from rci1
x00,: 0!select src0:`enq, n:count i, nassets:count distinct assetid by month0:`month$enquirytime0 from enq

d0: exec min modifiedda from traffic0
t00: update modifiedda:d0 from traffic0 where null modifiedda

x00,: 0!select src0:`traffic, n:count i, nassets:count distinct featureid by month0:`month$modifiedda from t00

dcover0: 0!`month0`src0 xasc x00
dcover1: 0!select { " " sv x } string src0, sum n by month0 from x00

.csv.t2csv[`dcover0]
.csv.t2csv[`dcover1]

dates0: exec min month0, max month0 from (select tag0: 4 <= count src0, sum n by month0 from x00) where tag0

// Date filter in month format.

.dcover.dates0: asc raze value dates0

// Classification reports

`.cwy set get `:./wscwy ;

rh0t: `rh0 xdesc (select n:count i by rh0 from cwy0) lj `rh0 xkey .cwy.roadhierarchy

.csv.t2csv[`rh0t]

// Some others: permits and claims

`.permit set get `:./wspermit;

prmtrisk: 0!.permit.risk
.csv.t2csv[`prmtrisk]

`.clm set get `:./wsclm;

clmprmt0: 0!.clm.prmt.response
clmprmt1: 0!.clm.prmt.cause

.csv.t2csv[`clmprmt0]
.csv.t2csv[`clmprmt1]

// Indices

usrn2aid0: update sitename: ":" sv string raze sitename by i from usrn2aid
.csv.t2csv[`usrn2aid0]

// Augmented data files

cwy1: cwy0 lj `featureid xkey `featureid xcol delete siteid from cwy2
.csv.t2csv[`cwy1]

// Save the workspace for reference.

`:./wsdcover set get `.dcover;


.sys.exit[0]

\

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load ../cache/csvdb help.q -verbose -halt -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
