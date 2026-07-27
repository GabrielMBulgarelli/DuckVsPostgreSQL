# Benchmark Results

| Query | DuckDB reported mean | PostgreSQL reported mean | DuckDB speedup |
|---|---:|---:|---:|
| Query A — Regression analysis | 47.937 s | 81.109 s | 1.69× |
| Query B — Borough-level aggregation | 55.271 s | 172.682 s | 3.12× |

Each published mean is based on three cold executions documented in the [full investigation report](../documents/Investigation_CI0141Project.pdf). See [`raw-results.csv`](raw-results.csv) for the individual measurements. Because the displayed run times are rounded to three decimal places, recomputing the DuckDB means from those values differs from the report by 0.001 seconds.

The experiment compared DuckDB reading Parquet files directly with PostgreSQL querying imported relational tables. The figures therefore reflect differences in storage and loading strategy as well as database-engine behavior.
