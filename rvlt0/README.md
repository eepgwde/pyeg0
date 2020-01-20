* Preamble

Revolut - Challenge

Walter Eaves (weaves)

* Notes

Quite an involved data method
For each user I construct the days between transactions between every pair. I then build an exponentially weighted moving average on each day.
I then perform an as-of join against the notifications. 
One hopes that after the notification the user will make more transactions and the days between transactions will reduce.
I therefore construct a percentage difference of the first and last averages after the notification.

A simple first test is to tabulate the population counts against the signum of the percentage change of the average.

I then build a control group. The same users but the month before. And tabulate in the same way.

I can carry a chi-square test (or similar).

That confirms that there has been some change in the number of users making more transactions.

It doesn't confirm the magnitude of the percentage or the magnitude of the values transacted.

* Overview

This system comprises a q/kdb+ database working with Python Pandas, SciKit and
SciPy. It also illustrates inter-working with Postgresql.

This is not a turnkey distribution so 

 - q/kdb+ runs under my qsys system with time0.q 

 - locate and install Python3 packages as needed. But Python3 notebooks will run
   within my gensim Anaconda environment.

* Sources

Data has been provided by Revolut - proprietary. No external data used.

* Make build using ldr.mk 

There is also a Makefile, this is used for testing the Python3 module rvlt/ and
is not used.

** Data extract

Uses csv1.awk

 $ make -f ldr.mk all
 
** Database load

 $ make -f ldr.mk install

And then run ldr0.q. Database is then ready with these q database files
 
 csvdb/devs csvdb/ntfs csvdb/sym csvdb/users0 csvdb/trns
 
** Run 

Run the tasks below by hand 

** Archive

To produce a Zip archive of key results. Render notebooks in HTML and generate
code counts.

 $ make -f ldr.mk dist-local
 
This does not include all the files.
 
* Analysis Tasks

CSV files from q/kdb+ runs go to ./cache/out
 
** Signups and Card-payments

Run anal0.q; this produces these CSVs tnunsX0 tnunsX1 q1 q2a q2b q2c.
The files are prefixed with x, and suffixed with .csv, eg. ./cache/out/xq1.csv

Excel workbook with text data import is rvlt0.xlsx has charts and pivots.

** Unengagedness - Activity window

Run anal1.q, this produces ttdays0 (as xttdays0.csv)

Make sure that rvlt can be loaded to provide make_pdf().

Run anal1.ipynb to see fitted distribution and collect mean, media and std
deviation.

** Unengagedness II - User Model

Run anal2.q this produces users1 (as xusers1.csv)

Run anal2.ipynb which fits to a supervised model. There are three datasets and three
models. Quotable results are cross-validation accuracy and feature importance.

** Unengagedness III - Responsiveness to Re-engagement Notification

Run anal3.q this produces res0 (as xres0.csv)

Run anal3.ipynb for a simple percentage comparison.

* Extras

** Written report

See rvlt0.odt

** Makefile

General Python3 local module test and install.

** Postgres and Python via Pandas

pgsql.ipynb and then ldr0.sql 

** Other files

csv0.awk is the prototype fo csv1.awk illustrates use of FPAT for embedded comma
text field extraction.

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
