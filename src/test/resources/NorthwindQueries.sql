-- BASICS
-- 1.Give me List of male Mr. employees living in London ?
   SELECT *
   FROM EMPLOYEES
   -- WHERE TITLEOFCOURTESY='Mr.' OR  TITLEOFCOURTESY='Dr.';
    WHERE TITLEOFCOURTESY IN ('Mr.','Dr.') AND CITY='London';

-- 2.Get me all employees information in following format with columnName ContactInfo
-- FirstName LastName can be reached at Extension
-- Nancy Davolio can be reached at 5467

   -- concatenation
   -- Java + FirstName+" "+LastName
    SELECT FIRSTNAME||' '||LASTNAME||' can be reached at '||EXTENSION AS PERSONAL_INFO
    FROM EMPLOYEES;

   -- ALIASES
    -- Table aliases
    -- Column aliases with as keyword

-- 3.Get me all the CustomerID in lowercase letter from
-- the customers table and rename column as ID
    SELECT * FROM CUSTOMERS;

    SELECT LOWER(CUSTOMERID) AS ID
    FROM CUSTOMERS;


-- 4.Give me List of customers  in Germany,France,Argentina
    -- OPT 1
    SELECT * FROM CUSTOMERS
    WHERE COUNTRY='Germany' OR COUNTRY='France' OR COUNTRY='Argentina';

    -- OPT 2
    SELECT * FROM CUSTOMERS
    WHERE COUNTRY IN ('Germany','France','Argentina');

-- 5.Get me all employees with the even number employeeID from employeesTable

     SELECT EMPLOYEEID,FIRSTNAME,LASTNAME
     FROM EMPLOYEES;

    -- WE NEED USE MODULUS OPERATOR TO SEE OF REMAINING IS ZERO
    -- SQLLITE - POSTGRESQL - MYSQL
      SELECT EMPLOYEEID,FIRSTNAME,LASTNAME
      FROM EMPLOYEES
      WHERE EMPLOYEEID%2=0;

    /*
      SELECT EMPLOYEEID,FIRSTNAME,LASTNAME
      FROM EMPLOYEES
      WHERE MOD(EMPLOYEEID,2)==0;

     */




-- 6.Get me all Suppliers CompanyName,ContactName,Region information
-- by using Suppliers Table
    SELECT COMPANYNAME,CONTACTNAME,REGION,CITY
    FROM SUPPLIERS;

    --  NEW --> --If Region is null display city information
    -- COALESCE() -> It takes 2 or more arguments and return FIRST NOT NULL VALUE
    SELECT COMPANYNAME,CONTACTNAME,coalesce(REGION,CITY)
    FROM SUPPLIERS;

    -- CASE STATEMENT IN SQL SAME WITH IF IN JAVA
    -- Q -- IF REGION CONTAINS
                -- America --> AMERICA
                -- Europe  --> EUROPE
                -- Asia    --> ASIA
                -- if condition is not MET --> OTHERS
    SELECT COMPANYNAME,CASE
            WHEN REGION LIKE '%America%' THEN 'AMERICA'
            WHEN REGION LIKE '%Europe%' THEN 'EUROPE'
            WHEN REGION LIKE '%Asia%' THEN 'ASIA'
            ELSE 'OTHERS'
            END AS REGION_INFO -- COLUMN ALIAS
    FROM SUPPLIERS;



-- 7.Get me top 10 OrderID, OrderDate, ShippedDate, CustomerID, Freight from the orders table
-- sorted by Freight in descending order.

    SELECT ORDERID,ORDERDATE,SHIPPEDDATE,CUSTOMERID,FREIGHT
    FROM ORDERS
    ORDER BY FREIGHT DESC;

    -- Get me top 10

    -- ORACLE ROWNUM

    -- POSTGRESQL - MYSQL - SQLITE - LIMIT KEYWORD
    SELECT ORDERID,ORDERDATE,SHIPPEDDATE,CUSTOMERID,FREIGHT
    FROM ORDERS
    ORDER BY FREIGHT DESC
    LIMIT 10;

    -- MSSQL - TOP
    /*
    SELECT TOP 10 ORDERID,ORDERDATE,SHIPPEDDATE,CUSTOMERID,FREIGHT
    FROM ORDERS
    ORDER BY FREIGHT DESC;

     */


-- 8.Get me ten most expensive products

    SELECT PRODUCTNAME,UNITPRICE
    FROM PRODUCTS
    ORDER BY UNITPRICE DESC
    LIMIT 10;


-- 9.Get me all customers where their country name startswith S
    SELECT CONTACTNAME,COUNTRY
    FROM CUSTOMERS
    WHERE COUNTRY LIKE 'S%';

    -- FIND ME CUSTOMERS WHERE COUNTRY NAME THIRD LETTER a
    SELECT CONTACTNAME,COUNTRY
    FROM CUSTOMERS
    WHERE COUNTRY LIKE '__a%';

-- 10.How many Customer we have where contactTitle is Owner
    SELECT COUNT(*)
    FROM CUSTOMERS
    WHERE CONTACTTITLE='Owner';

