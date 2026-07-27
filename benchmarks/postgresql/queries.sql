-- Run this file directly with psql after loading the PostgreSQL tables.
\timing on

-- Query A: regression analysis
SELECT
    regr_slope(base_passenger_fare, trip_miles) AS slope_passenger_miles,
    regr_intercept(base_passenger_fare, trip_miles) AS intercept_passenger_miles,
    regr_slope(base_passenger_fare, trip_time) AS slope_passenger_time,
    regr_intercept(base_passenger_fare, trip_time) AS intercept_passenger_time,
    regr_slope(driver_pay, trip_miles) AS slope_driver_miles,
    regr_intercept(driver_pay, trip_miles) AS intercept_driver_miles,
    regr_slope(driver_pay, trip_time) AS slope_driver_time,
    regr_intercept(driver_pay, trip_time) AS intercept_driver_time
FROM nyc_tlc;

-- Query B: borough-level aggregation
SELECT
    zones.borough AS nyc_borough,
    AVG(trips.base_passenger_fare) AS avg_passenger_fare,
    AVG(trips.driver_pay) AS avg_driver_pay,
    AVG(trips.trip_miles) AS avg_miles,
    AVG(trips.trip_time) AS avg_time
FROM nyc_tlc AS trips
JOIN zones
    ON zones.locationid = trips.pulocationid
GROUP BY zones.borough
ORDER BY avg_passenger_fare;
