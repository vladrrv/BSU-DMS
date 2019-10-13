
DROP TABLE Room CASCADE CONSTRAINTS PURGE;

DROP TABLE Hotel CASCADE CONSTRAINTS PURGE;

DROP TABLE Seat CASCADE CONSTRAINTS PURGE;

DROP TABLE TourEnrollment CASCADE CONSTRAINTS PURGE;

DROP TABLE Tour CASCADE CONSTRAINTS PURGE;

DROP TABLE Customer CASCADE CONSTRAINTS PURGE;

DROP TABLE Flight CASCADE CONSTRAINTS PURGE;

DROP TABLE City CASCADE CONSTRAINTS PURGE;

DROP TABLE Country CASCADE CONSTRAINTS PURGE;

CREATE TABLE City
(
    id                   INT NOT NULL ,
    Country_id           INT NOT NULL ,
    Name                 CHAR(18) NOT NULL
);

CREATE UNIQUE INDEX XPKCity ON City
    (id   ASC);

ALTER TABLE City
    ADD CONSTRAINT  XPKCity PRIMARY KEY (id);

CREATE TABLE Country
(
    id                   INT NOT NULL ,
    Name                 CHAR(18) NOT NULL ,
    Visa_Cost            DECIMAL(19,4) NULL  CONSTRAINT  CostConstraint3 CHECK (Visa_Cost >= 0)
);

CREATE UNIQUE INDEX XPKCountry ON Country
    (id   ASC);

ALTER TABLE Country
    ADD CONSTRAINT  XPKCountry PRIMARY KEY (id);

CREATE TABLE Customer
(
    id                   INT NOT NULL ,
    Name                 CHAR(18) NULL ,
    Address              CHAR(18) NULL ,
    Passport             CHAR(18) NULL ,
    CONSTRAINT Passport_1941159630 CHECK ( NOT REGEXP_LIKE(Passport,'^[[A-Z]{2}[0-9]{7}]$') )
);

CREATE UNIQUE INDEX XPKCustomer ON Customer
    (id   ASC);

ALTER TABLE Customer
    ADD CONSTRAINT  XPKCustomer PRIMARY KEY (id);

CREATE TABLE Flight
(
    id                   INT NOT NULL ,
    City_id              INT NOT NULL ,
    Leave_Date           DATE NOT NULL ,
    Return_Date          DATE NOT NULL ,
    CONSTRAINT FlightDateRule_1356924654 CHECK ( Leave_Date < Return_Date )
);

CREATE UNIQUE INDEX XPKFlight ON Flight
    (id   ASC);

ALTER TABLE Flight
    ADD CONSTRAINT  XPKFlight PRIMARY KEY (id);

CREATE TABLE Hotel
(
    id                   INT NOT NULL ,
    City_id              INT NOT NULL ,
    Address              CHAR(18) NULL ,
    Stars                INTEGER NULL  CONSTRAINT  HotelStarsConstraint CHECK (Stars IN (1, 2, 3, 4, 5)),
    Transfer_Cost        DECIMAL(19,4) NOT NULL  CONSTRAINT  TransferCostConstraint CHECK (Transfer_Cost >= 0),
    Name                 CHAR(18) NULL
);

CREATE UNIQUE INDEX XPKHotel ON Hotel
    (id   ASC);

ALTER TABLE Hotel
    ADD CONSTRAINT  XPKHotel PRIMARY KEY (id);

CREATE TABLE Tour
(
    id                   INT NOT NULL ,
    Country_id           INT NOT NULL ,
    Type                 CHAR(18) NOT NULL  CONSTRAINT  TourTypeConstraint CHECK (Type IN ('relax', 'trip', 'hunt', 'fish')),
    Start_Date           DATE NOT NULL ,
    End_Date             DATE NOT NULL ,
    CONSTRAINT TourDateRule_1068878767 CHECK ( Start_Date < End_Date )
);

CREATE UNIQUE INDEX XPKTour ON Tour
    (id   ASC);

