
-- -- DROP all the table/object

-- RELATIONAL TABLES
DROP TABLE travellers;

-- OBJECT TABLES
DROP TABLE addresses;

-- TYPES
DROP TYPE address_type;



-- -- CREATE all the Types / Objects / Tables

-- TYPES

CREATE OR REPLACE TYPE address_type AS OBJECT (
    street      VARCHAR2(40),
    city        VARCHAR2(40),
    country     VARCHAR2(40)
);
/

-- OBJECT TABLES

CREATE TABLE addresses OF address_type;


-- RELATIONAL TABLES

CREATE TABLE travellers (
    traveller_id    NUMBER(6),
    firstname       VARCHAR2(40),
    surname         VARCHAR2(40),
    dob             DATE,
    address         address_type
);




-- -- CONSTRAINTS

ALTER TABLE travellers
ADD CONSTRAINT pk_travellers
PRIMARY KEY (traveller_id);




-- -- INSERTS



-- -- QUERIES





