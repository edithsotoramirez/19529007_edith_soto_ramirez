# Actividad 3. Incidente sin bitácora

## Objetivo

Comprobar si PostgreSQL registra una modificación realizada por un usuario cuando el registro de instrucciones SQL no está activado.

## Resultado

Se inició sesión en la base de datos `comercial` utilizando el usuario `app_ventas`. Después se modificó el RFC de María García, quien tiene el identificador 3.

La instrucción devolvió `UPDATE 1`, confirmando que se modificó un registro. Al consultar nuevamente los datos, el RFC apareció como `GAMA780912XXX`.

Posteriormente, desde el usuario `postgres`, se buscó la instrucción y el nombre del usuario dentro del archivo de bitácora actual.

Se obtuvieron los siguientes resultados:

| Dato consultado | Resultado |
|---|---|
| Instrucción UPDATE | Posición 0 |
| Usuario app_ventas | Posición 1717 |

**Evidencias:**

- Insertar captura de la modificación realizada por `app_ventas`.
- Insertar captura de la consulta de la bitácora.

## Análisis

La modificación se realizó correctamente, pero al buscar el texto `UPDATE clientes` en el archivo de bitácora no se encontró. Esto coincide con la configuración inicial de PostgreSQL, donde `log_statement` estaba establecido en `none`.

Aunque apareció el nombre `app_ventas`, esto no significa que se haya registrado la instrucción que modificó el RFC. La búsqueda solamente permitió comprobar la presencia o ausencia de esos textos en el archivo consultado.

## Conclusión

Esta actividad me permitió comprender que una modificación puede realizarse correctamente sin que la instrucción SQL quede registrada en la bitácora. Por eso es importante configurar los registros de acuerdo con las necesidades de seguridad y auditoría de la base de datos.
