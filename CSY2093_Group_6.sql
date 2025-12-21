
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

PURGE RECYCLEBIN;

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

-- ADDRESS OBJECT INSERTS

INSERT INTO addresses
VALUES ('200 WESTMINSTER BRIDGE RD', 'PHUKET', 'THAILAND');

INSERT INTO addresses
VALUES ('56-60 GUILFORD STREET', 'JIMMA', 'ETHIOPIA');

INSERT INTO addresses
VALUES ('9 JUNCTION ROAD', 'SYLHET', 'BANGLADESH');

INSERT INTO addresses
VALUES ('73 ST. MICHAELS ROAD', 'NORTHAMPTON', 'UK');

INSERT INTO addresses
VALUES ('67 St. MICHAELS ROAD', 'UTOPIA', 'SERITH');

-- HOTELS

ALTER SESSION SET NLS_DATE_FORMAT = "HH24:MI";

INSERT INTO hotels (hotel_id, name, description, rating, contact_no, capacity, facilities, addresses)
SELECT 300001, 'PARK PLAZA LONDON WESTMINSTER BRIDGE',
    'MODERN HOTEL ON LONDONS SOUTH BANK, OPPOSITE BIG BEN, OFFERING STYLISH ROOMS, SPA, POOL, DINING, AND EASY ACCESS TO MAJOR ATTRACTIONS.', 'B', '03334006112', 2000,
facilities_varray_type(
    facilities_type('RESTAURANT', 'ON-SITE DINING FACILITY SERVING BREAKFAST, LUNCH AND DINNER', 200, '09:00', '22:00', 0.00),
    facilities_type('BAR', 'HOTEL BAR OFFERING DRINKS AND LIGHT SNACKS', 150, '13:00', '23:00', 0.00),
    facilities_type('SPA', 'WELLNESS FACILITY OFFERING TREATMENTS AND RELAXATION', 50, '09:00', '20:00', 66.00)),
    REF(a) FROM addresses a WHERE street = '200 WESTMINSTER BRIDGE RD';
    
INSERT INTO hotels (hotel_id, name, description, rating, contact_no, capacity, facilities, addresses)
SELECT 300002, 'PRESIDENT HOTEL', 'PRESIDENT HOTEL CAMDEN PROVIDES COMFORTABLE, AFFORDABLE ACCOMMODATION IN CENTRAL LONDON, CLOSE TO CAMDEN TOWN AND MAJOR TRANSPORT LINKS—IDEAL FOR TOURISTS, STUDENTS, AND BUSINESS TRAVELLERS.', 'C', '02078378844', 1000,  
facilities_varray_type(
    facilities_type('RESTAURANT', 'ON-SITE RESTAURANT SERVING BREAKFAST AND EVENING MEALS', 200, '07:00', '22:00', 0.00),
    facilities_type('BAR', 'HOTEL BAR OFFERING DRINKS AND LIGHT SNACKS', 150, '12:00', '23:00', 0.00),
    facilities_type('CONFERENCE ROOM', 'MEETING AND CONFERENCE FACILITIES FOR EVENTS AND BUSINESS USE', 300, '08:00', '21:00', 0.00),
    facilities_type('LOUNGE', 'GUEST LOUNGE AREA FOR RELAXATION AND INFORMAL MEETINGS', 100, '00:00', '23:59', 0.00)),
    REF(a) FROM addresses a WHERE street = '56-60 GUILFORD STREET';


INSERT INTO hotels (hotel_id, name, rating, contact_no, capacity, description, facilities, addresses)
SELECT 300003, 'PLAZA TIMBER', 'B', '07306036151', 2050, 'ENSUITE ROOM WITH FREE FOOD AND ACCESS TO THE POOL BAR',
facilities_varray_type(
    facilities_type('POOL', 'ON-SITE POOL WHERE GUESTS HAVE FUN WHENEVER THEY WANT', 150, '10:30', '22:30', 0.00),
    facilities_type('ROOM SERVICE', 'WORKERS CLEAN EVERYONE''S ROOM WHEN THEY ARE NOT IN THEIR ROOMS', 0, '09:00','08:00', 0.00),
    facilities_type('KIDS CLUB', 'THIS IS FOR CHILDREN ONLY TO HAVE FUN AND DO ACTIVITIES', 100, '12:00', '18:00', 0.00)),
    REF(a) FROM addresses a WHERE street= '9 JUNCTION ROAD';

INSERT INTO hotels (hotel_id, name, rating, contact_no, capacity, description, facilities, addresses)
SELECT 300004, 'HOTEL OAK BRIDGE', 'C', '073890321171', 1, 'ENSUITE WITH A FREE MINI FRIDGE AND ACCESS TO THE BAR',
facilities_varray_type(
    facilities_type('WIFI', 'ACCESS WIFI TO KEEP MEMORIES ON SOCIAL MEDIA', 50, '00:00', '00:00', 0.00),
    facilities_type('BAR', 'ACCESS TO THE BAR SO ADULTS CAN DRINK BEVERAGES OR SOFT DRINKS', 50, '00:00', '01:00', 0.00),
    facilities_type('POOL BAR', 'ACCESS TO BEVERAGES WHILE SWIMMING WITH THE FAMILY', 100, '10:30','22:30', 0.00)),
