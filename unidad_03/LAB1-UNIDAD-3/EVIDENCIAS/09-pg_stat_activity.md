# Actividad 9 — Sesiones activas con pg_stat_activity

## Objetivo

Comprobar cómo PostgreSQL permite supervisar las conexiones y consultas que se están ejecutando mediante la vista `pg_stat_activity`, y entender la diferencia entre consultar la actividad actual del servidor y revisar los eventos que quedan almacenados en las bitácoras.

## Procedimiento

Para realizar esta actividad se utilizaron dos terminales: PowerShell y SQL Shell (psql).

Primero, desde PowerShell, se estableció una conexión a la base de datos `comercial` utilizando el usuario `soporte_ana`. Se ejecutó la siguiente instrucción:

```sql
SELECT pg_sleep(90);
```

La función `pg_sleep(90)` hace que PostgreSQL espere 90 segundos antes de finalizar la consulta. Se utilizó para simular una operación de larga duración y tener tiempo de observarla desde otra sesión.

Mientras la consulta continuaba ejecutándose, se abrió SQL Shell con el usuario administrador `postgres` y se consultó la vista `pg_stat_activity`:

```sql
SELECT
    pid,
    usename,
    application_name,
    client_addr,
    backend_start,
    state,
    left(query, 30) AS query
FROM pg_stat_activity
WHERE backend_type = 'client backend';
```

Esta consulta permitió identificar las sesiones conectadas, sus usuarios, las aplicaciones utilizadas, las direcciones IP y las instrucciones SQL que estaban ejecutando.

Después se buscó el identificador del proceso de `soporte_ana` dentro de la bitácora:

```sql
SELECT
    num,
    left(linea, 250) AS linea
FROM dba.bitacora
WHERE linea LIKE '%[32216]%'
ORDER BY num;
```

Finalmente, después de que terminó la consulta de 90 segundos, se volvió a consultar `pg_stat_activity` para comprobar si la sesión seguía existiendo.

## Resultado

### 1. Identificación de sesiones activas

La primera consulta a `pg_stat_activity` mostró tres sesiones:

| PID | Usuario | Estado | Consulta |
|---|---|---|---|
| 26900 | postgres | active | Consulta a pg_stat_activity |
| 23872 | app_ventas | idle | Última consulta realizada |
| 32216 | soporte_ana | active | SELECT pg_sleep(90); |

La sesión de `soporte_ana` tenía el PID `32216`, utilizaba la aplicación `psql` y se conectó desde la dirección `127.0.0.1`.

El estado `active` indicó que estaba ejecutando una consulta en ese momento.

También apareció una sesión de `app_ventas` con estado `idle`, lo que significa que permanecía conectada, pero no estaba ejecutando una consulta en ese instante.

### 2. Búsqueda del proceso en la bitácora

Al buscar el PID `32216` en `dba.bitacora`, se encontraron tres registros:

| Registro | Hora | Evento |
|---|---|---|
| 157 | 23:12:50.425 | Conexión recibida |
| 158 | 23:12:50.484 | Autenticación correcta |
| 159 | 23:12:50.484 | Conexión autorizada |

Estos registros confirmaron que el usuario `soporte_ana` estableció una conexión desde `127.0.0.1` a la base de datos `comercial`.

La bitácora no mostró la instrucción `SELECT pg_sleep(90);`, porque la configuración `log_statement = mod` no registra normalmente las consultas de lectura.

### 3. Comprobación después de finalizar la consulta

Una vez terminada la espera, se ejecutó:

```sql
SELECT
    pid,
    usename,
    application_name,
    state,
    left(query, 50) AS consulta
FROM pg_stat_activity
WHERE pid = 32216;
```

El resultado fue:

`(0 filas)`

Esto confirmó que la conexión asociada al PID `32216` ya había terminado y no aparecía entre las sesiones actuales.

Sin embargo, sus registros de conexión seguían disponibles en la bitácora.

## Preguntas de la guía

### 1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?

La columna `pid`, que significa identificador de proceso, permite relacionar una sesión de `pg_stat_activity` con sus registros en la bitácora.

Cada conexión tiene un identificador de proceso asignado por PostgreSQL. Cuando el formato de la bitácora incluye `%p`, ese identificador aparece dentro de los registros.

En nuestra práctica, el PID fue `32216`. Al buscarlo en la bitácora, encontramos los eventos relacionados con la conexión del usuario `soporte_ana`.

Esto facilita investigar una sesión específica y relacionar lo que se observó mientras estaba activa con los eventos registrados por el servidor.

### 2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?

La bitácora conserva evidencia de los eventos que fueron registrados durante la conexión.

En nuestra prueba, después de finalizar `pg_sleep(90)`, la sesión dejó de aparecer en `pg_stat_activity`, pero los eventos de conexión, autenticación y autorización continuaron en la bitácora.

Por eso, `pg_stat_activity` es útil para supervisar lo que sucede en el momento, mientras que la bitácora permite investigar eventos anteriores.

Es importante aclarar que la bitácora conserva los eventos configurados para registrarse, no necesariamente todas las consultas ejecutadas.

### 3. ¿Por qué client_addr aparece vacío en la sesión del administrador?

En la guía, el administrador utiliza una conexión local que no se realiza mediante TCP/IP. En esos casos, `client_addr` puede aparecer como `NULL`, porque no existe una dirección IP de cliente asociada a esa conexión.

En nuestra práctica, el administrador se conectó mediante `::1`, que es la dirección de retorno local de IPv6. Por eso sí apareció una dirección en `client_addr`.

Tanto `::1` como `127.0.0.1` representan conexiones realizadas desde la misma computadora, pero utilizan IPv6 e IPv4, respectivamente.

La diferencia depende de cómo se establezca la conexión con PostgreSQL.

## Análisis

Esta actividad permitió comprobar que `pg_stat_activity` y las bitácoras tienen funciones diferentes, aunque pueden complementarse.

Con `pg_stat_activity` fue posible observar una consulta mientras se encontraba en ejecución, identificar su usuario, el PID, la aplicación y el estado de la sesión.

Al revisar la bitácora con el mismo PID, encontramos información sobre el inicio de la conexión y la autenticación del usuario.

Después de terminar la consulta, la sesión desapareció de `pg_stat_activity`, pero sus eventos registrados permanecieron en la bitácora.

Esto demuestra que una herramienta sirve para supervisar la actividad actual y la otra para conservar evidencia histórica. También observé que la configuración del registro determina qué información estará disponible para investigar posteriormente.

## Conclusión

En esta actividad aprendí a utilizar `pg_stat_activity` para identificar las sesiones conectadas a PostgreSQL y observar qué consultas están ejecutando.

También comprendí que el PID permite relacionar una sesión activa con sus registros en la bitácora, lo cual es útil para investigar problemas o actividades sospechosas.

Finalmente, comprobé que `pg_stat_activity` no sustituye a las bitácoras, porque cuando una sesión termina deja de aparecer en la vista, mientras que los eventos registrados pueden conservarse para futuras revisiones.