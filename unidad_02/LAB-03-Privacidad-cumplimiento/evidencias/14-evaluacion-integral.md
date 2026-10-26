##  Actividad 14 — Escenario integral

### Objetivo

Identificar los problemas de privacidad y seguridad en el manejo de los datos de los clientes, relacionándolos con los principios afectados, los riesgos que generan y los controles necesarios para corregirlos.

### Identificación de problemas y riesgos

| **Problema** | **Principio afectado** | **Riesgo** | **Control propuesto** |
|---|---|---|---|
| 1. Todo el personal de analítica puede consultar la tabla completa de clientes. | Control de acceso y confidencialidad. | Acceso a información personal que no necesitan para su trabajo. | Crear roles y permisos limitados según las funciones de cada empleado. |
| 2. El área de analítica utiliza datos personales para generar estadísticas mensuales. | Minimización de datos. | Exposición innecesaria de información que no se requiere para los análisis. | Utilizar datos agregados o anonimizados para generar estadísticas. |
| 3. Los datos se conservan desde hace 12 años sin una justificación documentada. | Limitación del plazo de conservación. | Acumulación de información innecesaria y mayor impacto ante una filtración. | Revisar los datos y establecer periodos de retención justificados. |
| 4. No existe una política de retención documentada. | Responsabilidad y limitación de la conservación. | Los datos pueden conservarse indefinidamente sin supervisión. | Crear una política que establezca plazos y procedimientos de eliminación. |
| 5. Los desarrolladores reciben copias completas de la base de datos. | Minimización de datos y confidencialidad. | Acceso innecesario a información personal por parte del equipo de desarrollo. | Entregar únicamente los datos necesarios para las pruebas. |
| 6. Las copias de desarrollo contienen información real de los clientes. | Privacidad por diseño y seguridad de los datos. | Filtración de información personal durante las pruebas o por errores de los desarrolladores. | Utilizar datos ficticios o anonimizados en los ambientes de desarrollo. |
| 7. Marketing utiliza los correos electrónicos para campañas promocionales sin una finalidad claramente documentada. | Limitación de la finalidad y transparencia. | Uso de datos personales para propósitos que podrían no haber sido informados o autorizados adecuadamente. | Documentar la finalidad y verificar la base legal y, cuando corresponda, el consentimiento para las campañas. |
| 8. No existe documentación sobre la finalidad de cada dato. | Limitación de la finalidad y responsabilidad. | Los datos pueden utilizarse para actividades distintas de aquellas para las que fueron recopilados. | Crear un inventario de datos que indique su finalidad, responsable y usuarios autorizados. |
| 9. Todos los datos personales están concentrados en una tabla accesible para distintas áreas. | Confidencialidad y minimización de datos. | Una consulta o filtración puede exponer numerosos datos de los clientes al mismo tiempo. | Crear vistas con información limitada para cada área y restringir el acceso a los campos sensibles. |
| 10. El RFC está disponible para el área de analítica aunque no se ha justificado su necesidad. | Minimización de datos y confidencialidad. | Exposición de información fiscal sin una necesidad funcional. | Restringir el RFC a las áreas que lo necesiten y excluirlo de los análisis estadísticos. |
| 11. No se especifican controles para registrar y revisar las consultas a la base de datos. | Responsabilidad y seguridad de la información. | Dificultad para detectar accesos indebidos e identificar a los responsables. | Implementar registros de auditoría y revisar periódicamente las actividades de los usuarios. |
| 12. No se describe un procedimiento para eliminar los datos que ya no son necesarios. | Limitación del plazo de conservación y minimización. | Permanencia de información personal sin una finalidad vigente. | Establecer procedimientos de eliminación segura o anonimización cuando corresponda, respetando las obligaciones legales de conservación. |

### Resultado

Se identificaron 12 problemas relacionados con el acceso a la información, la conservación de los datos, el uso de copias reales y la falta de documentación sobre sus finalidades. También se propusieron controles para reducir los riesgos detectados.

### Análisis

La empresa expone innecesariamente los datos de sus 50,000 clientes porque permite accesos amplios y conserva información durante años sin una política definida. Además, el uso de datos reales en desarrollo y la falta de claridad sobre las campañas de marketing aumentan los riesgos de privacidad.

### Conclusión

La empresa debe limitar el acceso a los datos, utilizar información anonimizada para las estadísticas y las pruebas, y establecer políticas claras de conservación y uso. Estas medidas ayudan a proteger la privacidad de los clientes y a mejorar la seguridad y administración de la base de datos.