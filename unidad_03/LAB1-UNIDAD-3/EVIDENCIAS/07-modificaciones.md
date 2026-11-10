# Actividad 7 — Modificaciones de datos: ddl frente a mod

## Objetivo

Comprobar las diferencias entre las configuraciones `ddl` y `mod` de PostgreSQL, para identificar qué operaciones registra cada una y comprender la importancia de las bitácoras al investigar modificaciones de información.

## Procedimiento

Primero se verificó que `log_statement` estuviera configurado como `ddl` mediante el comando `SHOW log_statement;`.

Después se realizó una modificación del RFC del cliente con `id = 3`, utilizando el usuario `app_ventas`:

```sql
UPDATE clientes SET rfc = 'GAMA780912XYZ' WHERE id = 3;
```

La operación devolvió `UPDATE 1`. Al consultar la bitácora, se encontraron eventos de conexión y desconexión, pero no la sentencia `UPDATE`.

Posteriormente, se cambió la configuración:

```sql
ALTER SYSTEM SET log_statement = 'mod';
SELECT pg_reload_conf();
```

Se comprobó que el nuevo valor fuera `mod` y se ejecutó otra modificación:

```sql
UPDATE clientes SET rfc = 'GAMA780912ZZZ' WHERE id = 3;
```

Finalmente, se consultó la bitácora para localizar la sentencia ejecutada.

## Resultado

| Configuración | Resultado |
|---|---|
| ddl | Se observaron conexiones, pero no la sentencia UPDATE |
| mod | Se registró la sentencia UPDATE |

En la segunda prueba, PostgreSQL registró el evento el 9 de noviembre de 2026 a las 22:58:32, con el usuario `app_ventas`, desde la dirección `127.0.0.1`, utilizando `psql`.

La bitácora mostró la instrucción que cambió el RFC a `GAMA780912ZZZ`.

## Preguntas de la guía

### 1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?

El nivel `all` de `log_statement` permitiría registrar también las instrucciones `SELECT`, utilizadas para consultar información, como el RFC de un cliente.

Sin embargo, en un servidor que recibe miles de consultas por minuto, registrar todas las sentencias produciría una gran cantidad de información. Esto aumentaría el espacio necesario para almacenar las bitácoras y podría afectar el rendimiento del sistema debido al trabajo adicional de registro.

También sería necesario proteger esos archivos, porque podrían contener consultas con información sensible.

### 2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza?

Aunque la bitácora registra quién ejecutó el `UPDATE`, cuándo lo hizo y qué valor escribió, no conserva automáticamente el valor anterior del RFC.

Para revertir el cambio con certeza necesitamos conocer el dato que tenía el cliente antes de la modificación.

Esto se puede resolver mediante una tabla de auditoría y un disparador que almacenen tanto los valores anteriores como los nuevos cada vez que se modifica un registro.

## Análisis

La práctica permitió comprobar que el nivel de registro influye directamente en la información disponible para investigar un incidente.

Con `ddl` se registraron los accesos, pero no la modificación del RFC. En cambio, con `mod` se pudo identificar la sentencia `UPDATE`, el usuario que la ejecutó y la hora.

Sin embargo, esto no significa que la bitácora sea suficiente para reconstruir todos los cambios, porque todavía necesitamos conservar los valores anteriores de los datos.

## Conclusión

En esta actividad aprendí que la configuración `log_statement` determina qué instrucciones se guardan en las bitácoras de PostgreSQL.

El nivel `mod` permite tener más información sobre los cambios realizados, pero no reemplaza una auditoría de datos que almacene los valores anteriores y posteriores.

Por eso es importante combinar una configuración adecuada de bitácoras con otros mecanismos de auditoría para investigar modificaciones y recuperar información cuando sea necesario.