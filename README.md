# Proyecto Final

CI0141 Bases de Datos Avanzadas
Marco Piedra Venegas - A64397
Alejandro Jiménez Corea - B84032
Daniel Artavia - B70771
Gabriel Molina Bulgarelli - C14826

## Introducción

En este proyecto se realiza el procesamiento de analítica de datos mediante el motor DuckDB sobre archivos en formato Parquet (Apache Parquet, 2024).

DuckDB se describe como una base de datos para analítica de datos dentro de procesos. De este modo, se puede integrar dentro de otros programas (DuckDB Foundation, 2024).

Parquet es un formato columnar especializado para almacenamiento y acceso rápido de datos. Utiliza compresión de alto rendimiento y esquemas de codificación para grandes volúmenes (Apache Parquet, 2024).

El objetivo del proyecto consiste en evidenciar la flexibilidad de un acercamiento no relacional para procesamiento de datos semiestructurados, cuyo volumen supere los recursos de memoria.

## Descripción

Se utilizan los conjuntos de datos de viajes en plataformas de transporte por alquiler de alto volumen (High Volume For-Hire Vehicle).

En esta categoría, definida por el gobierno de la ciudad de Nueva York, los proveedores generan más de 10000 viajes diarios y se incluyen a los proveedores Uber, Lyft, Juno, y Via (New York City Taxi and Limousine Commission, 2024).

Los conjuntos de datos se recopilan mensualmente desde febrero de 2019, suman 36 GB, y son de acceso público.

Cada archivo Parquet incluye campos como el código de proveedor, fecha y hora de inicio y fin de viaje, longitud del viaje en millas, tiempo del viaje en segundos, tarifa base para el pasajero, monto recibido por el conductor, propina, e impuestos.



## Referencias

Apache Parquet (2024). Overview. Obtenido de: https://parquet.apache.org/docs/overview/

DuckDB Foundation (2024). Why DuckDB. Obtenido de: https://duckdb.org/why_duckdb

New York City Taxi and Limousine Commission (2024). TLC Trip Record Data. Obtenido de: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
