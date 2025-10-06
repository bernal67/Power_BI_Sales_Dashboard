-- Portable schema (Postgres/SQL Server with small tweaks)
CREATE TABLE products (
  productid    INT PRIMARY KEY,
  productname  VARCHAR(200),
  category     VARCHAR(100),
  unitcost     NUMERIC(12,2),
  unitprice    NUMERIC(12,2)
);

CREATE TABLE stores (
  storeid    INT PRIMARY KEY,
  storename  VARCHAR(200),
  region     VARCHAR(50)
);

CREATE TABLE employees (
  employeeid   INT PRIMARY KEY,
  employeename VARCHAR(200),
  title        VARCHAR(100),
  storeid      INT REFERENCES stores(storeid)
);

CREATE TABLE sales (
  orderid    INT PRIMARY KEY,
  orderdate  DATE,
  storeid    INT REFERENCES stores(storeid),
  employeeid INT REFERENCES employees(employeeid),
  productid  INT REFERENCES products(productid),
  quantity   INT,
  unitprice  NUMERIC(12,2),
  discount   NUMERIC(6,4) DEFAULT 0
);
