all:: hexp-065.csv

hexp-065.csv0: IndonesiaData1.csv 
	dos2unix < $< > x.tmp
	sed -i -e 's/ /_/g' x.tmp 
	sed -i -e 's/Consumer_Expenditure_on_//g' -e 's/_-_US\$$//g' x.tmp
	sed -i -e 's/_per_household/_h/g' -e 's/_million/_t/g' x.tmp
	sed -i -e 's/Decile_\([0-9]\)/D\1/g' x.tmp
	sed -i -e 's/Total_/D0_/g' x.tmp
	tr -d \" < x.tmp > $@

hexp-065.csv: hexp-065.csv0
	awk -F, 'BEGIN { OFS=","; } NR == 1 { $$3="type0,decile"; print; next } $$3 ~ /_[ht]$$/ { tag0=$$3; gsub(/^.+_/, "", tag0); tag=$$3; gsub(/[^0-9]+/, "", tag); if (tag == 0) { tag="" }; $$3=tag0","tag; print }' $< > $@

