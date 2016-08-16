# Retail Sales Analytics Demo
## Overview
This demo illustrates retail analytics using an online retail dataset containing transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail. This dataset is used to demonstrate an end-to-end retail analytic use case on the Hortonworks Data Platform distribution:

* Data ingestion and cleansing using Apache Pig, 
* SQL on Hadoop using Hive
* Analytics and visualization using SparkSQL on Apache Zeppelin
* Market Basket Analysis using SparkMLLib on Apache Zeppelin

## Data set

The original Online Retail data set is available to download on the [UCI Machine Learning Repository] (https://archive.ics.uci.edu/ml/datasets/Online+Retail). It has been converted using Microsoft Excel to a tab delimited file available for convenience in the current repository as [OnlineRetail.txt.zip] (https://github.com/zoharsan/RetailAnalytics/blob/master/OnlineRetail.txt.zip).

## Prerequisites

* [Download](http://hortonworks.com/downloads/#sandbox) the HDP Sandbox 2.4 or higher.
* The [Learning the ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) is a great resource to get started.
* This demo runs as admin, and will require setting-up the admin credentials using the previous link. 
* Upload the [Online Retail dataset](https://github.com/zoharsan/RetailAnalytics/blob/master/OnlineRetail.txt.zip) after unzipping to HDFS on the sandbox at the location **/user/admin/retail**. You will have to create both **/user/admin** and **/user/admin/retail** subdirectories using the HDFS Ambari view. These are the path used in the different pig, hive, and spark scripts. You can customize these locations.


