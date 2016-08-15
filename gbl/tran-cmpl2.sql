drop table cmpl2;
drop table trans;

create table cmpl2 (
party_id INT,
date_created DATE,
source_complaint_id INT,
Comment_tx VARCHAR(50)
);

create table trans (
party_id INT,
start_dt DATE,
event_id INT,
amount0 DECIMAL(19,2)
);

load data infile '/misc/build/0/pyeg0/gbl/cmpl2.csv'
into table cmpl2
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(
	party_id,
	date_created,
	source_complaint_id,
	Comment_tx
);

load data infile '/misc/build/0/pyeg0/gbl/trans.csv'
into table trans
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(
	party_id,
	start_dt,
	event_id,
	amount0
);

