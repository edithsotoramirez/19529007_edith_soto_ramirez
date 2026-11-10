# Actividad 4. Configuración de bitácoras

## Objetivo

Configurar las bitácoras de PostgreSQL para registrar conexiones, desconexiones y cambios en la estructura de la base de datos.

## Resultado

Se modificaron los parámetros de PostgreSQL utilizando instrucciones `ALTER SYSTEM` y se recargó la configuración con `pg_reload_conf()`.

Se configuraron los siguientes valores:

| Parámetro | Valor |
|---|---|
| log_connections | on |
| log_disconnections | on |
| log_line_prefix | %m [%p] user=%u db=%d app=%a client=%h |
| log_statement | ddl |

Inicialmente, las conexiones y desconexiones seguían apareciendo desactivadas en la sesión anterior. Por eso se revisó la configuración y se inició una nueva sesión para comprobar los cambios.

**Evidencia:** Insertar captura de los parámetros de configuración.

## Análisis

La configuración permite registrar más información sobre los accesos y los cambios realizados en PostgreSQL. El registro de conexiones y desconexiones ayuda a identificar cuándo se accede al servidor, mientras que el registro DDL permite revisar modificaciones en su estructura.

## Conclusión

Aprendí a configurar las bitácoras de PostgreSQL y a comprobar si los cambios se aplicaron correctamente. También comprendí que algunos parámetros pueden requerir una nueva conexión para mostrar sus valores actualizados.
