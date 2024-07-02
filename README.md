# DuckDB vs. PostgreSQL: Performance Benchmark on Large Datasets

## Universidad de Costa Rica (UCR) - CI0141

**Estudiante:** Gabriel Molina Bulgarelli  
**ID:** C14826  

This project compares the performance of DuckDB and PostgreSQL in analyzing large datasets. The focus is on evaluating the efficiency and feasibility of DuckDB, an embedded database optimized for data analysis, against PostgreSQL, a traditional relational database engine.

## Introduction

In this project, we explore the capabilities of DuckDB, an embedded, columnar, and vectorized database optimized for data analysis, and compare its performance with PostgreSQL, a traditional relational database. The evaluation is based on executing specific analytical queries on a large dataset of taxi trips in New York City.

## Objectives

- Evaluate the effectiveness and performance of DuckDB compared to PostgreSQL.
- Determine the feasibility of DuckDB for large-scale data analysis.

## Dataset Description

The dataset consists of high-volume for-hire vehicle trips in New York City from February 2019 to March 2024. It includes 62 Parquet files totaling 25.2 GB. Each file contains various trip attributes such as the provider code, start and end timestamps, trip distance, trip time, base fare, driver payment, and tips.

# User Manual

## Installation

To run this project, you need to have DuckDB and PostgreSQL installed on your system.

### DuckDB

Download and install DuckDB from [DuckDB.org](https://duckdb.org/).

### PostgreSQL

Download and install PostgreSQL from [PostgreSQL.org](https://www.postgresql.org/download/).

### Downloading Parquet Files

Use the provided scripts to download the Parquet files. Each command should be executed in the repository's directory.

#### On Linux:

Run the `downloadOnLinux.sh` script using bash:

```sh
bash downloadOnLinux.sh
```

#### On Windows:

Run the `downloadOnWindows.ps1` script using PowerShell:

```powershell
.\downloadOnWindows.ps1
```

## Usage

### DuckDB

1. **Enable Timer:**
    Activate the timer to measure query execution time.

    ```sql
    .timer on
    ```

2. **Count Rows:**
    Count the total number of rows in all Parquet files.

    ```sql
    select count(*) from '*.parquet';
    ```

3. **Describe Data:**
    Provide a description of the columns and data types in the Parquet files.

    ```sql
    describe select * from '*.parquet';
    ```

4. **Calculate Averages:**
    Compute the averages for base passenger fares, driver payments, trip distances, and trip times.

    ```sql
    select avg(base_passenger_fare), avg(driver_pay), avg(trip_miles), avg(trip_time) from '*.parquet';
    ```

5. **Group by Borough:**
    Calculate the averages for base passenger fares, driver payments, trip distances, and trip times grouped by borough in New York City.

    ```sql
    select Borough, avg(base_passenger_fare), avg(driver_pay), avg(trip_miles), avg(trip_time)
    from read_parquet('*.parquet') join 'taxi_zone_lookup.csv' on LocationID = PULocationID
    group by Borough;
    ```

6. **Regression Analysis:**
    Perform a regression analysis to obtain the slope and intercept of base passenger fares and trip time.

    ```sql
    select regr_slope(base_passenger_fare, trip_time), regr_intercept(base_passenger_fare, trip_time) from '*.parquet';
    ```

### PostgreSQL

1. **Attach PostgreSQL Database:**
    Connect DuckDB to an existing PostgreSQL database.

    ```sql
    attach 'dbname=postgres user=postgres host=127.0.0.1' as postgres_db (type postgres);
    ```

2. **Create Table:**
    Create a table in PostgreSQL to store trip data.

    ```sql
    create table postgres_db.nyc_tlc (
        pulocationid int,
        dolocationid int,
        trip_miles double,
        trip_time double,
        base_passenger_fare double,
        driver_pay double
    );
    ```

3. **Insert Data:**
    Insert data from Parquet files into the PostgreSQL table.

    ```sql
    insert into postgres_db.nyc_tlc
    select PULocationID, DOLocationID, trip_miles, trip_time, base_passenger_fare, driver_pay from '*.parquet';
    ```

4. **Perform Regression Analysis:**

    ```sql
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
    ```

## Results

The results showed that DuckDB outperforms PostgreSQL in terms of query execution time. DuckDB is approximately 1.69 times faster than PostgreSQL for Query A and 3.12 times faster for Query B.

## References

- Apache Parquet. (2024). Overview. https://parquet.apache.org/docs/overview/
- Bellon, T. (2019). Gett's Juno ends NYC ride-hailing services, citing regulation. Reuters.
- Boncz, P., Zukowski, M., & Nes, N. (2005). MonetDB/X100: Hyper-Pipelining Query Execution. VLDB.
- DuckDB Foundation. (2024). Why DuckDB. https://duckdb.org/why_duckdb
- EnterpriseDB. (2024). Download PostgreSQL. https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
- Li, G., & Manoharan, S. (2013). A performance comparison of SQL and NoSQL databases. IEEE PACRIM.
- SQLite. (2024). About SQLite. https://www.sqlite.org/about.html
- NYC TLC. (2024). TLC Trip Record Data. https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- The PostgreSQL Global Development Group. (2024). About PostgreSQL. https://www.postgresql.org/about/
- West, M. (2011). Developing high-quality data models. Elsevier eBooks.