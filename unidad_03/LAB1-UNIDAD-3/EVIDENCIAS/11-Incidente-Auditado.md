# Evidencia 11 — El incidente auditado

## 1. Objetivo

Comprobar cómo funciona la auditoría cuando un usuario de la aplicación modifica información de un cliente, identificando quién realizó el cambio, cuándo ocurrió, desde dónde se conectó y cuáles eran los valores anteriores y posteriores.

También se busca verificar que el usuario de la aplicación no pueda consultar directamente los registros de auditoría, aunque sus modificaciones se registren automáticamente.

## 2. Procedimiento

### 2.1. Modificación del RFC desde la aplicación

Se utilizó el usuario `app_ventas` para modificar el RFC del cliente con identificador `3` en la base de datos `comercial`.

La instrucción ejecutada fue:

```sql
UPDATE clientes
SET rfc = 'GAMA780912ZZZ'
WHERE id = 3;
```

**Resultado obtenido:**

```text
UPDATE 1
```

Esto significa que PostgreSQL actualizó correctamente un registro.

Aunque la operación fue realizada por `app_ventas`, el disparador `trg_auditoria_clientes` ejecutó automáticamente la función `auditoria.registrar_cambio_cliente()` para guardar los detalles de la modificación.

### 2.2. Prueba de acceso denegado a la auditoría

Anteriormente se comprobó que `app_ventas` no tiene acceso directo al esquema `auditoria`.

La consulta utilizada para comprobar este comportamiento fue:

```sql
SELECT *
FROM auditoria.cambios_clientes;
```

**Resultado obtenido al probar el acceso con `app_ventas`:**

```text
ERROR: permiso denegado al esquema auditoria
```

Esto demuestra que el usuario puede modificar la información de los clientes según sus permisos, pero no puede consultar directamente el historial de auditoría.

La función utiliza `SECURITY DEFINER`, por lo que puede guardar los cambios con los privilegios de su propietario, sin conceder acceso directo a `app_ventas`.

### 2.3. Consulta del evento registrado

Desde la sesión del administrador `postgres`, se revisaron los eventos almacenados en `auditoria.cambios_clientes`.

La consulta para identificar el evento correspondiente es:

```sql
SELECT
    id,
    fecha_evento,
    usuario_sesion,
    usuario_efectivo,
    aplicacion,
    ip_cliente,
    operacion,
    id_cliente
FROM auditoria.cambios_clientes
WHERE id = 5;
```

**Resultado comprobado:**

| Campo | Valor |
|---|---|
| id | 5 |
| fecha_evento | 2026-11-09 22:58:32.260306-06 |
| usuario_sesion | app_ventas |
| usuario_efectivo | postgres |
| operacion | UPDATE |
| id_cliente | 3 |

En la prueba de conexión también se identificó la aplicación `psql` y la dirección `127.0.0.1`.

La diferencia entre `usuario_sesion` y `usuario_efectivo` se debe a que la función utiliza `SECURITY DEFINER`.

El primero identifica al usuario que inició la operación, mientras que el segundo corresponde al propietario cuyos privilegios utiliza la función.

## 3. Comparación de los valores anteriores y nuevos

Para identificar exactamente qué campo se modificó, se pueden comparar los documentos JSONB almacenados en `valores_antes` y `valores_despues`.

La consulta correspondiente es:

```sql
SELECT
    a.id,
    a.fecha_evento,
    a.usuario_sesion,
    a.ip_cliente,
    d.key AS campo,
    a.valores_antes ->> d.key AS antes,
    d.value #>> '{}' AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.id = 5
  AND a.operacion = 'UPDATE'
  AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY d.key;
```

**Comparación del cambio realizado:**

| Evento | Usuario | Campo | Valor anterior | Valor nuevo |
|---|---|---|---|---|
| 5 | app_ventas | rfc | GAMA780912XYZ | GAMA780912ZZZ |

El RFC del cliente cambió de `GAMA780912XYZ` a `GAMA780912ZZZ`.

Esto es importante porque la bitácora del servidor registra la sentencia `UPDATE`, pero la tabla de auditoría conserva también el valor anterior, permitiendo reconstruir la modificación.