ALTER TABLE Tour
    ADD CONSTRAINT  XPKTour PRIMARY KEY (id);

CREATE TABLE TourEnrollment
(
    id                   INT NOT NULL ,
    Customer_id          INT NOT NULL ,
    Tour_id              INT NOT NULL ,
    Need_Visa            SMALLINT NULL ,
    Need_Transfer        SMALLINT NULL ,
    Need_Insurance       SMALLINT NULL ,
    Cost                 DECIMAL(19,4) NULL
);

CREATE UNIQUE INDEX XPKTourEnrollment ON TourEnrollment
    (id   ASC);

ALTER TABLE TourEnrollment
    ADD CONSTRAINT  XPKTourEnrollment PRIMARY KEY (id);

CREATE TABLE Room
(
    id                   INT NOT NULL ,
    Hotel_id             INT NOT NULL ,
    Type                 CHAR(18) NULL  CONSTRAINT  RoomTypeConstraint CHECK (Type IN ('single', 'double', 'triple', 'quad', 'queen', 'king')),
    Living_Cost          DECIMAL(19,4) NOT NULL  CONSTRAINT  CostConstraint2 CHECK (Living_Cost >= 0),
    TE_id                INT NULL
);

CREATE UNIQUE INDEX XPKRoom ON Room
    (id   ASC,Hotel_id   ASC);

ALTER TABLE Room
    ADD CONSTRAINT  XPKRoom PRIMARY KEY (id,Hotel_id);

CREATE TABLE Seat
(
    id                   INT NOT NULL ,
    Flight_id            INT NOT NULL ,
    Cost                 DECIMAL(19,4) NOT NULL  CONSTRAINT  CostConstraint CHECK (Cost >= 0),
    TE_id                INT NULL
);

CREATE UNIQUE INDEX XPKSeat ON Seat
    (id   ASC,Flight_id   ASC);

ALTER TABLE Seat
    ADD CONSTRAINT  XPKSeat PRIMARY KEY (id,Flight_id);

ALTER TABLE City
    ADD (CONSTRAINT R_8 FOREIGN KEY (Country_id) REFERENCES Country (id));

ALTER TABLE Flight
    ADD (CONSTRAINT R_7 FOREIGN KEY (City_id) REFERENCES City (id));

ALTER TABLE Hotel
    ADD (CONSTRAINT R_9 FOREIGN KEY (City_id) REFERENCES City (id));

ALTER TABLE Tour
    ADD (CONSTRAINT R_16 FOREIGN KEY (Country_id) REFERENCES Country (id));

ALTER TABLE TourEnrollment
    ADD (CONSTRAINT R_20 FOREIGN KEY (Customer_id) REFERENCES Customer (id));

ALTER TABLE TourEnrollment
    ADD (CONSTRAINT R_21 FOREIGN KEY (Tour_id) REFERENCES Tour (id));

ALTER TABLE Room
    ADD (CONSTRAINT R_10 FOREIGN KEY (Hotel_id) REFERENCES Hotel (id));

ALTER TABLE Room
    ADD (CONSTRAINT R_11 FOREIGN KEY (TE_id) REFERENCES TourEnrollment (id) ON DELETE SET NULL);

ALTER TABLE Seat
    ADD (CONSTRAINT R_12 FOREIGN KEY (Flight_id) REFERENCES Flight (id));

ALTER TABLE Seat
    ADD (CONSTRAINT R_13 FOREIGN KEY (TE_id) REFERENCES TourEnrollment (id) ON DELETE SET NULL);

CREATE  TRIGGER  tD_City AFTER DELETE ON City for each row
    -- erwin Builtin Trigger
