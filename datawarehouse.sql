USE SolidWasteManagement11;
GO

DROP TABLE IF EXISTS MyFactTrips;
DROP TABLE IF EXISTS MyDimDate;
DROP TABLE IF EXISTS MyDimWaste;
DROP TABLE IF EXISTS MyDimZone;

CREATE TABLE MyDimDate (
    DataKey int PRIMARY KEY,
    Date date,
    Day int,
    DayOfWeek varchar(10),
    Month int,
    MonthName varchar(10),
    Quarter int,
    Year int
);

CREATE TABLE MyDimWaste (
    WasteKey int PRIMARY KEY,
    WasteType varchar(50),
    Description varchar(255)
);

CREATE TABLE MyDimZone (
    ZoneKey int PRIMARY KEY,
    ZoneName varchar(100),
    City varchar(100),
    Region varchar(100)
);

CREATE TABLE MyFactTrips (
    TripID int PRIMARY KEY,
    DateKey int,
    WasteKey int,
    Zonekey int,
    WasteCollectedTons decimal(10,2),
    FOREIGN KEY (DateKey) REFERENCES MyDimDate (DataKey),
    FOREIGN KEY (WasteKey) REFERENCES MyDimWaste (WasteKey),
    FOREIGN KEY (Zonekey) REFERENCES MyDimZone (ZoneKey)
);

SELECT  d.Year, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimDate d ON f.DateKey = d.DataKey 
GROUP BY d.Year
ORDER BY d.Year;

SELECT z.City, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
GROUP BY z.City;

SELECT w.WasteType, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimWaste w ON f.WasteKey = w.WasteKey
GROUP BY w.WasteType;

SELECT d.Year, d.Month, SUM(f.WasteCollectedTons) AS MonthlyWaste
FROM MyFactTrips f
JOIN MyDimDate d ON f.DateKey = d.DataKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;

SELECT *
FROM (
    SELECT z.City, 
           SUM(f.WasteCollectedTons) AS TotalWaste,
           DENSE_RANK() OVER (ORDER BY SUM(f.WasteCollectedTons) DESC) AS rank_position
    FROM MyFactTrips f
    JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
    GROUP BY z.City
) ranked_cities
WHERE rank_position <= 3;

SELECT d.Year, 
       d.Month, 
       SUM(f.WasteCollectedTons) AS MonthlyWaste, 
       SUM(SUM(f.WasteCollectedTons)) OVER (ORDER BY d.Year, d.Month) AS RunningTotal
FROM MyFactTrips f
JOIN MyDimDate d ON f.DateKey = d.DataKey
GROUP BY d.Year, d.Month;

SELECT z.City, 
       SUM(f.WasteCollectedTons) AS CityWaste, 
       SUM(f.WasteCollectedTons) * 100.0 / SUM(SUM(f.WasteCollectedTons)) OVER() AS WastePercentage
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
GROUP BY z.City;


SELECT z.City, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
GROUP BY z.City;


SELECT AVG(WasteCollectedTons) AS AvgWastePerTrip
FROM MyFactTrips;


SELECT TOP 1 z.City, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
GROUP BY z.City
ORDER BY TotalWaste DESC;


SELECT d.Year, w.WasteType, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimDate d ON f.DateKey = d.DataKey
JOIN MyDimWaste w ON f.WasteKey = w.WasteKey
GROUP BY d.Year, w.WasteType;



SELECT TOP 5 z.ZoneKey, z.City, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
GROUP BY z.ZoneKey, z.City
ORDER BY TotalWaste DESC;


SELECT d.Quarter, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimDate d ON f.DateKey = d.DataKey
GROUP BY d.Quarter;


SELECT z.City, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
GROUP BY z.City
HAVING SUM(f.WasteCollectedTons) > (
    SELECT AVG(CityTotal) 
    FROM (SELECT SUM(WasteCollectedTons) AS CityTotal FROM MyFactTrips f2 JOIN MyDimZone z2 ON f2.Zonekey = z2.ZoneKey GROUP BY z2.City) AS AvgTable
);


SELECT Year, TotalWaste,
       LAG(TotalWaste) OVER (ORDER BY Year) AS PreviousYearWaste,
       (TotalWaste - LAG(TotalWaste) OVER (ORDER BY Year)) AS Growth
FROM (
    SELECT d.Year, SUM(f.WasteCollectedTons) AS TotalWaste
    FROM MyFactTrips f
    JOIN MyDimDate d ON f.DateKey = d.DataKey
    GROUP BY d.Year
) AS YearlyTotals;


SELECT TOP 1 w.WasteType, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimWaste w ON f.WasteKey = w.WasteKey
GROUP BY w.WasteType
ORDER BY TotalWaste DESC;


SELECT z.City, d.Month, d.MonthName, SUM(f.WasteCollectedTons) AS TotalWaste
FROM MyFactTrips f
JOIN MyDimZone z ON f.Zonekey = z.ZoneKey
JOIN MyDimDate d ON f.DateKey = d.DataKey
GROUP BY z.City, d.Month, d.MonthName
ORDER BY z.City, d.Month;