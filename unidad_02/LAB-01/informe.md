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

## 19.2 Enmascaramiento
### 1. ¿Qué información continúa existiendo en la tabla original?
**Todos los datos completos de los clientes** (nombre, correo, teléfono, RFC, edad, ciudad, código postal y fecha de alta). La vista solo modifica la presentación, pero **no altera la base de datos original**.

### 2. ¿Qué información puede visualizar el usuario soporte?
Solo la vista `v_clientes_soporte`. Esto incluye el **ID, nombre completo** y los campos de **correo, teléfono y RFC parcialmente ocultos**. No tiene acceso a la tabla original.

### 3. ¿Por qué no es suficiente ocultar los datos únicamente en la aplicación?
Porque un usuario con conocimientos podría **saltarse la interfaz de la aplicación** y conectarse directo a la base de datos. La seguridad y las restricciones de acceso deben aplicarse desde el motor de la base de datos.

### 4. ¿Qué ocurriría si soporte tuviera acceso directo a clientes?
Podría **ver toda la información confidencial sin restricciones** (correos, teléfonos y RFC expuestos). Esto rompería las políticas de privacidad y expondría datos sensibles.

## 9. Actividad 3 — Seudonimización (pseudonymization)
# Preguntas y Respuestas sobre Seguridad y Protección de Datos

1. **¿Qué ocurriría si el analista pudiera consultar también `pii.mapa_cliente`?**
   Podría relacionar los tokens con los identificadores reales de los clientes y descubrir su identidad si también tiene acceso a los datos originales.

2. **¿Qué principio de seguridad se está aplicando al separar ambos accesos?**
   El principio de mínimo privilegio, que consiste en dar a cada usuario solamente los permisos estrictamente necesarios para desempeñar su función.

3. **¿Por qué la seudonimización no equivale a anonimización?**
   Porque los datos seudonimizados todavía pueden relacionarse con una persona mediante información adicional (como la tabla de mapeo), mientras que la anonimización es un proceso irreversible que busca impedir totalmente la identificación de la persona.

4. **¿Qué información permite volver a relacionar el token con una persona?**
   La tabla `pii.mapa_cliente`, que relaciona el token con el ID original del cliente, junto con la tabla `public.clientes`.
   
## 13. Actividad 6 — Análisis del riesgo de reidentificación

**1. ¿Qué identificadores directos fueron eliminados?**

Se eliminaron el nombre, correo electrónico, teléfono y RFC, porque permiten identificar directamente a los clientes.

**2. ¿Qué cuasi-identificadores permanecen?**

Permanecen la edad, ciudad, código postal y fecha de alta, que por sí solos pueden no identificar a alguien, pero combinados pueden hacerlo.

**3. ¿Qué combinaciones de atributos podrían reducir el anonimato?**

Combinar la edad, ciudad y código postal puede facilitar la identificación de una persona, especialmente si hay pocos clientes con esas características.

**4. ¿Qué sucede cuando un grupo contiene pocos registros?**

Es más fácil identificar a una persona porque hay menos registros con características similares y se puede distinguir más fácilmente.

**5. ¿Qué atributos deberían generalizarse?**

Se podrían generalizar la edad mediante rangos, el código postal usando solo algunos dígitos y la fecha de alta utilizando únicamente el año.

**6. ¿Qué información debería suprimirse?**

Se deberían eliminar los datos que permitan identificar fácilmente a una persona o que representen un riesgo importante para su privacidad.

**7. ¿Es correcto afirmar que el conjunto de datos es “100 % anónimo”? ¿Por qué?**

No, porque aunque se eliminaron los identificadores directos, todavía se podría identificar a alguien combinando los datos restantes con información externa.


### Reto: Reducir el riesgo de reidentificación

**Código SQL:**

```sql
SELECT
    cliente_token,
    CASE
        WHEN edad < 30 THEN 'Menos de 30'
        WHEN edad < 40 THEN '30 a 39'
        ELSE '40 o más'
    END AS rango_edad,
    ciudad,
    LEFT(codigo_postal, 3) AS codigo_postal,
    EXTRACT(YEAR FROM fecha_alta) AS anio_alta
FROM analitica.clientes;
```