-- DELETE trigger on City
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* City  Hotel on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00019b5e", PARENT_OWNER="", PARENT_TABLE="City"
    CHILD_OWNER="", CHILD_TABLE="Hotel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_9", FK_COLUMNS="City_id" */
    SELECT count(*) INTO NUMROWS
    FROM Hotel
    WHERE
        /*  %JoinFKPK(Hotel,:%Old," = "," AND") */
            Hotel.City_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete City because Hotel exists.'
            );
    END IF;

    /* erwin Builtin Trigger */
    /* City  Flight on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="City"
    CHILD_OWNER="", CHILD_TABLE="Flight"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_7", FK_COLUMNS="City_id" */
    SELECT count(*) INTO NUMROWS
    FROM Flight
    WHERE
        /*  %JoinFKPK(Flight,:%Old," = "," AND") */
            Flight.City_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete City because Flight exists.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_City BEFORE INSERT ON City for each row
    -- erwin Builtin Trigger
-- INSERT trigger on City
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Country  City on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e888", PARENT_OWNER="", PARENT_TABLE="Country"
    CHILD_OWNER="", CHILD_TABLE="City"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_8", FK_COLUMNS="Country_id" */
    SELECT count(*) INTO NUMROWS
    FROM Country
    WHERE
        /* %JoinFKPK(:%New,Country," = "," AND") */
            :new.Country_id = Country.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert City because Country does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_City AFTER UPDATE ON City for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on City
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* City  Hotel on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="0002c9e8", PARENT_OWNER="", PARENT_TABLE="City"
      CHILD_OWNER="", CHILD_TABLE="Hotel"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_9", FK_COLUMNS="City_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM Hotel
        WHERE
            /*  %JoinFKPK(Hotel,:%Old," = "," AND") */
                Hotel.City_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update City because Hotel exists.'
                );
        END IF;
    END IF;

    /* erwin Builtin Trigger */
    /* City  Flight on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="City"
      CHILD_OWNER="", CHILD_TABLE="Flight"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_7", FK_COLUMNS="City_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM Flight
        WHERE
            /*  %JoinFKPK(Flight,:%Old," = "," AND") */
                Flight.City_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update City because Flight exists.'
                );
        END IF;
    END IF;

    /* erwin Builtin Trigger */
    /* Country  City on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Country"
      CHILD_OWNER="", CHILD_TABLE="City"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_8", FK_COLUMNS="Country_id" */
    SELECT count(*) INTO NUMROWS
    FROM Country
    WHERE
        /* %JoinFKPK(:%New,Country," = "," AND") */
            :new.Country_id = Country.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update City because Country does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Country AFTER DELETE ON Country for each row
    -- erwin Builtin Trigger
-- DELETE trigger on Country
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Country  Tour on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001adff", PARENT_OWNER="", PARENT_TABLE="Country"
    CHILD_OWNER="", CHILD_TABLE="Tour"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_16", FK_COLUMNS="Country_id" */
    SELECT count(*) INTO NUMROWS
    FROM Tour
    WHERE
        /*  %JoinFKPK(Tour,:%Old," = "," AND") */
            Tour.Country_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete Country because Tour exists.'
            );
    END IF;

    /* erwin Builtin Trigger */
    /* Country  City on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Country"
    CHILD_OWNER="", CHILD_TABLE="City"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_8", FK_COLUMNS="Country_id" */
    SELECT count(*) INTO NUMROWS
    FROM City
    WHERE
        /*  %JoinFKPK(City,:%Old," = "," AND") */
            City.Country_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete Country because City exists.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Country AFTER UPDATE ON Country for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Country
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Country  Tour on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="0001dee7", PARENT_OWNER="", PARENT_TABLE="Country"
      CHILD_OWNER="", CHILD_TABLE="Tour"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_16", FK_COLUMNS="Country_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM Tour
        WHERE
            /*  %JoinFKPK(Tour,:%Old," = "," AND") */
                Tour.Country_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update Country because Tour exists.'
                );
        END IF;
    END IF;

    /* erwin Builtin Trigger */
    /* Country  City on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Country"
      CHILD_OWNER="", CHILD_TABLE="City"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_8", FK_COLUMNS="Country_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM City
        WHERE
            /*  %JoinFKPK(City,:%Old," = "," AND") */
                City.Country_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update Country because City exists.'
                );
        END IF;
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Customer AFTER DELETE ON Customer for each row
    -- erwin Builtin Trigger
