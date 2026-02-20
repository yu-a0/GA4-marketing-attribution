# GA4 Marketing Attribution Engine
An end-to-end data pipeline that migrates raw Google Analytics 4 (GA4) event data from BigQuery to a local SQLite environment to calculate and visualize multi-touch attribution models.

## Project Overview
Processed 47,000+ rows of event data, and compared three distinct models (first touch, last touch, and linear) to understand the true value of each marketing channel.

### The Stack
* Data Warehouse: Google BigQuery (GA4 Export)
* Database: SQLite (Local Edge DB)
* Language: Python (Pandas, Matplotlib, SQL)
* Logic: SQL Window Functions (First-Touch, Last-Touch, Linear)

### File Contents

| File Name | Description |
| :-- | :-- |
| `build_db.py` | Python script to build the database |
| `visualization.py` | Python script to visualize the data |
| `sql-queries` | All SQL queries used to process the data |
| `final_attribution_report.png` | Visualized data |

### Executive Insights (The "CEO View")
Based on the final model comparison, here are the key findings from the data:

| Channel | Linear % | Observation |
| :-- | :-- | :-- |
| ***Organic Search*** | 35.1% | The undisputed leader; drives high volume at every stage of the funnel. |
| ***Direct*** | 23.0% | High brand equity; users often return directly when ready to buy. |
| ***Uncategorized*** | 22.4% | Indicates a need for better UTM tagging to clean up "Dark Social" traffic. |
| ***Paid Search*** | 3.2% | Low conversion share; suggests ads are currently acting as an expensive "First-Touch" introduction rather than a closer. |