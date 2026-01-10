# inventory-analytics-pipeline
OVERVIEW: 
---
End-to-end inventory data cleaning, SQL normalization, and R visualization project. Demonstrates Excel preprocessing, MySQL data modeling, SQL transformations, and data analysis in R using tidyverse and ggplot2.
The goal of the project is to showcase practical data analyst skills, including data cleaning, SQL database design, data normalization, and exploratory data analysis (EDA) using real-world style inventory data.
---------------------------------------------------------------------------------------------------------------
Note: All datasets in this repository are simliar to but not actual company data. This is to preserve data structure while removing proprietary information. This was accomplished by scaling the data linearly and then adding a little random noise to each order and on hand value (thru is then calculated based on those two new values). Therefore all of the trends represented in plots will maintain the same shape just at a differemt scale.
---------------------------------------------------------------------------------------------------------------
IN DEPTH DESCRIPTION:
---
Inventory Data Cleaning, SQL Normalization, and R Visualization:

1.) Tools and Technologies:

- Excel for initial data cleaning and preprocessing
- MySQL for database creation, table design, and data normalization
- SQL for data ingestion, transformation, and validation
- R for data analysis and visualization (tidyverse, dplyr, and ggplot2)
  
2.) Workflow Summary:

a.) Excel Preprocessing:
- Removed unnecessary header rows and unused fields
- Standardized column names using camelCase
- Cleaned inconsistent formatting and obvious data errors
- Prepared data for database ingestion

b.) SQL Database Creation and Data Ingestion:
- Created a MySQL database and table structure
- Converted Excel data into SQL INSERT statements
- Inserted a wide inventory dataset (approximately 135 columns by 124 rows)
- SQL Data Cleaning and Normalization
- Updated numeric columns to set invalid negative values to NULL
- Replaced NULL values in weekly order columns with 0
- Removed remaining invalid or unwanted rows
- Ensured data consistency and readiness for analysis
  
c.) Import Into R:
- Imported two years of cleaned inventory data into R as data frames
- Performed additional data type checks and transformations
- Prepared datasets for comparative analysis
- Exploratory Data Analysis and Visualization
- Using R and the tidyverse, multiple visualizations were created to explore trends and patterns, including:
  * Bar charts identifying top and bottom inventory movers
  * Scatter plots examining relationships between inventory and usage
  * Boxplots for distribution analysis and outlier detection
  * Year-over-year comparisons for specific products
  * Most useful plots derived are available in the plots directory.

3.) Repository Structure:

inventory-analytics-pipeline/
│
├── data/
│   ├── bar_inventory_2023.csv
│   ├── bar_inventory_2024.csv
│
├── sql/
│   └── bar_inventory.sql
│
├── r/
│   └── bar_inventory.R
│
├──plots/
│	├── 2023_v_2024_Comparison_Plots/
│	|    ├── Scatter_Plots/
│	|    │   ├── Bacardi_Limon.png
│	|    │   └── Strawberry_vs_Pink_Lemonade.png
│	|    └── Vertical_Bar_Plot/
│	|        └── On_Hand_Comparison.png
│	├── Box_and_Whisker_Plots/
│	|    ├── Beer_and_Seltzers/
│	|    │   ├── Order/
│	|    │   │   ├── 2023.png
│	|    │   │   └── 2024.png
│	|    │   └── Thru/
│	|    │       ├── 2023.png
│	|    │       └── 2024.png
│	|    └── Top_Liquor/
│	|        ├── Order/
│	|        │   ├── 2023.png
│	|        │   └── 2024.png
│	|        └── Thru/
│	|            ├── 2023.png
│	|            └── 2024.png
│	└── Scatter_Plots/
│	     ├── Categorized_Products/
│	     │   ├── Vodkas_2023.png
│	     │   └── Vodkas_2024.png
│	     └── Individual_Products/
│	         ├── Titos_2023.png
│	         └── Titos_2024.png
│
└── README.md

4.) Key Skills Demonstrated:

Real-world data cleaning and preprocessing
SQL database design and normalization
Writing and executing UPDATE and DELETE queries
End-to-end ETL workflows (Excel to SQL to R)
Exploratory data analysis
Data visualization and trend analysis
Communicating insights through charts and summaries