-- DELETE trigger on Customer
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Customer  TourEnrollment on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e7d0", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_20", FK_COLUMNS="Customer_id" */
    SELECT count(*) INTO NUMROWS
    FROM TourEnrollment
    WHERE
        /*  %JoinFKPK(TourEnrollment,:%Old," = "," AND") */
            TourEnrollment.Customer_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete Customer because TourEnrollment exists.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Customer AFTER UPDATE ON Customer for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Customer
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Customer  TourEnrollment on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="00010814", PARENT_OWNER="", PARENT_TABLE="Customer"
      CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_20", FK_COLUMNS="Customer_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM TourEnrollment
        WHERE
            /*  %JoinFKPK(TourEnrollment,:%Old," = "," AND") */
                TourEnrollment.Customer_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update Customer because TourEnrollment exists.'
                );
        END IF;
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Flight AFTER DELETE ON Flight for each row
    -- erwin Builtin Trigger
-- DELETE trigger on Flight
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Flight Have Seat on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000cef8", PARENT_OWNER="", PARENT_TABLE="Flight"
    CHILD_OWNER="", CHILD_TABLE="Seat"
    P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_11", FK_COLUMNS="Flight_id" */
    SELECT count(*) INTO NUMROWS
    FROM Seat
    WHERE
        /*  %JoinFKPK(Seat,:%Old," = "," AND") */
            Seat.Flight_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete Flight because Seat exists.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Flight BEFORE INSERT ON Flight for each row
    -- erwin Builtin Trigger
-- INSERT trigger on Flight
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* City  Flight on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d8b3", PARENT_OWNER="", PARENT_TABLE="City"
    CHILD_OWNER="", CHILD_TABLE="Flight"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_7", FK_COLUMNS="City_id" */
    SELECT count(*) INTO NUMROWS
    FROM City
    WHERE
        /* %JoinFKPK(:%New,City," = "," AND") */
            :new.City_id = City.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert Flight because City does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Flight AFTER UPDATE ON Flight for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Flight
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Flight Have Seat on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="0001e248", PARENT_OWNER="", PARENT_TABLE="Flight"
      CHILD_OWNER="", CHILD_TABLE="Seat"
      P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_11", FK_COLUMNS="Flight_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM Seat
        WHERE
            /*  %JoinFKPK(Seat,:%Old," = "," AND") */
                Seat.Flight_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update Flight because Seat exists.'
                );
        END IF;
    END IF;

    /* erwin Builtin Trigger */
    /* City  Flight on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="City"
      CHILD_OWNER="", CHILD_TABLE="Flight"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_7", FK_COLUMNS="City_id" */
    SELECT count(*) INTO NUMROWS
    FROM City
    WHERE
        /* %JoinFKPK(:%New,City," = "," AND") */
            :new.City_id = City.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update Flight because City does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Hotel AFTER DELETE ON Hotel for each row
    -- erwin Builtin Trigger
-- DELETE trigger on Hotel
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Hotel Have Room on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000c4af", PARENT_OWNER="", PARENT_TABLE="Hotel"
    CHILD_OWNER="", CHILD_TABLE="Room"
    P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_10", FK_COLUMNS="Hotel_id" */
    SELECT count(*) INTO NUMROWS
    FROM Room
    WHERE
        /*  %JoinFKPK(Room,:%Old," = "," AND") */
            Room.Hotel_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete Hotel because Room exists.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Hotel BEFORE INSERT ON Hotel for each row
    -- erwin Builtin Trigger
