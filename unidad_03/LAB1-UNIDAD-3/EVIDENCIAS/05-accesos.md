# Actividad 5 — Accesos exitosos y fallidos

## Objetivo

Comprobar que PostgreSQL registra los intentos de conexión exitosos y fallidos, identificando el usuario, la hora y la dirección desde donde se realizó cada intento.

## Resultado

Se realizaron tres pruebas de conexión desde PowerShell utilizando `psql`.

| Hora | Usuario | Resultado |
|---|---|---|
| 22:31:51 | app_ventas | Falló por contraseña incorrecta |
| 22:33:10 | soporte_ana | Falló por contraseña incorrecta |
| 22:35:23 | app_ventas | Conexión exitosa |

Posteriormente, se consultó la vista `dba.bitacora` y se encontraron los tres eventos registrados. Todos se realizaron desde la dirección `127.0.0.1`.

## Análisis

La bitácora permitió identificar qué usuarios intentaron conectarse y si lograron acceder. También mostró la hora y la dirección de origen. Esto ayuda a detectar intentos de acceso no autorizados y revisar posibles problemas de seguridad.

## Conclusión

Con esta actividad comprobé que PostgreSQL puede registrar conexiones exitosas y fallidas. Esta información es útil para supervisar los accesos y tener evidencia de lo que ocurre en la base de datos.