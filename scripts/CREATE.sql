CREATE TABLE IF NOT EXISTS PLANET
(
    ID   SERIAL PRIMARY KEY,
    NAME VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS ADDRESS
(
    ID        SERIAL PRIMARY KEY,
    STREET    VARCHAR(50) NOT NULL,
    FK_PLANET INT REFERENCES PLANET (ID)
);

CREATE TABLE IF NOT EXISTS SPACEPORT
(
    ID         SERIAL PRIMARY KEY,
    NAME       VARCHAR(50) NOT NULL,
    FK_ADDRESS INT REFERENCES ADDRESS (ID)
);

CREATE TABLE IF NOT EXISTS CORPORATION
(
    ID         SERIAL PRIMARY KEY,
    NAME       VARCHAR(50) NOT NULL,
    FK_ADDRESS INT REFERENCES ADDRESS (ID)
);

CREATE TABLE IF NOT EXISTS SPACESHIP
(
    ID       SERIAL PRIMARY KEY,
    NAME     VARCHAR(50) NOT NULL,
    MODEL    VARCHAR(50) NOT NULL,
    SEATS    INT         NOT NULL,
    FK_OWNER INT REFERENCES CORPORATION (ID)
);

CREATE TABLE IF NOT EXISTS CUSTOMER
(
    ID            SERIAL PRIMARY KEY,
    NAME          VARCHAR(69420) NOT NULL,
    DATE_OF_BIRTH DATE           NOT NULL,
    SPECIES       VARCHAR(50)    NOT NULL,
    FK_ADDRESS    INT REFERENCES ADDRESS (ID)
);

CREATE TABLE IF NOT EXISTS FLIGHT
(
    ID             SERIAL PRIMARY KEY,
    START_TIME     TIMESTAMP NOT NULL,
    ARRIVAL_TIME   TIMESTAMP NOT NULL,
    FK_ORIGIN      INT REFERENCES SPACEPORT (ID),
    FK_DESTINATION INT REFERENCES SPACEPORT (ID),
    FK_SPACESHIP   INT REFERENCES SPACESHIP (ID)
);

CREATE TABLE IF NOT EXISTS RESERVATION
(
    ID          SERIAL PRIMARY KEY,
    PRICE       INT NOT NULL,
    IS_PAID     BIT NOT NULL,
    FK_CUSTOMER INT REFERENCES CUSTOMER (ID),
    FK_FLIGHT   INT REFERENCES FLIGHT (ID)
);

CREATE INDEX ON RESERVATION (FK_CUSTOMER);
CREATE INDEX ON RESERVATION (FK_FLIGHT);

CREATE VIEW ALL_RESERVATIONS AS
SELECT C.NAME, F.START_TIME, F.ARRIVAL_TIME, R.PRICE
FROM RESERVATION R
         LEFT JOIN CUSTOMER C on C.ID = R.FK_CUSTOMER
         LEFT JOIN FLIGHT F on F.ID = R.FK_FLIGHT
ORDER BY F.START_TIME, C.NAME;

CREATE VIEW UNPAID_RESERVATIONS AS
SELECT C.NAME, F.START_TIME, R.PRICE
FROM RESERVATION R
         LEFT JOIN CUSTOMER C on C.ID = R.FK_CUSTOMER
         LEFT JOIN FLIGHT F on F.ID = R.FK_FLIGHT
WHERE R.IS_PAID = B'0';
