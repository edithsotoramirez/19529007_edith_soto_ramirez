# Evidencia 15 — Reconstrucción cronológica

## 1. Objetivo

Reconstruir cronológicamente los acontecimientos ocurridos en la base de datos `comercial`, utilizando las bitácoras de PostgreSQL y los registros almacenados en `auditoria.cambios_clientes`.

El propósito es identificar qué operaciones se realizaron, cuándo ocurrieron, qué usuarios estuvieron involucrados y qué información fue modificada. También se busca reconocer las limitaciones de las evidencias disponibles y evitar atribuir acciones sin contar con registros que las respalden.

## 2. Procedimiento

Para realizar esta actividad se revisaron dos fuentes principales de información.

**Bitácora del servidor:** se utilizó la vista `dba.bitacora` y se consultaron archivos históricos de PostgreSQL para identificar operaciones de configuración, creación de objetos, intentos de conexión y errores.

**Tabla de auditoría:** se consultó `auditoria.cambios_clientes` para identificar las operaciones `INSERT`, `UPDATE` y `DELETE`, junto con sus fechas, usuarios y valores anteriores y posteriores.

Las consultas se realizaron desde SQL Shell (psql), utilizando el usuario administrador `postgres` en la base de datos `comercial`.

Posteriormente, se organizaron los acontecimientos por fecha y hora para reconstruir lo sucedido.

## 3. Cronología de acontecimientos

A partir de los resultados obtenidos, se identificaron los siguientes eventos:

| Fecha y hora | Usuario | Evento | Evidencia encontrada |
|---|---|---|---|
| 09/11/2026 00:11:38 | postgres | Creación del esquema de auditoría | Sentencia `CREATE SCHEMA` registrada en la bitácora. |
| 09/11/2026 00:16:21 | postgres | Creación de la función de auditoría | Sentencia `CREATE OR REPLACE FUNCTION` registrada en la bitácora. |
| 09/11/2026 00:16:23 | postgres | Creación del disparador | Sentencia `CREATE TRIGGER` registrada en la bitácora. |
| 09/11/2026 00:19:38 | postgres | Actualización del cliente 3 | Evento 1 de auditoría. |
| 09/11/2026 00:34:49 | postgres | Inserción de Pedro Ruiz | Evento 2 de auditoría. |
| 09/11/2026 00:36:09 | postgres | Eliminación de Pedro Ruiz | Evento 3 de auditoría. |
| 09/11/2026 22:31:51 | app_ventas | Intento fallido de conexión | Error `FATAL` por contraseña incorrecta. |
| 09/11/2026 22:33:10 | soporte_ana | Intento fallido de conexión | Error `FATAL` por contraseña incorrecta. |
| 09/11/2026 22:55:19 | app_ventas | Primera modificación auditada del RFC | Evento 4 de auditoría. |
| 09/11/2026 22:58:32 | app_ventas | Segunda modificación auditada del RFC | Evento 5 de auditoría. |
| 09/11/2026 23:04:02 | soporte_ana | Intento de operación sin permisos | Error de permiso denegado sobre `clientes`. |
| 09/11/2026 23:06:18 | postgres | Intento de eliminación de un rol | PostgreSQL rechazó `DROP ROLE soporte_ana` porque existían objetos dependientes. |

### Interpretación de la cronología

Los primeros acontecimientos corresponden a la creación del mecanismo de auditor