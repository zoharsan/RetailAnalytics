DROP TABLE RetailSales;
CREATE EXTERNAL TABLE IF NOT EXISTS RetailSales(
  InvoiceNo bigint,
  StockCode string,
  Description string,
  Quantity int,
  InvoiceDate timestamp,
  UnitPrice double,
  TotalPrice double,
  CustomerID int,
  Country string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LOCATION "/user/admin/retail/retailsalesclean";
