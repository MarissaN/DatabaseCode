--Marissa Norris

--CREATE TABLE SECTION

-- Create LOCATION table with Cluster B-Tree on zip
CREATE TABLE LOCATION (
    zip VARCHAR (5) PRIMARY KEY,
    loc_name VARCHAR (50),
    state VARCHAR (50)
)
ORGANIZATION INDEX; 

--Create PRODUCT table  
CREATE TABLE PRODUCT (
    prod_id NUMBER PRIMARY KEY,
    prod_name VARCHAR (250),
    price DECIMAL (6, 2)
);
--Secondary B-Tree on prod_name
CREATE INDEX prod_name_IDX
ON PRODUCT(prod_name);
--Secondary B- Tree on prod_id, prod_name
CREATE UNIQUE INDEX prod_id_name_IDX
ON PRODUCT (prod_id, prod_name);

--Create Cluster for platform_id
CREATE CLUSTER CustPlatform (platform_id NUMBER)
    SIZE 512;

--Create PLATFORM table with Cluster on platform_id
CREATE TABLE PLATFORM(
    platform_id NUMBER,
    web_address VARCHAR (50),
    contact VARCHAR (20),
    money_spent NUMBER (6,2),
    PRIMARY KEY (platform_id)

)
CLUSTER CustPlatform (platform_id);

--Create CUSTOMER table with Cluster on platform_id
CREATE TABLE CUSTOMER(
    cust_login VARCHAR (50),
    password VARCHAR (100),
    age NUMBER,
    email VARCHAR (50),
    platform_id NUMBER,
    zip VARCHAR (5),
    PRIMARY KEY (cust_login),
    FOREIGN KEY (platform_id) REFERENCES PLATFORM (platform_id),
    FOREIGN KEY (zip) REFERENCES LOCATION (zip)
)
CLUSTER CustPlatform (platform_id);

--Create Index
CREATE INDEX CustPlatform_IDX
ON CLUSTER CustPlatform; 

--Create PURCHASED table with HASH on p_time
CREATE CLUSTER Purchased_Hash (p_time DATE)
    SIZE 512
    SINGLE TABLE
    HASHKEYS 1050;
CREATE TABLE PURCHASED (
    cust_login VARCHAR (50),
    prod_id NUMBER,
    p_time DATE,
    quantity NUMBER,
    PRIMARY KEY (cust_login, prod_id, p_time),
    FOREIGN KEY (cust_login) REFERENCES CUSTOMER (cust_login),
    FOREIGN KEY (prod_id) REFERENCES PRODUCT (prod_id)

)
CLUSTER Purchased_Hash (p_time);

--VIEW SECTION

--Create View named YoungCustomers - Customers under 25
CREATE VIEW YoungCustomers
AS SELECT cust_login, email, age
FROM CUSTOMER
WHERE age < 25;

--Create View named BigSpenders - Customers who spend over $11000 overall
CREATE VIEW BigSpenders
AS SELECT C.cust_login, C.email, SUM(PR.price * PU.quantity) AS total_spent
FROM CUSTOMER C, PRODUCT PR, PURCHASED PU
WHERE C.cust_login = PU.cust_login AND PR.prod_id = PU.prod_id 
GROUP BY C.cust_login, C.email
HAVING SUM(PR.price * PU.quantity) > 11000;

--Create View named PlatformEffect - Amount spent by company and customers on platforms
 CREATE VIEW PlatformEffect
AS SELECT P.web_address AS Website, 
        P.money_spent AS Money_spent_by_us, 
        SUM(PR.price * PU.quantity) AS Money_spent_by_customers,
        ROUND(SUM(PR.price * PU.quantity) / P.money_spent, 2) AS Ratio
FROM PLATFORM P, CUSTOMER C, PRODUCT PR, PURCHASED PU
WHERE C.cust_login = PU.cust_login AND PR.prod_id = PU.prod_id
AND C.platform_id = P.platform_id
GROUP BY P.web_address, P.money_spent
HAVING P.money_spent > 0
ORDER BY Ratio DESC;

--Create View named LocationNumbers - Locations with the number of customers in each
CREATE VIEW LocationNumbers
AS SELECT L.loc_name AS Location, COUNT(C.cust_login) AS num_of_Customers
FROM Location L, Customer C
WHERE L.zip = C.zip
GROUP BY L.loc_name 
ORDER BY COUNT(C.cust_login) DESC;

--GRANT PRIVILAGE SECTION

--Grant select privilage to MarketOfficer for YoungCustomers and BigSpenders
GRANT select 
ON YoungCustomers 
TO MARKETOFFICER; 
GRANT select 
ON BigSpenders 
TO MARKETOFFICER; 

--Grant select privilage to ProductMGR for PlatformEffect and LocationNumbers
GRANT select 
ON PlatformEffect
TO PRODUCTMGR;
GRANT select 
ON LocationNumbers
TO PRODUCTMGR;
