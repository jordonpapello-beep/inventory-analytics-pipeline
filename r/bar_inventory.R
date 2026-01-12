# Load Libraries ----------------------------------------------------------
library(RMySQL)
library(tidyverse)
library(glue)

# Connecting to MySQL Database: -------------------------------------------
con <- dbConnect(RMySQL::MySQL(),
                 host = "localhost", 
                 dbname = "bar_inventory", 
                 user = "root", 
                 password = "************") # Hidden for github

# NOTE: ALL OF THE DATA IN THESE TABLES HAS BEEN ALTERED LINEARLY AND 
#       SLIGHTY RANDOMIZED TO CONCEAL PROPRIETARY COMPANY INFORMATION!

query <- "SELECT * FROM inventory2023"
inventory2023 <- dbGetQuery(con, query) # 2023 Data

query2 <- "SELECT * FROM inventory2024" 
inventory2024 <- dbGetQuery(con, query2)  # 2024 Data


# View Data-Frames: -------------------------------------------------------
View(inventory2023)

View(inventory2024)


# To Export Data-Frames as CSV Files for Back-Ups: ------------------------
write.csv(inventory2023, "/Users/homefolder/Desktop/bar_inventory2023_data.csv",
          row.names = FALSE)

write.csv(inventory2024, "/Users/homefolder/Desktop/bar_inventory2024_data.csv",
          row.names = FALSE)


# Data Transforms: --------------------------------------------------------

# PIVOT LONG: Useful for many plots:

# Most R plots are built around the idea that each row represents a single 
# observation. 
# When dates, thru values, and/or order values are spread across many columns, 
# R cannot easily determine which values belong to the same variable, which 
# makes grouping, filtering, and plotting extremely difficult/impossible.

# The following splits the columns into a "metric", "month", and "day" format

inventory2023_long <- inventory2023 %>%
  pivot_longer(cols = -c(item, 
                         category, 
                         company, 
                         number_per_case), # Don't pivot these columns
               names_to = c("metric", "month", "day"),
               names_pattern = "(\\w+)_(\\w+)_(\\w+)",
               values_to = "amount")

inventory2024_long <- inventory2024 %>%
  pivot_longer(cols = -c(item, 
                         category, 
                         company, 
                         number_per_case), 
               names_to = c("metric", "month", "day"),
               names_pattern = "(\\w+)_(\\w+)_(\\w+)",
               values_to = "amount")



# Plots Section: ----------------------------------------------------------
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~


# Box and Whisker Plots: --------------------------------------------------

# Box-and-whisker plots summarize the distribution of a dataset by showing the 
# median, interquartile range (middle 50%), overall spread of the data, and any 
# potential outliers. 
# Can be filtered to show specific items (products), categories (beer/wine) 
# and/or metrics (order/thru/oh).
# Using them in the way we are below, we are able to compare not only the spread 
# of each products order/thru/oh value side-by-side, but we also get to see them
# ordered (ascending in this case), which tells us what our leading/failing 
# products are.

# Peak Season Whisker Plot Data-Frame 1:
df_box <- inventory2024_long %>%
  filter(metric == "order", 
         item == "Bacardi Limon" | 
         item == "Captain Morgan" |
         item == "Casamigos Blanco" |
         item == "Jack Daniels" |
         item == "Jameson" |
         item == "Malibu" |
         item == "Patron" |
         item == "Peach Schnapps" |
         item == "Rack Rum" |
         item == "Rack Tequila" |
         item == "Rack Vodka" |
         item == "Titos" |
         item == "Triple Sec",
         month < 9 | (month == 9 & day == 3),
         month > 5 | (month == 5 & day == 28)) %>%
  reframe(item, amount, day, month) %>% # similar to summarize(), just without the group()
  group_by(item) %>%
  mutate(median_value = median(amount, na.rm = TRUE)) %>%  # Compute median, ignoring NAs
  ungroup() %>% # Don't perform group opperations anymore
  mutate(item = fct_reorder(item, median_value)) #, .desc = TRUE)) # Specify for desc, ascending is default

