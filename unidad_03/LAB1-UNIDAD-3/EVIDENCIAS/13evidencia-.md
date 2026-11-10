# Evidencia 13 — Manipulación de la auditoría

## 1. Objetivo

Analizar qué tan protegidos se encuentran los registros de auditoría en PostgreSQL, comprobando los permisos de los usuarios de la aplicación y evaluando los riesgos que existen si alguien intenta modificar el historial de cambios o desactivar el disparador encargado de registrar las operaciones.

## 2. Procedimiento

Para realizar esta actividad se utilizó la base de datos `comercial`, que contiene la tabla `clientes` y el esquema `auditoria`, donde se almacena el historial de modificaciones.

Se realizaron tres comprobaciones desde SQL Shell (psql), utilizando el usuario administrador `postgres`.

Primero se consultaron los permisos de `app_ventas` para verificar si podía acceder al esquema `auditoria`, consultar los registros, modificarlos o eliminarlos.

Después se revisó si ese usuario tenía el privilegio `TRIGGER` sobre la tabla `clientes` y se identificó quién era el propietario de la tabla.

Finalmente, se consultó el estado del disparador `trg_auditoria_clientes` para confirmar que continuaba habilitado.

Las pruebas fueron de consulta y verificación. No se modificaron ni eliminaron registros de auditoría y tampoco se desactivó el disparador.

## 3. Resultados

### 3.1. Verificación de permisos sobre la auditoría

Se ejecutó la siguiente consulta:

```sql
SELECT
    has_schema_privilege('app_ventas', 'auditoria', 'USAGE') AS acceso_esquema,
    has_table_privilege('app_ventas', 'auditoria.cambios_clientes', 'SELECT') AS puede_consultar,
    has_table_privilege('app_ventas', 'auditoria.cambios_clientes', 'UPDATE') AS puede_modificar,
    has_table_privilege('app_ventas', 'auditoria.cambios_clientes', 'DELETE') AS puede_eliminar;
```

**Resultados obtenidos:**

| Permiso | Resultado |
|---|---|
| Acceso al esquema | false |
| Consultar registros | false |
| Modificar registros | false |
| Eliminar registros | false |

Los cuatro resultados fueron `false`, lo que confirma que `app_ventas` no tiene estos permisos sobre la tabla de auditoría.

Esto es importante porque el usuario puede realizar operaciones autorizadas sobre `clientes`, pero no debe poder alterar el historial donde quedan registradas.

De esta manera se evita que un usuario común pueda borrar o modificar directamente la evidencia de sus propias operaciones.

### 3.2. Verificación de permisos sobre el disparador

Se ejecutó:

```sql
SELECT
    has_table_privilege(
        'app_ventas',
        'public.clientes',
        'TRIGGER'
    ) AS permiso_trigger,
    pg_get_userbyid(c.relowner) AS propietario_tabla
FROM pg_class c
WHERE c.oid = 'public.clientes'::regclass;
```

**Resultados obtenidos:**

| Campo | Resultado |
|---|---|
| permiso_trigger | false |
| propietario_tabla | postgres |

Se comprobó que `app_ventas` no tiene el privilegio `TRIGGER` y que el propietario de la tabla `clientes` es `postgres`.

Esto significa que `app_ventas` no tiene los privilegios de propietario necesarios para desactivar normalmente el disparador mediante `ALTER TABLE`.

Esta protección es importante porque, si el disparador estuviera desactivado, los cambios realizados sobre los clientes podrían dejar de registrarse en la tabla de auditoría.

### 3.3. Estado del disparador

Para comprobar que el disparador continuaba habilitado, se ejecutó:

```sql
SELECT
    tgname AS disparador,
    CASE tgenabled
        WHEN 'O' THEN 'Habilitado'
        WHEN 'D' THEN 'Deshabilitado'
        WHEN 'R' THEN 'Solo replica'
        WHEN 'A' THEN 'Siempre'
    END AS estado
FROM pg_trigger
WHERE tgname = 'trg_auditoria_clientes'
  AND NOT tgisinternal;
```

