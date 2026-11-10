# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL

**Universidad Autónoma de Sinaloa**  
**Facultad de Informática Culiacán**  
**Estudiante:** Edith Marcela Soto Ramírez  
**Unidad III — Administración de Bases de Datos**

## 1. Descripción

En este laboratorio se configuraron las bitácoras de PostgreSQL para registrar conexiones, modificaciones de datos, cambios de permisos y errores.

También se implementó una auditoría mediante funciones y triggers para identificar quién modificó los datos y conservar sus valores anteriores y posteriores.

## 2. Entorno y despliegue

- **Sistema operativo:** Windows
- **PostgreSQL:** versión 17.2
- **Instalación:** directamente en Windows mediante el instalador de PostgreSQL.
- **Herramientas:** SQL Shell (psql) y PowerShell.
- **Base de datos:** `comercial`.

El servidor se utilizó de manera local, sin Docker, siguiendo la alternativa de instalación directa del laboratorio.

## 3. Estructura del proyecto

```text
LAB1-UNIDAD-3/
├── README.md
├── informe.md
├── sql/
│   ├── 01-colector-y-vista.sql
│   ├── 02-configuracion-bitacora.sql
│   ├── 03-privilegios-estructura.sql
│   ├── 04-esquema-auditoria.sql
│   ├── 05-funcion-disparador.sql
│   └── 06-campos-modificados.sql
└── EVIDENCIAS/
    ├── 01-configuracion-inicial.md
    ├── ... 
    ├── 15-cronologia.md
    ├── bitacora-lab01.log
    └── bitacora-lab01.sha256
```

La carpeta `sql` contiene los scripts utilizados, mientras que `EVIDENCIAS` incluye los comandos, resultados y análisis de las actividades. El archivo `informe.md` presenta los resultados generales y las preguntas de reflexión.

## 4. Resultados

Se configuraron las bitácoras para registrar actividades del servidor y se creó una tabla de auditoría para operaciones `INSERT`, `UPDATE` y `DELETE`.

Se identificaron accesos fallidos, errores de permisos y modificaciones realizadas por distintos usuarios.

También se exportó una bitácora de 195 líneas y se verificó su integridad mediante SHA-256, obteniendo como resultado que los hashes coincidían.

## 5. Consideraciones

La práctica opcional de pgAudit no se realizó. Algunas pruebas de manipulación y volumen quedaron pendientes.

Antes de publicar el repositorio en GitLab, se debe revisar que la bitácora no contenga contraseñas ni otros datos sensibles.

## 6. Conclusión

Esta práctica permitió comprender la importancia de configurar las bitácoras y utilizar mecanismos de auditoría para investigar modificaciones en una base de datos y proteger las evidencias obtenidas.