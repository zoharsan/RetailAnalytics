# Retail Sales Analytics Demo
## Overview
This demo illustrates retail analytics using an online retail dataset containing transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail. This dataset is used to demonstrate an end-to-end retail analytic use case on the Hortonworks Data Platform distribution:

* Data ingestion and cleansing using Apache Pig, 
* SQL on Hadoop using Hive
* Analytics and visualization using SparkSQL on Apache Zeppelin
* Market Basket Analysis using SparkMLLib on Apache Zeppelin

The following diagram represents the overview of the demo:

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailAnalyticsOverview.jpg "Retail Analytics Demo Overview")

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

## Hive Tables

Two Hive tables are created. Sample data from these tables can be shown through the Ambari Hive view:

- [RetailSalesRaw](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSalesRaw.ddl) allows to read the Hive table through SQL and can be used to do similar transformations as done with the Pig scripts. The SQL code is not provided.
- [RetailSales](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSales.ddl) reads the cleansed data from the previous Pig scripts and will be used to query through SparkSQL for Retail Analytics.

## Retail Analytics using SparkSQL

Apache Zeppelin is used for creating a Retail Analytics Notebook to run SparkSQL queries (using %sql interpreter) and visualizing data. 
* Make sure the Apache Zeppelin Notebook is started from the Ambari Dashboard. If not, start it. Zeppelin is installed by default on the HDP 2.4 sandbox.
* Go to the Zeppelin main URL at http://127.0.0.1:9995/#/
* Create a New Notebook called Retail Sales Analytics

[RetailSalesAnalytics.sql](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailAnalytics.sql) contains all the sql necessary to create the visualizations. Below are all the screenshots for the notebook:

### Revenue by Country

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/RevenueByCountry.png "Revenue By Country")

### Daily and Hourly Sales Activity

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/DailyHourlySalesActivity.png "Daily and Hourly Sales Activity")

### Market Basket Analysis

![alt text](https://github.com/zoharsan/RetailAnalytics/blob/master/MarketBasketAnalysis.png "Market Basket Analysis")



