CREATE OR REPLACE VIEW v_sales_enriched AS
SELECT
  s.orderid,
  s.orderdate,
  s.storeid,
  st.storename,
  st.region,
  s.employeeid,
  e.employeename,
  e.title,
  s.productid,
  p.productname,
  p.category,
  s.quantity,
  s.unitprice,
  (s.quantity * s.unitprice) AS gross_amount,
  (s.quantity * s.unitprice) * (1 - COALESCE(s.discount,0)) AS net_amount,
  p.unitcost,
  (s.quantity * p.unitcost) AS cost_amount,
  ((s.quantity * s.unitprice) * (1 - COALESCE(s.discount,0))) - (s.quantity * p.unitcost) AS margin
FROM sales s
JOIN products p  ON s.productid  = p.productid
JOIN stores   st ON s.storeid    = st.storeid
JOIN employees e ON s.employeeid = e.employeeid;

CREATE OR REPLACE VIEW v_kpi_daily AS
SELECT
  CAST(orderdate AS DATE) AS day,
  SUM(net_amount)   AS total_sales,
  SUM(quantity)     AS total_units,
  COUNT(DISTINCT orderid) AS orders,
  SUM(margin)       AS total_margin
FROM v_sales_enriched
GROUP BY 1;

CREATE OR REPLACE VIEW v_kpi_by_store AS
SELECT
  region,
  storename,
  SUM(net_amount) AS total_sales,
  SUM(quantity)   AS total_units,
  SUM(margin)     AS total_margin
FROM v_sales_enriched
GROUP BY region, storename;

CREATE OR REPLACE VIEW v_kpi_by_product AS
SELECT
  category,
  productname,
  SUM(quantity)   AS total_units,
  SUM(net_amount) AS total_sales,
  SUM(margin)     AS total_margin
FROM v_sales_enriched
GROUP BY category, productname;

CREATE OR REPLACE VIEW v_kpi_by_employee AS
SELECT
  employeename,
  storename,
  SUM(net_amount) AS total_sales,
  SUM(quantity)   AS total_units,
  SUM(margin)     AS total_margin
FROM v_sales_enriched
GROUP BY employeename, storename;
