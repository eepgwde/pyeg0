truncate table trns;
\! date
\copy trns FROM 'cache/in/transactions.csv2' WITH DELIMITER ',' CSV HEADER;
\! date
