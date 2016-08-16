-- Cleanup HDFS directory
rmf /user/admin/retail/retailsalesclean
rmf /user/admin/retail/georevenue

-- Loading raw data
InputFile = LOAD '/user/admin/retail/retailsalesraw/OnlineRetail.txt' using PigStorage('\t') 
				 as (	InvoiceNo: int,
                 			StockCode: chararray,
                        		Description: chararray,
                	 		Quantity: int,
                        		InvoiceDate: chararray,
                        		UnitPrice: float,
                        		CustomerID: int,
                        		Country: chararray);
-- Cleansing File                        
RetailSalesRaw = filter InputFile BY NOT (InvoiceDate matches 'InvoiceDate');
RetailSalesClean = FOREACH RetailSalesRaw GENERATE 	InvoiceNo,
							StockCode,
                                                    	Description,
                                                    	Quantity,                                                
                                                    	CONCAT(InvoiceDate,':00') as (InvoiceDate:chararray),
                                                    	UnitPrice,
                                                    	ROUND(UnitPrice * Quantity * 100f)/100f as (TotalPrice: float),
                                                    	CustomerID,
                                                    	Country;
-- Storing Cleansed File                                                    
STORE RetailSalesClean into '/user/admin/retail/retailsalesclean' using PigStorage ('\t');

-- Generate Overall Sales Aggregate and Sales for top 10 countries
GeoGroup = group RetailSalesClean by Country;
GeoRevenue  = foreach GeoGroup generate group, ROUND(SUM(RetailSalesClean.TotalPrice)) as TotalRevenueByCountry;
GeoRevenueDesc = ORDER GeoRevenue BY TotalRevenueByCountry DESC;
Top10GeoRevenue = LIMIT GeoRevenueDesc 10;

STORE Top10GeoRevenue into '/user/admin/retail/georevenue' using PigStorage ('\t');