-- INSERT trigger on Hotel
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* City  Hotel on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000db28", PARENT_OWNER="", PARENT_TABLE="City"
    CHILD_OWNER="", CHILD_TABLE="Hotel"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_9", FK_COLUMNS="City_id" */
    SELECT count(*) INTO NUMROWS
    FROM City
    WHERE
        /* %JoinFKPK(:%New,City," = "," AND") */
            :new.City_id = City.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert Hotel because City does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Hotel AFTER UPDATE ON Hotel for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Hotel
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Hotel Have Room on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="0001bb3a", PARENT_OWNER="", PARENT_TABLE="Hotel"
      CHILD_OWNER="", CHILD_TABLE="Room"
      P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_10", FK_COLUMNS="Hotel_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM Room
        WHERE
            /*  %JoinFKPK(Room,:%Old," = "," AND") */
                Room.Hotel_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update Hotel because Room exists.'
                );
        END IF;
    END IF;

    /* erwin Builtin Trigger */
    /* City  Hotel on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="City"
      CHILD_OWNER="", CHILD_TABLE="Hotel"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_9", FK_COLUMNS="City_id" */
    SELECT count(*) INTO NUMROWS
    FROM City
    WHERE
        /* %JoinFKPK(:%New,City," = "," AND") */
            :new.City_id = City.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update Hotel because City does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Tour AFTER DELETE ON Tour for each row
    -- erwin Builtin Trigger
-- DELETE trigger on Tour
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Tour  TourEnrollment on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e75f", PARENT_OWNER="", PARENT_TABLE="Tour"
    CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_21", FK_COLUMNS="Tour_id" */
    SELECT count(*) INTO NUMROWS
    FROM TourEnrollment
    WHERE
        /*  %JoinFKPK(TourEnrollment,:%Old," = "," AND") */
            TourEnrollment.Tour_id = :old.id;
    IF (NUMROWS > 0)
    THEN
        raise_application_error(
                -20001,
                'Cannot delete Tour because TourEnrollment exists.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_Tour BEFORE INSERT ON Tour for each row
    -- erwin Builtin Trigger
-- INSERT trigger on Tour
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Country  Tour on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000e3de", PARENT_OWNER="", PARENT_TABLE="Country"
    CHILD_OWNER="", CHILD_TABLE="Tour"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_16", FK_COLUMNS="Country_id" */
    SELECT count(*) INTO NUMROWS
    FROM Country
    WHERE
        /* %JoinFKPK(:%New,Country," = "," AND") */
            :new.Country_id = Country.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert Tour because Country does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Tour AFTER UPDATE ON Tour for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Tour
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Tour  TourEnrollment on parent update restrict */
    /* ERWIN_RELATION:CHECKSUM="0001fb33", PARENT_OWNER="", PARENT_TABLE="Tour"
      CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_21", FK_COLUMNS="Tour_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        SELECT count(*) INTO NUMROWS
        FROM TourEnrollment
        WHERE
            /*  %JoinFKPK(TourEnrollment,:%Old," = "," AND") */
                TourEnrollment.Tour_id = :old.id;
        IF (NUMROWS > 0)
        THEN
            raise_application_error(
                    -20005,
                    'Cannot update Tour because TourEnrollment exists.'
                );
        END IF;
    END IF;

    /* erwin Builtin Trigger */
    /* Country  Tour on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Country"
      CHILD_OWNER="", CHILD_TABLE="Tour"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_16", FK_COLUMNS="Country_id" */
    SELECT count(*) INTO NUMROWS
    FROM Country
    WHERE
        /* %JoinFKPK(:%New,Country," = "," AND") */
            :new.Country_id = Country.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update Tour because Country does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_TourEnrollment AFTER DELETE ON TourEnrollment for each row
    -- erwin Builtin Trigger
-- DELETE trigger on TourEnrollment
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* TourEnrollment  Seat on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00015581", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
    CHILD_OWNER="", CHILD_TABLE="Seat"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_12", FK_COLUMNS="TE_id" */
    UPDATE Seat
    SET
        /* %SetFK(Seat,NULL) */
        Seat.TE_id = NULL
    WHERE
        /* %JoinFKPK(Seat,:%Old," = "," AND") */
            Seat.TE_id = :old.id;

    /* erwin Builtin Trigger */
    /* TourEnrollment  Room on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
    CHILD_OWNER="", CHILD_TABLE="Room"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_11", FK_COLUMNS="TE_id" */
    UPDATE Room
    SET
        /* %SetFK(Room,NULL) */
        Room.TE_id = NULL
    WHERE
        /* %JoinFKPK(Room,:%Old," = "," AND") */
            Room.TE_id = :old.id;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tI_TourEnrollment BEFORE INSERT ON TourEnrollment for each row
    -- erwin Builtin Trigger
-- INSERT trigger on TourEnrollment
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* Tour  TourEnrollment on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001e3f4", PARENT_OWNER="", PARENT_TABLE="Tour"
    CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_21", FK_COLUMNS="Tour_id" */
    SELECT count(*) INTO NUMROWS
    FROM Tour
    WHERE
        /* %JoinFKPK(:%New,Tour," = "," AND") */
            :new.Tour_id = Tour.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert TourEnrollment because Tour does not exist.'
            );
    END IF;

    /* erwin Builtin Trigger */
    /* Customer  TourEnrollment on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_20", FK_COLUMNS="Customer_id" */
    SELECT count(*) INTO NUMROWS
    FROM Customer
    WHERE
        /* %JoinFKPK(:%New,Customer," = "," AND") */
            :new.Customer_id = Customer.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert TourEnrollment because Customer does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_TourEnrollment AFTER UPDATE ON TourEnrollment for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on TourEnrollment
