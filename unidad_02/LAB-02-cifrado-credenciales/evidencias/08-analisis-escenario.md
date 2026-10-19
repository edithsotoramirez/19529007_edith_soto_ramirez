# Actividad 8 — Analizar un escenario de seguridad

## Pregunta 1. ¿Cuáles son los principales riesgos?

Los principales riesgos son la exposición de contraseñas y RFC, la posibilidad de que terceros intercepten información durante la comunicación, la filtración de claves criptográficas y el acceso no autorizado a los respaldos. Estos problemas pueden provocar robo de información, suplantación de identidad y pérdidas económicas.

## Pregunta 2. ¿Qué mecanismo utilizarías para cada elemento?

- **Nombre:** control de acceso y protección de la base de datos según la sensibilidad de la información.
- **Correo electrónico:** control de acceso y cifrado cuando el riesgo lo requiera.
- **Contraseña:** hash con un algoritmo diseñado específicamente para proteger contraseñas.
- **RFC:** cifrado de datos almacenados y control de acceso.
- **Información financiera:** cifrado en reposo, conexiones protegidas con TLS y permisos adecuados.
- **Claves criptográficas:** almacenamiento en un gestor de secretos o sistema de gestión de claves, con acceso restringido y rotación.

También utilizaría TLS con validación del certificado del servidor, cifrado para los respaldos y controles para evitar que las claves aparezcan en archivos SQL o repositorios.

## Pregunta 3. ¿Cuál de los problemas consideras más crítico y por qué?

Considero que el almacenamiento de contraseñas en texto claro es uno de los problemas más críticos, porque una filtración permitiría conocer inmediatamente las contraseñas de los usuarios. Además, algunas personas pueden reutilizar la misma contraseña en otros servicios, lo que aumentaría el daño.

## Pregunta 4. ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?

No. Los usuarios y permisos ayudan a limitar quién puede acceder a la información, pero no sustituyen otros mecanismos de seguridad. También se necesitan hashes seguros para contraseñas, cifrado para datos sensibles y respaldos, TLS para las comunicaciones y una gestión adecuada de las claves criptográficas.