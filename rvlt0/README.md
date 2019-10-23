* Preamble

weaves
Walter Eaves

Revolut - Challenge

* Contents

So far

** anal0.q SQL for the 3 SQL Questions

Heavily annotated file explaining the SQL queries used to produce the results of
the 3 questions.

** rvlt0.xlsx Excel workbook with results tables, charts and analysis

This imports the output CSV files of anal0.q and visualises the results.

** pgsql.ipynb

A jupyter ipython notebook that illustrates the use of Pandas with a Postgres server.

** Other files

ldr.mk a Makefile to load the databse

ldr0.q another SQL file to establish foreign keys.

csv0.awk and csv1.awk AWK script files to extract the "city" text fields.

* Technology

I prefer not to use SQL for analysis because that commits me to using an ACID
relational database for analysis. Conventional relational databases are too slow
and inflexible for analytic work. They have fixed schema, they expect to be used
in a multi-user environment with many clients so they lock at record and table
level; they need indices built to achieve usable performance. Most vendors have
realized that analytics should be lock-free: so Microsoft has developed SSAS,
TeraData has Aster Analytics and other vendors have similar products.

One of the reasons for the success of Pandas is that it uses NumPy which, like
Matlab before it, uses the vector processor of the modern CPU to process data.
Vector processors have been used with databases. This has given rise to columnar
databases. Rather than process data a record at a time, a whole column is loaded
into a vector processor which can use, for example, a single vector operation to
aggregate.

I'll be using such a columnar analytics database. It's called q/kdb+ from
kx.com. It's mature product and widely used in finance and engineering (Morgan
Stanley, citi and others, and RedBull and AirBus.). q/kdb+ was the fastest
time-series database, it is now second.

https://db-engines.com/en/ranking/time+series+dbms

Using Pandas can have comparable performance to q/kdb+, but needs careful coding.

https://kx.com/blog/a-comparison-of-python-and-q-for-data-problem-solving/

q/kdb+ does support a variant of SQL it calls k-sql. This is relatively easy to
convert to a sequence of standard SQL2016 commands. Its support for database constructs is
better evolved than Pandas - it supports foreign keys directly for example.
Tables can be viewed in a web-browser for investigative work. 

It is a very succinct language - it takes only 50 lines of q code to produce the
tables that are the answers of the 3 questions. It also allows analysts to do
their data processing with a more natural workflow, in particular, they don't
have to use cursors and non-standard SQL procedural code.

I first used q/kdb+ over 10 years ago after many years of using SQL and R for
ETL. I experienced the "shock and awe" of q/kdb+ and have used it on just about
every project I've worked on since then. It allows me to prototype rapidly and
then migrate to a production hybrid SQL, Python/R,.Net/Java environment. to
migrate a known working solution to a production system is much more accurate.

* ETL - CSV files

** Using Pandas

To justify my use of q/kdb+ I've illustrated how to load the files into Pandas
and a Postgres SQL server.

In the notebook pgsql.ipynb I load the transactions CSV file - 2.7 million
records - into pandas in 13 seconds.

** Using SQL

To use Pandas and the to_sql() to upload the 2.7 million records into the
Postgresql database is prohibitively slow - several hours. (It does this by a
line-by-line text insert with locking.) See the jupyter notebook pgsql.ipynb.
This also illustrates embedding SQL statements into ipython. For Postgresql
there is limited support for Postgres Special commands.

I have illustrated a native SQL load method where I have used the Pandas
to_sql() method to create the table (and define the schema) by uploading 1
record. And after that to upload to Postgres using its client side system copy
command. The Postgres commands are in the file ldr0.sql. That takes 30 seconds.

  $ time psql -f ldr0.sql
  TRUNCATE TABLE
  Wed 23 Oct 11:55:48 BST 2019
  COPY 2740075
  Wed 23 Oct 11:56:22 BST 2019

  real    0m34.050s
  user    0m0.892s
  sys     0m0.299s

** Using q/kdb+

The load of the transactions CSV takes about 15 seconds - comparable to Pandas.
q/kdb+ does more processing - it reduces text strings to enumerations that are
integers, cross-referenced to a textual representation in a file called "sym".
This is comparable to converting text objects in Pandas to categories.

  Qp transactions.load.q cache/in/transactions.csv2 csvdb -bl -bs -savedb csvdb -savename transactions -exit
  KDB+ 3.5 2017.11.30 Copyright (C) 1993-2017 Kx Systems
  l32/ 4()core 12009MB weaves j1 192.168.145.145 NONEXPIRE  

  "loaded: /home/weaves/share/qsys/trdrc.q"
  11:22:28 saving <cache/in/transactions.csv2> to directory csvdb/transactions
  11:22:36 done (2740075 records; 327917 records/sec; 30 MB/sec)
  11:22:36 loading <cache/in/transactions.csv2> to variable DATA
  11:22:41 done (2740075 records; 531125 records/sec; 48 MB/sec)