DECLARE NUMROWS INTEGER;
BEGIN
    /* TourEnrollment  Seat on parent update set null */
    /* ERWIN_RELATION:CHECKSUM="00037aa4", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
      CHILD_OWNER="", CHILD_TABLE="Seat"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_12", FK_COLUMNS="TE_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        UPDATE Seat
        SET
            /* %SetFK(Seat,NULL) */
            Seat.TE_id = NULL
        WHERE
            /* %JoinFKPK(Seat,:%Old," = ",",") */
                Seat.TE_id = :old.id;
    END IF;

    /* TourEnrollment  Room on parent update set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
      CHILD_OWNER="", CHILD_TABLE="Room"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_11", FK_COLUMNS="TE_id" */
    IF
        /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
            :old.id <> :new.id
    THEN
        UPDATE Room
        SET
            /* %SetFK(Room,NULL) */
            Room.TE_id = NULL
        WHERE
            /* %JoinFKPK(Room,:%Old," = ",",") */
                Room.TE_id = :old.id;
    END IF;

    /* erwin Builtin Trigger */
    /* Tour  TourEnrollment on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Tour"
      CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_21", FK_COLUMNS="Tour_id" */
    SELECT count(*) INTO NUMROWS
    FROM Tour
    WHERE
        /* %JoinFKPK(:%New,Tour," = "," AND") */
            :new.Tour_id = Tour.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update TourEnrollment because Tour does not exist.'
            );
    END IF;

    /* erwin Builtin Trigger */
    /* Customer  TourEnrollment on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
      CHILD_OWNER="", CHILD_TABLE="TourEnrollment"
      P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_20", FK_COLUMNS="Customer_id" */
    SELECT count(*) INTO NUMROWS
    FROM Customer
    WHERE
        /* %JoinFKPK(:%New,Customer," = "," AND") */
            :new.Customer_id = Customer.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update TourEnrollment because Customer does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Room BEFORE INSERT ON Room for each row
    -- erwin Builtin Trigger
