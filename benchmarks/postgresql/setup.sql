-- Run this file from the DuckDB CLI.
-- Update the connection string if your PostgreSQL settings differ.
INSTALL postgres;
LOAD postgres;

ATTACH 'dbname=postgres user=postgres host=127.0.0.1'
    AS postgres_db (TYPE postgres);

DROP TABLE IF EXISTS postgres_db.nyc_tlc;
CREATE TABLE postgres_db.nyc_tlc (
    pulocationid INTEGER,
    dolocationid INTEGER,
    trip_miles DOUBLE PRECISION,
    trip_time DOUBLE PRECISION,
    base_passenger_fare DOUBLE PRECISION,
    driver_pay DOUBLE PRECISION
);

INSERT INTO postgres_db.nyc_tlc
SELECT
    PULocationID,
    DOLocationID,
    trip_miles,
    trip_time,
    base_passenger_fare,
    driver_pay
FROM read_parquet('datasets/*.parquet');

DROP TABLE IF EXISTS postgres_db.zones;
CREATE TABLE postgres_db.zones (
    locationid INTEGER,
    borough VARCHAR,
    zone VARCHAR,
    service_zone VARCHAR
);

INSERT INTO postgres_db.zones
SELECT
    LocationID,
    Borough,
    Zone,
    service_zone
FROM read_csv_auto('data-dictionary/taxi_zone_lookup.csv');