-- 11.How many  customers  we have  in EACH FOLLOWING COUNTRY Germany,France,Argentina ?
    -- WHERE
    SELECT COUNTRY,COUNT(*)
    FROM CUSTOMERS
    WHERE COUNTRY IN ('Germany','France','Argentina')
    GROUP BY COUNTRY;

    -- HAVING -- BAD PRACTICE
    SELECT COUNTRY,COUNT(*)
    FROM CUSTOMERS
    GROUP BY COUNTRY
    HAVING COUNTRY IN ('Germany','France','Argentina');


    -- GIVE ME INFORMATION WHERE WE HAVE MORE THAN 10 CUSTOMER
        SELECT COUNTRY,COUNT(*)
        FROM CUSTOMERS
        WHERE COUNTRY IN ('Germany','France','Argentina')
        GROUP BY COUNTRY
        HAVING COUNT(*)>10;

    -- SORT DATA IN DESC ORDER BASED COUNTRY NAME
        SELECT COUNTRY,COUNT(*) AS CUSTOMER_COUNT
        FROM CUSTOMERS
        WHERE COUNTRY IN ('Germany','France','Argentina')
        GROUP BY COUNTRY
        HAVING COUNT(*)>10
        ORDER BY COUNTRY DESC;



-- 12.How many sales did each of my employees  ?
    SELECT * FROM ORDERS;

    SELECT EMPLOYEEID,COUNT(*)
    FROM ORDERS
    GROUP BY EMPLOYEEID;

-- Get me firstname and lastname  of this employee
    SELECT FIRSTNAME,LASTNAME,COUNT(*)
    FROM EMPLOYEES E INNER JOIN ORDERS O
            ON E.EMPLOYEEID=O.EMPLOYEEID
    GROUP BY FIRSTNAME,LASTNAME;


-----------------------------------------------------------
-- 13.Which of our personnel make more than 75 sales ?
    SELECT EMPLOYEEID,COUNT(*)
    FROM ORDERS
    GROUP BY EMPLOYEEID
    HAVING COUNT(*)>75;

    -- GET ME EMPLOYEE FIRSTNAME,LASTNAME
    SELECT E.EMPLOYEEID,FIRSTNAME,LASTNAME,COUNT(*)
    FROM ORDERS O INNER JOIN EMPLOYEES E
            ON O.EMPLOYEEID=E.EMPLOYEEID
    GROUP BY E.EMPLOYEEID,FIRSTNAME,LASTNAME
    HAVING COUNT(*)>75;

    -- CAN WE DO THIS WITH SUBQUERY (NO JOIN )
    -- This query gets always employeeid who has more than 75 sales
        SELECT EMPLOYEEID
        FROM ORDERS
        GROUP BY EMPLOYEEID
        HAVING COUNT(*)>75;

        SELECT FIRSTNAME,LASTNAME
        FROM EMPLOYEES
        WHERE EMPLOYEEID IN (1,2,3,4,8);

        -- SOLUTION
        SELECT FIRSTNAME,LASTNAME
        FROM EMPLOYEES
        WHERE EMPLOYEEID IN (SELECT EMPLOYEEID
                             FROM ORDERS
                             GROUP BY EMPLOYEEID
                             HAVING COUNT(*)>75);


-- 14.Get me product id and the total quantities ordered for each product
-- in the Order Details table.
-- IF THE NAME OF THE TABLE HAS SPACE WE CAN USE
    -- "ORDER DETAILS"
    -- [ORDER DETAILS]

    SELECT PRODUCTID,SUM(QUANTITY)
    FROM [ORDER DETAILS]
    GROUP BY PRODUCTID;

    SELECT * FROM [ORDER DETAILS];

    -- FILTER RESULT TO SEE ONLY PRODUCT WHICH IS SOLD MORE THAN 1000

    -- SORT DATA IN DESC BASED ON PRODUCT COUNT


-- 15. --Select a list of customer names who have no orders in the Orders table.
    -- JOIN
    SELECT O.CUSTOMERID,C.CUSTOMERID,CONTACTNAME
      FROM ORDERS O RIGHT JOIN  CUSTOMERS C
            ON O.CUSTOMERID=C.CUSTOMERID
      WHERE O.CUSTOMERID IS NULL;

    -- SUBQUERY
        SELECT DISTINCT CUSTOMERID FROM ORDERS; -- 89
        SELECT CUSTOMERID FROM CUSTOMERS;  -- 93

        SELECT CONTACTNAME
        FROM CUSTOMERS
        WHERE CUSTOMERID NOT IN (SELECT DISTINCT CUSTOMERID FROM ORDERS)

    -- EXCEPT( SQLLITE - MYSQL ) = MINUS ( ORACLE )
    -- MINUS Q1-Q2 "Cydeo-SQL" - "Cydeo" = "SQL"
        SELECT CUSTOMERID FROM CUSTOMERS
        EXCEPT
        SELECT DISTINCT CUSTOMERID FROM ORDERS;


-- 16. --Select a list of customer names who have orders in the Orders table.


-- JOIN
-- 1.How many product we have in each category

-- 2.Get me categoryID that has highest products number ?

-- 3.What is the name of category

-- 4.From which supplier companies did we purchase products with
-- a unit price of more than 20 in the Beverages category?

-- 5.Select the name of customers who bought only products with price less than 50

-- 6.Select the customer name and customer address of all customers
-- with orders that shipped using United Package

-- 7.Get me most used shippers company name

-- 8.Get me Customer ContactName who has highest order number

-- 9.Get me all employees and their managers

-- 10.Get me all customers and employees phone numbers

-- 11.Get me all suppliers and customers city,companyName,ContactName
