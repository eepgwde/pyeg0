
%.xsd: share/doc/%.rng
	trang $< $@
	sed -i 's/use="required"//g' $@

providers.csv: share/doc/providers.lst
	sed 's/  [ ]*/,/g' $< > $@

X_SCH?=../music-v5_1.xsd

all: x02.err

x01.xml: metadata.xml
	xmlstarlet fo $< > $@

x02.xml: x01.xml
	egrep -v '<mastered' $< > $@

x02.err: x02.xml $(X_SCH)
	xmlstarlet val -e -s $(X_SCH) $< > $@ 2>&1
