**¿Qué diferencia existe entre `crypt()` y `pgp_sym_encrypt()`?**

`crypt()` se utiliza para generar hashes de contraseñas y comprobarlas, mientras que `pgp_sym_encrypt()` cifra información utilizando una clave secreta.

**¿Cuál de los dos mecanismos permite recuperar el dato original?**

`pgp_sym_encrypt()` permite recuperar el dato original mediante `pgp_sym_decrypt()` y la clave correcta. `crypt()` no permite recuperar directamente la contraseña original.

**¿Qué ocurre si se utiliza una clave incorrecta?**

El descifrado falla y PostgreSQL genera un error, porque la clave no permite recuperar correctamente la información original.

**¿Qué problema de seguridad representa colocar la clave directamente en una consulta?**

La clave podría quedar expuesta en registros, historiales de consultas o capturas de pantalla. Una persona que la obtenga podría descifrar la información protegida.