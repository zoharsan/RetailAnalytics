--Clean-up HDFS
rmf /user/admin/retail/marketbaskets

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
BasketsRawN = FILTER InputFile BY (InvoiceNo is not null OR StockCode is not null);
BasketsRawE = FILTER BasketsRawN BY NOT (StockCode == ' ' 
					OR StockCode == 'DOT' 
                                        OR StockCode == 'POST' 
                                        OR StockCode == 'BANK' 
                                        OR StockCode == 'M'
                                        );
BasketsRaw = FOREACH BasketsRawE GENERATE InvoiceNo, 
					  SUBSTRING(StockCode,0,4) as (StockCat:chararray);
BasketsRaw1 = FILTER BasketsRaw BY NOT ( StockCat == '8509');
BasketsRawU = DISTINCT BasketsRaw1;
BasketsGroupR1 = GROUP BasketsRawU by InvoiceNo;
BasketsGroupR2 = FOREACH BasketsGroupR1 GENERATE group as IN, BasketsRawU as Bkt;
BasketsGroupR3 = FILTER BasketsGroupR2 BY SIZE(Bkt) > 1 AND SIZE(Bkt) < 10;
MarketBaskets = FOREACH BasketsGroupR3 GENERATE FLATTEN(BagToTuple(Bkt.StockCat));

-- Storing Market Baskets                                                    
STORE MarketBaskets into '/user/admin/retail/marketbaskets' using PigStorage (',');
