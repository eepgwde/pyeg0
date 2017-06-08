#!/bin/sh
eval `dmalloc -l logfile -i 100 high`


tfile=in-file.lst
ifile=$(tempfile)

./equi0 -N 10 $(seq 1 5 | xargs printf "-T%d ")

# ./equi0 $tfile

grep "not freed" logfile | tee unfreed.txt

echo "DMALLOC_OPTIONS were :"
printenv DMALLOC_OPTIONS

rm -f $ifile

exit 0
