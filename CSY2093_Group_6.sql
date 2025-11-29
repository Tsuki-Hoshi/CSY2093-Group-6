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



-- -- QUERIES