-- INSERT trigger on Room
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* TourEnrollment  Room on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001d32f", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
    CHILD_OWNER="", CHILD_TABLE="Room"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_11", FK_COLUMNS="TE_id" */
    UPDATE Room
    SET
        /* %SetFK(Room,NULL) */
        Room.TE_id = NULL
    WHERE
        NOT EXISTS (
                SELECT * FROM TourEnrollment
                WHERE
                    /* %JoinFKPK(:%New,TourEnrollment," = "," AND") */
                        :new.TE_id = TourEnrollment.id
            )
        /* %JoinPKPK(Room,:%New," = "," AND") */
      and Room.id = :new.id AND
            Room.Hotel_id = :new.Hotel_id;

    /* erwin Builtin Trigger */
    /* Hotel Have Room on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Hotel"
    CHILD_OWNER="", CHILD_TABLE="Room"
    P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_10", FK_COLUMNS="Hotel_id" */
    SELECT count(*) INTO NUMROWS
    FROM Hotel
    WHERE
        /* %JoinFKPK(:%New,Hotel," = "," AND") */
            :new.Hotel_id = Hotel.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert Room because Hotel does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Room AFTER UPDATE ON Room for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Room
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* TourEnrollment  Room on child update set null */
    /* ERWIN_RELATION:CHECKSUM="0001793d", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
    CHILD_OWNER="", CHILD_TABLE="Room"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_11", FK_COLUMNS="TE_id" */
    /* Not Implemented due to an ORA-04091 Mutating Table Issue */
    NULL;

    /* erwin Builtin Trigger */
    /* Hotel Have Room on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Hotel"
      CHILD_OWNER="", CHILD_TABLE="Room"
      P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_10", FK_COLUMNS="Hotel_id" */
    SELECT count(*) INTO NUMROWS
    FROM Hotel
    WHERE
        /* %JoinFKPK(:%New,Hotel," = "," AND") */
            :new.Hotel_id = Hotel.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update Room because Hotel does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Seat BEFORE INSERT ON Seat for each row
    -- erwin Builtin Trigger
-- INSERT trigger on Seat
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* TourEnrollment  Seat on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="0001e5a5", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
    CHILD_OWNER="", CHILD_TABLE="Seat"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_12", FK_COLUMNS="TE_id" */
    UPDATE Seat
    SET
        /* %SetFK(Seat,NULL) */
        Seat.TE_id = NULL
    WHERE
        NOT EXISTS (
                SELECT * FROM TourEnrollment
                WHERE
                    /* %JoinFKPK(:%New,TourEnrollment," = "," AND") */
                        :new.TE_id = TourEnrollment.id
            )
        /* %JoinPKPK(Seat,:%New," = "," AND") */
      and Seat.id = :new.id AND
            Seat.Flight_id = :new.Flight_id;

    /* erwin Builtin Trigger */
    /* Flight Have Seat on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Flight"
    CHILD_OWNER="", CHILD_TABLE="Seat"
    P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_11", FK_COLUMNS="Flight_id" */
    SELECT count(*) INTO NUMROWS
    FROM Flight
    WHERE
        /* %JoinFKPK(:%New,Flight," = "," AND") */
            :new.Flight_id = Flight.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20002,
                'Cannot insert Seat because Flight does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Seat AFTER UPDATE ON Seat for each row
    -- erwin Builtin Trigger
-- UPDATE trigger on Seat
DECLARE NUMROWS INTEGER;
BEGIN
    /* erwin Builtin Trigger */
    /* TourEnrollment  Seat on child update set null */
    /* ERWIN_RELATION:CHECKSUM="00017817", PARENT_OWNER="", PARENT_TABLE="TourEnrollment"
    CHILD_OWNER="", CHILD_TABLE="Seat"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="",
    FK_CONSTRAINT="R_12", FK_COLUMNS="TE_id" */
    /* Not Implemented due to an ORA-04091 Mutating Table Issue */
    NULL;

    /* erwin Builtin Trigger */
    /* Flight Have Seat on child update restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Flight"
      CHILD_OWNER="", CHILD_TABLE="Seat"
      P2C_VERB_PHRASE="Have", C2P_VERB_PHRASE="",
      FK_CONSTRAINT="R_11", FK_COLUMNS="Flight_id" */
    SELECT count(*) INTO NUMROWS
    FROM Flight
    WHERE
        /* %JoinFKPK(:%New,Flight," = "," AND") */
            :new.Flight_id = Flight.id;
    IF (
        /* %NotnullFK(:%New," IS NOT NULL AND") */

            NUMROWS = 0
        )
    THEN
        raise_application_error(
                -20007,
                'Cannot update Seat because Flight does not exist.'
            );
    END IF;


