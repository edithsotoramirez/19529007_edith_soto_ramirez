# Actividad 5 — Verificar el estado de TLS en PostgreSQL


**¿La conexión actual utiliza TLS?**

Depende del resultado de la consulta en `pg_stat_ssl`. Si el campo `ssl` muestra `true`, la conexión utiliza TLS. Si muestra `false`, la conexión no está protegida con TLS.

**¿Qué versión de TLS se está utilizando?**

La versión se muestra en el campo `version` de la consulta a `pg_stat_ssl`. Debo registrar la versión que aparezca en mi resultado.

**¿Qué algoritmo de cifrado aparece?**

El algoritmo se muestra en el campo `cipher`. Debo escribir el nombre que aparezca en mi consulta.

**¿Qué diferencia existe entre una conexión protegida con TLS y una conexión sin TLS?**

Una conexión protegida con TLS cifra la comunicación entre el cliente y el servidor, ayudando a evitar que terceros lean o modifiquen los datos durante la transmisión. Sin TLS, la información puede quedar expuesta si alguien logra observar el tráfico de red.