# Plot:
ggplot(df_box, aes(x = item, y = amount, fill = item)) +
  geom_boxplot(outlier.size = 3, outlier.colour = "red") +  # Create the box plot
  coord_flip() +
  labs(
    title = "Distribution of Weekly Order Amounts 2024 (Top Liquor Ordered):",
    subtitle = "Organized in Ascending Order of the Median Weekly Order Value: 
    (Peak Season: 5/28 - 9/03)",
    caption = "Outliers in data marked by red dot",
    x = "Product",
    y = "Weekly Order Amount (bottles)"
  ) + 
  theme_minimal() +  # Minimal theme for clean look
  theme(
    plot.title = element_text(face = "bold", size = 30, hjust = .5),
    plot.subtitle = element_text(face = "bold", size = 18, hjust = 0.4),
    plot.caption = element_text(face = "bold", size = 14, hjust = 0),
    axis.title = element_text(face = "bold", size = 20),
    axis.text = element_text(size = 12),
    legend.position = "none"  # Remove the legend
  ) +
  scale_y_continuous(breaks = seq(0, 450, by = 20))  

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

# Peak Season Whisker Plot Data-Frame 2:
df_box2 <- inventory2024_long %>%
  filter(metric == "thru", 
         category == "beer" | category == "seltzer",
         month < 9 | (month == 9 & day == 3),
         month > 5 | (month == 5 & day == 28)) %>%
  reframe(item, amount, day, month) %>% # similar to summarize(), just without the group()
  group_by(item) %>%
  mutate(median_value = median(amount, na.rm = TRUE)) %>%  # Compute median, ignoring NAs
  ungroup() %>% # Don't perform group opperations anymore
  mutate(item = fct_reorder(item, median_value)) #, .desc = TRUE)) # Specify for desc, ascending is default

# Plot:
ggplot(df_box2, aes(x = item, y = amount, fill = item)) +
  geom_boxplot(outlier.size = 3, outlier.colour = "red") +  # Create the box plot
  coord_flip() +
  labs(
    title = "Distribution of Weekly Thru Amounts 2024 (Beer and Seltzers):",
    subtitle = "Organized in Ascending Order of the Median Weekly Thru Value: 
    (Peak Season: 5/28 - 9/03)",
    caption = "Outliers in data marked by red dot",
    x = "Product",
    y = "Weekly Thru Amount (cases)"
  ) + 
  theme_minimal() +  # Minimal theme for clean look
  theme(
    plot.title = element_text(face = "bold", size = 30, hjust = .5),
    plot.subtitle = element_text(face = "bold", size = 18, hjust = 0.4),
    plot.caption = element_text(face = "bold", size = 14, hjust = 0),
    axis.title = element_text(face = "bold", size = 20),
    axis.text = element_text(size = 12),
    legend.position = "none"  # Remove the legend
  ) +
  scale_y_continuous(breaks = seq(0, 450, by = 5))  


# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# Scatter Plots: ----------------------------------------------------------

# Unlike the other plots thus far, these scatter plots enable us to compare all
# of the metrics (i.e. thru/order/oh) of 1 product on the same plot over the 
# course of a specified time range (peak business season). Due to this, we are
# not only able to visualize individual trends much more easily, but we are also
# now  able to compare the relationship between 2 trends and draw conclusions 
# from these comparisons. This will be Scatter Plot Type 1.
# We can also average values across a category of products (beer/vodka/etc...)
# and plot that to see all of the metrics described above viewed bbut instead
# viewed as a category of products. This will be Scater Plot Type 2.

# Scatter Plot Type 1:

# Data-Frame:
df_Scatter <- inventory2024_long %>%
  filter(metric == "thru" | metric == "order" | metric == "oh",
         item == "Titos") %>%
  select(item, metric, month, day, amount) %>%
  filter(month >= 4 | month == 10) %>% 
  filter(!is.na(amount)) %>% # Remove rows with NA in amount (don't want to plot)
  mutate(date = mdy(paste(month, day, "2024")), # Creates a Date column
         amount = as.numeric(amount))  # Ensure metric is numeric

