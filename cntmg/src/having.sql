-- MariaDB
-- Using this example database https://www.mysqltutorial.org/

-- Some simplifying views

create view vorders as select orderNumber, sum(priceEach * quantityOrdered) as price from orderdetails group by orderNumber ;

create view vorders1 as
  select v.orderNumber, o.orderDate, v.price
    from vorders v
         inner join orders as o
             on o.orderNumber = v.orderNumber ;

-- Fake a current date function that works on this dataset.

delimiter $$
  create function getdate() returns date
  reads sql data
  begin
    return (select max(orderDate) from orders);
  end;
$$
delimiter ;

-- Check that works

select o.customerNumber, v.orderNumber, v.price
  from vorders1 v
       inner join orders o
           on o.orderNumber = v.orderNumber 
 where year(v.orderDate) = year(getdate()) ;

-- Final query using one having clause

select o.customerNumber, count(o.customerNumber) n
  from vorders1 v
       inner join orders o
           on o.orderNumber = v.orderNumber 
 where year(v.orderDate) = year(getdate())
 group by o.customernumber
having min(price) > 30000;

                                                                      on c.customerNumber = o.customerNumber ;
