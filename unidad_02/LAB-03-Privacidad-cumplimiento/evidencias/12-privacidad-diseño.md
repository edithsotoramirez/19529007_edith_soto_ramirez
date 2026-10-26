## 18. Actividad 12 — Privacidad por diseño

### Objetivo

Analizar el diseño de una tabla de clientes para identificar riesgos de privacidad y determinar qué datos son realmente necesarios para el funcionamiento de la aplicación.

### 1. ¿Qué problemas identificas?

Se están solicitando demasiados datos personales sin conocer si son necesarios para el funcionamiento de la aplicación. Esto aumenta el riesgo de filtraciones, accesos no autorizados y uso indebido de la información.

### 2. ¿Qué principio de privacidad se está ignorando?

Se está ignorando el principio de minimización de datos, que consiste en recopilar únicamente la información necesaria para cumplir con una finalidad específica.

### 3. ¿Qué preguntas realizarías antes de aprobar el diseño?

- ¿Para qué se necesita cada dato?
- ¿Qué funciones de la aplicación requieren esa información?
- ¿Quién tendrá acceso a los datos?
- ¿Durante cuánto tiempo se conservarán?
- ¿Qué medidas se utilizarán para protegerlos?

### 4. ¿Qué datos eliminarías?

Eliminaría inicialmente la ocupación, el salario, el estado civil y la fecha de nacimiento, porque no se ha demostrado que sean necesarios. También revisaría si la edad es indispensable y evitaría almacenar simultáneamente datos que cumplan la misma función sin una justificación.

### 5. ¿Qué datos requerirían una justificación adicional?

El RFC, la dirección, el teléfono, la edad, la fecha de nacimiento, la ocupación, el salario y el estado civil requieren una justificación adicional, ya que pueden revelar información personal que no siempre es necesaria para registrar a un cliente.

### 6. ¿Cómo aplicarías privacidad por defecto?

Config uraría la aplicación para solicitar únicamente los datos indispensables, limitaría el acceso según las funciones de cada usuario y establecería periodos de conservación. Además, protegería la información mediante permisos, cifrado cuando corresponda y eliminación segura de los datos que ya no sean necesarios.

## 19. Actividad 13 — Diferenciar controles técnicos y administrativos

| **Medida** | **Técnico** | **Administrativo** |
|---|:---:|:---:|
| Crear roles de PostgreSQL | X | |
| Política de retención | | X |
| Cifrado de datos | X | |
| Procedimiento para solicitudes ARCO | | X |
| Vista con información limitada | X | |
| Clasificación de información | | X |
| Registro de auditoría | X | |
| Política de control de acceso | | X |

### Justificación

Ciertas medidas pueden involucrar ambos tipos de control. La política de control de acceso es administrativa porque establece las reglas sobre quién puede consultar la información, pero su aplicación requiere controles técnicos, como los roles y permisos de PostgreSQL.

De igual manera, una política de retención es administrativa porque define cuánto tiempo se conservan los datos, pero puede apoyarse en controles técnicos para automatizar su eliminación.

### Resultado

Se clasificaron las medidas de seguridad en controles técnicos y administrativos, identificando su función en la protección de los datos.

### Análisis

Los controles técnicos utilizan herramientas para proteger la información, mientras que los administrativos establecen reglas y procedimientos para su manejo. Ambos se complementan para mejorar la seguridad.

### Conclusión

Combinar controles técnicos y administrativos permite proteger los datos, regular su uso y reducir los riesgos de accesos no autorizados.