# Scatter Plot Theme (For Style):
theme_Scatter <- theme(
  plot.title = element_text(hjust = 0.5, vjust = .5, face = "bold", size = 34),
  plot.subtitle = element_text(hjust = 0.5, face = "bold", size = 24),
  plot.caption = element_text(face = "bold", size = 9, hjust = 0),
  plot.margin = margin(0, 20, 10, 20), 
  axis.text.x = element_text(angle = 90, hjust = .5, vjust = .5, face = "bold", size = 15),  # Rotate x-axis labels by 45 degrees
  axis.text.y = element_text(hjust = .5, face = "bold", size = 15),
  axis.title.x = element_text(vjust = .5, size = 30, face = "bold"), 
  axis.title.y = element_text(size = 30, face = "bold", vjust = 2), 
  legend.position = "right",
  legend.direction = "vertical",
  legend.title = element_text(size = 16, face = "bold"),
  legend.text = element_text(size = 14, face = "bold"),  # Increase legend text size
  panel.grid.major = element_line(size = 0.5),
  panel.grid.minor = element_line(size = 0.15),
  panel.grid.minor.y = element_line(color = "grey"),
  panel.grid.major.y = element_line(color = "grey"),
  panel.grid.minor.x = element_line(color = "grey"),
  panel.grid.major.x = element_line(color = "grey")
)

