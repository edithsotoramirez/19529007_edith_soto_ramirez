# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL

**Universidad Autónoma de Sinaloa**  
**Facultad de Informática Culiacán**  
**Unidad III — Administración de Bases de Datos**  
**Estudiante:** Edith Marcela Soto Ramírez  
**Base de datos:** `comercial`  
**Sistema gestor:** PostgreSQL 17

---

## 1. Despliegue y situación inicial

Para realizar este laboratorio utilicé PostgreSQL 17, instalado directamente en Windows. Trabajé principalmente desde SQL Shell (psql) para ejecutar las consultas y configuraciones necesarias, y utilicé PowerShell para verificar la integridad de los archivos exportados.

La práctica se realizó sobre la base de datos `comercial`, utilizando diferentes usuarios, como `postgres`, `app_ventas` y `soporte_ana`, para observar cómo se registraban sus actividades y qué información podía recuperarse de ellas.

Al inicio del laboratorio, la configuración de las bitácoras no permitía identificar con suficiente detalle todas las operaciones realizadas. Esto representaba un problema porque, si alguien modificaba información sensible, no necesariamente existía un registro que permitiera identificar quién lo había hecho, cuándo ocurrió y qué valor tenía el dato anteriormente.

Esta situación se observó en el primer incidente, cuando se realizó una modificación sobre un RFC sin contar todavía con los mecanismos de auditoría necesarios para reconstruir completamente el cambio.

Por esta razón, fue necesario configurar las bitácoras del servidor e implementar un mecanismo adicional que registrara los cambios realizados directamente sobre los datos.

## 2. Configuración aplicada

Durante el laboratorio se configuraron diferentes parámetros de PostgreSQL para mejorar el registro de actividades.

