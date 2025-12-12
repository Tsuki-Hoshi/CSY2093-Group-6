-- DROP all the table/object
DROP TABLE facilities_varray_type;
DROP TYPE facilities_type;
DROP TABLE hotels;
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

CREATE TABLE tickets (
    ticket_id NUMBER(6),
    trip_id NUMBER(6),
    traveller_id NUMBER(6),
    price NUMBER(7,2),
    name VARCHAR2(40),
    description VARCHAR2(255)
);

-- CONSTRAINTS
ALTER TABLE hotels
ADD CONSTRAINT pk_hotels
PRIMARY KEY (hotel_id);

ALTER TABLE travellers
ADD CONSTRAINT pk_travellers
PRIMARY KEY (traveller_id);

ALTER TABLE trip_categorys
ADD CONSTRAINT pk_trip_category
PRIMARY KEY (trip_category_id);

ALTER TABLE trips
ADD CONSTRAINT pk_trips
PRIMARY KEY (trip_id);

ALTER TABLE tickets
ADD CONSTRAINT pk_tickets
PRIMARY KEY (ticket_id);

ALTER TABLE trips
ADD CONSTRAINT fk_tr_trip_categories
FOREIGN KEY (trip_category_id)
REFERENCES trip_categories (trip_category_id);

ALTER TABLE trips
ADD CONSTRAINT fk_tr_hotels
FOREIGN KEY (hotel_id)
REFERENCES hotels (hotel_id);

ALTER TABLE tickets
ADD CONSTRAINT fk_ti_trips
FOREIGN KEY (trip_id)
REFERENCES trips (trip_id);

ALTER TABLE tickets
ADD CONSTRAINT fk_ti_travellers
FOREIGN KEY (traveller_id)
REFERENCES travellers (traveller_id);
-- INSERT example



-- QUERY example


