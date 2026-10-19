# Actividad 10 — Política mínima de protección de claves

1. **Generación:** las claves deben generarse con herramientas criptográficas seguras y utilizando métodos adecuados para cada propósito.

2. **Almacenamiento:** las claves deben guardarse en un gestor de secretos o sistema seguro de gestión de claves, nunca directamente en el código fuente.

3. **Acceso:** solamente las personas y aplicaciones autorizadas deben tener acceso a las claves que necesitan para realizar sus funciones.

4. **Rotación:** las claves deben cambiarse periódicamente según la política de la organización y cuando exista sospecha de exposición.

5. **Respaldo:** las claves necesarias para recuperar información deben contar con respaldos seguros, cifrados y con acceso restringido.

6. **Revocación:** las claves comprometidas o que ya no sean necesarias deben revocarse para impedir que continúen utilizándose.

7. **Exposición accidental:** si una clave se publica por error, debe considerarse comprometida, revocarse o cambiarse y revisarse si fue utilizada sin autorización.

8. **Eliminación:** las claves que ya no se necesiten deben eliminarse de forma segura, considerando también las copias y los respaldos donde puedan permanecer.

9. **Separación:** las claves deben mantenerse separadas del código, los scripts y los datos cifrados para reducir el riesgo de que una sola filtración permita acceder a toda la información.