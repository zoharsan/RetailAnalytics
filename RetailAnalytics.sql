%sql
-- Revenue Aggregate By Country for top 5 countries
select Country, ceil(sum(totalprice)) as RevenueByCountry
from retailsales
where totalprice > 0
group by Country
order by  RevenueByCountry desc
limit 5

%sql
-- Sales Metrics by country for top 5 countries
WITH InvoiceAmount AS (Select country, customerid, invoiceno, count(distinct Stockcode) as NumItems, sum(totalprice) as InvoiceTotal from retailsales where totalprice > 0 and Country in ('United Kingdom','Netherlands','EIRE','Germany','France') group by country,invoiceno,customerid)
select Country, count(distinct customerid) as NumCustomers, count(distinct invoiceno) as NumTransactions, ceil(avg(NumItems)) as AvgNumItems, ceil(min(InvoiceTotal)) as MinAmtperCustomer, ceil(max(InvoiceTotal)) as MaxAmtperCustomer, ceil(avg(InvoiceTotal)) as AvgAmtperCustomer, ceil(std(InvoiceTotal)) as StdDevAmtperCustomer from InvoiceAmount
group by Country
order by NumCustomers desc

%sql
-- Daily Sales Activity per POSIX day of the year
with DailySales as (select dayofyear(Invoicedate) as DayOfYear,Invoiceno, totalprice from retailsales where totalprice > 0 and Invoicedate > '2010-11-31' and Invoicedate < '2011-12-01')
select DayOfYear, count(distinct Invoiceno) as NumVisits, ceil(sum(totalprice)) as TotalAmt from DailySales group by DayOfYear order by DayOfYear

%sql
-- Hourly sales Activity per hour of day
with HourlySales as (select hour(Invoicedate) as HourDay,Invoiceno, totalprice from retailsales where totalprice > 0)
select HourDay, count(distinct Invoiceno) as NumVisits, ceil(sum(totalprice)) as TotalAmt from HourlySales group by HourDay order by HourDay

%sql
-- Basket size distribution
with ItemsDist as (select invoiceno, count(distinct Stockcode) as NumItems from retailsales group by invoiceno)
select NumItems, count(NumItems) as CountNumItems from ItemsDist group by NumItems order by NumItems asc

%sql
-- Top 20 Items sold by frequency
select Description, count(Stockcode) as ItemFrequency from retailsales where totalprice > 0  group by Description order by ItemFrequency desc limit 20

%sql
-- Customer Lifetime Value distribution by intervals of 1000 GBPs
with CLV as (select customerid, count(distinct invoiceno) as NumTransactions, ceil(sum(totalprice)/1000)*1000 as CustomerLifeValue from retailsales where customerid is not null and totalprice > 0 group by customerid)
select distinct CustomerLifeValue, count(CustomerLifeValue) as NumCustomers from CLV group by CustomerLifeValue order by CustomerLifeValue asc
