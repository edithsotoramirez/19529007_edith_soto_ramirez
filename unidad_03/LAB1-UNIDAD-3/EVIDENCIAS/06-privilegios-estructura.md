# Actividad 6 — Cambios de privilegios y de estructura

## Objetivo

Comprobar cómo PostgreSQL registra los cambios de permisos y las modificaciones en la estructura de la base de datos, así como identificar los riesgos de seguridad cuando una bitácora almacena información sensible.

## Procedimiento

Primero se revisaron los permisos de los usuarios `app_ventas` y `soporte_ana` sobre la tabla `clientes`.

Se utilizaron las instrucciones `REVOKE` y `GRANT` para controlar quién podía modificar los registros.

También se realizó una modificación de estructura mediante `ALTER TABLE` y se creó y eliminó un rol temporal utilizando `CREATE ROLE` y `DROP ROLE`.

Finalmente, se consultaron los archivos de bitácora para buscar estas operaciones.

## Resultado

Al consultar los permisos, se obtuvo lo siguiente:

| Usuario | Permisos |
|---|---|
| app_ventas | SELECT, UPDATE |
| soporte_ana | SELECT |

Esto confirmó que `app_ventas` puede consultar y modificar registros, mientras que `soporte_ana` tiene permiso de consulta.

También se comprobó que la tabla `clientes` contiene la columna `segmento`, de tipo `character varying`, con una longitud máxima de 30 caracteres.

Al revisar el archivo `postgresql-2026-11-08_222206.log`, se encontraron tres registros relacionados con las instrucciones `ALTER TABLE`, `CREATE ROLE` y `DROP ROLE`, ejecutadas por el usuario `postgres`.

El rol temporal utilizado en nuestra práctica fue `rol_temporal_lab`, creado con `NOLOGIN` y sin contraseña. Por lo tanto, esta prueba no generó una contraseña expuesta en la bitácora.

## Preguntas de la guía

### 1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?

Las instrucciones `REVOKE UPDATE` y `GRANT UPDATE` son eventos relacionados con los privilegios, porque permiten quitar u otorgar permisos a los usuarios.

En cambio, `ALTER TABLE` es un evento de estructura, porque modifica la definición de una tabla. En este caso, se utilizó para trabajar con la columna `segmento`.

### 2. ¿Por qué GRANT y REVOKE quedan registrados con log_statement = 'ddl'?

Porque PostgreSQL incluye las instrucciones de administración de privilegios, como `GRANT` y `REVOKE`, dentro de las sentencias que registra cuando `log_statement` está configurado como `ddl`.

Esto permite conservar evidencia de los cambios en los permisos y revisar quién autorizó o restringió determinadas operaciones.

### 3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.

La bitácora debería estar disponible únicamente para administradores y personal de seguridad autorizado, porque puede contener información sensible, como usuarios, direcciones IP e incluso contraseñas escritas dentro de algunas sentencias SQL.

Esto se relaciona con la gestión de secretos de la Unidad II, donde aprendimos que las contraseñas deben protegerse y no almacenarse en texto claro.

Aunque en nuestra prueba el rol temporal se creó sin contraseña, comprendí que escribir una contraseña directamente en una sentencia SQL puede provocar que quede registrada en la bitácora.

Por eso es importante restringir el acceso a estos archivos, evitar incluir contraseñas en las sentencias y utilizar mecanismos seguros para administrar las credenciales.

## Análisis

Los resultados muestran que la bitácora es útil para investigar cambios administrativos en la base de datos. Se pudo comprobar qué permisos tenían los usuarios y localizar instrucciones relacionadas con la modificación de estructuras y roles.

También observé que la configuración de auditoría debe considerar la protección de los propios registros, ya que almacenar información sensible sin restringir su acceso podría generar nuevos riesgos de seguridad.

## Conclusión

En esta actividad aprendí que PostgreSQL puede registrar cambios en los privilegios y en la estructura de la base de datos. Esto ayuda a identificar operaciones administrativas y mantener un historial de lo ocurrido.

También comprendí que no basta con activar las bitácoras, sino que es necesario protegerlas para evitar que personas no autorizadas consulten información sensible.