**1. Cambio realizado:**

Se agrupó la edad por rangos, se redujo el código postal a tres dígitos y se mostró solo el año de alta.

**2. Motivo:**

Mostrar datos menos específicos para proteger la identidad de los clientes.

**3. Resultado obtenido:**

Se obtienen datos generales que permiten analizar a los clientes sin mostrar tanta información detallada.

**4. Riesgo que se pretende reducir:**

Se busca evitar que una persona sea identificada al combinar su edad, ciudad, código postal y fecha de alta.

##

**1. ¿Qué registros serían afectados?**

clientes inactivos o con mas de 5 años de antiguedad

**2. ¿Cuál sería la justificación del periodo?**

Establecer un tiempo límite para conservar los datos y evitar almacenar información más tiempo del necesario.

**3. ¿Qué aprobación debería existir antes de eliminar información?**

La autorización del responsable de los datos y la confirmación de que su eliminación está permitida.

**4. ¿Qué respaldo debería existir?**

Una copia de seguridad actualizada que permita recuperar la información si ocurre algún problema.

**5. ¿Qué evidencia debería conservarse?**

Un registro de los datos afectados, la autorización, la fecha y el motivo de la eliminación.

**6. ¿Qué procedimiento permitiría recuperar información eliminada accidentalmente?**

Restaurar la información desde una copia de seguridad y verificar que los datos se hayan recuperado correctamente.

## 19.6 Conclusiones

**¿Qué técnica utilizarías para un área de soporte?**  
Utilizaría el enmascaramiento para ocultar datos personales que no sean necesarios para atender al cliente.

**¿Qué técnica utilizarías para un área de analítica?**  
Utilizaría la seudonimización para analizar los datos sin mostrar directamente la identidad de las personas.

**¿Qué técnica utilizarías para publicar estadísticas?**  
Utilizaría la anonimización y la agrupación de datos para evitar identificar a las personas.

**¿Por qué ninguna de estas técnicas sustituye al control de acceso?**  
Porque todavía es necesario controlar quién puede consultar, modificar o utilizar la información.

---

## 20. Preguntas de reflexión

1. **¿Cuál es la diferencia entre enmascaramiento y seudonimización?**  
   El enmascaramiento oculta parte de un dato, mientras que la seudonimización reemplaza los datos que identifican a una persona por otros valores.

2. **¿Por qué la seudonimización no significa anonimización?**  
   Porque todavía se puede identificar a la persona si se cuenta con información adicional para relacionar los datos.

3. **¿Por qué eliminar nombre y RFC no garantiza que un conjunto de datos sea anónimo?**  
   Porque todavía pueden existir otros datos que permitan identificar a una persona, como su edad, ubicación o información muy específica.

4. **¿Qué función tienen los cuasi-identificadores?**  
   Son datos que, por sí solos, no identifican directamente a una persona, pero combinados pueden ayudar a identificarla.

5. **¿Por qué es importante separar el mapa de seudonimización?**  
   Porque contiene la relación entre los datos originales y los seudónimos, por lo que debe mantenerse protegido y separado.

6. **¿Qué principio de seguridad se aplica al impedir que el analista acceda al mapa?**  
   El principio de mínimo privilegio, porque cada usuario debe tener acceso solamente a la información que necesita para realizar su trabajo.

7. **¿Por qué una vista puede ser preferible a entregar acceso directo a la tabla?**  
   Porque permite mostrar únicamente los datos necesarios y ocultar la información que el usuario no debe consultar.

8. **¿Qué diferencia existe entre proteger un dato para visualización y protegerlo contra acceso no autorizado?**  
   Protegerlo para visualización significa ocultarlo al mostrarlo, mientras que protegerlo contra accesos no autorizados significa impedir que personas sin permiso puedan consultarlo.

9. **¿Por qué la retención forma parte de la protección de datos?**  
   Porque permite establecer cuánto tiempo se debe conservar la información y evitar guardar datos personales durante más tiempo del necesario.

10. **¿Qué riesgo existe si una organización conserva información indefinidamente?**  
    Aumenta el riesgo de filtraciones, robo de información y uso indebido de datos personales.