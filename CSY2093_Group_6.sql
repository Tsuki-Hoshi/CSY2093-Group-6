-- DROP all the table/object
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

-- INSERT example



-- QUERY example


