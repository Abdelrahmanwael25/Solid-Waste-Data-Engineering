# 🚛 Solid Waste Management Data Pipeline & Analytics

This project implements a complete Data Engineering pipeline. It starts from raw CSV data, processes it using **Python (Pandas & SQLAlchemy)**, and loads it into a **SQL Server** Database using a **Star Schema** architecture.

## 🛠️ Technologies Used
- **Database:** SQL Server (T-SQL)
- **Language:** Python 3.x
- **Libraries:** Pandas, SQLAlchemy, PyODBC
- **Architecture:** Star Schema (Fact and Dimension tables)

## 📊 Database Schema
The project uses a Star Schema consisting of:
- **Fact Table:** `MyFactTrips` (Trip details and waste tonnage)
- **Dimension Tables:** `MyDimDate`, `MyDimWaste`, `MyDimZone`

## 🚀 How to Run
1. Execute the SQL script in `schema.sql` to create the tables.
2. Update the connection string in `main.py`.
3. Run `python main.py` to migrate data from CSVs to SQL Server.
