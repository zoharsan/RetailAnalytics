DROP TABLE RetailSalesRaw;
CREATE EXTERNAL TABLE IF NOT EXISTS RetailSalesRaw(
  InvoiceNo bigint,
  StockCode string,
  Description string,
  Quantity int,
  InvoiceDate string,
  UnitPrice double,
  CustomerID int,
  Country string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "\t"
LOCATION "/user/admin/retail"
tblproperties ("skip.header.line.count"="1");
