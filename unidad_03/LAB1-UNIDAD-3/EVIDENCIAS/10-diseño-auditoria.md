# Actividad 10 — Diseñar y crear el registro de auditoría

## Objetivo

Diseñar y comprobar una estructura de auditoría que permita registrar los cambios realizados en la tabla `clientes`, conservando información sobre quién hizo cada operación, cuándo ocurrió, desde qué aplicación y dirección IP, y cuáles eran los valores anteriores y posteriores.

## Planteamiento del problema

El área de facturación necesita poder recuperar el RFC correcto cuando se realiza una modificación equivocada. Para lograrlo, no es suficiente saber que un usuario ejecutó una sentencia `UPDATE`, porque también necesitamos conocer el valor que tenía el registro antes del cambio.

Por eso se requiere una tabla de auditoría que conserve información de cada operación y permita reconstruir lo sucedido.

## Procedimiento

Se trabajó con el esquema `auditoria`, separado del esquema principal de la base de datos, y con la tabla `auditoria.cambios_clientes`.

Primero se consultó `information_schema.columns` para comprobar los nombres, tipos de datos, valores predeterminados y restricciones de nulidad de los campos.

Después se consultaron los registros almacenados en la tabla de auditoría, identificando las operaciones realizadas y comprobando si se conservaron los valores anteriores y nuevos.

No fue necesario volver a crear la tabla, porque ya existía y contenía registros de las pruebas anteriores.

## Matriz de diseño de auditoría

La guía propone los campos `id_evento` y `momento`. En nuestra base de datos estos campos se llaman `id` y `fecha_evento`, respectivamente, pero cumplen las mismas funciones.

| Campo utilizado | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
|---|---|---|---|
| id | BIGSERIAL | ¿Cuál es el identificador del evento? | No. Cada evento necesita un identificador único. |
| fecha_evento | TIMESTAMPTZ | ¿Cuándo ocurrió el cambio? | En la tabla actual sí se permite NULL, aunque tiene CURRENT_TIMESTAMP como valor predeterminado. Sería recomendable exigir NOT NULL. |
| usuario_sesion | TEXT | ¿Quién inició la sesión que realizó el cambio? | Actualmente sí se permite NULL, aunque para una auditoría confiable debería ser obligatorio. |
| usuario_efectivo | TEXT | ¿Con los privilegios de qué usuario se ejecutó la operación de auditoría? | Actualmente sí se permite NULL, pero conviene conservarlo para identificar el contexto de ejecución. |
| aplicacion | TEXT | ¿Desde qué aplicación se realizó el cambio? | Sí, porque el nombre de la aplicación puede no estar disponible. |
| ip_cliente | INET | ¿Desde qué dirección IP se realizó la operación? | Sí, porque algunas conexiones locales pueden no tener una dirección IP asociada. |
| operacion | TEXT | ¿Qué tipo de operación se realizó? | Actualmente sí se permite NULL, pero debería ser obligatorio para distinguir INSERT, UPDATE y DELETE. |
| id_cliente | BIGINT | ¿Qué cliente fue afectado? | Actualmente sí se permite NULL, aunque para registrar cambios en clientes convendría exigirlo. |
| valores_antes | JSONB | ¿Qué información tenía el cliente antes del cambio? | Sí. En una inserción no existe un registro anterior. |
| valores_despues | JSONB | ¿Qué información quedó después del cambio? | Sí. En una eliminación no existe un registro posterior. |

## Resultado

La consulta de estructura confirmó que la tabla contiene diez columnas.

El campo `id` no permite valores nulos y utiliza una secuencia para generar identificadores automáticamente. El campo `fecha_evento` tiene `CURRENT_TIMESTAMP` como valor predeterminado.

También se comprobó que los otros campos permiten valores nulos en la estructura actual.

Al consultar la tabla se encontraron cinco eventos:

| ID | Usuario de sesión | Operación | Cliente | Valores anteriores | Valores nuevos |
|---|---|---|---|---|---|
| 1 | postgres | UPDATE | 3 | Sí | Sí |
| 2 | postgres | INSERT | 6 | No | Sí |
| 3 | postgres | DELETE | 6 | Sí | No |
| 4 | app_ventas | UPDATE | 3 | Sí | Sí |
| 5 | app_ventas | UPDATE | 3 | Sí | Sí |

