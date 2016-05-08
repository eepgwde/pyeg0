// weaves

// Using q/kdb+ for the db.

// Some cleaning and simplifying for R.

count data

c0: cols data

data1: update in0:"b"$(sample0 = `In_Sample) from data

select count i by folio0,sample0 from data

select count i by folio0,in0 from data1

delete sample0 from `data1

select x1, ratios x1 from data1 where folio0 = `KF

folio1:`KF

c1: (cols data1) where { (x like "x*" ) or (x like "r0") } each string cols data1
c2: { `$"d",x } each string c1
c12: (c1; c2)

t:data1
c:(=;`folio0;`KF]
b:(0b)
a:

?[data1;

/  Local Variables: 
/  mode:q 
/  q-prog-args: "-p 5000 -load csvdb help.q -verbose -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
