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

INSERT INTO trip_categories
VALUES (
    200001,
    duration_varray_type(
        DATE ('12-DEC-2025'),
        DATE ('31-DEC-2025')
    ),
    18,
    'CHRISTMAS',
    'SNOWFLAKE',
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
    'FIREWORK FEST',
    'CELEBRATION EVENTS WITH FIREWORK SHOWS AND STREET FOOD'
);

INSERT INTO trip_categories
VALUES (
    200003,
    duration_varray_type(
        DATE('14-FEB-2026'),
        DATE('20-FEB-2026')
    ),
    16,
    'VALENTINE',
    'HEARTWARM',
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
    'BLOOMFEST',
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
    'SUNBURST',
    'BEACH ACTIVITIES LIKE SWIMMING, VOLLEYBALL, AND BOAT RIDES'
);

-- -- QUERIES


