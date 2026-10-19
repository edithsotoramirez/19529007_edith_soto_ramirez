# LAB-02 — Cifrado y protección de credenciales

## 1. Introducción

En esta práctica, el objetivo principal fue conocer diferentes métodos para proteger la información almacenada en una base de datos PostgreSQL. Se analizaron los riesgos de guardar datos sensibles sin protección y las medidas que ayudan a evitar que personas no autorizadas puedan acceder a ellos.

También se abordó la seguridad de las comunicaciones mediante TLS y la importancia de proteger las claves criptográficas.

## 2. Protección de credenciales

Guardar contraseñas en texto claro es un riesgo, ya que cualquier persona con acceso a la tabla puede verlas.

Para evitarlo, PostgreSQL permite utilizar `pgcrypto` y generar hashes mediante `crypt()` y `gen_salt()`. Los resultados pueden variar para una misma contraseña debido a la generación de una nueva sal.

Además, una contraseña puede verificarse sin recuperar su valor original. A diferencia del hash, el cifrado permite recuperar los datos mediante una clave.

## 3. Protección de datos sensibles

El RFC sirvió como ejemplo de información que necesita protección. Mediante la función `pgp_sym_encrypt()` es posible guardar el dato cifrado en una columna de tipo `BYTEA`.

Por otro lado, `pgp_sym_decrypt()` permite recuperar el RFC cuando se dispone de la clave correcta. De esta manera, el cifrado protege información que posteriormente necesita consultarse en su forma original.

Es importante mantener la clave segura, ya que cualquier persona que la obtenga podría descifrar los datos.

## 4. TLS

TLS protege la información durante la comunicación entre el cliente y el servidor de PostgreSQL, reduciendo el riesgo de que terceros puedan leer los datos transmitidos.

Se revisaron parámetros como `ssl`, `ssl_min_protocol_version`, `port` y `listen_addresses`. También se consultó `pg_stat_ssl` para comprobar si la conexión utilizaba TLS y conocer su versión y algoritmo de cifrado.

Los resultados de la conexión fueron los siguientes:

- **¿La conexión utiliza TLS?:** [Anotar true o false].
- **Versión de TLS:** [Anotar el valor obtenido].
- **Algoritmo de cifrado:** [Anotar el valor obtenido].

Esto permitió distinguir entre tener SSL configurado y utilizar realmente una conexión protegida.

## 5. Gestión de claves

Las claves reales no deben incluirse directamente en las consultas SQL ni en los archivos del proyecto. Si estos archivos se publican en GitLab, existe el riesgo de que otras personas obtengan las claves y las utilicen para descifrar información.

Una alternativa más segura es almacenarlas en un gestor de secretos y limitar el acceso a las personas o aplicaciones autorizadas.

Cuando existe la sospecha de que una clave fue expuesta, es necesario cambiarla o revocarla. También se deben evitar los secretos reales en el repositorio, incluso cuando es privado.

## 6. Resultados

Las actividades permitieron identificar las diferencias entre almacenar información en texto claro, generar un hash y cifrar datos.

También quedó clara la forma de verificar contraseñas sin guardar sus valores originales y de cifrar y recuperar un RFC mediante `pgcrypto`.

Por otra parte, la configuración de TLS permitió conocer cómo se protege la comunicación en PostgreSQL. En conjunto, estos procedimientos muestran que la seguridad de una base de datos requiere varias medidas complementarias.

## 7. Problemas encontrados

Durante la práctica fue necesario interpretar las consultas y los resultados de PostgreSQL para comprender las funciones y verificar la protección de los datos.

También se distinguieron los resultados que dependen de la configuración del entorno. Por ejemplo, el uso de TLS debe confirmarse mediante los datos de la conexión actual.

[Si hubo errores, puedo mencionar problemas con `pgcrypto`, consultas incorrectas o dificultades de conexión. Si no hubo errores, puedo indicar que no se presentaron problemas técnicos importantes.]

## 8. Conclusiones

La práctica permitió comprender que la seguridad de una base de datos no depende únicamente de crear usuarios y asignar permisos. También es necesario proteger las contraseñas, cifrar los datos sensibles, asegurar las comunicaciones y gestionar correctamente las claves criptográficas.

Evitar las contraseñas en texto claro y no publicar claves reales en los archivos del proyecto son medidas fundamentales para reducir los riesgos.

En un entorno real, también sería recomendable utilizar conexiones TLS con validación del certificado, respaldos cifrados y un sistema seguro para administrar las claves.

# 23. Preguntas de reflexión

## 1. ¿Por qué una contraseña no debe almacenarse como texto claro?

Porque cualquier persona con acceso a la tabla podría verla y utilizarla para entrar a la cuenta del usuario. Por eso es preferible almacenar un hash generado con un algoritmo diseñado para proteger contraseñas.

## 2. ¿Por qué un hash no es equivalente a un cifrado?

Porque el hash no está diseñado para recuperar el dato original. En cambio, el cifrado permite recuperar la información utilizando la clave correcta.

## 3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?

Porque el cifrado protege la información, pero no determina quién puede consultar o modificar la base de datos. Para ello se necesitan permisos que limiten el acceso a los usuarios autorizados.

## 4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?

Porque TLS protege la comunicación entre el cliente y el servidor, pero no determina qué acciones puede realizar cada usuario. Para eso se necesitan usuarios, roles y permisos.

## 5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?

Podría perder la posibilidad de recuperar los datos cifrados. Por eso es importante mantener respaldos seguros de las claves y controlar quién puede acceder a ellas.

## 6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?

Otras personas podrían obtenerla y utilizarla para descifrar la información protegida. En ese caso, la clave debe considerarse comprometida, cambiarse o revocarse, y se deben revisar posibles accesos no autorizados.

## 7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?

Porque las personas con acceso al repositorio podrían ver los archivos y una configuración incorrecta podría exponerlos. Las claves deben almacenarse en un sistema diseñado específicamente para administrar secretos.

## 8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?

La protección de información almacenada evita que los datos guardados puedan leerse sin autorización, por ejemplo, mediante cifrado. En cambio, la protección durante la transmisión evita que terceros puedan leer o modificar los datos que viajan entre el cliente y el servidor, por ejemplo, mediante TLS.

## 9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?

Porque, aunque se utilice un algoritmo seguro, una persona que obtenga la clave podría acceder a la información cifrada. Por eso las claves deben guardarse de forma segura y tener acceso restringido.

## 10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?

El cifrado de los respaldos, su almacenamiento en una ubicación segura y la restricción del acceso al personal autorizado ayudarían a protegerlos. También sería importante realizar pruebas periódicas de restauración para comprobar que funcionan correctamente.