REF(a) FROM addresses a WHERE street= '73 ST. MICHAELS ROAD';

INSERT INTO hotels (hotel_id, name, rating, contact_no, capacity, description, facilities, addresses)
SELECT 300005, 'PREMIER HOTEL', 'A', '073083647183', 1 , 'SINGLE ROOM WITH SHARED BATHROOM WITH ACCESS TO JOINING ROOMS',
facilities_varray_type(
    facilities_type('ROOM SERVICES', 'WORKERS CLEAN EVERYONE''S ROOM WHEN THEY ARE NOT IN THEIR ROOMS', 0, '09:00', '08:00', 0.00),
    facilities_type('RESTRAUNT', 'ACCESS FOOD AND DRINKS WITH FAMILY AND FRIENDS', 150, '09:00', '23:30', 0.00),
    facilities_type('SPA', 'ACCESS TO A NICE SPA WITH YOUR SIGNIFICANT OTHER', 120, '12:00','21:30', 0.00)), 
    REF(a) FROM addresses a WHERE street='67 ST. MICHAELS ROAD';

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MON/YYYY';

-- TRIPS

INSERT INTO trips
VALUES (400001, 200001, 300001, 'ALPINE BREAK',
    'ENJOY OUTDOOR ACTIVITIES',
    '17-JUN-2025', '25-AUG-2025',
    activity_table_type(
        activity_type('MOUNTAIN HIKE', 'GUIDED GROUP HIKE THROUGH SCENIC MOUNTAIN TRAILS', 12, 4, 20, 'OUTDOOR'),
        activity_type('LAKESIDE PICNIC', 'RELAXING PICNIC BY THE LAKE WITH PROVIDED MEALS', 8, 15, 'CULINARY'),
        activity_type('ROCK CLIMBING SESSION', 'BEGINNER-FRIENDLY CLIMBING ON NATURAL SURFACES', 3, 3, 12, 'ADVENTURE'))
);

INSERT INTO trips
VALUES (400002, 200002, 300002, 'CITY EXPLORER WEEKEND',
    'ENJOY THE CITY THIS WEEKEND',
    '10-DEC-2016', '11-DEC-2016',
    activity_table_type(
        activity_type('HISTORIC MUSEUM TOUR', 'GUIDED WALK THROUGH MAJOR HISTORICAL MUSEUM HIGHLIGHTS', 5, 2, 30, 'CULTURAL'),
        activity_type('STREET FOOD WALK', 'VISIT SEVERAL POPULAR FOOD STALLS AND LEARN ABOUT LOCAL CUISINE', 7, 2, 20, 'CULINARY'),
        activity_type('RIVER CRUISE', 'CALM SIGHTSEEING CRUISE ALONG THE CITY''S RIVER', 1, 1, 50, 'LEISURE'))                              -- check if the ' work or not
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
VALUES (400004, 200004, 300004, 'FESTIVAL AND CULTURE TOUR'
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
VALUES (500001, 400001, 100001, 'CHILD', 200.00, 'THIS TICKET IS ONLY VALID FOR CUSTOMERS AGED 0-17');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500002, 400001, 100002, 'ADULT', 500.00, 'THIS TICKET IS ONLY VALID FOR CUSTOMERS OVER THE AGE OF 17');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500003, 400002, 100003, 'STUDENT', 300.00, 'THIS TICKET IS ONLY VALID FOR CUSTOMERS WHO ARE CURRENTLY STUDENTS');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500004, 400002, 100004, 'DISABLED', 250.00, 'THIS TICKET IS ONLY VALID FOR CUSTOMERS WHO HAVE DISABILITIES');

INSERT INTO tickets (ticket_id, trip_id, traveller_id, name, price, description)
VALUES (500004, 400002, 100005, 'CARER', 0.00, 'THIS TICKET IS ONLY VALID FOR CUSTOMERS WHO CARE FOR A PERSON WITH A DISABILITY');

