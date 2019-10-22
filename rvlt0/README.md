weaves

CSV files

The city field is a quoted text field when it has an embedded comma.
Python does provide an excel dialect that can handle this.
Also, there are UTF-8 issues.

I've chosen to remove the city fields. They're not used in any analysis.

numreferalls and numsuccessfulreferalls are null in the users - ie. all zero.

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