# Descriptive Cation to Explain Plot Relationships in Depth:
caption_Scatter <- "* The horizontal red lines are the maximum value that you want to keep the OH curve below during the season (solid), and where you want the currved line to be at or below by the end (dashed). You never need more OH 
  during the season than the solid red line (If you do, than you're over stocked). This trend becomes apparent on the plot as the red OH curve will cross above the solid red line for an extended period of time.\n** Green vertical line indicates when in the season you should begin to carefully watch how much you are ordering and going through. August is the last month where 
       you are open everyday and still have enough throughput to get rid of extra on hand stock by either ordering less of the product, or none at all.\n*** IDEAL PLOT CHARACTERISTICS (What you want the plot to look like):
       THRU CURVE (Usage and/or demand) (Blue Curve): GOAL = Smooth and predicatble. The thru curve should be relatively smooth and predictable. Seasonal or event-driven spikes should match expectations.
       ORDER CURVE (Green Curve):    GOAL = Slightly Below or Equal to THRU curve. Ordering should match expected usage, so the order curve should track just below or equal to the thru curve. 
       This is especially true once you begin to approach/cross the vertical green line!!! Ideally, the order curve should slightly lead the thru curve (anticipating demand without over-ordering).
                                                          * OVER ORDERING: If the order curve consistently exceeds the thru curve, you may be over-ordering (If the order curve rises above the thru curve for too long).
                                                          * UNDER ORDERING: If the order curve is frequently below the thru curve, you may risk running out of stock.
       ON HAND CURVE (Expected Demand)(Red Curve):  GOAL = Stays Low & Doesn’t Increase Unnecessarily. Ideally, the on hand curve should remain stable or decline toward the end of the season. 
                                                          * A rising on hand curve suggests excess stock.
                                                          * If on hand dips to near-zero too often, you might be under-ordering and running out.
**** SUMMARY: This plot is a combination of many products of the category to see what the average trends are that arise across top throughput items. 
***** DIFFERENCES: On Hand (OH) - Thru (Usage) → Over/Under-Stocking Cost Impact: Large positive values indicate wasted capital; negative values suggest potential lost revenue (Should be compared to solid red line for losses).
                                    Order - On Hand → Inventory Turnover Management: his reveals how aggressive your ordering is compared to current stock. 
                                                          * If Order > OH: You’re frequently replenishing stock, which can be good if demand is strong, but risky if demand drops.
                                                          * If Order < OH: You may be relying too much on existing stock, which could lead to shortages if demand spikes.
                                    Order - Thru → Ordering Efficiency: This shows whether your ordering matches real usage. Order should closely track Thru, with slight anticipation of demand."


# Scatter Plot:
# For this plot, when creating for a new item, must change: 
# titles, y axis step, horizontal red line floor and ceiling values.
ggplot(df_Scatter, aes(x = date, y = amount, color = item, shape = metric)) +
  geom_point(size = 4, color = "black") +  # Scatter plot points
  scale_y_continuous(breaks = seq(0, max(df_Scatter$amount + 25, na.rm = TRUE), # sets the max y to be the max value of the column + 20
                                  by = 24)) + # Step
  geom_hline(yintercept = 0, color = "black", size = 1) +
  geom_vline(xintercept = as.Date(min(df_Scatter$date, na.rm = TRUE) - 7), # sets the vertical line to be at the minimum date minus 7 days
             color = "black", 
             size = 1) + 
  geom_vline(xintercept = as.Date("2024-08-05"), # sets the vertical lije to be at the minimum date minus 7 days
             color = "green3", size = 1, linetype = "twodash") +
  geom_hline(yintercept = 12, color = "red", size = 1, linetype = "longdash") + # Target line for OH end of season
  # The following line should be determined by looking at the maximum thru value of the season. Round up to nearest 10!
  geom_hline(yintercept = 144, color = "red", size = 1) + # Target line for OH max: shouldn't exceed during season
  geom_smooth(method = "loess", se = FALSE, level = .9, aes(color = metric)) +  # Linear regression line. "Level" adjusts the confidence interval (0.9 = 90% conf.)
  labs(title = "ORDER vs THRU vs ON HAND Trend Comparison",
       subtitle = "Titos (2024):",
       x = "Date", y = "Amount (Bottles)",
       # " LOESS looks at all data points locally to fit a polynomial curve around each point (window size controlled by smoothing parameter), so it can adapt to more complex, non-linear relationships.
       caption = caption_Scatter) + 
  theme_minimal() + 
  theme_Scatter + # Custom Theme Template defined above
  scale_x_date(
    limits = as.Date(c("2024-04-29", "2024-10-14")),  # Set custom date range (May 1st to July 31st)
    date_labels = "%b %d", # Format x-axis labels as Month Day (e.g., "May 01")
    date_breaks = "week" # Set the interval for the ticks (e.g., every week)
  ) 

# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

# Scatter Plot Type 2:

# This data frame filters and aggregates the 'inventory"YEAR"_long' dataset, 
# selecting specific items ('Rack Vodka', 'Rack Tequila', 'Rack Rum') and metrics 
# ('thru', 'order', 'oh'). It groups the data by 'metric', 'month', and 'day', 
# summing the 'amount' values for each combination, while preserving the 'item', 
# 'month', and 'day' columns.
df_Scatter2 <- inventory2023_long %>%
  filter(metric %in% c("thru", "order", "oh"),  # Filter by metric
         category %in% c("vodka")) %>%  # Filter by category
  select(item, metric, month, day, amount) %>%
  filter(month >= 4 | month == 10) %>%  # Fixes the issue with month 10 being considered smaller than month 4
  filter(!is.na(amount)) %>%  # Remove rows with NA in amount
  mutate(date = mdy(paste(month, day, "2023")),  # Create a Date column
         amount = as.numeric(amount)) %>%  # Ensure amount is numeric
  group_by(metric, month, day) %>%  # Group by metric, month, and day
  mutate(amount = sum(amount, na.rm = TRUE)) %>%  # Sum amount for each group
  ungroup()  # Remove the grouping after mutating


caption_Scatter2 <- "* The horizontal red lines are the maximum value that you want to keep the OH curve below during the season (solid), and where you want the currved line to be at or below by the end (dashed). You never need more OH 
  during the season than the solid red line (If you do, than you're over stocked). This trend becomes apparent on the plot as the red OH curve will cross above the solid red line for an extended period of time.\n** Green vertical line indicates when in the season you should begin to carefully watch how much you are ordering and going through. August is the last month where 
       you are open everyday and still have enough throughput to get rid of extra on hand stock by either ordering less of the product, or none at all.\n*** IDEAL PLOT CHARACTERISTICS (What you want the plot to look like):
       THRU CURVE (Usage and/or demand) (Blue Curve): GOAL = Smooth and predicatble. The thru curve should be relatively smooth and predictable. Seasonal or event-driven spikes should match expectations.
       ORDER CURVE (Green Curve):    GOAL = Slightly Below or Equal to THRU curve. Ordering should match expected usage, so the order curve should track just below or equal to the thru curve. 
       This is especially true once you begin to approach/cross the vertical green line!!! Ideally, the order curve should slightly lead the thru curve (anticipating demand without over-ordering).
                                                          * OVER ORDERING: If the order curve consistently exceeds the thru curve, you may be over-ordering (If the order curve rises above the thru curve for too long).
                                                          * UNDER ORDERING: If the order curve is frequently below the thru curve, you may risk running out of stock.
       ON HAND CURVE (Expected Demand)(Red Curve):  GOAL = Stays Low & Doesn’t Increase Unnecessarily. Ideally, the on hand curve should remain stable or decline toward the end of the season. 
                                                          * A rising on hand curve suggests excess stock.
                                                          * If on hand dips to near-zero too often, you might be under-ordering and running out.
**** SUMMARY: This plot is a combination of many products of the category to see what the average trends are that arise across top throughput items. 
***** DIFFERENCES: On Hand (OH) - Thru (Usage) → Over/Under-Stocking Cost Impact: Large positive values indicate wasted capital; negative values suggest potential lost revenue (Should be compared to solid red line for losses).
                                    Order - On Hand → Inventory Turnover Management: his reveals how aggressive your ordering is compared to current stock. 
                                                          * If Order > OH: You’re frequently replenishing stock, which can be good if demand is strong, but risky if demand drops.
                                                          * If Order < OH: You may be relying too much on existing stock, which could lead to shortages if demand spikes.
                                    Order - Thru → Ordering Efficiency: This shows whether your ordering matches real usage. Order should closely track Thru, with slight anticipation of demand."


# Scatter Plot:
ggplot(df_Scatter2, aes(x = date, y = amount, color = item, shape = metric)) +
  geom_point(size = 4, color = "black") +  # Scatter plot points
  scale_y_continuous(breaks = seq(0, max(df_Scatter2$amount + 25, na.rm = TRUE), # sets the max y to be the max value of the column + 20
                                  by = 100)) + # Step
  geom_hline(yintercept = 0, color = "black", size = 1) +
  geom_vline(xintercept = as.Date(min(df_Scatter2$date, na.rm = TRUE) - 7), # sets the vertical lije to be at the minimum date minus 7 days
             color = "black", 
             size = 1) + 
  geom_vline(xintercept = as.Date("2023-08-05"), # sets the vertical line to be at the minimum date minus 7 days
             color = "green3", size = 1, linetype = "twodash") +
  geom_hline(yintercept = 108, color = "red", size = 1, linetype = "longdash") + # Target line for OH end of season
  # The following line should be determined by looking at the maximum thru value of the season. Round up to nearest 10!
  geom_hline(yintercept = 840, color = "red", size = 1) + # Target line for OH max: shouldn't exceed during season
  geom_smooth(method = "loess", se = FALSE, level = .9, aes(color = metric)) +  # Linear regression line. "Level" adjusts the confidence interval (0.9 = 90% conf.)
  labs(title = "ORDER vs THRU vs ON HAND Trend Comparison",
       subtitle = "Combination: Vodkas (2023):",
       x = "Date", y = "Amount (Bottles)",
       # " LOESS looks at all data points locally to fit a polynomial curve around each point (window size controlled by smoothing parameter), so it can adapt to more complex, non-linear relationships.
       caption = caption_Scatter2) + 
  theme_minimal() + 
  theme_Scatter + # Custom Theme Template defined above
  scale_x_date(
    limits = as.Date(c("2023-04-29", "2023-10-14")),  # Set custom date range (May 1st to July 31st)
    date_labels = "%b %d", # Format x-axis labels as Month Day (e.g., "May 01")
    date_breaks = "week" # Set the interval for the ticks (e.g., every week)
  ) 


# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
# Year to Year Comparison Plots: ------------------------------------------

# A common goal for a seasonal restaurant is to be able to sell
# as much product as you can and be left with as little as possible at the end
# of the season. Surplus stock cuts into profits. With the following plot, we
# will be able to cleary see which year was more successful in getting rid
# of stock across all categories by the end of the season/year. 

# On Hand Comparison Vertical Bar Plot for the End of the Year 2023 v 2024:

# Two individual tables with data I want to combine:
df_2023_half <- inventory2023_long %>%
  filter(metric == "oh", month == 9, day == 26) %>%
  select(category, amount) %>% 
  group_by(category) %>% 
  summarize(totalAmount = sum(amount, na.rm = TRUE), .groups = "drop") %>%
  mutate(year = "2023")

df_2024_half <- inventory2024_long %>%
  filter(metric == "oh", month == 10, day == 14) %>%
  select(category, amount) %>% 
  group_by(category) %>% 
  summarize(totalAmount = sum(amount, na.rm = TRUE), .groups = "drop") %>%
  mutate(year = "2024")

# Combine both datasets:
combined_data <- full_join(df_2023_half, df_2024_half, by = "category") %>%
  rename(Ending_OnHand_2023 = totalAmount.x, Ending_OnHand_2024 = totalAmount.y)

# Reshape data to long format for plotting:
long_data <- combined_data %>%
  gather(key = "year", value = "amount", Ending_OnHand_2023, Ending_OnHand_2024)

# Bar Plot Theme:
bar_plot_theme <- theme(
  plot.title = element_text(hjust = 0.5, vjust = 3, face = "bold", size = 32),
  plot.subtitle = element_text(hjust = 0.5, vjust = 3, face = "bold", size = 24),
  plot.caption = element_text(face = "bold", size = 9, hjust = 0),
  plot.margin = margin(20, 20, 10, 20), 
  axis.text.x = element_text(angle = 90, hjust = .5, vjust = .5, face = "bold", size = 14),  # Rotate x-axis labels by 45 degrees
  axis.text.y = element_text(hjust = .5, face = "bold", size = 15),
  axis.title.x = element_text(vjust = .5, size = 30, face = "bold"), 
  axis.title.y = element_text(size = 30, face = "bold", vjust = 3, hjust = .5), 
  legend.position = "top",
  legend.direction = "vertical",
  legend.title = element_text(size = 20, face = "bold", hjust = .5),
  legend.text = element_text(size = 14, face = "bold", color = "grey30"),  # Increase legend text size
  panel.grid.major = element_line(size = 0.5),
  panel.grid.minor = element_line(size = 0.15),
  panel.grid.minor.y = element_line(color = "grey"),
  panel.grid.major.y = element_line(color = "grey"),
  panel.grid.minor.x = element_line(color = "grey"),
  panel.grid.major.x = element_line(color = "grey")
)


# Create a side-by-side bar chart
ggplot(long_data, aes(x = category, y = amount, fill = as.factor(year))) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label = round(amount, 1)), # Add the text labels (rounded to 1 decimal place)
            position = position_dodge(width = 0.8), # Adjust text position for dodged bars
            vjust = -0.5, # Vertical adjustment to position the labels above the bars
            color = "black", 
            size = 5,
            fontface = "bold") +  
  scale_y_continuous(breaks = seq(0, max(long_data$amount + 25, na.rm = TRUE), # sets the max y to be the max value of the column + 20
                                  by = 25)) + # Step
  labs(title = "Comparison of End of Year OH Amounts between 2023 and 2024",
       subtitle = "Separated by Category:",
       x = "Category",
       y = "Amount (Cases or Bottles)",
       fill = "Year") +
  theme_minimal() +
  bar_plot_theme 


# ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

# Finally, we have the side by side scatter plots which are extremely useful
# for the obvious reason that you are directly complaring the same product
# from one year to the next. You can easily spot differences in thru values
# during specific times of the season and observe underlying seasonal trends.
# This plot also incorporates some 'variables' in the plots caption which 
# gives a detailed breakdown of total thru values, averages, and other stats!!!

# Another way to use this plot is to compare a product to one that you replaced
# it with. Often times in the industry you'll wind up replacing a product that
# isn't selling well. With this plot, you'll be able to determine if it was 
# profitable or not! (In our case we have strawberry vs pink lemonade frozens)

# Side by Side 2023 v 2024 Product Comparison Scatter Plot:

# Create Two tables to be joined:
df_Scatter_2023_half <- inventory2023_long %>%
  filter(metric == "thru",
         item == "Bacardi Limon") %>%
  select(item, metric, month, day, amount) %>%
  filter(!is.na(amount)) %>% # Remove rows with NA in amount (if you don't want to plot them)
  mutate(date = mdy(paste(month, day, "2023")),  # Creates a Date column
         amount = as.numeric(amount)) %>% # Ensure metric is numeric
  mutate(yearlySum = sum(amount)) %>%
  mutate(q1_amount = quantile(amount, 0.25, na.rm = TRUE)) %>%
  mutate(q3_amount = quantile(amount, 0.75, na.rm = TRUE)) %>%
  mutate(average = mean(amount, na.rm = TRUE)) %>%
  mutate(stdev = sd(amount, na.rm = TRUE)) %>%
  mutate(count = n())  # Adds a new column with the total row count

