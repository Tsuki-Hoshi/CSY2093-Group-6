-- DROP all the table/object
DROP TABLE facilities_varray_type;
DROP TYPE facilities_type;

-- CREATE all the table/object
CREATE TYPE duration_varray_type AS VARRAY(2) OF DATE;
/

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
end_date DATE);

CREATE TABLE hotels (
    hotel_id NUMBER(6),
    name VARCHAR2(40),
    description VARCHAR2(255),
    rating CHAR(1),
    contact_no VARCHAR2(15),
    capacity NUMBER(4),
    addresses REF address_type SCOPE IS addresses
);

CREATE OR REPLACE TYPE facilities_type AS OBJECT (
    name        VARCHAR2(40),
    description VARCHAR2(255),
    capacity    NUMBER(5),
    opening_time DATE,
    closing_time DATE,
    entry_price NUMBER(7,2)
);
/

CREATE TYPE facilities_varray_type AS VARRAY(100) OF facilities_type;
/
-- CONSTRAINTS
ALTER TABLE hotels
ADD CONSTRAINT pk_hotels
PRIMARY KEY (hotel_id);
-- INSERT example



-- QUERY example


