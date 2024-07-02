# CI0141 - Proyecto Final Bases de Datos Avanzadas
Marco Piedra Venegas - A64397
Alejandro Jiménez Corea - B84032
Daniel Artavia - B70771
Gabriel Molina Bulgarelli - C14826

Este proyecto compara el rendimiento de DuckDB y PostgreSQL en el análisis de grandes conjuntos de datos. El enfoque está en evaluar la eficiencia y viabilidad de DuckDB, una base de datos embebida optimizada para el análisis de datos, frente a PostgreSQL, un motor de base de datos relacional tradicional.

## Tabla de Contenidos
- [Introducción](#introducción)
- [Objetivos](#objetivos)
- [Descripción del Conjunto de Datos](#descripción-del-conjunto-de-datos)
- [Instalación](#instalación)
- [Uso](#uso)
  - [DuckDB](#duckdb)
  - [PostgreSQL](#postgresql)
- [Consultas](#consultas)
  - [Consultas en DuckDB](#consultas-en-duckdb)
  - [Consultas en PostgreSQL](#consultas-en-postgresql)
- [Resultados](#resultados)
- [Referencias](#referencias)

## Introducción
En este proyecto, exploramos las capacidades de DuckDB, una base de datos embebida, columnar y vectorizada optimizada para el análisis de datos, y comparamos su rendimiento con PostgreSQL, una base de datos relacional tradicional. La evaluación se basa en la ejecución de consultas analíticas específicas en un gran conjunto de datos de viajes en taxi de la ciudad de Nueva York.

## Objetivos
- Evaluar la efectividad y el rendimiento de DuckDB en comparación con PostgreSQL.
- Determinar la viabilidad de DuckDB para el análisis de datos a gran escala.

## Descripción del Conjunto de Datos
El conjunto de datos consiste en viajes de vehículos de alquiler de alto volumen en la ciudad de Nueva York desde febrero de 2019 hasta marzo de 2024. Incluye 62 archivos Parquet con un total de 25.2 GB. Cada archivo contiene varios atributos del viaje como el código del proveedor, las marcas de tiempo de inicio y fin, la distancia del viaje, el tiempo del viaje, la tarifa base, el pago al conductor y las propinas.

# Manual de usuario

## Instalación
Para ejecutar el proyecto, necesitas tener DuckDB y PostgreSQL instalados en tu sistema.

### DuckDB
Descarga e instala DuckDB desde [DuckDB.org](https://duckdb.org/).

### PostgreSQL
Descarga e instala PostgreSQL desde [PostgreSQL.org](https://www.postgresql.org/download/).

### Descarga de Archivos Parquet
Utiliza los scripts proporcionados para descargar los archivos Parquet. Cada comando se debe de ejecutar en la ruta del repositorio.

#### En Linux:
Ejecuta el script `downloadOnLinux.sh` utilizando bash:
```sh
bash downloadOnLinux.sh
```

#### En Windows:
Ejecuta el script `downloadOnWindows.ps1` utilizando PowerShell:
```powershell
.\downloadOnWindows.ps1
```

## Uso

### DuckDB
1. **Habilitar Temporizador:**
    Activa el temporizador para medir el tiempo de ejecución de las consultas.
    ```sql
    .timer on
    ```

2. **Contar Filas:**
    Cuenta el número total de filas en todos los archivos Parquet.
    ```sql
    select count(*) from '*.parquet';
    ```

3. **Describir Datos:**
    Proporciona una descripción de las columnas y tipos de datos en los archivos Parquet.
    ```sql
    describe select * from '*.parquet';
    ```

4. **Calcular Promedios:**
    Calcula los promedios de las tarifas base de los pasajeros, pagos a conductores, distancias de viaje y tiempos de viaje.
    ```sql
    select avg(base_passenger_fare), avg(driver_pay), avg(trip_miles), avg(trip_time) from '*.parquet';
    ```

5. **Agrupar por Borough:**
    Calcula los promedios de las tarifas base de los pasajeros, pagos a conductores, distancias de viaje y tiempos de viaje agrupados por borough (distrito) en la ciudad de Nueva York.
    ```sql
    select Borough, avg(base_passenger_fare), avg(driver_pay), avg(trip_miles), avg(trip_time) 
    from read_parquet('*.parquet') join 'taxi_zone_lookup.csv' on LocationID = PULocationID 
    group by Borough;
    ```

6. **Análisis de Regresión:**
    Realiza un análisis de regresión para obtener la pendiente y la intersección de las tarifas base de los pasajeros y el tiempo de viaje.
    ```sql
    select regr_slope(base_passenger_fare, trip_time), regr_intercept(base_passenger_fare, trip_time) from '*.parquet';
    ```

### PostgreSQL
1. **Adjuntar Base de Datos PostgreSQL:**
    Conecta DuckDB a una base de datos PostgreSQL existente.
    ```sql
    attach 'dbname=postgres user=postgres host=127.0.0.1' as postgres_db (type postgres);
    ```

2. **Crear Tabla:**
    Crea una tabla en PostgreSQL para almacenar los datos de los viajes.
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

3. **Insertar Datos:**
    Inserta los datos de los archivos Parquet en la tabla de PostgreSQL.
    ```sql
    insert into postgres_db.nyc_tlc
    select PULocationID, DOLocationID, trip_miles, trip_time, base_passenger_fare, driver_pay from '*.parquet';
    ```

4. **Realizar Análisis de Regresión:**
    Realiza un análisis de regresión para obtener la pendiente y la intersección de las tarifas base de los pasajeros y el tiempo de viaje.
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

## Consultas

### Consultas en DuckDB
- **Consulta A:** Análisis de Regresión
    Realiza un análisis de regresión para obtener las pendientes e intersecciones de las tarifas base de los pasajeros y los pagos a conductores con respecto a las distancias y tiempos de viaje.
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
    FROM read_parquet('*.parquet');
    ```

- **Consulta B:** Agregación por Borough
    Calcula los promedios de las tarifas base de los pasajeros, pagos a conductores, distancias de viaje y tiempos de viaje agrupados por borough (distrito) en la ciudad de Nueva York y ordena los resultados por la tarifa promedio de los pasajeros.
    ```sql
    SELECT Borough AS nyc_borough,
        AVG(base_passenger_fare) AS avg_passenger_fare,
        AVG(driver_pay) AS avg_driver,
        AVG(trip_miles) AS avg_miles,
        AVG(trip_time) AS avg_time
    FROM read_parquet('*.parquet')
    JOIN 'taxi_zone_lookup.csv' ON LocationID = PULocationID
    GROUP BY Borough
    ORDER BY avg_passenger;
    ```

### Consultas en PostgreSQL
- **Consulta A:** Análisis de Regresión
    Realiza un análisis de regresión para obtener las pendientes e intersecciones de las tarifas base de los pasajeros y los pagos a conductores con respecto a las distancias y tiempos de viaje.
    ```sql
    SELECT
        regr_slope(base_passenger_fare, trip_miles) AS slope_passenger_miles,
        regr_intercept(base_passenger_fare, trip_miles) AS intercept_passenger_miles,
        regr_slope(base_passenger_fare, trip_time) AS slope_passenger_time,
        regr_intercept(base_passenger_fare, trip_time) AS intercept_passenger_time,
        regr_slope(driver_pay, trip_miles) AS slope_driver_miles,
        regr_intercept(driver_pay, trip_miles) AS intercept_driver_miles,
        regr_slope(driver_pay, trip_time) AS slope_driver_time,
        regr_intercept(driver_pay

, trip_time) AS intercept_driver_time
    FROM nyc_tlc;
    ```

- **Consulta B:** Agregación por Borough
    Calcula los promedios de las tarifas base de los pasajeros, pagos a conductores, distancias de viaje y tiempos de viaje agrupados por borough (distrito) en la ciudad de Nueva York y ordena los resultados por la tarifa promedio de los pasajeros.
    ```sql
    SELECT Borough AS nyc_borough,
        AVG(base_passenger_fare) AS avg_passenger_fare,
        AVG(driver_pay) AS avg_driver,
        AVG(trip_miles) AS avg_miles,
        AVG(trip_time) AS avg_time
    FROM nyc_tlc
    JOIN zones ON locationid = PULocationID
    GROUP BY Borough
    ORDER BY avg_passenger_fare;
    ```

## Resultados
Los resultados mostraron que DuckDB supera a PostgreSQL en términos de tiempo de ejecución de consultas. DuckDB es aproximadamente 1.69 veces más rápido que PostgreSQL para la Consulta A y 3.12 veces más rápido para la Consulta B.

## Referencias
- Apache Parquet. (2024). Overview. https://parquet.apache.org/docs/overview/
- Bellon, T. (2019). Gett's Juno ends NYC ride-hailing services, citing regulation. Reuters.
- Boncz, P., Zukowski, M., & Nes, N. (2005). MonetDB/X100: Hyper-Pipelining Query Execution. In Proceedings of International Conference on Very Large Data Bases (VLDB) 2005. Very Large Data Base Endowment.
- DuckDB Foundation. (2024). Why DuckDB. https://duckdb.org/why_duckdb
- EnterpriseDB. (2024). Download PostgreSQL. https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
- Li, G., & Manoharan, S. (2013). A performance comparison of SQL and NoSQL databases. IEEE Pacific Rim Conference on Communications, Computers and Signal Processing (PACRIM), 15-19.
- SQLite. (2024). About SQLite. https://www.sqlite.org/about.html
- Taxi & Limousine Commission. (2024). New York City - TLC Trip Record Data. https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- The PostgreSQL Global Development Group. (2024). About PostgreSQL. https://www.postgresql.org/about/
- West, M. (2011). Developing high quality data models. Elsevier eBooks. https://doi.org/10.1016/c2009-0-30508-5

Siéntete libre de personalizar el contenido aún más según tus requisitos específicos y la información adicional del proyecto.