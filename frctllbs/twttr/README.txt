* Preamble

weaves

* Demonstration program - timestamps background updates

** Not a Twitter Monitor Application

Twitter have tightened up their security policy and I'm still waiting for my
OAuth to be verified.

** CoinDesk Bitcoin Exchange Rate

To do something similar to the Twitter task, I interrogated the CoinDesk
bitcoin exchange rate. It is available as a JSON file.

 https://api.coindesk.com/v1/bpi/currentprice.json

The make.log file demonstrates the program interrogating the website. A
short excerpt is this:

  invocation: 16; new: ts:  6447.91 @ 2018-10-25T19:02:00Z 
  size: 3;  6449.92 @ 2018-10-25T19:00:00Z;  6447.91 @ 2018-10-25T19:02:00Z
  delta: -0.03%
  invocation: 17; new: ts:  6448.85 @ 2018-10-25T19:03:00Z 
  size: 4;  6449.92 @ 2018-10-25T19:00:00Z;  6448.85 @ 2018-10-25T19:03:00Z
  delta: -0.02%

It shows that the 16th time the task executed, it received a new timestamp
with a dollar price of £6449.92. There are only three updates in the set of
updates observed: the first and the last are given. And the price delta is
-0.03%. On the 17th invocation, a new update was received at 19:03 and the
price delta changes.

* Structure

The main() method is from Fetcher.java. This class is very similar to the
TwitterScanner one provided.

This uses the ScheduledExecutorService to run the Runnable task contained
in Fetcher.

The constructor is now used to pass the URL. Most of the object members are
instanced on construction. A SortedSet instance is used to collect the
timestamped data. A Parser instance is used to process the JSON received
from a URL GET.

The logic for updating the metric is discussed below.

** TSValue: the time-series class

This class was provided. A few methods have been added. For debugging, a
toString() and for use with a SortedSet, a compareTo(). Another constructor
has been added. There is a clone() that is only used for testing.

** run method

There is a try-with-resources block that performs the URL GET using an
openStream(), this is then built up to be a BufferedReader.

** Parser and the parse method

The JSON parser uses a JSON component from org.json.simple.
It has been designed to be able to have the constructor act as a Factory.

It has some polymorphic methods that would allow for a different parser
implementation to find different data.

*** Idiom: typed get() methods

The method

 public Vector<java.io.Serializable> get(Vector<java.io.Serializable> bag)

is designed to be called with bag as null. Like this, if in Scala:

 val v = parser.get((Vector<java.io.Serializable>) null)

It's an idiom that Scala programmers use for Java. Rather than having a
method called getResults(), the return type is given as a null parameter.

It uses Vector<T> as a bag container, so that parsers and calling code can
be easily extended to return longer and longer sequences of results.

*** Idiom: typed conversion methods: as()

Another idiom is to conversion functions: this is parseDate(String input).
It has the added feature that the Vector<T> passed can be null or an
instance. In the latter case, the as() can set the contents of a caller's
data structure.

    as(Vector<Date> bag, String input)

*** parse method

The parse method contains the logic of the decode of the JSON string. The
parse() method is designed to be a pointer to an implementation. I chose
not to do this in this iteration of the design, but it should be possible
to extend it. The parse method updates it containing object's instance
variables dates and results.

*** Time-basis for the change metric

The original specification was to show the percentage increase in the
number of hashtag hits for a name and to poll this for an hourly update.

I've changed this to be the percentage change in the value of the bitcoin
to USD exchange rate.

It's always difficult to test slow metrics in real-time, so the design of
the metric is this.

Take the most recent reading from the sorted set of readings. Readings are
sorted by time. Calculate the timestamp one hour ago - the hour prior
timestamp. Find the tail set, all those after that timestamp, and use the
first reading from that set.

The task runs every 10 seconds (a command line argument allows this to
changed) and after 360 invocations, when there is an update, a full hour of
data will have been collected. The data structure is a set, so only new
timestamp values make for a new element in the set.

After that the window moves forward with every new tick that arrives.

The sorted set should be pruned at this point. The set can be replaced by
the tail set.

I've left it collecting the updates. It should also write to disk and be
able to recover from a shutdown by loading the last hour of data from a
file.

Here's some inspection, the total after 421 invocations 

   weaves@j1:/misc/build/0/pyeg0/frctllbs/twttr
   81$ grep invocation: make.log | wc -l
   421

The first hour, the first and last 

   weaves@j1:/misc/build/0/pyeg0/frctllbs/twttr
   82$ grep invocation: make.log | head -360 | head -1
   invocation: 1; new: ts:  6449.92 @ 2018-10-25T19:00:00Z 
   weaves@j1:/misc/build/0/pyeg0/frctllbs/twttr
   83$ grep invocation: make.log | head -360 | tail -1
   invocation: 360; new: ts:  6443.75 @ 2018-10-25T20:00:00Z 

The last hour, the first and last

   weaves@j1:/misc/build/0/pyeg0/frctllbs/twttr
   85$ grep invocation: make.log | tail -360 | head -1
   invocation: 111; new: ts:  6447.63 @ 2018-10-25T19:18:00Z 
   weaves@j1:/misc/build/0/pyeg0/frctllbs/twttr
   86$ grep invocation: make.log | tail -360 | tail -1
   invocation: 470; new: ts:  6440.39 @ 2018-10-25T20:18:00Z 

And currently bitcoin has fallen by -0.13%

* Development and running

Usually, you only need

 mvn compile && mvn test

And eventually, you'll need to run the application. Maven has an exec:java
and an exec:exec method. The former doesn't run threaded systems reliably.
The latter does, but has some difficult invocations.

These are captured and sequenced with the Makefile.

There is a utility called mvnexec at GitHub that does this in a more ad-hoc
manner.

** Test Driven Development

*** Test resources

There is a file of a typical JSON result from CoinDesk in date-sample.json.
And it is obtained from the resources tree.

*** AppTest

There is only one test class. The methods prefixed with "test" are run
independently from one another. The methods cascade test0002 calls
test0000 and that method just gets the test JSON file.

test0002 invokes the JSON Parser and gets the results. It then constructs a
list to display the types. It then uses the new constructor to create a
timestamp.

test0004 is a standalone method. It builds a SortedSet and performs the
partitioning of the data and the arithmetic to update a metric.


** This file's Emacs file variables

[  Local Variables: ]
[  mode:text ]
[  mode:outline-minor ]
[  mode:auto-fill ]
[  fill-column: 75 ]
[  coding: iso-8859-1-unix ]
[  comment-column:50 ]
[  comment-start: "[  "  ]
[  comment-end:"]" ]
[  End: ]

