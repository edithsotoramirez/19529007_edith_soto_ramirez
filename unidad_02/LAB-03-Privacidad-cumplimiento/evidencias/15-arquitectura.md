## 21. Actividad 15 — Propuesta de arquitectura de datos protegidos

### Objetivo

Diseñar una arquitectura conceptual que separe los datos según su finalidad y establezca controles para proteger la información, limitar los accesos y administrar su conservación y eliminación.

### Propuesta de arquitectura

```text
                    BASE DE DATOS
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ▼               ▼                ▼
      OPERACIÓN       ANALÍTICA        AUDITORÍA
          │               │                │
          ▼               ▼                ▼
    Datos necesarios  Datos agregados   Registros de
    para atender      o anonimizados    accesos y cambios
    a los clientes
          │               │                │
          ▼               ▼                ▼
    Acceso limitado   Sin datos que     Acceso restringido
    por roles         identifiquen      y trazabilidad
                      a los clientes
          │               │                │
          └───────────────┼────────────────┘
                          │
                          ▼
                 CONTROLES DE PRIVACIDAD
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ▼               ▼                ▼
       Retención      Eliminación      Solicitudes
       definida       segura           de los clientes
```

### Controles propuestos

| **Control** | **Propuesta de aplicación** |
|---|---|
| Acceso | Crear roles y permisos en PostgreSQL para que cada área consulte únicamente la información necesaria para sus funciones. |
| Minimización | Recopilar y utilizar solamente los datos indispensables para cada actividad. |
| Protección de información sensible | Restringir el acceso a datos como el RFC y protegerlos mediante cifrado cuando corresponda. |
| Retención | Establecer periodos de conservación según la finalidad y las obligaciones legales aplicables. |
| Trazabilidad | Registrar los accesos y cambios importantes para identificar actividades no autorizadas. |
| Eliminación | Eliminar de forma segura los datos cuando termine su periodo de conservación y no exista una obligación de mantenerlos. |
| Atención de solicitudes | Establecer un procedimiento para recibir, verificar y atender las solicitudes de acceso, rectificación, cancelación y oposición (ARCO), conforme a la normativa aplicable. |

### Resultado

Se propuso una arquitectura que separa los datos operativos, analíticos y de auditoría, incorporando controles para administrar el acceso, la protección y el ciclo de vida de la información.

### Análisis

La separación permite que cada área trabaje con los datos que necesita sin acceder a toda la información de los clientes. Además, el uso de datos agregados o anonimizados en analítica reduce la exposición de información personal.

### Conclusión

Una arquitectura de datos protegidos permite aplicar los principios de privacidad mediante decisiones técnicas y administrativas. De esta manera, se mejora el control de acceso, se reduce el riesgo de exposición y se facilita el cumplimiento de las políticas de conservación y eliminación.


## 22. Verificación final

**Privacidad:** La seguridad protege la información y la privacidad se enfoca en cómo se utilizan los datos personales.

**Finalidad:** Porque los datos deben usarse solo para fines justificados y no para cualquier actividad.

**Minimización:** Porque guardar datos innecesarios aumenta los riesgos de filtración y mal uso.

**ARCO:** Son los derechos que permiten a las personas acceder a sus datos personales, corregirlos si son incorrectos, solicitar que se cancelen y oponerse a su uso en determinadas situaciones.

**Retención:** Porque conservar datos indefinidamente aumenta el riesgo de exposición y uso indebido.

**Gobierno:** Las áreas responsables del negocio, junto con privacidad y seguridad, deben definir qué datos se usan y para qué.

**DBA:** El DBA administra la base de datos, los permisos y la seguridad técnica, pero las finalidades y los plazos de conservación deben decidirse con las áreas responsables y legales.