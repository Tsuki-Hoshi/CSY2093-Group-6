-- -- DROP ALL TABLES / OBJECTS / TYPES

-- RELATIONAL TABLES
DROP TABLE hotels;
DROP TABLE travellers;

-- OBJECT TABLES
DROP TABLE addresses;

-- OBJECT TYPES
DROP TYPE facilities_varray_type;
DROP TYPE facilities_type;
DROP TYPE address_type;

-- -- CREATE ALL TYPES / OBJECTS / TABLES

-- TYPES

CREATE OR REPLACE TYPE facilities_type AS OBJECT (
    name        VARCHAR2(40),
    description VARCHAR2(255),
    capacity    NUMBER(5),
    opening_time DATE,
    closing_time DATE,
    entry_price NUMBER(7,2)
);
/

CREATE OR REPLACE TYPE address_type AS OBJECT (
    street      VARCHAR2(40),
    city        VARCHAR2(40),
    country     VARCHAR2(40)
);
/

CREATE TYPE duration_varray_type AS VARRAY(2) OF DATE;
/

-- VARRAY TYPES
    
CREATE TYPE facilities_varray_type AS VARRAY(100) OF facilities_type;
/

-- OBJECT TABLES

CREATE TABLE addresses OF address_type;

-- RELATIONAL TABLES
    
CREATE TABLE hotels (
    hotel_id NUMBER(6),
    name VARCHAR2(40),
    description VARCHAR2(255),
    rating CHAR(1),
    contact_no VARCHAR2(15),
    capacity NUMBER(4),
    addresses REF address_type SCOPE IS addresses,
    facilities facilities_varray_type
);

CREATE TABLE travellers (
    traveller_id    NUMBER(6),
    firstname       VARCHAR2(40),
    surname         VARCHAR2(40),
    dob             DATE,
    address         address_type
);

CREATE TABLE trip_categories(
trip_category_id NUMBER(6),
duration duration_varray_type,
minimum_age NUMBER(3),
genre VARCHAR2(40),
name VARCHAR2(40),
description VARCHAR2(255));

CREATE TABLE trips(
trip_id NUMBER(6),
trip_category_id NUMBER(6),
hotel_id NUMBER(6),
name VARCHAR2(40),
description VARCHAR2(255),
start_date DATE,
end_date DATE,
activities activity_table_type)
NESTED TABLE activities STORE AS activity_table;

-- -- CONSTRAINTS

ALTER TABLE hotels
ADD CONSTRAINT pk_hotels
PRIMARY KEY (hotel_id);

ALTER TABLE travellers
ADD CONSTRAINT pk_travellers
PRIMARY KEY (traveller_id);


-- -- INSERTS



-- -- QUERIES


