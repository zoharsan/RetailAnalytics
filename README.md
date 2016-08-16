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

## Data Cleansing and Ingestion Running Apache Pig

The script [RetailSalesIngestion.pig](https://github.com/zoharsan/RetailAnalytics/blob/master/RetailSalesIngestion.pig) runs data cleansing and transformation by:
* Filtering out the header
* Make the timestamp format consumable by Hive by adding the seconds field.
* Add a column with the Total Price for a line item (Quantity * Unit Price).

The script will copy the data under a new HDFS subdirectory /user/admin/retail/retailsalesclean which can be mapped onto a Hive table.