**Resultado obtenido:**

| Disparador | Estado |
|---|---|
| trg_auditoria_clientes | Habilitado |

El resultado confirmó que el disparador permanece activo.

Esto significa que, bajo las condiciones normales de ejecución, continúa preparado para registrar las operaciones `INSERT`, `UPDATE` y `DELETE` realizadas sobre la tabla `clientes`.

## 4. Preguntas de análisis

### 1. ¿Puede app_ventas modificar o eliminar directamente los registros de auditoría? ¿Por qué?

No. En las consultas realizadas se comprobó que `app_ventas` no tiene permisos `UPDATE` ni `DELETE` sobre `auditoria.cambios_clientes`.

Tampoco tiene acceso directo al esquema `auditoria`.

Esto ayuda a proteger el historial de modificaciones, porque evita que un usuario de la aplicación pueda alterar o eliminar fácilmente la evidencia de las operaciones que realiza.

### 2. ¿Qué sucedería si un administrador desactivara el disparador de auditoría?

Si un administrador con los privilegios necesarios desactivara el disparador, las operaciones realizadas sobre `clientes` dejarían de ejecutar automáticamente la función de auditoría mientras permaneciera deshabilitado.

Esto significa que podrían realizarse modificaciones sin generar nuevos registros en `auditoria.cambios_clientes`.

Por eso es importante controlar quién puede modificar la configuración de los disparadores y supervisar los cambios realizados en la estructura de la base de datos.

En nuestra práctica no se desactivó el disparador. Únicamente se comprobó que estaba habilitado.

### 3. ¿Por qué una auditoría basada en disparadores no es completamente resistente a la manipulación?

Porque los registros de auditoría se almacenan dentro de la misma base de datos que se está supervisando.

Aunque los usuarios comunes tengan permisos restringidos, un administrador con privilegios elevados podría modificar la tabla de auditoría, eliminar registros o desactivar el disparador.

Por lo tanto, este mecanismo ayuda a registrar los cambios, pero no garantiza por sí solo que el historial sea imposible de alterar.

Para mejorar su protección sería conveniente utilizar bitácoras externas, respaldos protegidos, controles estrictos sobre los administradores y mecanismos de supervisión que permitan detectar cambios no autorizados.

## 5. Análisis

En esta actividad comprobé que los permisos de PostgreSQL permiten separar las operaciones de los usuarios de la aplicación del acceso a los registros de auditoría.

Los resultados mostraron que `app_ventas` no puede consultar, modificar ni eliminar directamente los registros almacenados en `auditoria.cambios_clientes`.

También se comprobó que este usuario no es propietario de la tabla `clientes` y que el disparador continúa habilitado.

Estas restricciones ayudan a proteger el historial frente a manipulaciones realizadas por usuarios con permisos limitados.

Sin embargo, también identifiqué una limitación importante: un administrador con privilegios elevados puede tener capacidad para modificar los mecanismos de auditoría.

Por eso, además de utilizar disparadores y controles de acceso, es necesario contar con medidas adicionales que permitan conservar evidencia fuera del alcance de quienes administran la base de datos.

## 6. Conclusión

En esta actividad aprendí que no es suficiente crear una tabla de auditoría para garantizar la protección de sus registros.

Comprobé que `app_ventas` tiene restricciones que le impiden modificar o eliminar directamente el historial, y que el disparador encargado de registrar los cambios continúa habilitado.

También comprendí que los administradores con privilegios elevados representan un riesgo para la integridad de la auditoría si no existen controles adicionales.

Finalmente, considero que una auditoría confiable debe combinar permisos restringidos, supervisión de cambios y mecanismos de conservación de evidencia para evitar que las operaciones realizadas puedan ocultarse o manipularse fácilmente.