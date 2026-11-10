# Evidencia 12 — Altas y bajas

## 1. Objetivo

Comprobar que el mecanismo de auditoría de PostgreSQL registra correctamente las operaciones de inserción y eliminación de clientes, conservando los datos necesarios para identificar qué información se agregó o eliminó y quién realizó la operación.

## 2. Procedimiento

Para esta actividad se utilizaron los registros generados anteriormente mediante el disparador `trg_auditoria_clientes`, asociado a la tabla `clientes` de la base de datos `comercial`.

Primero se insertó un cliente llamado Pedro Ruiz. Después se eliminó ese mismo registro para comprobar que el mecanismo de auditoría conservara evidencia de ambas operaciones.

Las operaciones realizadas fueron:

- **INSERT:** se agregó el cliente Pedro Ruiz, al que PostgreSQL asignó el identificador `6`.
- **DELETE:** se eliminó el cliente con identificador `6`.

Posteriormente, desde la sesión del administrador `postgres`, se consultó la tabla `auditoria.cambios_clientes` para revisar los eventos almacenados.

La consulta de verificación fue:

```sql
SELECT
    id AS evento,
    fecha_evento,
    operacion,
    id_cliente,
    valores_antes ->> 'nombre' AS nombre_anterior,
    valores_despues ->> 'nombre' AS nombre_nuevo,
    valores_antes IS NOT NULL AS tiene_antes,
    valores_despues IS NOT NULL AS tiene_despues
FROM auditoria.cambios_clientes
WHERE id_cliente = 6
ORDER BY id;
```

Esta consulta permitió identificar las operaciones realizadas sobre el cliente y verificar qué información se conservó antes y después de cada una.

## 3. Resultados

La consulta devolvió dos registros de auditoría:

| Evento | Operación | Cliente | Nombre anterior | Nombre nuevo | Tiene valores anteriores | Tiene valores nuevos |
|---|---|---|---|---|---|---|
| 2 | INSERT | 6 | NULL | Pedro Ruiz | false | true |
| 3 | DELETE | 6 | Pedro Ruiz | NULL | true | false |

El evento `2` corresponde a la inserción del cliente, realizada el 9 de noviembre de 2026 a las 00:34:49.

El evento `3` corresponde a su eliminación, realizada el mismo día a las 00:36:09.

En ambos casos, la información quedó registrada automáticamente mediante el disparador.

### Resultado del INSERT

Al insertar a Pedro Ruiz, el campo `valores_antes` quedó en `NULL`, porque el cliente todavía no existía en la tabla.

Por otro lado, `valores_despues` almacenó los datos del cliente recién agregado.

Esto permite conocer qué información se incorporó a la base de datos.

### Resultado del DELETE

Al eliminar a Pedro Ruiz, `valores_antes` conservó los datos que tenía el cliente antes de ser eliminado.

En cambio, `valores_despues` quedó en `NULL`, porque después de la eliminación ya no existe una versión nueva del registro.

Esto demuestra que la auditoría conserva información histórica incluso cuando el registro original fue eliminado.

## 4. Preguntas de análisis

### 1. ¿Qué guarda la auditoría cuando se realiza un INSERT?

Cuando se realiza un `INSERT`, la auditoría guarda los datos del registro nuevo en `valores_despues`.

El campo `valores_antes` queda en `NULL`, porque antes de la inserción el registro no existía.

En nuestra prueba, el evento `2` conservó el nombre Pedro Ruiz en los valores posteriores y no presentó valores anteriores.

### 2. ¿Qué guarda la auditoría cuando se realiza un DELETE?

Cuando se realiza un `DELETE`, la auditoría conserva los datos del registro eliminado en `valores_antes`.

El campo `valores_despues` queda en `NULL`, porque después de la operación el registro ya no existe en la tabla principal.

En nuestra prueba, el evento `3` conservó el nombre Pedro Ruiz en los valores anteriores.

Esto permite investigar qué información fue eliminada.

### 3. ¿Por qué es importante conservar los datos de un registro eliminado?

Porque, si únicamente elimináramos el registro de la tabla principal, podríamos perder información necesaria para investigar qué ocurrió.

Al conservar los valores anteriores en la auditoría, es posible identificar qué cliente fue eliminado y qué datos tenía antes de la operación.

Esta información puede ayudar a investigar eliminaciones accidentales o no autorizadas y a determinar si es necesario recuperar los datos.

Sin embargo, también es importante proteger estos registros y establecer políticas de conservación, porque pueden contener información personal.

## 5. Análisis

Los resultados demostraron que el disparador registra correctamente tanto las inserciones como las eliminaciones.

En la inserción de Pedro Ruiz se conservaron los valores nuevos, mientras que en su eliminación se guardaron los valores anteriores.

Esto confirma que el mecanismo de auditoría utiliza la información correspondiente a cada tipo de operación.

También observé que los registros de auditoría permanecen almacenados después de eliminar al cliente de la tabla principal.

Esta característica es importante porque permite conservar evidencia histórica y reconstruir lo sucedido, incluso cuando los datos originales ya no están disponibles.

## 6. Conclusión

En esta actividad aprendí cómo funciona la auditoría cuando se agrega o elimina un registro en PostgreSQL.

Comprobé que las inserciones conservan los valores nuevos y las eliminaciones guardan los valores anteriores, permitiendo identificar qué información fue afectada.

También comprendí que la auditoría es útil para investigar errores o eliminaciones no autorizadas, porque mantiene un historial de las operaciones realizadas.

Finalmente, considero importante que estos registros estén protegidos, ya que pueden contener datos personales que deben conservarse y utilizarse de manera responsable.