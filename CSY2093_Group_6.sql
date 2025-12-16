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
    name VARCHAR2(40),
    price NUMBER(7,2),
    description VARCHAR2(255)
);

-- CONSTRAINTS
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

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500001, 400000, 100000, 'Child', 200.00, 'This ticket is only valid for customers aged 0-17');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500002, 400000, 100001, 'Adult', 500.00, 'This ticket is only valid for customers over the age of 17');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500003, 400001, 100002, 'Student', 300.00, 'This ticket is only valid for customers who are currently students');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500004, 400001, 100003, 'Disabled', 250.00, 'This ticket is only valid for customers who have disabilities');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500004, 400001, 100004, 'Carer', 0.00, 'This ticket is only valid for customers who care for a person with a disability');


-- Unsure about dates (Reclarify with Carole)


INSERT INTO hotels (hotel_id, name, description, rating, contact_no, capacity, facilities, addresses)
SELECT 300001, 'Park Plaza London Westminster Bridge', 
facilities_varray_type(
    facilities_type('Restaurant', 'On-site dining facility serving breakfast, lunch and dinner', 200, '09:00', '22:00', 0.00),
    facilities_type('Bar', 'Hotel bar offering drinks and light snacks', 150, '13:00', '23:00', 0.00),
    facilities_type('Spa', 'Wellness facility offering treatments and relaxation', 50, '09:00', '20:00', 66.00)),
    'Modern hotel on Londons South Bank, opposite Big Ben, offering stylish rooms, spa, pool, dining, and easy access to major attractions.', 'B', '03334006112', 2000, 
    REF(a) FROM addresses a WHERE street = '200 Westminster Bridge Rd';
    
INSERT INTO hotels (hotel_id, name, description, rating, contact_no, capacity, facilities, addresses)
SELECT 300002, 'President Hotel', 'President Hotel Camden provides comfortable, affordable accommodation in central London, close to Camden Town and major transport links—ideal for tourists, students, and business travellers.', 'C', '02078378844', 1000,  
facilities_varray_type(
    facilities_type('Restaurant', 'On-site restaurant serving breakfast and evening meals', 200, '07:00', '22:00', 0.00),
    facilities_type('Bar', 'Hotel bar offering drinks and light snacks', 150, '12:00', '23:00', 0.00),
    facilities_type('Conference Room', 'Meeting and conference facilities for events and business use', 300, '08:00', '21:00', 0.00),
    facilities_type('Lounge', 'Guest lounge area for relaxation and informal meetings', 100, '00:00', '23:59', 0.00)),
    REF(a) FROM addresses a WHERE street = '56-60 Guilford Street';
    ;


INSERT INTO hotels (hotel_id, name, rating, contact_no, capacity, description, facilities, addresses)
SELECT 300003, 'Plaza Timber', 'B', '07306036151', 2050, 'Ensuite room with free food and access to the Pool bar',
facilities_varray_type(
    facilities_type('Pool', 'On-site pool where guests have fun whenever they want', 150, '10:30', '22:30', 0.00),
    facilities_type('Room Service', 'Workers clean everyones room when they are not in their rooms', 0, '09:00','08:00', 0.00),
    facilities_type('Kids club3', 'This is for children only to have fun and do activities', 100, '12:00', '18:00', 0.00)),
    REF(a) FROM addresses a WHERE street= '9 Junction Road';

INSERT INTO hotels (hotel_id, name, rating, contact_no, capacity, description, facilities, addresses)
SELECT 300004, 'Hotel Oak Bridge', 'C', '073890321171', 1, 'Ensuite with a free mini fridge and access to the Bar',
facilities_varray_type(
    facilities_type('Wifi', 'Access Wifi to keep memories on social media', 50, '00.00', '00.00', 0.00),
    facilities_type('Bar', 'Access to the bar so adults can drink beverages or soft drinks', 50, '05.00', '01.00', 0.00),
    facilities_type('Pool bar', 'Access to beverages while swimming with the family', 100, '10.30','22.30', 0.00)),
REF(a) FROM addresses a WHERE street= '73 St. Michaels Road';

INSERT INTO hotels (hotel_id, name, rating, contact_no, capacity, addresses, facilities, description)
SELECT 300005, 'Premier Hotel', 'A', '073083647183', 1 , 'Single room with shared bathroom with access to Joining rooms',
facilities_varray_type(
    facilities_type('Room services', 'Workers clean everyones room when they are not in their rooms', 0, '09.00', '08.00', 0.00),
    facilities_type('Restraunt', 'Access food and drinks with family and friends', 150, '09.00', '23.30', 0.00),
    facilities_type('Spa', 'Access to a nice spa with your significant other', 120, '12.00','21.30', 0.00)), 
    REF(a) FROM addresses a WHERE street='67 St. Michaels Road';
-- QUERY example


