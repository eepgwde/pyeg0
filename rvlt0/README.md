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

Some of the DECLINED transactions are ridiculously large.

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

* Part II - Engagement and Churn

** Define a target metric to measure user engagement. 

"How would you define an engaged vs. unengaged user?"

The transactions cover the period 2018.01.01 to 2019.05.16. There are 19430
users. If we define activity as having at least one transaction registered then
there are 664 users who were *never active* in that period.

If an activity is defined as a day when a user has at least one transaction.
Then one can define the days between activities as the transaction days (tdays0
in the code in anal1.q and the table is ttdays0.)

An *inactive* user is arbitrarily defined as one who has more than 365 days
between activities. There are 803 of those.

These classes of users are very unengaged.

If we take the distribution of users' activities and fit them to a frequency
distribution more classes can be derived using the mean and standard deviation.

Referring to the notebook anal1.ipynb, the most sensible distribution proves to
be the Wald distribution - also known as the Inverse Gaussian. Unlike other more
extreme distributions, it has a finite mean and variance. And, usefully, for
this data it provides a meaningful result.

It has a median of 11 days between activities, a mean of 19 days and a standard
deviation of 22. Because of the very long tail in the data, it would be best to
use the median. If one adds 22 to the median, this gives 33 which is about a
month.

It can then be argued that a reasonably active user will be using his account at
least once a month. (An appeal to business principles is that many billing
systems use monthly payments - so an active user will have at least one billing
service being paid with his account.)

So we can classify all users who are using their accounts less often than that
as unengaged.

That gives another 5869 users who can be classified as unengaged. They have more
than 30 and less than 365 days between activities.

** Classify engaged and unengaged users

"Using your logic from above, build a model (heuristic/statistical/ML) to classify
engaged and unengaged users. Note that features which are directly correlated with
your target metric could lead to overfitting."

The numbers are 19430 users and by the classes above only 7349 are unengaged
(never-active, inactive (> 365 between activity) and unengaged (> 30 and <
365)). So under 40% are inactive or unengaged: 2 customers in 5 make little or
no use of their account.

I'll develop a classifier from the user data that will use features like device
type, country, age and some transaction metrics to classify if a user is likely
to be unengaged. This is not a typical classification exercise, because I have
am deciding class membership. For example, more typical would be disease
incidence. A person's features such age, weight, height, body-mass-index,
gender, lifestyle features would be correlated against whether they developed
diabetes. In this way, it would be become clear which features are more likely
to indicate possible diabetes sufferers. This is known as root-cause analysis
and the techniques used for it include logistic regression and shallow
machine-learning classifiers, such as random forest. These methods provide a
means to rank feature importance. Neural network methods don't easily deliver a
feature importance. 

This is a shame. A multi-layer classifying perceptron - feed-forward neural
network - is very easy to implement because it does its own feature scaling.

The caveat noted above - "features that are directly correlated to the target
metric" mean that we should not use features similar to account activity. So
total number of transactions or transaction value would be examples of what are
known as *prescient* features - the outcome is encoded in them in some way.

Features to consider: 

    - average transaction value should be usable
    - age of user
    - possibly age of account (but perhaps a prescient feature)
    - number of notifications received (prescient?)
    - user features: plan, number of contacts, push and email
    - the city feature could be useful but needs a lot cleaning
    - and the others in the user record
    
From the transaction records, indicator variables might be usable.

    - indicator for transaction failure or reversion 
    - indicator for transaction direction
    - used account feature: indicator of whether a transaction type has been used

And from the notification file, this might be indicative

    - indicator for notification failure
    - and others might be indicators for ONBOARDING, LOST_CARD_ORDER and NO_INITIAL events

Generally, anything that indicates age of the account might be prescient, so
total counts should not be used.

The city text field has a lot of variety in spelling - upper-case, lower-case,
mixed-case, language accents. Names are often abbreviated (Cagnes vs.
Cagnes-sur-mer). And occasionally mispelt or plainly incorrect. A soundex method
would have to be used to trap some mis-spellings. A nearest neighbours methods
could also be used if I had access to the postcode - and knew how that was
encoded in each country. This is too large a job for this challenge I think.

The results from this analysis are given in the anal2.ipynb notebook. The
mechanics are that I've used the users1.csv file generated by anal2.q. I've
applied three models that don't need too much work done to get the working (I've
haven't had to scale the features.) The SVM model only converges after a very
long time. The MLPC (multi-perceptron classifier) can converge quite well but
these models are so opaque, they just illustrate that there statistical
inference is possible. And the most useful model is a logistic regressor. 

For the three data unengagedness cases (never-active, no activity in a year, and
no activity for a month), the dominant features are the indicators of
transaction failures. With an unusual feature of the
ONBOARDING_TIPS_ACTIVATED_USERS notification having been issued.


** How would you test to check whether we are actually reducing churn?

"Let’s assume an unengaged user is a churned user. Now suppose we use your model
to identify unengaged users and implement some business actions try to convert
them to engaged users (commonly known as reducing churn). How would you set up a
test/experiment to check whether we are actually reducing churn?"

The test would be send them a notification (a Change Point, in business analysis
and time-series analysis: some indication of a change in organisational status).
On measure activity on either side of the changepoint, and one would hope to see
some activity after it. 

Because I've arbitrarily chosen a month, one would need a window before and
after the notification of at least 30 days to detect any activity on the
account.

The statistical test to use is a comparison of two ratios. If a user had an
activity of one transaction-day in 60 days before the changepoint and then there are
two transaction-days in the next 60 days, the ratio would be 2/40 : 2/60 an increase
in activity of 50%.

The ratio has to be used to normalize over all unengaged users so that one can
construct a test across all users, 5/120 before and 1/30 after, this would *not*
be thought of as an increase in activity.

It might be possible to use a time-window on either side of the change point.

Another test that could be employed and is useful to streamed data is is to
estimate the new population using a capture-tag-recapture method. This is used
to estimate animal populations. Capture some birds, say, tag them; release them
back to the wild and then capture some more birds later. The proportion of the
newly captured birds that are tagged can be used to estimate the population. If
the estimate is larger than the actual population then one could argue the
policy to re-activate users has been effective.

And of course, we have a control group those who have not received the
REENGAGEMENT_ACTIVE_FUNDS notification.

** Re-engagement Campaign Effectiveness

"In the past, one business action we took to reduce churn was to re-engage
inactive users. Our engagement team designed a marketing campaign,
REENGAGEMENT_ACTIVE_FUNDS to remind inactive users about funds on their Revolut
account. Define a metric to measure the effectiveness of the campaign. Under
this metric, was the campaign effective?"

One of the many features of q/kdb+ is that it implements as as-of join. Pandas
support the same with pandas.merge_asof. The q/kdb+ as-of joins allow for
variable size windows and are, as always, blazingly fast which means more and
better prototypes.

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
