# inventory-analytics-pipeline
### OVERVIEW: 

Inventory data cleaning, SQL normalization, and R visualization project. Demonstrates Excel preprocessing, MySQL data modeling and SQL transformations, and data analysis in R using tidyverse and ggplot2.
The goal of the project is to showcase practical data analyst skills, including data cleaning, SQL database design, data normalization, and exploratory data analysis (EDA) using real-world inventory data.

> Note: All datasets in this repository are simliar to but not actual company data. This is to preserve the data structure while removing proprietary information. This was accomplished by scaling the data linearly and then adding a little random noise to each order and on hand value (thru is then calculated based on those two new values). Therefore all of the trends represented in plots will maintain the same shape just at a different scale.

-------
### PROJECT ORDER:

Here's the order this projects folders should be viewed in:
- data
  - `1 Original Inventory` (data hidden but table structure visible)
  - `2 Uncleaned but Preped for SQL` (linearly scaled data with small random noise visible with other normalization before transferring to MySQL)
- sql
  - `bar_inventory.sql`
- data
  - `3 Cleaned after SQL`
- r
  - bar_inventory
  - `r_2023_long.csv` (just to understand what the long form of the data-frame looks like)
  - `r_2024_long.csv` (just to understand what the long form of the data-frame looks like)
- plots

IN DEPTH DESCRIPTION:
---
Inventory Data Cleaning, SQL Normalization, and R Plot Creation and Visualization:

### 1.) Tools and Technologies:

- Excel for initial data cleaning and preprocessing
- MySQL/SQL for database creation, table design, and data normalization/validation 
- R for data analysis and visualization (tidyverse, dplyr, and ggplot2)
  
### 2.) Workflow Summary:

**a.) Excel Preprocessing:**
- Removed unnecessary header rows and unused fields
- Standardized column names with "snake_case"
- Cleaned inconsistent formatting and obvious data errors
- Prepared data for database ingestion by creating final column that creates the sql insert statements which can be copy-pasted into sql

**b.) SQL Database Creation and Data Ingestion:**
- Created a MySQL database and table structure
- SQL Data Cleaning and Normalization (explained in detail in the sql file)
  - Updated numeric columns to set invalid negative values to NULL
  - Replaced NULL values in weekly order columns with 0 
  - Removed remaining invalid or unwanted rows that were missed in excel
  - etc...
  
**c.) Import Into R:**
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

### 3.) Key Skills Demonstrated:

- Real-world data cleaning and preprocessing
- SQL database design and normalization
- Writing and executing UPDATE and DELETE queries
- End-to-end workflows (Excel to SQL to R)
- Exploratory data analysis with data visualization and trend analysis


