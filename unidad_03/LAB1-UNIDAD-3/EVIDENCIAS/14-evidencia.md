# Evidencia 14 — Límites de la auditoría

## 1. Objetivo

Identificar las limitaciones de una auditoría basada en disparadores de PostgreSQL, comprobando qué operaciones quedan registradas y analizando los problemas que pueden surgir cuando el historial de auditoría crece constantemente.

## 2. Procedimiento

Para realizar esta actividad se utilizó la base de datos `comercial`, donde ya se encontraba configurado el disparador `trg_auditoria_clientes` para registrar operaciones de inserción, modificación y eliminación sobre la tabla `clientes`.

Se realizaron dos pruebas principales.

La primera consistió en ejecutar una consulta `SELECT` sobre los clientes y comparar la cantidad de eventos de auditoría antes y después de realizarla.

La segunda consistió en consultar el tamaño total de la tabla `auditoria.cambios_clientes` para conocer cuánto espacio estaba utilizando el historial almacenado.

Todas las consultas se realizaron desde SQL Shell (psql), utilizando el usuario administrador `postgres`.

## 3. Resultados

### 3.1. Comprobación de consultas SELECT

Primero se consultó la cantidad de eventos almacenados:

```sql id="4wqu3l"
SELECT COUNT(*) AS eventos_antes
FROM auditoria.cambios_clientes;
```

**Resultado:** 5 eventos.

Después se ejecutó una consulta de lectura:

```sql id="yg4n6e"
SELECT id, nombre, ciudad
FROM public.clientes
LIMIT 5;
```

La consulta mostró cinco clientes:

| ID | Nombre | Ciudad |
|---|---|---|
| 1 | Ana López | Culiacán |
| 2 | Carlos Pérez | Mazatlán |
| 4 | Luis Ramírez | Los Mochis |
| 5 | Laura Torres | Guasave |
| 3 | María García | Mazatlán |

Finalmente, se volvió a consultar la cantidad de eventos:

```sql id="3kv1e8"
SELECT COUNT(*) AS eventos_despues
FROM auditoria.cambios_clientes;
```

**Resultado:** 5 eventos.

Esto significa que la consulta `SELECT` no generó nuevos registros de auditoría.

El resultado se debe a que el disparador está configurado para operaciones `INSERT`, `UPDATE` y `DELETE`, pero no para registrar lecturas.

### 3.2. Tamaño de la tabla de auditoría

Se ejecutó:

```sql id="lql0vv"
SELECT
    pg_size_pretty(
        pg_total_relation_size('auditoria.cambios_clientes')
    ) AS tamano_total,
    COUNT(*) AS eventos_registrados
FROM auditoria.cambios_clientes;
```

**Resultados obtenidos:**

| Tamaño total | Eventos registrados |
|---|---|
| 32 kB | 5 |

La tabla ocupa actualmente 32 kB, incluyendo los datos, índices y almacenamiento asociado.

Aunque el tamaño es pequeño, esto se debe a que solamente se han generado cinco eventos.

En una base de datos utilizada diariamente, la cantidad de registros podría aumentar considerablemente, especialmente si se realizan muchas modificaciones.

## 4. Preguntas de análisis

### 1. ¿Por qué el disparador no registra las consultas SELECT?

Porque el disparador utilizado está configurado para ejecutarse después de operaciones `INSERT`, `UPDATE` y `DELETE`.

Estas operaciones modifican los datos de las filas, mientras que `SELECT` solamente consulta información.

Además, PostgreSQL no dispone de disparadores DML tradicionales para registrar cada lectura `SELECT` de una tabla.

Por eso, para auditar consultas de lectura sería necesario utilizar otros mecanismos, como las bitácoras del servidor o herramientas especializadas de auditoría.

### 2. ¿Qué riesgos genera el crecimiento de la tabla de auditoría?

El crecimiento continuo de la auditoría puede aumentar el consumo de almacenamiento y afectar el rendimiento de algunas operaciones.

También puede hacer que las consultas sobre el historial sean más lentas y que los respaldos ocupen más espacio.

Otro riesgo es conservar información personal durante más tiempo del necesario, porque los registros de auditoría pueden almacenar datos anteriores y posteriores de los clientes.

Por eso es importante supervisar el crecimiento de la tabla y establecer una política de conservación.

### 3. ¿Qué medidas se pueden aplicar para controlar el volumen de información?

Se pueden establecer periodos de retención de acuerdo con las necesidades de la organización y sus obligaciones legales.

También es posible utilizar particionamiento por fechas, archivar registros antiguos en un almacenamiento protegido y eliminar información cuando termine su periodo de conservación autorizado.

Además, conviene definir qué eventos realmente necesitan registrarse, supervisar el tamaño de las tablas y proteger los respaldos.

Estas medidas permiten mantener una auditoría útil sin conservar información innecesaria de manera indefinida.

## 5. Análisis

En esta actividad comprobé que una auditoría basada en disparadores tiene limitaciones importantes.

La primera prueba demostró que las consultas `SELECT` no generan registros en nuestra tabla de auditoría, ya que la cantidad de eventos permaneció en cinco antes y después de consultar los clientes.

Esto significa que el mecanismo permite identificar cambios en los datos, pero no conocer todas las ocasiones en que fueron consultados.

También comprobé que la tabla de auditoría ocupa actualmente 32 kB y contiene cinco eventos.

Aunque este tamaño no representa un problema, en una organización con miles de operaciones diarias el historial podría crecer rápidamente.

Por eso considero importante combinar los disparadores con otros mecanismos de registro y establecer medidas para administrar el almacenamiento y la conservación de la información.

## 6. Conclusión

En esta actividad aprendí que los disparadores permiten registrar modificaciones de datos, pero no son suficientes para auditar todas las operaciones realizadas en una base de datos.

Comprobé que las consultas de lectura no generan eventos en nuestra auditoría y que el historial ocupa espacio adicional de almacenamiento.

También comprendí que, conforme aumenta la cantidad de operaciones, es necesario administrar el crecimiento de los registros y establecer periodos de conservación adecuados.

Finalmente, considero que una auditoría completa debe combinar distintos mecanismos de supervisión, controles de acceso y políticas de retención para mantener información útil y protegida.