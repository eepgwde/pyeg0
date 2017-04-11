

x01.xml: metadata.xml
	xmlstarlet fo $< > $@

x02.xml: x01.xml
	egrep -v '<mastered' $< > $@

x02.err: x02.xml
	xmlstarlet val -e -s ../music-v5_1.xsd $< > $@ 2>&1
