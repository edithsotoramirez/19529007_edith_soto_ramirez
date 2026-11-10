# Actividad 8. Prueba del disparador de auditoría

## Actividad 8 — Errores y operaciones rechazadas

## Objetivo

Comprobar cómo PostgreSQL controla las operaciones no autorizadas y registra los errores en sus bitácoras, para entender su importancia en la seguridad y administración de la base de datos.

## Procedimiento

Primero se intentó eliminar un registro de la tabla `clientes` utilizando el usuario `soporte_ana`:

```sql
DELETE FROM clientes WHERE id = 5;
```

Después, desde una sesión de administrador, se intentó eliminar el rol `soporte_ana`:

```sql
DROP ROLE soporte_ana;
```

Finalmente, se consultó la vista `dba.bitacora` para localizar los errores generados por ambas operaciones.

## Resultado

**Primera prueba: eliminación de un cliente**

PostgreSQL mostró el mensaje:

`ERROR: permiso denegado a la tabla clientes`

Esto confirmó que el usuario `soporte_ana` no tenía autorización para eliminar registros y que la operación fue rechazada.

**Segunda prueba: eliminación de un rol**

PostgreSQL mostró un error indicando que el rol `soporte_ana` no podía eliminarse porque otros objetos dependían de él.

Entre las dependencias aparecieron privilegios sobre el esquema `public`, la base de datos `comercial` y la tabla `clientes`.

**Verificación en la bitácora**

Se encontraron registros de ambos errores:

| Hora | Usuario | Evento |
|---|---|---|
| 23:04:02 | soporte_ana | Intento de DELETE rechazado |
| 23:06:18 | postgres | Intento de DROP ROLE rechazado |

La bitácora permitió identificar los usuarios, las horas y las operaciones relacionadas con los errores.

## Preguntas de la guía

### 1. ¿El intento de soporte_ana causó algún daño? ¿Por qué debe auditarse de todos modos?

No, el intento no eliminó ningún registro porque PostgreSQL rechazó la operación al detectar que `soporte_ana` no tenía el permiso necesario.

Sin embargo, es importante registrar estos intentos porque pueden indicar que un usuario está intentando realizar operaciones fuera de sus funciones. También permiten identificar posibles errores en el uso del sistema o intentos de acceso indebido.

Aunque la operación no se complete, conservar evidencia ayuda a investigar lo sucedido y tomar medidas preventivas.

### 2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?

La autenticación consiste en comprobar la identidad de un usuario, por ejemplo, mediante su nombre y contraseña. Un error de autenticación ocurre cuando PostgreSQL no puede confirmar esa identidad y rechaza la conexión.

En cambio, la autorización determina qué operaciones puede realizar un usuario que ya consiguió conectarse.

En esta actividad, `soporte_ana` pudo iniciar sesión, pero PostgreSQL no le permitió eliminar un cliente porque no tenía el permiso `DELETE`.

Por lo tanto, la autenticación responde a quién intenta acceder, mientras que la autorización determina qué tiene permitido hacer.

### 3. ¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?

El error indica que no se debe intentar eliminar un usuario sin revisar primero los permisos y dependencias que tiene dentro de la base de datos.

Antes de eliminar un rol, el administrador debe identificar los objetos relacionados, retirar los privilegios correspondientes y resolver las dependencias necesarias.

Una vez que el rol ya no tenga dependencias que impidan su eliminación, se puede ejecutar `DROP ROLE`.

Esto permite realizar una baja ordenada y evitar problemas en la administración de los permisos.

## Análisis

Los resultados muestran que PostgreSQL aplica controles de seguridad tanto para las operaciones sobre los datos como para la administración de usuarios.

En la primera prueba, se impidió que `soporte_ana` eliminara un cliente. En la segunda, se evitó eliminar un rol que todavía tenía privilegios asignados.

También comprobé que ambos errores quedaron registrados en la bitácora. Esto permite investigar operaciones rechazadas, identificar posibles riesgos y tener un historial de los intentos realizados.

## Conclusión

En esta actividad aprendí que los errores de PostgreSQL también proporcionan información importante para la seguridad.

Aunque una operación sea rechazada y no cause cambios en la base de datos, debe quedar registrada para poder identificar quién la intentó realizar y por qué falló.

También comprendí que la administración de usuarios requiere revisar sus permisos y dependencias antes de eliminarlos.