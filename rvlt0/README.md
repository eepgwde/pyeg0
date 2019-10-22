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



