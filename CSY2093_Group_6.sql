
-- -- DROP ALL TABLES / OBJECTS / TYPES

-- RELATIONAL TABLES

DROP TABLE hotels;
DROP TABLE travellers;
DROP TABLE trip_categories;
DROP TABLE trips;
DROP TABLE tickets;

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

CREATE TABLE tickets (
    ticket_id NUMBER(6),
    trip_id NUMBER(6),
    traveller_id NUMBER(6),
    name VARCHAR2(40),
    price NUMBER(7,2),
    description VARCHAR2(255)
);

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

ALTER TABLE tickets
ADD CONSTRAINT pk_tickets
PRIMARY KEY (ticket_id);

-- FOREIGN KEYS

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

-- -- INSERTS

-- TRAVELLERS

INSERT INTO travellers
VALUES (100001, 'JUNYO', 'ISHIZAKA ANTARASEN', '31-MAY-2005', address_type('10 FUNKY WAY', 'PHUKET', 'THAILAND'));

INSERT INTO travellers
VALUES (100002, 'NATNAEL', 'SINTAYEHU', '15-FEB-2006', address_type(' 16 LEAGUE STREET', 'JIMMA', 'ETHIOPIA'));

INSERT INTO travellers
VALUES (100003, 'SYED YAMEEN', 'MAHDI', '14-MAR-2006', address_type('49 COOL ALLEYWAY', 'SYLHET', 'BANGLADESH'));

INSERT INTO travellers
VALUES (100004, 'WARREN', 'BROWNE', '24-APR-2003', address_type('4 SILENT ROAD', 'NORTHAMPTON', 'UK'));

INSERT INTO travellers
VALUES (100005, 'HUGO', 'VEIL', '06-JAN-1800', address_type('13 SERRIN LAND', 'UTOPIA', 'SERITH'));

-- TRIP CATEGORIES

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

-- HOTELS

INSERT INTO hotels (hotel_id, name, description, rating, contact_no, capacity, addresses, facilities)
VALUES (300001, 'Park Plaza London Westminster Bridge', 'Modern hotel on Londons South Bank, opposite Big Ben, offering stylish rooms, spa, pool, dining, and easy access to major attractions.', 'B', '03334006112', 2000, 
(REF(a) FROM addresses a WHERE street = '200 Westminster Bridge Rd'), 
facility_varray_type(
    facilities_type('Restaurant', 'On-site dining facility serving breakfast, lunch and dinner', 200, '09:00', '22:00', 0.00),
    facilities_type('Bar', 'Hotel bar offering drinks and light snacks', 150, '13:00', '23:00', 0.00),
    facilities_type('Spa', 'Wellness facility offering treatments and relaxation', 50, '09:00', '20:00', 66.00))
    );
    
INSERT INTO hotels (hotel_id, name, description, rating, contact_no, capacity, addresses, facilities)
VALUES (300002, 'President Hotel', 'President Hotel Camden provides comfortable, affordable accommodation in central London, close to Camden Town and major transport links—ideal for tourists, students, and business travellers.', 'C', '02078378844', 1000, 
(REF(a) FROM addresses a WHERE street = '56-60 Guilford Street'), 
facility_varray_type(
    facilities_type('Restaurant', 'On-site restaurant serving breakfast and evening meals', 200, '07:00', '22:00', 0.00),
    facilities_type('Bar', 'Hotel bar offering drinks and light snacks', 150, '12:00', '23:00', 0.00),
    facilities_type('Conference Room', 'Meeting and conference facilities for events and business use', 300, '08:00', '21:00', 0.00),
    facilities_type('Lounge', 'Guest lounge area for relaxation and informal meetings', 100, '00:00', '23:59', 0.00))
    );


INSERT INTO hotel (hotel_id, name, rating, contact_no, capacity, addresses, facilities, description)
VALUES(300003, 'Plaza Timber', 'B', '07306036151', 2050, REF(a) FROM addresses WHERE a.street= '9 Junction Road', 'Ensuite room with free food and access to the Pool bar',
facility_varry_type(
    facility_type('Pool', 'On-site pool where guests have fun whenever they want', 150, '10.30', '22.30', 0.00),
    facility_type('Room Service', 'Workers clean everyones room when they are not in their rooms', 0, '09.00','08.00', 0.00),
    facility_type('Kids club3', 'This is for children only to have fun and do activities', 100, '12.00', '18.00', 0.00)
));

INSERT INTO hotel (hotel_id, name, rating, contact_no, capacity, addresses, facilities, description)
VALUES(300004, 'Hotel Oak Bridge', 'C', '073890321171', 1, REF(a) FROM addresses WHERE a.street= '73 St. Michaels Road', 'Ensuite with a free mini fridge and access to the Bar'
facility_varry_type(
    facility_type('Wifi', 'Access Wifi to keep memories on social media', 50, '00.00', '00.00', 0.00),
    facility_type('Bar', 'Access to the bar so adults can drink beverages or soft drinks', 50, '05.00', '01.00', 0.00),
    facility_type('Pool bar', 'Access to beverages while swimming with the family', 100, '10.30','22.30', 0.00)
));

