-- LAB-01: Bitacoras y auditoria del dato
-- Actividad 2: Colector y vista de bitacora

-- El colector ya estaba activado al realizar la verificacion.

-- Consultar el archivo de bitacora actual
SELECT pg_current_logfile();

-- La lectura como texto produjo un error de codificacion UTF-8.
-- Por eso se utilizo lectura binaria.

-- Comprobar la lectura binaria del archivo
SELECT
    pg_current_logfile() AS archivo,
    octet_length(
        pg_read_binary_file(pg_current_logfile(), 0, 2000)
    ) AS bytes_leidos;

-- Crear el esquema para consultar las bitacoras
CREATE SCHEMA IF NOT EXISTS dba;

-- Restringir el acceso publico
REVOKE ALL ON SCHEMA dba FROM PUBLIC;

-- Crear la vista con las columnas num y linea
DROP VIEW IF EXISTS dba.bitacora;

CREATE VIEW dba.bitacora AS
SELECT
    row_number() OVER () AS num,
    linea
FROM regexp_split_to_table(
    convert_from(
        pg_read_binary_file(pg_current_logfile()),
        'WIN1252'
    ),
    E'\r?\n'
) AS linea;

-- Consultar las ultimas lineas de la bitacora
SELECT
    num,
    left(linea, 100) AS linea
FROM dba.bitacora
WHERE linea LIKE '%LOG:%'
ORDER BY num DESC
LIMIT 5;