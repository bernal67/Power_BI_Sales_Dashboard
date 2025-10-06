# DAX Measures (copy these into a 'Measures' table)

## Core
**Total Sales**
```DAX
Total Sales = SUMX(Sales, Sales[Quantity] * Sales[UnitPrice] * (1 - Sales[Discount]))
```
**Orders**
```DAX
Orders = DISTINCTCOUNT(Sales[OrderID])
```
**Total Units**
```DAX
Total Units = SUM(Sales[Quantity])
```
**Average Order Value (AOV)**
```DAX
AOV = DIVIDE([Total Sales], [Orders])
```

## Margin
**Total Cost**
```DAX
Total Cost = SUMX(Sales, Sales[Quantity] * RELATED(Products[UnitCost]))
```
**Total Margin**
```DAX
Total Margin = [Total Sales] - [Total Cost]
```
**Margin %**
```DAX
Margin % = DIVIDE([Total Margin], [Total Sales])
```

## Time Intelligence (requires 'Calendar')
**MTD Sales**
```DAX
MTD Sales = CALCULATE([Total Sales], DATESMTD('Calendar'[Date]))
```
**QTD Sales**
```DAX
QTD Sales = CALCULATE([Total Sales], DATESQTD('Calendar'[Date]))
```
**YTD Sales**
```DAX
YTD Sales = CALCULATE([Total Sales], DATESYTD('Calendar'[Date]))
```
**Sales YoY**
```DAX
Sales YoY = CALCULATE([Total Sales], DATEADD('Calendar'[Date], -1, YEAR))
```
**Sales YoY %**
```DAX
Sales YoY % = DIVIDE([Total Sales] - [Sales YoY], [Sales YoY])
```

## Convenience
**Top Product Name**
```DAX
Top Product Name =
VAR t =
    TOPN(1,
        SUMMARIZE(Products, Products[ProductName], "SalesAmt",
            CALCULATE([Total Sales])),
        [SalesAmt], DESC)
RETURN
    MAXX(t, Products[ProductName])
```
**Top Store Name**
```DAX
Top Store Name =
VAR t =
    TOPN(1,
        SUMMARIZE(Stores, Stores[StoreName], "SalesAmt",
            CALCULATE([Total Sales])),
        [SalesAmt], DESC)
RETURN
    MAXX(t, Stores[StoreName])
```
