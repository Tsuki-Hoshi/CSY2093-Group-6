-- -- DROP ALL TABLES / OBJECTS / TYPES

-- RELATIONAL TABLES
DROP TABLE trip_categories;
DROP TABLE trips;

-- OBJECT TABLES

-- OBJECT TYPES
DROP TYPE duration_varray_type;

-- -- CREATE ALL TYPES / OBJECTS / TABLES

-- TYPES
CREATE TYPE duration_varray_type AS VARRAY(2) OF DATE;
/

-- VARRAY TYPES

-- OBJECT TABLES

-- RELATIONAL TABLES
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

ALTER TABLE trip_categories
ADD CONSTRAINT pk_trip_categories
PRIMARY KEY (trip_category_id);

ALTER TABLE trips
ADD CONSTRAINT pk_trips
PRIMARY KEY (trip_id);


-- -- INSERTS

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MON';

INSERT INTO trip_categories
VALUES (
    200001,
    duration_varray_type(
        '12/DEC',
        '31/DEC'
    ),
    10,
    'CHRISTMAS',
    'MULTIPLE ACTIVITIES WITH SNOW LIKE SKIING AND BUILDING A SNOWMAN'
);

INSERT INTO trip_categories
VALUES (
    200002,
    duration_varray_type(
        '01/JAN',
        '10/JAN'
    ),
    12,
    'NEW YEAR',
    'CELEBRATION EVENTS WITH FIREWORK SHOWS AND STREET FOOD'
);

INSERT INTO trip_categories
VALUES (
    200003,
    duration_varray_type(
        '14/FEB',
        '20/FEB'
    ),
    18,
    'VALENTINE',
    'ROMANTIC ACTIVITIES LIKE COUPLE COOKING AND SKY LANTERNS'
);

INSERT INTO trip_categories
VALUES (
    200004,
    duration_varray_type(
        '01/APR',
        '05/APR'
    ),
    10,
    'SPRING',
    'FLOWER GARDEN TOURS AND PICNIC ACTIVITIES IN FULL SPRING BLOOM'
);

INSERT INTO trip_categories
VALUES (
    200005,
    duration_varray_type(
        '15/JUL',
        '25/JUL'
    ),
    15,
    'SUMMER',
    'BEACH ACTIVITIES LIKE SWIMMING, VOLLEYBALL, AND BOAT RIDES'
);

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MON/YYYY';

-- -- QUERIES