df_Scatter_2024_half <- inventory2024_long %>%
  filter(metric == "thru",
         item == "Bacardi Limon") %>%
  select(item, metric, month, day, amount) %>%
  filter(!is.na(amount)) %>% # Remove rows with NA in amount (if you don't want to plot them)
  mutate(date = mdy(paste(month, day, "2024")),  # Creates a Date column
         amount = as.numeric(amount)) %>%  # Ensure metric is numeric
  mutate(yearlySum = sum(amount)) %>%
  mutate(q1_amount = quantile(amount, 0.25, na.rm = TRUE)) %>%
  mutate(q3_amount = quantile(amount, 0.75, na.rm = TRUE)) %>%
  mutate(average = mean(amount, na.rm = TRUE)) %>%
  mutate(stdev = sd(amount, na.rm = TRUE)) %>%
  mutate(count = n())  # Adds a new column with the total row count

# Scatter Plots Theme 2:
theme_Scatter2 <- theme(
  plot.title = element_text(hjust = .5, vjust = 2, face = "bold", size = 34),
  plot.subtitle = element_text(hjust = 0.5, face = "bold", size = 28),
  plot.caption = element_text(face = "bold", size = 16, hjust = 0),
  plot.margin = margin(10, 10, 10, 10), 
  axis.text.x = element_text(angle = 90, hjust = .5, vjust = .5, face = "bold", size = 15),  # Rotate x-axis labels by 45 degrees
  axis.text.y = element_text(hjust = .5, face = "bold", size = 15),
  axis.title.x = element_text(vjust = .5, size = 30, face = "bold"), 
  axis.title.y = element_text(size = 30, face = "bold", vjust = 2), 
  legend.position = "right",
  legend.direction = "vertical",
  legend.title = element_text(size = 26, face = "bold", hjust = .5),
  legend.text = element_text(size = 18, face = "bold"),  # Increase legend text size
  panel.grid.major = element_line(size = 0.5),
  panel.grid.minor = element_line(size = 0.15),
  panel.grid.minor.y = element_line(color = "grey"),
  panel.grid.major.y = element_line(color = "grey"),
  panel.grid.minor.x = element_line(color = "grey"),
  panel.grid.major.x = element_line(color = "grey"),
  panel.background = element_rect(, color = "white", fill = "white")
)

