all:
	mvn compile

mvn-dependencies:
	mvn dependency:copy-dependencies

run: mvn-dependencies 
	mvn exec:exec -Dexec.executable=/usr/bin/java -Dexec.workingdir=. -Dexec.args='-cp target/classes:target/dependency/* com.fractallabs.assignment.Fetcher '

check:: src/test/resources/date-sample.json

src/test/resources/date-sample.json:
	wget -O $@ https://api.coindesk.com/v1/bpi/currentprice.json

