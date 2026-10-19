# Actividad 7 — Comparar protección en reposo y protección en tránsito

| Situación | Mecanismo apropiado | ¿Qué protege? |
|---|---|---|
| Contraseña de usuario | Hash con un algoritmo diseñado para contraseñas | Evita almacenar la contraseña original y dificulta recuperarla si se filtra la base de datos. |
| RFC almacenado en una tabla | Cifrado en reposo | Protege el RFC para que no pueda leerse directamente sin la clave de descifrado. |
| Consulta enviada desde un cliente al servidor | TLS | Protege la información mientras viaja entre el cliente y PostgreSQL. |
| Respaldo de una base de datos | Cifrado del respaldo | Evita que personas sin autorización puedan leer la información del archivo de respaldo. |
| Clave criptográfica | Gestor de secretos o sistema seguro de gestión de claves | Evita que las claves queden expuestas y permite controlar su acceso y uso. |