-- -- QUERIES                   THESE ARE NOT COMPLETELY FORMAT YET!!! MOST OF THEM LOOK QUITE BAD :(

-- Simple one

-- The duration look really weird(it does not show which is the start/finish), it is perfectly fine for developer but not for user
-- maybe this problem can be fix with function/procedure part

-- (yam comment):                       ASK CAROLE ABOUT THIS 'HOW TO QUERY SIMPLE VARRAYS AND DISPLAY THE INFORMATION IN A NICELY FORMATTED WAY'

COLUMN name FORMAT a15;
COLUMN duration FORMAT a46;

SELECT trip_category_id id, name, minimum_age, duration(1) START_DATE, duration(2) END_DATE
FROM trip_categories;

-- OBJECT REFERENCED IN TABLES
COLUMN name FORMAT a18;                 -- (yam comment): see how the formatting is for this, i think this is more legible
COLUMN street FORMAT a15;
COLUMN city FORMAT a15;
COLUMN country FORMAT a15;

SELECT hotel_id, h.name, h.addresses.street street, h.addresses.city city, h.addresses.country country
FROM hotels h;

-- OBJECT TYPE IN COLUMNS
COLUMN firstname FORMAT a15;
COLUMN city FORMAT a15;
COLUMN country FORMAT a15;

SELECT t.traveller_id, t.firstname, t.address.city CITY, t.address.country COUNTRY
FROM travellers t;

-- VARRAY
-- THE OPENING/CLOSING TIME IS A DATE INSTEAD OF TIME       unresolved - yam dont know dis unfortunately
-- Formatting doesn't work here for some reason             (yam comment): fixed by using the pseudoname instead of the column name, check if u want
COLUMN hotel_name FORMAT a15;
COLUMN facility_name FORMAT a15;

SELECT hotel_id, h.name hotel_name, f.name facility_name, f.opening_time, f.closing_time, f.entry_price
FROM hotels h, TABLE(h.facilities) f
WHERE hotel_id = 300005;

-- QUERYING TABLES WITH NESTED TABLES
-- Formatting doesn't work here for some reason             (yam comment): fixed formatting; refer to line 427 comment
COLUMN trip_name FORMAT a11;
COLUMN activity_name FORMAT a16;
COLUMN genre FORMAT a13;

SELECT trip_id, t.name trip_name, a.name activity_name, a.activity_count, a.duration D_HOURS, a.genre       -- (yam comment): removed 1 column cuz it had the same info (plus it contradicted and would look bad cuz of inconsistencies :sob:)
FROM trips t, TABLE(t.activities) a;

-- QUERYING NESTED TABLES ONLY
SELECT VALUE(a)
FROM THE(
SELECT t.activities
FROM trips t
WHERE t.trip_id = 400001) a;

-- UNION, INTERSECT, MINUS

SELECT traveller_id, firstname, surname FROM travellers WHERE dob > '31-MAY-2005'
UNION
SELECT traveller_id, firstname, surname FROM travellers WHERE dob > '31-MAY-2003';

SELECT traveller_id, firstname, surname FROM travellers WHERE dob > '31-MAY-2005'
INTERSECT
SELECT traveller_id, firstname, surname FROM travellers WHERE dob > '31-MAY-2003';

SELECT traveller_id, firstname, surname FROM travellers WHERE dob > '31-MAY-2005'
MINUS
SELECT traveller_id, firstname, surname FROM travellers WHERE dob > '31-MAY-2003';

-- AGGREGATE FUNCTIONS                                                                                   --- FIX FIX FIX FIX 

SELECT COUNT(traveller_id), traveller_id
FROM travellers
GROUP BY travellers;

SELECT MIN(price), ticket_id, name
FROM tickets
GROUP BY ticket_id, name;

SELECT MAX(end_date), hotel_id, name
FROM trips
GROUP BY hotel_id, name;

SELECT SUM(capacity) hotel_id, contact_no
FROM hotels
GROUP BY hotel_id, contact_no;

SELECT AVG(price) ticket_id, name
FROM tickets
GROUP BY ticket_id, name;

-- LIKE, IN, OR, BETWEEN, ANY, SOME AND ALL

SELECT traveller_id, firstname, surname FROM travellers WHERE surname LIKE 'I%';

SELECT t.traveller_id, t.firstname, t.surname 
FROM travellers t 
WHERE t.address.country IN ('UK', 'BANGLADESH', 'ETHIOPIA');

SELECT hotel_id, name, rating, capacity FROM hotels WHERE capacity BETWEEN 1000 AND 3000;

SELECT hotel_id, name, rating FROM hotels WHERE rating < ANY (SELECT rating FROM hotels WHERE rating = 'B');

SELECT hotel_id, name, rating FROM hotels WHERE rating > ALL (SELECT rating FROM hotels WHERE rating = 'B');

-- INNER JOINS : Finding the Ticket Prices for each Traveller and Their Respective Ticket Name, Ordered from Cheapest to most Expensive

COLUMN firstname FORMAT a15;
COLUMN TICKET_NAME FORMAT a15;

SELECT tr.traveller_id, tr.firstname, ti.name TICKET_NAME, ti.price
FROM travellers tr
INNER JOIN tickets ti
    ON tr.traveller_id = ti.traveller_id
ORDER BY ti.price;

-- OUTER JOINS : Listing all the Travellers with their respective Ticket Names and Prices 

COLUMN surname FORMAT a20;

SELECT ti.traveller_id, ti.name TICKET_NAME, ti.price, tr.firstname, tr.surname
FROM tickets ti
LEFT JOIN travellers tr
    ON ti.traveller_id = tr.traveller_id;

-- SUB-QUERIES : Find the information of Travellers who have a Student Ticket

SELECT tr.traveller_id, tr.firstname, tr.surname
FROM travellers tr
WHERE (tr.traveller_id) IN (
    SELECT ti.traveller_id, ti.name
    FROM tickets ti
    WHERE name = 'STUDENTS'
);

/*
NOTES

EXCEPTION HANDLING

*/