INSERT INTO hotel (hotel_id, name, rating, contact_no, capacity, addresses, facilities, description)
VALUES(300005, 'Premier Hotel', 'A', '073083647183', 1, REF(a) FROM addresses WHERE a.street='67 St. Michaels Road', 'Single room with shared bathroom with access to Joining rooms'
facility_varry_type(
    facility_type('Room services', 'Workers clean everyones room when they are not in their rooms', 0, '09.00', '08.00', 0.00),
    facility_type('Restraunt', 'Access food and drinks with family and friends', 150, '09.00', '23.30', 0.00),
    facility_type('Spa', 'Access to a nice spa with your significant other', 120, '12.00','21.30', 0.00)
));

-- TRIPS

INSERT INTO trips
VALUES (400001, 200001, 300001, 'ALPINE BREAK',
    'ENJOY OUTDOOR ACTIVITIES',
    '17-JUN-2025', '25-AUG-2025',
    activity_table_type(
        activity_type('MOUNTAIN HIKE', 'GUIDED GROUP HIKE THROUGH SCENIC MOUNTAIN TRAILS', 12, 4, 20, 'OUTDOOR'),
        activity_type('LAKESIDE PICNIC', 'RELAXING PICNIC BY THE LAKE WITH PROVIDED MEALS', 8, 15, 25, 'CULINARY'),
        activity_type('ROCK CLIMBING SESSION', 'BEGINNER-FRIENDLY CLIMBING ON NATURAL SURFACES', 3, 3, 12, 'ADVENTURE'))
);

INSERT INTO trips
VALUES (400002, 200002, 300002, 'CITY EXPLORER WEEKEND',
    'ENJOY THE CITY THIS WEEKEND',
    '10-DEC-2016', '11-DEC-2016',
    activity_table_type(
        activity_type('HISTORIC MUSEUM TOUR', 'GUIDED WALK THROUGH MAJOR HISTORICAL MUSEUM HIGHLIGHTS', 5, 2, 30, 'CULTURAL'),
        activity_type('STREET FOOD WALK', 'VISIT SEVERAL POPULAR FOOD STALLS AND LEARN ABOUT LOCAL CUISINE', 7, 2, 20, 'CULINARY'),
        activity_type('RIVER CRUISE', 'CALM SIGHTSEEING CRUISE ALONG THE CITY''S RIVER', 1, 1, 50, 'LEISURE'))                                          -- check this ESCAPE VALUEEE
);

INSERT INTO trips
VALUES (400003, 200003, 300003, 'DESERT ADVENTURE TOUR',
    'EXPLORE THE VAST DESERTS',
    '22-DEC-2025', '28-DEC-2025',
    activity_table_type(
        activity_type('SAND DUNE SAFARI', 'OFF-ROAD VEHICLE RIDE ACROSS SAND DUNES', 4, 3, 15, 'ADVENTURE'),
        activity_type('CAMEL TREK', 'TRADITIONAL CAMEL RIDE ACROSS THE DESERT', 1, 2, 18, 'OUTDOOR'),
        activity_type('STARGAZING NIGHT CAMP', 'NIGHTTIME DESERT CAMP FOCUSED ON ASTRONOMY AND CONSTELLATIONS', 1, 5, 25, 'EDUCATIONAL'))
);

INSERT INTO trips
VALUES (400004, 200004, 300004, 'FESTIVAL AND CULTURE TOUR',
    'EXPERIENCE THE FESTIVAL AND THE CULTURE OF THE CITY',
    '29-DEC-2025', '04-JAN-2026',
    activity_table_type(
        activity_type('MUSIC FESTIVAL ENTRY', 'FULL-DAY ADMISSION TO MAJOR MUSIC FESTIVAL', 1, 10, 100, 'ENTERTAINMENT'),
        activity_type('LOCAL CRAFTS WORKSHOP', 'HANDS-ON WORKSHOP MAKING TRADITIONAL CRAFT ITEMS', 4, 2, 20, 'CULTURAL'),
        activity_type('PHOTOGRAPHY WALK', 'GUIDED PHOTO WALK THROUGH COLOURFUL FESTIVAL AREAS', 6, 3, 25, 'ARTISTIC'))
);

INSERT INTO trips
VALUES (400005, 200005, 300005, 'ISLAND RESORT RETREAT',
    'CHECK OUT THIS SWAGGER ISLAND AND THESE ACTIVITIES',
    '09-AUG-2027', '15-AUG-2027',
    activity_table_type(
        activity_type('SNORKELING TOUR', 'GUIDED SNORKELING SESSION IN SHALLOW CORAL REEFS', 3, 2, 20, 'WATER'),
        activity_type('BEACH YOGA SESSION', 'MORNING GUIDED YOGA ON THE BEACH', 1, 1, 15, 'WELLNESS'),
        activity_type('SUNSET BOAT RIDE', 'EVENING BOAT RIDE WITH SCENIC OCEAN VIEWS', 1, 1, 30, 'LEISURE'))
);

-- TICKETS

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

-- -- QUERIES

SELECT trip_category_id id, name, minimum_age, tc.duration
FROM trip_categories tc;


/*
NOTES

EXCEPTION HANDLING

*/

