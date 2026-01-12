# inventory-analytics-pipeline
OVERVIEW: 
---
Inventory data cleaning, SQL normalization, and R visualization project. Demonstrates Excel preprocessing, MySQL data modeling and SQL transformations, and data analysis in R using tidyverse and ggplot2.
The goal of the project is to showcase practical data analyst skills, including data cleaning, SQL database design, data normalization, and exploratory data analysis (EDA) using real-world inventory data.
---------------------------------------------------------------------------------------------------------------
Note: All datasets in this repository are simliar to but not actual company data. This is to preserve data structure while removing proprietary information. This was accomplished by scaling the data linearly and then adding a little random noise to each order and on hand value (thru is then calculated based on those two new values). Therefore all of the trends represented in plots will maintain the same shape just at a different scale.
---------------------------------------------------------------------------------------------------------------
PROJECT ORDER:
Here's the order this projects folders should be viewed in:
- data
  - unclean
  - data
- sql
- r
- plots

IN DEPTH DESCRIPTION:
---
Inventory Data Cleaning, SQL Normalization, and R Visualization:

1.) Tools and Technologies:

- Excel for initial data cleaning and preprocessing
- MySQL/SQL for database creation, table design, and data normalization/validation 
- R for data analysis and visualization (tidyverse, dplyr, and ggplot2)
  
2.) Workflow Summary:

a.) Excel Preprocessing:
- Removed unnecessary header rows and unused fields
- Standardized column names with "snake_case"
- Cleaned inconsistent formatting and obvious data errors
- Prepared data for database ingestion by creating final column that creates the sql insert statements which can be copy-pasted into sql

b.) SQL Database Creation and Data Ingestion:
- Created a MySQL database and table structure
- SQL Data Cleaning and Normalization (explained in detail in the sql file)
- Updated numeric columns to set invalid negative values to NULL
- Replaced NULL values in weekly order columns with 0 
- Removed remaining invalid or unwanted rows that were missed in excel
  
c.) Import Into R:
- Imported two years of cleaned inventory data into R as data frames
- Exported inventory data-frames as csv files as backups
- Performed needed data transformations that were essential for many plots (wide to long format)
- Exploratory Data Analysis and Visualization
- Using R and the tidyverse, multiple visualizations were created to explore trends and patterns, including:
  * Bar charts identifying top and bottom inventory movers
  * Scatter plots examining relationships between inventroy demand, stock and order values
  * Boxplots for distribution analysis and outlier detection
  * Year-over-year comparisons for specific products
  * Many plots were made, but the most useful plots derived are available in the plots directory.

3.) Key Skills Demonstrated:

- Real-world data cleaning and preprocessing
- SQL database design and normalization
- Writing and executing UPDATE and DELETE queries
- End-to-end workflows (Excel to SQL to R)
- Exploratory data analysis
- Data visualization and trend analysis
- Communicating insights through various plots