| Parámetro | Valor configurado | Función |
|---|---|---|
| `logging_collector` | `on` | Permite que PostgreSQL recopile los mensajes y los almacene en archivos de bitácora. |
| `log_connections` | `on` | Registra los intentos de conexión al servidor. |
| `log_disconnections` | `on` | Registra las desconexiones de los usuarios. |
| `log_statement` | `mod` | Registra sentencias que modifican datos o la estructura de la base de datos. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h` | Agrega información que ayuda a identificar el momento, proceso, usuario, base de datos, aplicación y cliente. |

El parámetro `logging_collector` requiere reiniciar el servidor para aplicar un cambio de estado, mientras que los parámetros de registro de conexiones, desconexiones, sentencias y prefijo pueden aplicarse mediante una recarga de configuración.

La finalidad de estos cambios fue contar con información suficiente para relacionar las operaciones con los usuarios que las ejecutaron.

También se creó una vista llamada `dba.bitacora` para consultar el contenido del archivo de registro actual desde PostgreSQL. Sin embargo, durante la práctica observé que esta vista podía mostrar cero registros cuando los eventos que buscaba estaban en un archivo histórico diferente.

Esto permitió comprender que no basta con revisar únicamente la bitácora actual, ya que algunos eventos pueden encontrarse en archivos anteriores.

## 3. Eventos observados

Después de configurar el registro de actividades, se realizaron distintas pruebas para comprobar qué información almacenaba PostgreSQL.

### Accesos y conexiones

Se observaron intentos de conexión fallidos de los usuarios `app_ventas` y `soporte_ana` desde la dirección `127.0.0.1`, debido a errores de autenticación.

Estos registros permiten identificar qué usuario intentó acceder, desde dónde se realizó el intento y en qué momento ocurrió.

También se revisaron las sesiones activas mediante `pg_stat_activity`, lo que permitió comparar la información de las conexiones actuales con los eventos históricos almacenados en las bitácoras.

### Cambios de privilegios

Se trabajó con instrucciones como `GRANT` y `REVOKE` para administrar los permisos de los usuarios.

El usuario `app_ventas` tenía permisos para consultar y actualizar información de clientes, mientras que `soporte_ana` contaba con permisos de consulta.

Estas pruebas ayudaron a comprobar la importancia de asignar únicamente los permisos necesarios para las actividades de cada usuario.

### Cambios en la estructura

Se realizaron operaciones de modificación de estructura, como agregar el campo `segmento` a la tabla `clientes`.

Este tipo de operaciones es importante dentro de una auditoría porque permite identificar cambios que pueden afectar el funcionamiento de una base de datos, aunque no modifiquen directamente los valores de los registros existentes.

### Modificaciones de datos

Se ejecutaron operaciones `UPDATE`, `INSERT` y `DELETE` sobre la tabla de clientes.

Entre los cambios registrados se encontraron modificaciones del RFC de un cliente y la inserción y eliminación de un registro de prueba.

Con estas operaciones fue posible comparar la información disponible en las bitácoras generales con la que posteriormente se almacenó en la tabla de auditoría.

### Errores

También se identificaron errores relacionados con permisos insuficientes.

Por ejemplo, el usuario `soporte_ana` intentó ejecutar una operación para la cual no tenía autorización, por lo que PostgreSQL rechazó la instrucción.

Este resultado demuestra que las bitácoras no solamente ayudan a revisar operaciones exitosas, sino también intentos que fueron bloqueados por el sistema.

## 4. Auditoría del dato

Una de las partes más importantes del laboratorio fue implementar un mecanismo que permitiera conocer los valores anteriores y posteriores de los datos modificados.

Para ello, se creó el esquema `auditoria` y la tabla `auditoria.cambios_clientes`.

Esta tabla contiene información como la fecha del evento, el usuario de sesión, el usuario efectivo, la aplicación utilizada, la dirección IP, el tipo de operación, el identificador del cliente y los valores anteriores y posteriores del registro.

Los valores se almacenaron mediante campos de tipo `JSONB`, lo que permite conservar la información del registro antes y después de una modificación.

### Función y disparador

Se creó una función de auditoría y un disparador llamado `trg_auditoria_clientes`, asociado a la tabla `clientes`.

Su finalidad es registrar automáticamente las operaciones `INSERT`, `UPDATE` y `DELETE`.

La función utiliza `SECURITY DEFINER`, por lo que puede ejecutarse con los privilegios de su propietario. Esto permite registrar los cambios sin otorgar a los usuarios de la aplicación acceso directo a la tabla de auditoría.

También se utilizó `session_user` para identificar al usuario que inició la sesión. Esto es importante porque, al utilizar `SECURITY DEFINER`, el usuario efectivo puede ser diferente del usuario que realizó la operación.

### Resultado del incidente auditado

Durante las pruebas, el usuario `app_ventas` modificó el RFC del cliente con identificador 3.

La auditoría permitió recuperar los siguientes cambios:

| Operación | RFC anterior | RFC posterior |
|---|---|---|
| Primer UPDATE auditado de `app_ventas` | `GAMA780912XXX` | `GAMA780912XYZ` |
| Segundo UPDATE auditado de `app_ventas` | `GAMA780912XYZ` | `GAMA780912ZZZ` |

En ambos casos se identificó a `app_ventas` como usuario de sesión.

Además, se registraron operaciones de inserción y eliminación de un cliente de prueba, por lo que se comprobó el funcionamiento de la auditoría para los tres tipos de modificaciones.

La tabla de auditoría llegó a contener cinco eventos registrados durante las pruebas revisadas.

Esto demuestra que la auditoría mediante disparadores proporciona información que no siempre puede obtenerse únicamente con el registro de sentencias SQL.

## 5. Limitaciones

Aunque las bitácoras y los disparadores mejoran la capacidad de investigar incidentes, también presentan limitaciones.

### Registro de lecturas

Con `log_statement = 'mod'`, PostgreSQL registra operaciones de modificación, pero no todas las consultas `SELECT`.

Durante la práctica se comprobó que realizar una consulta de lectura no aumentaba la cantidad de eventos almacenados en la tabla de auditoría.

Por lo tanto, este mecanismo permite identificar modificaciones, pero no demuestra por sí solo quién consultó información sensible.

### Volumen de registros

Registrar más actividades también significa generar una mayor cantidad de información.

Si una base de datos recibe muchas operaciones, las bitácoras pueden crecer rápidamente y consumir espacio de almacenamiento.

Por esta razón, es necesario encontrar un equilibrio entre la información que se necesita conservar y los recursos disponibles.

En las pruebas realizadas, la tabla de auditoría contenía cinco eventos y ocupaba aproximadamente 32 kB. Esta cantidad corresponde únicamente al escenario del laboratorio y no representa el volumen que tendría un sistema real con muchos usuarios.

### Control del administrador

Otra limitación importante es que un administrador con privilegios suficientes puede modificar la configuración del registro o desactivar los mecanismos de auditoría.

Esto representa un riesgo porque, si una persona tiene control tanto sobre los datos como sobre las evidencias, podría dificultar la investigación de sus propias acciones.

Por ello, es recomendable separar responsabilidades, restringir los privilegios administrativos y conservar copias de las bitácoras fuera del servidor principal.

## 6. Riesgos de la bitácora

Las bitácoras son útiles para investigar incidentes, pero también pueden contener información sensible.

### Exposición de secretos

Cuando PostgreSQL registra una sentencia SQL, puede almacenar los valores incluidos directamente en ella.

Por ejemplo, si una instrucción contiene una contraseña o un dato personal, esa información podría quedar expuesta dentro del archivo de registro.

Durante la práctica se revisó la bitácora buscando referencias a contraseñas. Sin embargo, esta búsqueda por sí sola no garantiza que no existan otros datos sensibles, por lo que es importante revisar el contenido antes de compartirlo.

### Pérdida de registros

Si las bitácoras se conservan únicamente en el mismo servidor, pueden perderse cuando ocurre una falla, una eliminación accidental o un incidente de seguridad.

Por ello, conviene contar con respaldos y conservar las evidencias en una ubicación protegida.

### Acceso de terceros

Las bitácoras pueden revelar información sobre usuarios, direcciones IP, consultas y operaciones realizadas.

Por esta razón, su acceso debe limitarse al personal autorizado.

### Exportación e integridad

Como parte de la práctica, se exportó una bitácora histórica de PostgreSQL con 195 líneas.

El archivo se guardó con el nombre `bitacora-lab01.log` y se generó su correspondiente huella SHA-256 en `bitacora-lab01.sha256`.

Posteriormente, se comparó el hash almacenado con el calculado nuevamente sobre el archivo exportado.

El resultado fue:

**INTEGRIDAD VERIFICADA: los hashes coinciden.**

Esto permite comprobar que el contenido del archivo no cambió desde que se calculó la huella.

Sin embargo, el SHA-256 no impide que alguien modifique un archivo. Su utilidad consiste en detectar cambios al comparar las huellas digitales, siempre que el valor original se conserve de forma confiable.

## 7. Cronología y conclusión

### Reconstrucción de los hechos

Se elaboró una cronología utilizando la información recuperada de las bitácoras y de la tabla de auditoría.

Entre los eventos identificados se encontraron la creación de los mecanismos de auditoría, modificaciones de datos, inserciones, eliminaciones, intentos fallidos de conexión y errores de permisos.

La cronología completa se encuentra documentada en `EVIDENCIAS/15-cronologia.md`.

Una diferencia importante fue que el incidente realizado antes de configurar la auditoría no podía reconstruirse completamente con las evidencias disponibles.

En cambio, los cambios posteriores realizados por `app_ventas` sí permitieron identificar al usuario responsable y recuperar los valores anteriores y posteriores del RFC.

### Conclusión

Durante este laboratorio aprendí que las bitácoras son importantes para conocer las actividades que se realizan dentro de una base de datos, pero que su utilidad depende de cómo estén configuradas.

Al principio no se contaba con suficiente información para investigar completamente una modificación de datos. Después de configurar los registros e implementar una auditoría con disparadores, fue posible identificar usuarios, operaciones y valores anteriores y posteriores.

También comprendí que registrar una sentencia SQL no es lo mismo que guardar el cambio real de un dato, ya que una sentencia puede indicar qué operación se ejecutó, pero no necesariamente conserva el valor que tenía la información antes de modificarla.

Otro aspecto importante fue aprender que las evidencias también deben protegerse. No basta con generar bitácoras, sino que es necesario controlar quién puede consultarlas, evitar que expongan información sensible y comprobar su integridad.

En conclusión, considero que una buena auditoría debe combinar la configuración del servidor, el control de privilegios, el registro de cambios y la protección de las evidencias. De esta manera, es posible investigar incidentes con mayor claridad y contar con información más confiable sobre lo ocurrido.

---

## 8. Preguntas de reflexión

### 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

Porque la auditoría necesita estar activa antes de que ocurran los hechos. Si una modificación no se registró cuando sucedió, configurar la auditoría después no permite recuperar automáticamente quién la realizó ni cuáles eran los valores anteriores. Esto fue lo que se observó en el primer incidente del laboratorio.

### 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

Porque PostgreSQL puede administrar directamente la generación y almacenamiento de sus registros, sin depender de que una terminal o herramienta externa permanezca abierta. Esto permite mantener un registro más constante de las actividades del servidor.

### 3. ¿Por qué el prefijo de línea es tan importante como el nivel de `log_statement`?

Porque `log_statement` determina qué sentencias se registran, mientras que `log_line_prefix` agrega información para interpretar esos eventos. Sin datos como el usuario, la fecha, la aplicación o la dirección del cliente, sería más difícil relacionar una operación con su responsable.

### 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?

Registrar la sentencia permite saber qué instrucción SQL se ejecutó, por ejemplo, un `UPDATE`. En cambio, registrar el cambio del dato permite conocer el valor anterior y el nuevo. Para investigar modificaciones de información sensible, ambos registros se complementan.

### 5. ¿Qué evidencia ofrece `pg_stat_activity` que no ofrece la bitácora, y viceversa?

`pg_stat_activity` permite observar las sesiones y actividades que existen en ese momento, mientras que la bitácora conserva información histórica de eventos registrados anteriormente.

Por ejemplo, una conexión que ya terminó puede dejar de aparecer en `pg_stat_activity`, pero su registro puede seguir disponible en los archivos de bitácora.

### 6. Si el administrador puede cambiar `log_statement` a `none` y desactivar el disparador, ¿quién audita al administrador?

Se necesita un mecanismo de supervisión independiente del administrador de la base de datos. Por ejemplo, enviar los registros a un sistema externo protegido, separar las responsabilidades entre diferentes personas y establecer controles sobre los cambios administrativos.

Esto es importante porque una auditoría que depende completamente de la misma persona que administra el sistema puede ser manipulada sin que exista suficiente evidencia para investigarlo.

---

## Consideraciones finales

La parte opcional de pgAudit no se realizó.

Los comandos SQL y las evidencias individuales se encuentran organizados en las carpetas `sql` y `EVIDENCIAS`, respectivamente.