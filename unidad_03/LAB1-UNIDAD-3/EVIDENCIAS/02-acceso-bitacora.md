# Actividad 2. Acceso a los archivos de bitácora

## Objetivo

Comprobar que PostgreSQL puede acceder a sus archivos de bitácora mediante consultas SQL y crear una vista para facilitar su consulta.

## Código SQL utilizado

```sql
SELECT pg_current_logfile();

SELECT pg_read_file(
    pg_current_logfile(),
    0,
    2000
);
```

Debido a un error de codificación UTF-8, se utilizó una lectura binaria:

```sql
SELECT
    pg_current_logfile() AS archivo,
    octet_length(
        pg_read_binary_file(pg_current_logfile(), 0, 2000)
    ) AS bytes_leidos;
```

Después se creó el esquema y la vista:

```sql
CREATE SCHEMA IF NOT EXISTS dba;

REVOKE ALL ON SCHEMA dba FROM PUBLIC;

CREATE OR REPLACE VIEW dba.bitacora AS
SELECT
    pg_current_logfile() AS archivo,
    pg_read_binary_file(
        pg_current_logfile()
    ) AS contenido_binario;
```

Finalmente, se comprobó su funcionamiento:

```sql
SELECT
    archivo,
    octet_length(contenido_binario) AS bytes
FROM dba.bitacora;
```

## Resultado

Se comprobó que el parámetro `logging_collector` ya estaba activado. Al intentar leer el archivo como texto apareció un error de codificación UTF-8, por lo que se utilizó una lectura binaria.

Se creó correctamente el esquema `dba` y la vista `dba.bitacora`. La consulta final mostró el archivo `log/postgresql-2026-11-08_222206.log`, con un tamaño de 3119 bytes al momento de realizar la consulta.

**Evidencia:** Insertar aquí la captura de la creación de la vista y del resultado de la consulta.

## Análisis

Se pudo acceder al archivo de bitácora desde PostgreSQL. El problema de codificación impidió leerlo directamente como texto, pero utilizando una función de lectura binaria fue posible comprobar su contenido. También se restringió el acceso público al esquema `dba`.

## Conclusión

Esta actividad me permitió aprender cómo localizar y consultar los archivos de bitácora de PostgreSQL. También comprendí que los problemas de codificación pueden afectar su lectura y que es importante controlar quién tiene acceso a esta información.
