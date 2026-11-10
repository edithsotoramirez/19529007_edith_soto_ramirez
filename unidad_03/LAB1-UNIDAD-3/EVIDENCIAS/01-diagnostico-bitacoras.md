# Actividad 1. Diagnóstico inicial de bitácoras

## Objetivo

Revisar la configuración inicial de las bitácoras en PostgreSQL para identificar qué información se está registrando y qué parámetros necesitan modificarse para mejorar la auditoría.

## Código SQL utilizado

```sql
SELECT name, setting
FROM pg_settings
WHERE name IN (
    'log_destination',
    'logging_collector',
    'log_directory',
    'log_filename',
    'log_connections',
    'log_disconnections',
    'log_line_prefix',
    'log_statement',
    'log_min_error_statement',
    'log_timezone'
)
ORDER BY name;
```

## Resultado

Al ejecutar la consulta se obtuvieron los siguientes valores:

| Parámetro | Valor |
|---|---|
| log_connections | off |
| log_destination | stderr |
| log_directory | log |
| log_disconnections | off |
| log_filename | postgresql-%Y-%m-%d_%H%M%S.log |
| log_line_prefix | %m [%p] |
| log_min_error_statement | error |
| log_statement | none |
| log_timezone | America/Chihuahua |
| logging_collector | on |

**Evidencia:** Insertar aquí la captura de los resultados obtenidos en SQL Shell.

## Análisis

Se observó que PostgreSQL ya tenía activado el colector de bitácoras, pero no estaba registrando las conexiones, desconexiones ni todas las instrucciones SQL ejecutadas. Esto significa que, aunque el sistema puede guardar registros, todavía no cuenta con suficiente información para identificar algunas actividades realizadas por los usuarios.

## Conclusión

Esta actividad me ayudó a identificar cómo estaban configuradas las bitácoras y a comprender que es necesario ajustar ciertos parámetros para tener un mejor seguimiento de las operaciones realizadas en la base de datos.
