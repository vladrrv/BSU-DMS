INSERT ALL
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('1', 'Norway', '50')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('2', 'Sweden', '100')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('3', 'Finland', '60')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('4', 'Russia', '0')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('5', 'Denmark', '100')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('6', 'Estonia', '80')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('7', 'Latvia', '80')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('8', 'Georgia', '80')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('9', 'Poland', '80')
INTO COUNTRY (id, Name, Visa_Cost) VALUES ('10', 'Ukraine', '0')
SELECT 1 FROM DUAL;

INSERT ALL
INTO CITY (ID, Name, Country_id) VALUES ('1', 'Oslo', '1')
INTO CITY (ID, Name, Country_id) VALUES ('2', 'Stockholm', '2')
INTO CITY (ID, Name, Country_id) VALUES ('3', 'Helsinki', '3')
INTO CITY (ID, Name, Country_id) VALUES ('4', 'Petrozavodsk', '4')
INTO CITY (ID, Name, Country_id) VALUES ('5', 'Murmansk', '4')
INTO CITY (ID, Name, Country_id) VALUES ('6', 'Tallin', '6')
INTO CITY (ID, Name, Country_id) VALUES ('7', 'St-Petersburg', '4')
INTO CITY (ID, Name, Country_id) VALUES ('8', 'Moscow', '4')
INTO CITY (ID, Name, Country_id) VALUES ('9', 'Kyiv', '10')
INTO CITY (ID, Name, Country_id) VALUES ('10', 'Warsaw', '9')
SELECT 1 FROM DUAL;

INSERT ALL
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('1', '1', 'Zvyazda', '25 Some Str', '5', '15')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('2', '1', 'Evropa', '14 Some Str', '3', '10')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('3', '2', 'Moooo', '44 Another Str', '4', '5')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('4', '2', 'Tokio', '103 Another Str', '4', '7')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('5', '3', 'Minsk', '11 Cool Str', '2', '4')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('6', '3', 'Happy', '5 Weird Str', '5', '14')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('7', '4', 'Random', '77 Cold Str', '3', '8')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('8', '4', 'OMG', '55 Bear Str', '3', '5')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('9', '5', 'Blah-Blah', '8 Strange Str', '5', '12')
INTO HOTEL (ID, City_id, Name, Address, Stars, Transfer_Cost) VALUES ('10', '5', 'SomeName', '1 Creepy Str', '5', '10')
SELECT 1 FROM DUAL;

INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('1', '1', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('2', '1', TO_DATE('15.02.2020', 'DD.MM.YY'), TO_DATE('27.02.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('3', '2', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('4', '2', TO_DATE('25.03.2020', 'DD.MM.YY'), TO_DATE('07.04.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('5', '3', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('6', '3', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('7', '4', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('8', '4', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('9', '5', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));
INSERT INTO FLIGHT (ID, CITY_ID, LEAVE_DATE, RETURN_DATE) VALUES ('10', '5', TO_DATE('10.01.2020', 'DD.MM.YY'), TO_DATE('20.01.2020', 'DD.MM.YY'));

INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '1', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '2', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '3', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '4', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '5', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '6', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '7', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '8', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '9', '10');
INSERT INTO SEAT (ID, FLIGHT_ID, COST) VALUES ('1', '10', '10');

INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('1', '1', 'single', '20');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('2', '1', 'single', '20');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('3', '7', 'double', '50');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('4', '6', 'double', '50');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('1', '3', 'single', '40');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('2', '3', 'single', '30');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('2', '9', 'double', '60');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('1', '4', 'single', '40');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('2', '10', 'double', '60');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('1', '5', 'single', '80');
INSERT INTO ROOM (ID, HOTEL_ID, TYPE, LIVING_COST) VALUES ('2', '8', 'double', '120');

INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('1', '1', 'fish', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('2', '1', 'relax', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('3', '2', 'trip', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('4', '2', 'relax', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('5', '3', 'hunt', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('6', '3', 'fish', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('7', '4', 'hunt', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('8', '4', 'relax', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('9', '4', 'trip', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));
INSERT INTO TOUR (ID, COUNTRY_ID, TYPE, START_DATE, END_DATE) VALUES ('10', '4', 'fish', TO_DATE('11.01.2020', 'DD.MM.YY'), TO_DATE('19.01.2020', 'DD.MM.YY'));

INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('1', 'Ivanov', 'MP1234567');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('2', 'Petrov', 'MP1234568');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('3', 'Sidorov', 'MH1234569');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('4', 'Sergeev', 'MP1234567');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('5', 'Mihailov', 'MP1564568');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('6', 'Sidorov', 'MH1279669');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('7', 'Ivanova', 'MP1245667');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('8', 'Petrova', 'MP1411168');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('9', 'Sidorova', 'MT8234569');
INSERT INTO CUSTOMER (ID, NAME, PASSPORT) VALUES ('10', 'Doe', 'ME1734469');

INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('1', '1', '1', '2', '0', '2');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('2', '2', '2', '0', '0', '0');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('3', '2', '4', '1', '0', '0');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('4', '4', '3', '0', '0', '0');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('5', '4', '1', '4', '4', '4');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('6', '5', '4', '0', '0', '0');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('7', '6', '10', '0', '0', '1');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('8', '7', '8', '0', '0', '0');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('9', '8', '4', '0', '5', '0');
INSERT INTO TOURENROLLMENT (ID, CUSTOMER_ID, TOUR_ID, NEED_VISA, NEED_TRANSFER, NEED_INSURANCE) VALUES ('10', '10', '1', '1', '1', '2');

UPDATE ROOM SET TE_ID = '1' WHERE ID = '1' AND HOTEL_ID = '1';
UPDATE ROOM SET TE_ID = '1' WHERE ID = '2' AND HOTEL_ID = '1';
UPDATE ROOM SET TE_ID = '6' WHERE ID = '1' AND HOTEL_ID = '3';
UPDATE ROOM SET TE_ID = '9' WHERE ID = '2' AND HOTEL_ID = '3';

UPDATE SEAT SET TE_ID = '1' WHERE ID = '1' AND FLIGHT_ID = '1';
UPDATE SEAT SET TE_ID = '1' WHERE ID = '1' AND FLIGHT_ID = '2';
UPDATE SEAT SET TE_ID = '6' WHERE ID = '1' AND FLIGHT_ID = '3';
UPDATE SEAT SET TE_ID = '9' WHERE ID = '1' AND FLIGHT_ID = '4';

UPDATE TOURENROLLMENT SET COST = '3000' WHERE ID = '1';
UPDATE TOURENROLLMENT SET COST = '4000' WHERE ID = '2';
UPDATE TOURENROLLMENT SET COST = '2500' WHERE ID = '3';
UPDATE TOURENROLLMENT SET COST = '1000' WHERE ID = '1';