Los resultados muestran que la auditoría conserva información diferente según la operación realizada.

En los eventos `UPDATE` se guardaron los valores anteriores y posteriores. En el evento `INSERT` solamente se almacenaron los valores nuevos, y en el evento `DELETE` se conservaron los anteriores.

También observé que en los dos últimos eventos `usuario_sesion` es `app_ventas`, mientras que `usuario_efectivo` es `postgres`. Esto ocurre porque la función de auditoría utiliza `SECURITY DEFINER` y se ejecuta con los privilegios de su propietario.

## Preguntas de la guía

### 1. ¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?

Porque `TIMESTAMPTZ` permite almacenar un instante de tiempo teniendo en cuenta la zona horaria de la sesión al interpretar y mostrar la fecha.

Esto es importante en una auditoría, ya que las conexiones pueden realizarse desde diferentes lugares o con distintas configuraciones de zona horaria.

En cambio, `TIMESTAMP` sin zona horaria almacena la fecha y hora sin esa referencia, lo que puede generar confusiones al comparar eventos de distintos sistemas.

En nuestra tabla este campo se llama `fecha_evento` y utiliza `TIMESTAMPTZ`.

### 2. ¿Por qué se guarda el registro completo en JSONB y no solo la columna que cambió?

Porque conservar el registro completo permite conocer el estado del cliente antes y después de cada modificación.

Si solamente guardáramos la columna modificada, podríamos perder información útil para investigar el contexto del cambio o reconstruir el registro.

El tipo `JSONB` permite almacenar varios campos dentro de una misma estructura y facilita consultar o comparar sus valores.

Además, si posteriormente cambia la estructura de `clientes`, los eventos anteriores pueden seguir conservando los campos que existían cuando fueron registrados.

### 3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?

Significa que la tabla de auditoría también contiene información personal que necesita protección, porque al guardar los valores anteriores y posteriores se pueden almacenar datos como el RFC de los clientes.

Por lo tanto, no debemos considerar la tabla de auditoría como información pública ni permitir que cualquier usuario la consulte.

Es necesario restringir su acceso a los administradores o personas autorizadas, aplicar el principio de mínimo privilegio y evitar modificaciones o eliminaciones indebidas de los registros.

También deben considerarse medidas como cifrado, respaldos protegidos y políticas de conservación, porque la auditoría puede contener información sensible durante mucho tiempo.

## Análisis

Esta actividad permitió comprender que una auditoría de datos necesita más información que una bitácora de sentencias SQL.

La bitácora puede indicar que se ejecutó un `UPDATE`, pero la tabla de auditoría permite conservar el estado anterior y posterior del registro. Esto es especialmente importante cuando se necesita investigar un cambio incorrecto o recuperar información.

Los cinco eventos encontrados demuestran que la estructura permite registrar inserciones, modificaciones y eliminaciones, identificando al usuario de sesión y al cliente afectado.

También identifiqué una diferencia entre la estructura propuesta en la guía y nuestra tabla: algunos campos que deberían ser obligatorios actualmente permiten valores nulos. Aunque las pruebas realizadas contienen la información necesaria, sería recomendable reforzar esas restricciones para mejorar la confiabilidad de la auditoría.

Otro aspecto importante es que la tabla almacena información personal. Por eso, además de registrar cambios, es necesario proteger los propios registros de auditoría.

## Conclusión

En esta actividad aprendí a identificar los campos necesarios para diseñar una tabla de auditoría y comprendí la función que cumple cada uno.

También comprobé que nuestra tabla conserva los valores anteriores y posteriores según el tipo de operación, lo cual permite investigar modificaciones y recuperar información cuando sea necesario.

Finalmente, comprendí que una auditoría confiable debe registrar suficiente información para reconstruir lo sucedido, pero también debe contar con controles de acceso y protección, porque puede almacenar datos personales de los clientes.