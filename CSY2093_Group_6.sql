
-- -- DROP ALL TABLES / OBJECTS / TYPES

-- RELATIONAL TABLES

DROP TABLE hotels;
DROP TABLE travellers;
DROP TABLE trip_categories;
DROP TABLE trips;

-- OBJECT TABLES

DROP TABLE addresses;

-- NESTED TABLES

DROP TYPE activity_table_type;

-- OBJECT TYPES

DROP TYPE facilities_varray_type;
DROP TYPE facilities_type;
DROP TYPE address_type;
DROP TYPE duration_varray_type;
DROP TYPE activity_type;

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

CREATE OR REPLACE TYPE activity_type AS OBJECT (
    name            VARCHAR2(40),
    description     VARCHAR2(255),
    activity_count  NUMBER(5),
    duration        NUMBER(5),
    capacity        NUMBER(5),
    genre           VARCHAR2(40)
);
/

-- VARRAY TYPES
    
CREATE TYPE facilities_varray_type AS VARRAY(100) OF facilities_type;
/

CREATE TYPE duration_varray_type AS VARRAY(2) OF DATE;
/


-- OBJECT TABLES

CREATE TABLE addresses OF address_type;

-- NESTED TABLES

CREATE TYPE activity_table_type AS TABLE OF activity_type;
/

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

                                            -- add username maybe for functions on travellers

CREATE TABLE trip_categories(
trip_category_id NUMBER(6),
duration duration_varray_type,
minimum_age NUMBER(3),
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

-- PRIMARY KEYS

ALTER TABLE hotels
ADD CONSTRAINT pk_hotels
PRIMARY KEY (hotel_id);

ALTER TABLE travellers
ADD CONSTRAINT pk_travellers
PRIMARY KEY (traveller_id);

ALTER TABLE trip_categories
ADD CONSTRAINT pk_trip_categories
PRIMARY KEY (trip_category_id);

ALTER TABLE trips
ADD CONSTRAINT pk_trips
PRIMARY KEY (trip_id);

-- FOREIGN KEYS

                                                -- -- VERIFY IF WE NEED TO DROP CONSTRAINTS FOR CAROLE


trips 2
tickets

-- -- INSERTS

                                                -- -- VERIFY HOW CAN WE ADDED DATE WITHOUT THE YEAR CAROLE
INSERT INTO trip_categories
VALUES (
    200001,
    duration_varray_type(
        DATE ('12-DEC-2025'),
        DATE ('31-DEC-2025')
    ),
    10,
    'CHRISTMAS',
    'MULTIPLE ACTIVITIES WITH SNOW LIKE SKIING AND BUILDING A SNOWMAN'
);

INSERT INTO trip_categories
VALUES (
    200002,
    duration_varray_type(
        DATE('01-JAN-2026'),
        DATE('10-JAN-2026')
    ),
    12,
    'NEW YEAR',
    'CELEBRATION EVENTS WITH FIREWORK SHOWS AND STREET FOOD'
);

INSERT INTO trip_categories
VALUES (
    200003,
    duration_varray_type(
        DATE('14-FEB-2026'),
        DATE('20-FEB-2026')
    ),
    18,
    'VALENTINE',
    'ROMANTIC ACTIVITIES LIKE COUPLE COOKING AND SKY LANTERNS'
);

INSERT INTO trip_categories
VALUES (
    200004,
    duration_varray_type(
        DATE('01-APR-2026'),
        DATE('05-APR-2026')
    ),
    10,
    'SPRING',
    'FLOWER GARDEN TOURS AND PICNIC ACTIVITIES IN FULL SPRING BLOOM'
);

INSERT INTO trip_categories
VALUES (
    200005,
    duration_varray_type(
        DATE('15-JUL-2026'),
        DATE('25-JUL-2026')
    ),
    15,
    'SUMMER',
    'BEACH ACTIVITIES LIKE SWIMMING, VOLLEYBALL, AND BOAT RIDES'
);

-- -- QUERIES

SELECT trip_category_id id, name, minimum_age, tc.duration
FROM trip_categories tc;


/*
NOTES

EXCEPTION HANDLING

*/
