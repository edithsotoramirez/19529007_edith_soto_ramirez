| Campo | ¿Identifica directamente? | ¿Puede contribuir a identificar? | ¿Requiere protección? | Justificación |
| --- | --- | --- | --- | --- |
| **id** | No | Sí | Sí | Es la clave primaria interna; combinado con el mapa de correspondencia o en otros contextos puede vincular directamente con el titular. |
| **nombre** | Sí | Sí | Sí | Identificador directo inequívoco de una persona física (dato personal). |
| **correo** | Sí | Sí | Sí | Identificador directo único de una persona que permite la localización e identificación directa. |
| **telefono** | Sí | Sí | Sí | Identificador directo único asignado a un titular. |
| **rfc** | Sí | Sí | Sí | Identificador oficial único en México que incluye fecha de nacimiento e iniciales de la persona. |
| **edad** | No | Sí | Sí | Cuasi-identificador que, al combinarse con otros atributos (como ciudad o código postal), ayuda a reidentificar a una persona. |
| **ciudad** | No | Sí | Sí | Cuasi-identificador geográfico que reduce significativamente el universo de búsqueda de una persona. |
| **codigo_postal** | No | Sí | Sí | Cuasi-identificador altamente específico que delimita la ubicación geográfica a un sector muy reducido. |
| **fecha_alta** | No | Sí | Sí | Dato operativo/temporal que puede actuar como cuasi-identificador si se cruza con registros transaccionales o de registro externos.

### 1. ¿Qué campos identifican directamente a una persona?

* **`nombre`**: Identificador directo inequívoco de una persona física.
* **`correo`**: Identificador digital único que permite contactar e identificar directamente a un titular.
* **`telefono`**: Número de línea asignado individualmente a un usuario.
* **`rfc`**: Identificador oficial e irrepetible (en México) que incluye las iniciales y la fecha de nacimiento del titular.

---

### 2. ¿Qué campos no identifican por sí solos pero podrían contribuir a hacerlo? (Cuasi-identificadores)

* **`id`**: Clave primaria interna que, al cruzarse con mapas de referencia o sistemas internos, vincula de forma directa el registro con el individuo.
* **`edad`**: Atributo demográfico que acota el universo de búsqueda.
* **`ciudad`**: Delimitación geográfica general que reduce el grupo de posibles titulares.
* **`codigo_postal`**: Ubicación geográfica específica que delimita el entorno a un sector o colonia reducida.
* **`fecha_alta`**: Atributo temporal/operativo que puede coincidir con eventos específicos (como contratos o transacciones) y cruzarse con registros externos.

---

### 3. ¿Qué combinación de campos podría incrementar el riesgo de reidentificación?

* **`codigo_postal` + `edad` + `fecha_alta`**: Combinar un área geográfica reducida, una edad exacta y el momento preciso de registro genera un perfil sumamente específico, facilitando ataques de vinculación (*linkage attacks*).
* **`ciudad` + `edad` + `fecha_alta`**: Aunque la ciudad abarca un área mayor, la precisión del marcador temporal (`fecha_alta`) y la edad incrementan drásticamente la probabilidad de aislar a un solo sujeto.

---

### 4. ¿Todos los datos que deben protegerse son necesariamente datos personales sensibles desde el punto de vista jurídico?

**No.** Desde la perspectiva legal (como la LFPDPPP en México o el RGPD en Europa), existe una distinción clave:

* **Datos Personales Ordinarios:** Son aquellos que identifican o hacen identificable a una persona (como el nombre, correo, teléfono o RFC). **Requieren protección legal y técnica obligatoria**, pero no son clasificados como sensibles.
* **Datos Personales Sensibles:** Son aquellos que afectan la esfera más íntima del titular o cuyo uso indebido pueda dar origen a discriminación o un riesgo grave (por ejemplo: origen étnico/racial, estado de salud, información genética, creencias religiosas, afiliación sindical, opiniones políticas o preferencia sexual).

> **Conclusión:** Todos los campos de la matriz **requieren protección por ser datos personales**, pero **ninguno de ellos se clasifica como "dato personal sensible"** en el marco jurídico habitual.