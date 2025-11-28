-- DROP all the table/object
DROP TABLE hotels;
DROP TABLE facilities_varray_type;
DROP TYPE facilities_type;
-- CREATE all the table/object

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

-- CONSTRAINTS
ALTER TABLE hotels
ADD CONSTRAINT pk_hotels
PRIMARY KEY (hotel_id);
-- INSERT example



-- QUERY example


