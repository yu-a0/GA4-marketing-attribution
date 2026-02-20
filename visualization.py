import sqlite3
import pandas as pd
import matplotlib.pyplot as plt

# 1. Paths (Keep using absolute paths to avoid the "no such table" error)
DB_PATH = r"C:\Users\yuars\Documents\Yusuf-stuff\Technical-Projects\6-marketing-attribution\marketing_attribution.db"
SQL_FILE_PATH = r"C:\Users\yuars\Documents\Yusuf-stuff\Technical-Projects\6-marketing-attribution\sql-queries\ceo-view.sql"

# 2. Read and Execute
with open(SQL_FILE_PATH, 'r') as f:
    query = f.read()

conn = sqlite3.connect(DB_PATH)
df = pd.read_sql_query(query, conn)
conn.close()

# 3. Plotting Percentages
ax = df.set_index('channel').plot(kind='bar', figsize=(12, 7), width=0.8)

plt.title('Attribution Model Comparison (% Share of Credit)', fontsize=16, pad=20)
plt.ylabel('Percentage (%)', fontsize=12)
plt.xlabel('Marketing Channel', fontsize=12)
plt.xticks(rotation=45)

# ADJUST Y-AXIS HERE:
# Setting this to 45 or 50 gives you 'breathing room' above the 37.6% peak
plt.ylim(0, 50) 

plt.grid(axis='y', linestyle='--', alpha=0.3)

# Add value labels
for p in ax.patches:
    ax.annotate(f"{p.get_height():.1f}%", 
                (p.get_x() + p.get_width() / 2., p.get_height()), 
                ha='center', va='center', 
                xytext=(0, 9), 
                textcoords='offset points',
                fontsize=9,
                fontweight='bold')

plt.tight_layout()
plt.show()