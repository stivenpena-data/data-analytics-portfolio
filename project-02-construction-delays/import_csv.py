import csv
import mysql.connector

# Connect to MySQL
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='admin123',
    database='construction_pm'
)
cursor = conn.cursor()

# Clear existing data
cursor.execute("DELETE FROM delays_raw")

# Read and insert CSV
with open('D:/Business Analytics Course/construction_delays_dirty.csv', 'r', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)
    rows = []
    for row in reader:
        rows.append((
            row['Task_ID'], row['Project'], row['Task_Type'], row['Worker'],
            row['Supplier'], row['Planned_Start'], row['Planned_End'],
            row['Actual_End'], row['Delay_Days'], row['Delay_Reason'],
            row['On_Time'], row['Cost_CAD']
        ))

sql = """INSERT INTO delays_raw
         (Task_ID, Project, Task_Type, Worker, Supplier,
          Planned_Start, Planned_End, Actual_End,
          Delay_Days, Delay_Reason, On_Time, Cost_CAD)
         VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"""

cursor.executemany(sql, rows)
conn.commit()

print(f"✅ Imported {cursor.rowcount} rows successfully")

cursor.execute("SELECT COUNT(*) FROM delays_raw")
print(f"✅ Total rows in delays_raw: {cursor.fetchone()[0]}")

cursor.close()
conn.close()
