#!/bin/sh
eval `dmalloc -l logfile -i 100 high`


tfile=in-file.lst
ifile=$(tempfile)

for i in $(seq 1 5)
do
    let r0=$RANDOM
    echo $r0
done > $tfile

./equi0 $tfile

grep "not freed" logfile | tee unfreed.txt

echo "DMALLOC_OPTIONS were :"
printenv DMALLOC_OPTIONS

rm -f $ifile

exit 0