The other files load in a second or less (that's files users, notifications, devices
and transactions) this takes. The operation is sequenced by the Makefile ldr.mk 

 $ make -f ldr.mk install

The time for the whole load is 

  real    0m15.808s
  user    0m13.765s
  sys     0m0.472s
  
* CSV files schema

** id fields: transaction_id and user_id

I've use the GNU utility sed to operate on the CSV files and simplify these
fields to just an integer. Integers use less storage and are easier to compare.

** text field: city

The city field is a quoted text field when it has an embedded comma. The Excel
encoding standard. Python csv reader does provide an excel dialect that can
handle this and Pandas uses that. For the city field, there are UTF-8 issues.

Because of this, I've chosen to remove the city fields. They're not used in any
analysis. I've used a mature GNU utility AWK to do this - see csv.

** numreferalls and numsuccessfulreferalls 

These are are null in the users - ie. all zero.

* Dataset Relations

All these transactions have no eamctry

tstype      | x     
------------| ------
ATM         | 65    
CARD_PAYMENT| 149   
CARD_REFUND | 107   
CASHBACK    | 82789 
EXCHANGE    | 159148
FEE         | 23659 
REFUND      | 1493  
TAX         | 2829  
TOPUP       | 388331
TRANSFER    | 500409

And these do have a country

tstype      | x      
------------| -------
ATM         | 93610  
CARD_PAYMENT| 1475631
CARD_REFUND | 11855  

** Week-number convention

Most libraries use strftime which implements an ISO

http://man7.org/linux/man-pages/man3/strftime.3.html

%V 

The ISO 8601 week number (see NOTES) of the current year as a decimal number,
range 01 to 53, where week 1 is the first week that has at least 4 days in the
new year. See also %U and %W.

** Card Payments

There is an issue what should be counted.

tsstate  | x      
---------| -------
COMPLETED| 1257461
DECLINED | 133469 
PENDING  | 19055  
REVERTED | 6579

There is an order of magnitude between COMPLETED and the others, so we only
consider the COMPLETED payments. (The non-COMPLETED transactions could be
tallied for their transaction costs, but not in this analysis.)

Some qualifications are refinements might be:

  state the value of transactions that are non-COMPLETED
  age-bands could be adjusted to capture, for example, university leavers at 22

** Monthly Metrics

This is 16 months of data, 2018.01.01 2019.05.16. So the phrase, monthly result,
could be interpreted as month qualified by year - Jan 2018, Feb 2018. Or as each
calendar month in a calendar year. 

The former is useful for tracking growth with the underlying seasonality from
month to month. However, if one were to aggregate across all the months for the
16 months, then metrics for Jan to May would have two months and wouldn't be
comparable to the other months (Jun to Dec).

The latter dataset, the calendar year metrics, will be useful to year-on-year
comparison of each month. Although only 16 months are available.

I've implemented two calendar year results. One, from the beginning of the
transaction data and forward for a year; the other from the end of the data and back a
year. Or 2018.01 to 2019.01.01 and 2018.05.16 to 2019.06.16.

These could be used to produce year-on-year monthly statistics, but I haven't
done that in this analysis.

** Standard to non-standard users

This has the same consideration about COMPLETED and non-COMPLETED for "Card
Payments". Only COMPLETED will be considered.

It can be seen from the users table that the users on the standard plan vastly
outnumber the non-standard: 93% to 7% - or there are 12.5 more standard users
than non-standard.

So to relativize the non-standard plan metrics, we should scale their transactional
value up by 12.5. From that one can form a null-hypothesis that the value of standard
users should be the same as that of the non-standard.

As for the implementation, I've had to use coalesce to convert null values to 0.
(It would not have hurt much to have discarded incomplete records.)

There is also an issue with real (or floating point) number representations.
q/kdb+ like every other finite numeric system can introduce rounding errors.
(Conventional relational databases have number format types designed to avoid
them.) I've dealt with that problem here by rounding to 2 decimal places. (I've
also illustrated how to round and return an integer.)

* More notes

** Efficacy of q/kdb+

It's worthwhile to look at the coding effort needed to answer the 3 questions
using q/kdb+

(Use 

 $ make all-local
 
For a simple code line count.)

The analysis of the 3 questions takes 50 lines of q code.
The re-keying of the data tables takes 14 lines of q code.

** Cost of q/kdb+

For a commercial licence q/kdb+ is very expensive. I have used the community
non-commercial system, it is only a 32 bit implementation, but is still very
usable.

** q/kdb+ and Python

There is an extension to Python that allows q/kdb+ to be used within Python:
pyq. It is quite usable. For simple cases, it is easier to load CSV files using
HTTP from a q/kdb+ server.

[  Local Variables: ]
[  mode:text ]
[  mode:outline-minor ]
[  mode:auto-fill ]
[  fill-column: 75 ]
[  coding: utf-8 ]
[  comment-column:50 ]
[  comment-start: "[  "  ]
[  comment-end:"]" ]
[  End: ]
