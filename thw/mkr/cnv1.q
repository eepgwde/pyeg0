// weaves
// @file cnv1.q

cnv1: value select by i from cnv0
cnv1: `adid xkey cnv1

c0: `id0`xyz0`fb0`age`gender`interest`impressions`clicks`spent`tcnv0`acnv0

cnv1: c0 xcol cnv1

// Numericize some qualities

update age0: { "I"$first "-" vs x } each string age from `cnv1 ;
update male0: gender = "M" from `cnv1 ;

// spent and clicks are both null for many campaigns
update spent:`float$0N from `cnv1 where spent <= 0 ;
update clicks:`int$0N from `cnv1 where (clicks <= 0),(null spent) ;

// clicks <= impressions are always 
select by i from cnv1 where clicks >= impressions

// impressions is the number of times an ad is shown.

				      

// Some checks

count exec distinct id0 from cnv1

select count i by xyz0 from cnv1

select sum n from select n:count i by fb0 from cnv1 where (0 = spent)

count select from cnv1 where (0 = spent),(0 = clicks)

count select from cnv1 where (0 = spent)

select count i by age from cnv1


// Write out

save `:./cnv1

.sys.exit[0]

\

/  Local Variables: 
/  mode: kdbp 
/  q-prog-args: "-p 5000 -c 200 120 -C 2000 2000 -load ../cache/csvdb help.q -verbose -halt -quiet"
/  fill-column: 75
/  comment-column:50
/  comment-start: "/  "
/  comment-end: ""
/  End:
