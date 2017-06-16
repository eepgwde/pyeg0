#!/bin/sh
eval `dmalloc -l logfile -i 100 high`


tfile=in-file.lst
ifile=$(tempfile)

for i in $(seq 1 5)
do
    let r0=$RANDOM
    echo add $r0
done > $tfile

cat $tfile | awk '{ $1="del"; print }' | tac > $ifile
cat $ifile >> $tfile

(
echo find $r0 
echo print 0
echo quit 0 
echo add 1 
echo del 1 
) >> $tfile

./textrb < $tfile

grep "not freed" logfile | tee unfreed.txt

echo "DMALLOC_OPTIONS were :"
printenv DMALLOC_OPTIONS

rm -f $ifile

exit 0
