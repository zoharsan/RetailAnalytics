# Retail Sales Analytics Demo
## Overview
This demo illustrates retail analytics using an online retail dataset containing transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail. This dataset is used to demonstrate an end-to-end retail analytic use case on the Hortonworks Data Platform distribution:

* Data ingestion and cleansing using Apache Pig, 
* SQL on Hadoop using Hive
* Analytics and visualization using SparkSQL on Apache Zeppelin
* Market Basket Analysis using SparkMLLib on Apache Zeppelin

The following diagram represents the overview of the demo:

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSalesAnalyticsDiagram.jpg "Retail Analytics Demo Overview")

## Data set

The original Online Retail data set is available to download on the [UCI Machine Learning Repository] (https://archive.ics.uci.edu/ml/datasets/Online+Retail). It has been converted using Microsoft Excel to a tab delimited file available for convenience in the current repository as [OnlineRetail.txt.zip] (https://github.com/zoharsan/RetailAnalytics/blob/master/OnlineRetail.txt.zip).

## Prerequisites

* [Download](http://hortonworks.com/downloads/#sandbox) the HDP Sandbox 2.4 or higher.
* [Learning the ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) is a great resource to get started.
* This demo runs as admin, and will require setting-up the admin credentials using the previous link. 
* Upload the [Online Retail dataset](https://github.com/zoharsan/RetailAnalytics/blob/master/OnlineRetail.txt.zip) after unzipping to HDFS on the sandbox at the location **/user/admin/retail/retailsalesraw**. You can quickly create all the subdirectories under **/user** using the HDFS Ambari view. These paths are used in the different pig, hive, and spark scripts. You can customize these locations.

## Data Preparation using Apache Pig

### Data Ingestion, Cleansing and Aggregation

The script [RetailSalesIngestion.pig](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSalesIngestion.pig) runs data cleansing and transformation by:
* Filtering out the header
* Make the timestamp format consumable by Hive by adding the seconds field.
* Add a column with the Total Price for a line item (Quantity * Unit Price).

The script will copy the data under a new HDFS subdirectory **/user/admin/retail/retailsalesclean** which can be mapped onto a Hive table.

The second part of the script aggregates the total revenue by country and store the results in a new HDFS subdirectory **/user/admin/retail/georevenue**. This snippet illustrates the difference in paradigm between a Pig transformation and SQL through Hive.


### Data Preparation for Market Basket Analysis

The script [MBADataPrep.pig](https://github.com/zoharsan/RetailAnalytics/blob/master/MBADataPrep.pig) does data preparation and builds the market baskets for the Spark MLlib FPGrowth association algorithm. The following steps are run to prepare the market baskets:

* The baskets are built by stockcodes grouped by InvoiceNo.
* Since the data set does not have any item category (Eg, a red alarm clock versus alarm clock category), an item category is built by truncating the last character in the stockcode. Looking at the data set, it seems an acceptable assumption for most items.
* Some generic stockcodes or stockcodes not corresponding to actual items are filtered out.
* Stockcodes in each basket are deduplicated.
* Baskets are filtered out by size, keeping only baskets with more than 1 item and less than 10 items.

Alternatively, the data preparation could be done using Spark.

## Hive Tables

Two Hive tables are created. Sample data from these tables can be shown through the Ambari Hive view:

- [RetailSalesRaw](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSalesRaw.ddl) allows to read the raw data as-is through SQL and can be used to do similar transformations as done with the Pig scripts. The SQL code is not provided.
- [RetailSales](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSales.ddl) reads the cleansed data from the previous Pig scripts and will be used to query through SparkSQL for Retail Analytics.

## Retail Analytics using SparkSQL

Apache Zeppelin is used for creating a Retail Analytics Notebook to run SparkSQL queries (using %sql interpreter) and visualizing data. 
* Make sure the Apache Zeppelin Notebook is started from the Ambari Dashboard. If not, start it. Zeppelin is installed by default on the HDP 2.4 and HDP 2.5 sandbox.
* Go to the Zeppelin main URL at http://127.0.0.1:9995/#/
* You can import the Notebook (Tested on HDP 2.5):
  * This Notebook is corresponding to [RetailSalesAnalytics.json](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSalesAnalytics.json). Download it to your workstation.
  * Click on **Import Notebook** on the Zeppelin main page
  * Click on the Tile 'Choose a JSON here'
  * Select the RetailSalesAnalytics.json file previously downloaded.
* Alternatively, you can create the Notebook if you can't import the existing json file. Create a New Notebook called Retail Sales Analytics



[RetailSalesAnalytics.sql](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailAnalytics.sql) contains all the sql necessary to create the visualizations. Note that %sql invokes the SparkSQL interpreter in Zeppelin.

Below are all the screenshots for the notebook:

### Revenue by Country

The pie chart below shows the distribution of revenue per country for the top 5 countries purchasing online. The table below shows a drill down on the number of customers, transactions, the average size of the basket and metrics on the amount of purchases. It appears clearly that **United Kingdom** is the main source of revenue, with the largest customer base, and the largest Number of transactions.

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/RevenueByCountry.png "Revenue By Country")

### Daily and Hourly Sales Activity

The two following graphs show the daily sales activity over the year, and per hour of the day. It is interesting to note that the most active day was on day 336 of the year 2010, which is December 2nd 2010. The hourly activity shows that the peak hours are 10 am to 3 pm, with a peak at 12pm-1pm during lunch break with 3220 visits during that hour.

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/DailyHourlySalesActivity.png "Daily and Hourly Sales Activity")

### Market Basket Analysis

The first graph shows the basket size distribution. It appears that most customers mostly purchase a single item from the website, but a few customers are actually buying many items from 20 to 40 items. The second graph shows the top 20 popular items.

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/MarketBasketAnalysis.png "Market Basket Analysis")

### Customer LifeTime Value

The histogram below represents the distribution of customer life value by intervals of 1000 GBP for the customer base.

![alt text] (https://github.com/zoharsan/RetailAnalytics/blob/master/CustomerLifeTimeValue.png "Customer LifeTime Value")

## Market Basket Analysis using Spark MLLib

The Spark MLLib library is used to perform a market basket analysis using the [FP Growth](https://en.wikipedia.org/wiki/Association_rule_learning#FP-growth_algorithm) association rule mining algorithm available with Spark MLLib. The [MBAFPGrowth.scala](https://github.com/zoharsan/RetailAnalytics/blob/master/MBAFPGrowth.scala) is a scala implementation of the algorithm which reads the output of the [data preparation in the Apache pig script](https://github.com/zoharsan/RetailAnalytics/blob/master/MBADataPrep.pig).

As you can notice in the parameters of the model, the Minimum support is set to 0.7% to be able to have a relevant most frequent itemset for this data set. The confidence level is set to 80%. This can be subject to further tweaking.

Create a new notebook called Market Basket Analysis, and copy the [MBAFPGrowth.scala](https://github.com/zoharsan/RetailAnalytics/blob/master/MBAFPGrowth.scala) code into it. This notebook is corresponding to [MarketBasketAnalysis.json](https://github.com/zoharsan/RetailAnalytics/blob/master/MarketBasketAnalysis.json).

When you run it, you should see first the list of the frequent itemset, followed by the association rules found with a confidence level higher than 80%:

> minConfidence: Double = 0.8
>
> [2319,2238] => [2320], 0.8857142857142857
>
> [2266,2072] => [2238], 0.8571428571428571

By looking at items with StockCodes:
* Starting with 2319, most of these items are notepads, shopping lists, notebooks. 
* Starting with 2238, items are mostly lunch bags.
* Starting with 2320, items are jumbo grocery bags.

We can deduct that customers purchasing notepads/notebooks and lunch bags purchase as well the grocery bags more than 88% of the time.

The following SQL query can show these item types:

> %sql
>
>select distinct stockcode, description from retailsales where stockcode like '2319%' or stockcode like '2238%' 
> or stockcode like '2320%' 
> or stockcode like '2266%'
> or stockcode like '2072%' 
> and description <> '' and description not like '%com%' and description not like 'mailout%' and description not like 'damaged%' order by stockcode asc

Please note that the assumption is not 100% valid in terms of trying to deduct an item category from the first 4 digits of the Item code, but reasonable enough for the purpose of the exercise. Ideally, it would take a dataset with an item category. Another possibility is to run it with the full stockcode, it will show more precise associations between individual items. However, by being specific to the item, It requires to use a much lower minimum support, and provide association rules for much less frequent baskets.