## 4. Sentencia para restaurar el RFC

Como conocemos el valor anterior, podemos identificar la instrucción necesaria para restaurarlo:

```sql
UPDATE clientes
SET rfc = 'GAMA780912XYZ'
WHERE id = 3;
```

**Esta instrucción se presenta únicamente como propuesta de restauración. No se ejecutó en esta actividad.**

Si fuera necesario ejecutarla, el disparador también registraría la restauración como un nuevo evento, conservando evidencia de ambos cambios.

## 5. Preguntas de análisis

### 1. Compara tu hipótesis de la Actividad 11 con este resultado.

En la Actividad 11 planteé que, si la función no utilizara `SECURITY DEFINER`, se ejecutaría con los privilegios de `app_ventas`.

Como este usuario no tiene acceso al esquema `auditoria`, la función no podría insertar el registro de auditoría y la modificación probablemente fallaría.

Los resultados respaldan esta hipótesis, porque comprobamos que `app_ventas` pudo modificar el RFC y que el cambio quedó registrado, aunque no tiene acceso directo a la auditoría.

Además, el campo `usuario_efectivo` mostró `postgres`, confirmando que la función se ejecutó con los privilegios de su propietario.

No fue necesario desactivar `SECURITY DEFINER` para realizar esta comprobación, ya que eso habría modificado la configuración de seguridad.

### 2. Escribe la sentencia UPDATE que restauraría el valor anterior.

La sentencia sería:

```sql
UPDATE clientes
SET rfc = 'GAMA780912XYZ'
WHERE id = 3;
```

Esta instrucción permitiría recuperar el valor anterior del RFC, identificado mediante la información almacenada en la auditoría.

Además, si se ejecutara, generaría otro evento de auditoría que permitiría conservar el historial de la restauración.

### 3. ¿Qué columna conserva más valor para una investigación: aplicacion o ip_cliente? ¿Cuál puede falsificar el cliente con más facilidad?

Considero que `ip_cliente` tiene mayor valor técnico para una investigación, porque PostgreSQL obtiene la dirección desde la que recibe la conexión.

En nuestra práctica, la dirección utilizada fue `127.0.0.1`, lo que indica que la conexión se realizó desde la misma computadora.

En cambio, el campo `aplicacion` depende del nombre que declara el programa cliente mediante `application_name`.

Este nombre puede cambiarse fácilmente desde la conexión, por lo que no es una prueba confiable de identidad por sí sola.

Ambos campos son útiles, pero deben analizarse junto con el usuario, la fecha, la operación y los demás datos de auditoría.

## 6. Análisis

En esta actividad se comprobó que el sistema de auditoría permite investigar una modificación de datos con mayor detalle que una bitácora tradicional.

El usuario `app_ventas` realizó correctamente una actualización del RFC, pero no pudo consultar directamente la tabla de auditoría debido a las restricciones de acceso.

A pesar de eso, el cambio quedó almacenado automáticamente porque la función utiliza `SECURITY DEFINER`.

También se comprobó que la auditoría conserva información del usuario que inició la operación y del usuario efectivo utilizado por la función. Esta diferencia es importante para interpretar correctamente los registros.

La comparación de `valores_antes` y `valores_despues` permitió identificar el RFC anterior y el nuevo. Gracias a esto, fue posible determinar cómo restaurar el dato sin depender únicamente de la sentencia registrada en la bitácora.

## 7. Conclusión

En esta actividad aprendí que una auditoría de datos no solamente debe indicar quién realizó una modificación, sino también conservar la información necesaria para comprender qué cambió y cómo podría recuperarse.

Comprobé que el disparador registra automáticamente los cambios realizados por `app_ventas`, aunque ese usuario no tenga acceso directo a la tabla de auditoría.

También comprendí la importancia de conservar los valores anteriores y posteriores, porque permiten investigar errores y reconstruir modificaciones.

Finalmente, entendí que los datos de auditoría, como el usuario, la dirección IP, la aplicación y la fecha, deben analizarse en conjunto para tener una explicación más completa de lo sucedido.