# Scatter Plot: FACET WRAP:
# USEFUL FOR COMPARING ONLY 2 ITEMS FOR ACROSS YEARS:

# Combine the two data sets, adding a 'year' column for each dataset
combined_data <- bind_rows(
  mutate(df_Scatter_2023_half, year = 2023),  # Add 'year' column for 2023
  mutate(df_Scatter_2024_half, year = 2024)   # Add 'year' column for 2024
)

caption_facet1 <- glue("2023:                                                                                                                   2024:\n
  Total Thru: {df_Scatter_2023_half$yearlySum[[1]]} bottles                                                                                       Total Thru: {df_Scatter_2024_half$yearlySum[[1]]} bottles
  AVG: {round(df_Scatter_2023_half$average[[1]], 0)} bottles / week                                                                                       AVG: {round(df_Scatter_2024_half$average[[1]], 0)} bottles / week 
  Standard Deviation: {round(df_Scatter_2023_half$stdev[[1]])} bottles / week                                                              Standard Deviation: {round(df_Scatter_2024_half$stdev[[1]])} bottles / week
  1st Interquartile Range: {round(df_Scatter_2023_half$q1_amount[[1]], 0)} bottles / week                                                        1st Interquartile Range: {round(df_Scatter_2024_half$q1_amount[[1]], 0)} bottles / week 
  3rd Interquartile Range: {round(df_Scatter_2023_half$q3_amount[[1]], 0)} bottles / week                                                        3rd Interquartile Range: {round(df_Scatter_2024_half$q3_amount[[1]], 0)} bottles / week 
  Number of Weeks with Data: {df_Scatter_2023_half$count[[1]]}                                                                       Number of Weeks with Data: {df_Scatter_2024_half$count[[1]]}")                                                          

# Create the plot with facet_wrap to separate by year
ggplot(combined_data, aes(x = date, y = amount)) +
  geom_point(aes(color = as.factor(year)), size = 5) +  # Color by year
  geom_smooth(aes(color = as.factor(year)), method = "loess", se = FALSE) +  # LOESS curve for each year
  geom_hline(yintercept = 0, color = "grey40", size = 1) +
  facet_wrap(~ year, scales = "free_x", ncol = 2) +  # Facet by year
  # Scale:
  scale_y_continuous(breaks = seq(0, max(combined_data$amount + 10, na.rm = TRUE), # sets the max y to be the max value of the column + 20
                                  by = 6)) + # Step
  labs(title = "2023 vs 2024 Product Comparison Scatter Plots",
       subtitle = "Bacardi Limon:",
       caption = caption_facet1,
       x = "Month",
       y = "Amount (Bottles)",
       color = "Year") +  # Title and labels
  theme_Scatter4 +
  theme(legend.position = "right",
        strip.text = element_text(size = 20, face = "bold")) # Position legend to the right
