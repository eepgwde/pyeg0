select version(), current_date;

select * from trans;

select * from cmpl2;

set @doff=1;

drop function fAmount1;
create function fAmount1 (str0 VARCHAR(255))
returns decimal
begin
 declare str1 VARCHAR(255);
 set str1 = substr(str0 from 1+locate('£', str0));
 return convert(substring_index(str1, ' ', 1), decimal);
end

drop view vwAmount1;
create view vwAmount1 as
select v0.cid as id
, convert(substring_index(v0.v, ' ', 1), decimal) as amount1
from (select source_complaint_id as id,
     substr(Comment_tx from 1+locate('£', Comment_tx)) as v from cmpl2) as v0;

drop view vwCmpl20;
create view vwCmpl20 as select c.source_complaint_id
, date_add(c.date_created, interval 2 day) as 'udt'
, c.date_created
, date_sub(c.date_created, interval 2 day) as 'ldt'
from cmpl2 c left join 

select c.party_id, t.event_id, c.source_complaint_id
, udt
, c.date_created
, t.start_dt
, ldt
, t.amount0
, c1.Comment_tx
from vwCmpl20 c left join trans t on c.party_id = t.party_id and t.start_dt <= c.udt and t.start_dt >= c.ldt
left join cmpl2 c1 on c.source_complaint_id = c1.source_complaint_id;