-- erwin Builtin Trigger
END;
/


CREATE TRIGGER tour_cost_check
    BEFORE UPDATE ON TourEnrollment
    for each row
DECLARE
    pragma autonomous_transaction;
    MinTourCost DECIMAL(19,4);
BEGIN
    SELECT SC+RC+VC+TC+NVL(:new.NEED_INSURANCE*100,0) INTO MinTourCost
    FROM (
             SELECT NVL(SUM(S.COST), 0) SC
             FROM SEAT S JOIN TOURENROLLMENT TE on S.TE_ID = TE.ID
             WHERE S.TE_ID = :new.ID
         ), (
             SELECT NVL(SUM(R.LIVING_COST*(T.END_DATE-T.START_DATE)),0) RC
             FROM ROOM R JOIN TOURENROLLMENT TE on R.TE_ID = TE.ID JOIN TOUR T on TE.TOUR_ID = T.ID
             WHERE R.TE_ID = :new.ID
         ), (
             SELECT NVL(SUM(:new.NEED_VISA*CN.VISA_COST),0) VC
             FROM TOUR T JOIN COUNTRY CN on T.COUNTRY_ID = CN.ID
             WHERE T.ID = :new.TOUR_ID
         ), (
             SELECT NVL(SUM(:new.NEED_TRANSFER*H.TRANSFER_COST),0) TC
             FROM ROOM R JOIN HOTEL H on R.HOTEL_ID = H.ID JOIN CITY C on H.CITY_ID = C.ID JOIN TOUR T on C.COUNTRY_ID = T.COUNTRY_ID
             WHERE R.TE_ID = :new.ID
         );
    IF (NVL(:new.COST,0) < MinTourCost) THEN
        raise_application_error(-20000, 'Tour cost should be not less than sum of all other costs');
    END IF;
END;


CREATE TRIGGER hotel_country_check
    BEFORE UPDATE ON Room
    for each row
DECLARE
    TourCountry INTEGER;
    HotelCountry INTEGER;
BEGIN
    SELECT T.COUNTRY_ID INTO TourCountry
    FROM TOURENROLLMENT TE JOIN TOUR T on TE.TOUR_ID = T.ID
    WHERE TE.ID = :new.TE_ID;
    SELECT C.COUNTRY_ID INTO HotelCountry
    FROM HOTEL H JOIN CITY C on H.CITY_ID = C.ID
    WHERE H.ID = :new.HOTEL_ID;
    IF (HotelCountry <> TourCountry) THEN
        raise_application_error(-20000, 'Hotel must be located in tour country');
    END IF;
END;


CREATE TRIGGER tour_availability_check
    BEFORE INSERT ON TourEnrollment
    for each row
DECLARE
    numAvailableSeats INTEGER;
    numAvailableRooms INTEGER;
BEGIN
    SELECT COUNT(*) INTO numAvailableSeats
    FROM SEAT S JOIN FLIGHT F on S.FLIGHT_ID = F.ID JOIN CITY C on F.CITY_ID = C.ID JOIN TOUR T on C.COUNTRY_ID = T.COUNTRY_ID
    WHERE :new.TOUR_ID = T.ID;
    SELECT COUNT(*) INTO numAvailableRooms
    FROM ROOM R JOIN HOTEL H on R.HOTEL_ID = H.ID JOIN CITY C on H.CITY_ID = C.ID JOIN TOUR T on C.COUNTRY_ID = T.COUNTRY_ID
    WHERE :new.TOUR_ID = T.ID;
    IF (numAvailableSeats < 1) THEN
        raise_application_error(-20000, 'No available seats for this tour');
    END IF;
    IF (numAvailableRooms < 1) THEN
        raise_application_error(-20000, 'No available rooms for this tour');
    END IF;
END;
