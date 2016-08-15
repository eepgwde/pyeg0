select version(), current_date;

select * from trans;

select * from cmpl2;

set @doff=1;

drop view vwCmpl20;
create view vwCmpl20 as select c.party_id, c.source_complaint_id
, date_add(c.date_created, interval 2 day) as 'udt'
, c.date_created
, date_sub(c.date_created, interval 2 day) as 'ldt'
from cmpl2 c;

select c.party_id, t.event_id, c.source_complaint_id, t.start_dt
, udt
, c.date_created
, ldt
from vwCmpl20 c left join trans t on c.party_id = t.party_id and t.start_dt <= c.udt and t.start_dt >= c.ldt ;
