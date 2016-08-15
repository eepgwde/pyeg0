select version(), current_date;

select * from trans;

select * from cmpl2;

set @doff=1;

drop function fAmount1;
delimiter //
create function fAmount1 (str0 VARCHAR(255))
returns decimal
begin
 declare str1 VARCHAR(255);
 set str1 = substr(str0 from 1+locate('£', str0));
 return convert(substring_index(str1, ' ', 1), decimal);
end //
delimiter ;

drop view vwCmpl21;
create view vwCmpl21 as select c.source_complaint_id as id
, fAmount1(Comment_tx) as amount1
from cmpl2 c;

drop view vwCmpl20;
create view vwCmpl20 as select c.source_complaint_id id
, date_add(c.date_created, interval 2 day) as 'udt'
, c.date_created as 'dt'
, date_sub(c.date_created, interval 2 day) as 'ldt'
, (1+0.05) * v.amount1 as v1u
, v.amount1 as v1
, (1-0.05) * v.amount1 as v1l
from cmpl2 c left join vwCmpl21 v on c.source_complaint_id = v.id;

select c2.party_id, t.event_id, c2.source_complaint_id
, v0.udt
, c2.date_created
, t.start_dt
, v0.ldt
, t.amount0
, c2.Comment_tx
from trans t left join cmpl2 c2 on c2.party_id = t.party_id
  left join vwCmpl20 v0 on c2.source_complaint_id = v0.id
  and t.start_dt <= v0.udt and t.start_dt >= v0.ldt
  and t.amount0 <= v0.v1u and t.amount0 >= v0.v1l ;
