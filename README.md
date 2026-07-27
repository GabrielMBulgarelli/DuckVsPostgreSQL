# DuckDB vs. PostgreSQL: Analytical Performance Benchmark

A reproducible comparison of DuckDB and PostgreSQL using 25.2 GB of NYC trip data stored across 62 Parquet files.

## Benchmark at a Glance

| Property | Value |
|---|---|
| Dataset | NYC High-Volume For-Hire Vehicle Trip Records |
| Period | February 2019–March 2024 |
| Files | 62 Parquet files |
| Dataset size | 25.2 GB |
| Databases | DuckDB and PostgreSQL |
| Workload | Regression and borough-level aggregation |
| Main result | DuckDB completed both tested analytical queries faster |

| Query | DuckDB | PostgreSQL | DuckDB speedup |
|---|---:|---:|---:|
| Query A — Regression analysis | 47.937 s | 81.109 s | 1.69× |
| Query B — Borough-level aggregation | 55.271 s | 172.682 s | 3.12× |

These are the means published in the original report from three cold executions. See [Results](#results) for the individual measurements and methodology.

## Overview

This project evaluates the analytical performance of DuckDB and PostgreSQL using a large collection of NYC high-volume for-hire vehicle trip records.

DuckDB processes the source Parquet files directly using its columnar and vectorized execution engine. PostgreSQL processes an imported relational table containing the equivalent benchmark columns.

The comparison focuses on two analytical workloads: statistical regression over the complete dataset and aggregation by New York City borough.

## Objectives

- Compare DuckDB and PostgreSQL execution times for analytical SQL workloads.
- Evaluate DuckDB's ability to query large Parquet datasets directly.
- Compare direct Parquet analysis with analysis over imported PostgreSQL tables.
- Document the setup and queries so the experiment can be reproduced.
- Identify the practical strengths and limitations of each database system.

## Dataset

The benchmark uses NYC Taxi and Limousine Commission High-Volume For-Hire Vehicle Trip Records. The 62 monthly Parquet files cover February 2019 through March 2024 and total approximately 25.2 GB.

The benchmark columns describe pickup and drop-off locations, trip distance and duration, base passenger fare, and driver pay. Query B also uses the included taxi-zone lookup table to map pickup location IDs to boroughs.

## Benchmark Environment

The original measurements were collected on this machine:

| Component | Specification |
|---|---|
| Computer | Dell XPS 13 9315 |
| Processor | Intel Core i5-1230U, 12 logical CPUs |
| Memory | 8 GB DDR5 RAM |
| Operating system | Debian GNU/Linux 12.6 (Bookworm) |

DuckDB and PostgreSQL ran on the same computer and used the same source dataset.

## Benchmark Methodology

The same analytical operations were implemented for both databases using equivalent source columns. Each database-and-query combination was measured three times. Every execution was run cold: the DuckDB CLI process was exited and restarted before a DuckDB run, while the PostgreSQL service was stopped and restarted before a PostgreSQL run.

The tables below use the arithmetic means published in the report for the three executions.

| Setting | Value |
|---|---|
| Measured runs | 3 per database and query |
| Reported statistic | Arithmetic mean |
| Execution condition | DuckDB process or PostgreSQL service restarted before each run |

### Comparison Scope

This experiment compares two practical analytical workflows:

- DuckDB reading Parquet files directly.
- PostgreSQL querying data imported into native relational tables.

The result therefore reflects both database-engine behavior and differences in storage format. It should not be interpreted as a completely isolated comparison of query optimizers or execution engines.

## Repository Structure

```text
.
├── benchmarks/
│   ├── duckdb/
│   │   ├── queries.sql
│   │   └── setup.sql
│   └── postgresql/
│       ├── queries.sql
│       └── setup.sql
├── data-dictionary/
│   ├── taxi_zone_lookup.csv
│   └── supporting data dictionaries and maps
├── datasets/
│   └── datasets.txt
├── documents/
│   ├── Investigation_CI0141Project.pdf
│   └── Presentation_CI0141Project.pdf
├── results/
│   ├── raw-results.csv
│   └── summary.md
├── downloadOnLinux.sh
├── downloadOnWindows.ps1
└── README.md
```

Downloaded Parquet files are intentionally excluded from Git.

## Requirements

Before reproducing the benchmark, install:

- The [DuckDB CLI](https://duckdb.org/docs/installation/).
- [PostgreSQL](https://www.postgresql.org/download/).
- PowerShell on Windows, or Bash and `wget` on Linux.
- At least 30 GB of free storage for the downloaded dataset and temporary files.
- Additional storage for the PostgreSQL tables.

The full dataset contains approximately 25.2 GB of Parquet files.

## Download the Dataset

The repository contains a list of NYC TLC Parquet URLs covering February 2019 through March 2024.

### Linux

From the repository root, run:

```bash
bash downloadOnLinux.sh
```

### Windows

From the repository root, run:

```powershell
.\downloadOnWindows.ps1
```

Both scripts download the files into `datasets/` and skip files that already exist. Downloads use temporary `.part` files so an interrupted transfer is not mistaken for a complete Parquet file.

## Database Setup

All commands assume the current working directory is the repository root.

### DuckDB

Start DuckDB and load the CLI settings:

```text
duckdb
.read benchmarks/duckdb/setup.sql
```

DuckDB reads `datasets/*.parquet` directly, so it does not require a data-import step.

### PostgreSQL

The PostgreSQL setup is executed through DuckDB's PostgreSQL extension. Review the connection string in [`benchmarks/postgresql/setup.sql`](benchmarks/postgresql/setup.sql), then run:

```text
duckdb
.read benchmarks/postgresql/setup.sql
```

This recreates and populates the `nyc_tlc` and `zones` tables in PostgreSQL. It is a data-loading step and should be timed separately from query execution.

The benchmark queries themselves run directly in PostgreSQL with `psql`:

```bash
psql -U postgres -d postgres -f benchmarks/postgresql/queries.sql
```

Keeping the import and query contexts separate avoids mixing DuckDB catalog names with native PostgreSQL table names.

## Benchmark Queries

The complete executable queries are in:

- [`benchmarks/duckdb/queries.sql`](benchmarks/duckdb/queries.sql)
- [`benchmarks/postgresql/queries.sql`](benchmarks/postgresql/queries.sql)

### Query A — Regression Analysis

Calculates slopes and intercepts relating passenger fares and driver payments to trip distance and trip duration.

### Query B — Borough-Level Aggregation

Joins pickup locations with the taxi-zone lookup table, then calculates average passenger fare, driver pay, trip distance, and trip duration for each borough.

Run the DuckDB queries from the repository root with:

```text
duckdb
.read benchmarks/duckdb/queries.sql
```

## Results

The original report contains the following execution times. They are also available as machine-readable data in [`results/raw-results.csv`](results/raw-results.csv), with a concise summary in [`results/summary.md`](results/summary.md).

| Database | Query | Run 1 | Run 2 | Run 3 | Reported mean |
|---|---|---:|---:|---:|---:|
| DuckDB | Query A | 47.717 s | 48.397 s | 47.700 s | 47.937 s |
| DuckDB | Query B | 55.478 s | 55.947 s | 54.390 s | 55.271 s |
| PostgreSQL | Query A | 81.059 s | 79.334 s | 82.933 s | 81.109 s |
| PostgreSQL | Query B | 172.537 s | 172.816 s | 172.693 s | 172.682 s |

DuckDB was approximately 1.69 times faster for Query A and 3.12 times faster for Query B, based on the reported means.

The displayed run times are rounded to three decimal places. Recomputing their means produces 47.938 seconds for DuckDB Query A and 55.272 seconds for DuckDB Query B, each 0.001 seconds above the mean printed in the report. The published means and speedups are retained here as the original benchmark findings.

## Interpretation

In these workloads, DuckDB benefited from reading compressed, columnar Parquet data directly and applying vectorized execution to analytical operations. PostgreSQL first required the source data to be imported into relational tables.

The result illustrates the practical efficiency of DuckDB for local analytical work over Parquet files. PostgreSQL remains better suited to workloads that require a persistent database server, concurrent transactional access, mature authorization controls, and broader application integration.

## Limitations

- DuckDB reads the source Parquet files directly, while PostgreSQL reads imported relational tables.
- Storage format and loading strategy influence the results.
- The results represent one computer and two analytical query patterns.
- The benchmark focuses on single-user analytical processing.
- Results may vary with database version, hardware, memory, caching, storage, and configuration.

## Conclusion

In the tested analytical workloads, DuckDB completed both selected queries faster than PostgreSQL. The strongest observed advantage was Query B, where DuckDB was approximately 3.12 times faster.

These results apply to the documented dataset, queries, hardware, and experimental procedure. They should not be generalized to every PostgreSQL or DuckDB workload.

## Documentation

- [Full investigation report](documents/Investigation_CI0141Project.pdf)
- [Project presentation](documents/Presentation_CI0141Project.pdf)

## Project Origin

This project was originally developed for CI0141 at the University of Costa Rica and later organized as a reproducible database performance benchmark.

## References

- [Apache Parquet documentation](https://parquet.apache.org/docs/overview/)
- [DuckDB: Why DuckDB](https://duckdb.org/why_duckdb)
- [NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
- [PostgreSQL overview](https://www.postgresql.org/about/)
