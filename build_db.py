import pandas as pd
import sqlite3

# Load the csv
stg = pd.read_csv('CSV_Name.csv')

# Connect to SQLite
conn = sqlite3.connect('databaseName.db')

# Push to SQL
stg.to_sql('CSV_Name', conn, if_exists='replace', index=False)

print("Table 'CSV_Name' is ready!")