Visualization and Conclusions:
---
After creating the plots and viewing them, many conclusions can be drawn that would be cumbersome or near impossible to draw from looking at the original inventory sheets:
  - Ordered representation of which products sell more per week and by how much (Box and Whisker Plots)
  - How spread the data is per product for both ordering and throughput values, and if there are outliers (Box and Whisker Plots)
  - The seasonal demand trends for specific products (Scatter Plots)
  - If a product is over/under stocked, or over/under ordered (Scatter Plots)
  - If a product is over/under performing itself or its replacment from the following year (23/24 Comparison Scatter Plots)

    
  Specific Conclusions Drawn from Some of the Plots:
  ---
  * **1.)** 2023 v 2024 Comparison Plots / Scatter Plots / `Bacardi Limon.png`:
    * **Observations:** The 2023 trendline is relatively flat, while the 2024 trendline forms a distinct "bell curve" peak during the mid-summer months (June/July). The average weekly sales jumped from 28 bottles to 39 bottles. The standard deviation, rising from 20 bottles/week to 29 bottles/week.
   
    *  **Conclusions:** In 2023, demand was inconsistent; in 2024, we can see there was a definative "peak season". This provides us with a predictive model for 2025.Furthermore, the demand has shifted from sporadic, low-volume sales to a much higher baseline, suggesting that 2024 marketing or distribution strategy successfully reached a larger audience. Finally, since we were selling more, the demand is also more erratic than it was last year. Because the standard deviation is high relative to the average, we need to maintain higher safety stock during the peak season to avoid running out of this product.
   

  * **2.)** 2023 v 2024 Comparison Plots / Vertical Bar PLot / `On Hand Comparison.png`:
    * **Observations:** It can be seen that **in 2024 we did a much better job getting rid of a few products than we did in 2023 by the end of the season**: liqueurs, cases of canned alcoholic seltzers, tequilas, vodkas, whiskeys, red wines, and white wines. Conversly, a few products were not as successfully sold off by the end of the season: frozen mixes, gin, cases of redbulls, and rums. Finally, cases of beer, kegs, and fortified wines were sold off at approximately the same rate.
   
    *  **Conclusions:** The goal is to have a little product left over as possible by the end of a season because **product not sold is money lost**. From this plot we can conclude that the business did a much better job selling off product in 2024 than it did in 2023: 616 less bottles of liquer in stock, 57 less cases of canned alcoholic seltzers, and 220 less bottles of wine. As far as the products that were not sold off as successfully: 24 extra bottles of frozen mixes, 34 bottles of gin, 15 caes of redbulls, and 84 bottles of rum. **In total, 2024 saw 718 less bottles of alcohol, 24 less bottles of frozen mixes, and 57 less cases of canned bverages (seltzers vs redbulls). That's a lot less money lost and a lot of storage space saved for the end of the season.** 


  * **3.)** Box and Whisker PLots / Beer and Seltzers / Thru / `2024.png`:
    * **Observations:** There is a **vast difference in product weekly throuput**: top-tier brands like Surf Side and Corona drive significantly higher median throughput and exhibit substantial volatility (wide interquartile ranges), whereas the majority of lower-ranked products display consistently tight, low-volume sales patterns.
   
    *  **Conclusions:** This **patterned distribution allows us to selectively manage our inventory by product**: you must apply quick, responsive restocking for the high-volume, high-variance products to capitalize on demand spikes without runningout of stock, while applying reserved inventory controls to the long tail of low-volume products to minimize unnecessary holding costs.


  * **4.)** Box and Whisker PLots / Top Liquer / Order / `2024.png`:
    * **Observations:** Unlike the more stable categories, **our top-tier spirits—specifically Casamigos Blanco, Rack Vodka, and Rack Tequila—display significant volatility**, characterized by wide interquartile ranges and frequent extreme positive outliers, indicating that order volumes are not consistent but subject to massive, sporadic spikes.
   
    *  **Conclusions:** Because our highest-volume liquor products are prone to unpredictable demand surges rather than steady, reliable consumption, **we must shift away from ordering based on average weekly volume toward a dynamic safety stock model**; failure to do so will result in stockouts during the outlier high-demand weeks visualized in the plot.


  * **5.)** Scatter Plots / Categorized Products / `Vodkas_2023.png`:
    * **Observations:** The "On Hand" (OH) curve (red) remains significantly above the seasonal maximum threshold (solid red line) during the early-season peak and fails to converge with the end-of-season target (dashed red line) by October, sitting at roughly 500 bottles when the goal is closer to 100.
   
    *  **Conclusions:** This visual gap confirms that **Vodkas were aggressively overstocked early in the season and replenishment (Order curve) was not throttled back quickly enough** to prevent the substantial surplus seen at the end of the year; future procurement must be more "Thru-driven" to ensure the OH curve tracks downward as the season closes.


  * **6.)** Scatter Plots / Individual Products / `Titos_2024.png`:
    * **Observations:** Unlike the general Vodka category, **Tito's inventory (Red curve) was managed with high precision**, peaking just slightly above the seasonal maximum (solid red line) in July and successfully drawing down to hit the end-of-season target (dashed red line) by October. Furthermore, **a massive order spike in late June (green triangle above 312 bottles) was strategically timed to front-load inventory for the July peak**, followed by a sharp tapering of orders after the August milestone (vertical green line) to facilitate a clean sell-through.
   
    *  **Conclusions:** This plot serves as the **"ideal" model for inventory management**; by closely aligning the Order curve with the Thru (demand) curve and initiating a timely drawdown, we **maximized sales during peak weeks while successfully eliminating the risk of carrying expensive "dead stock" into the off-season.**
