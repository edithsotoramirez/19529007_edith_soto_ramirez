
## 1. Inventario de datos



| Campo | ¿Dato personal? | Finalidad | ¿Necesario? | Acceso | Retención |
|---|---|---|---|---|---|
| id | no| Identificar registros | Sí | Interno | Mientras exista |
| nombre | Sí | Identificar usuario | Sí | Restringido | Mientras sea necesario |
| correo | Sí | Contactar | Sí, según el servicio | Restringido | Mientras sea necesario |
| telefono | Sí | Contactar | Depende | Restringido | Mientras sea necesario |
| rfc | Sí | Trámites fiscales | Si se requiere | Muy restringido | Según la ley |
| edad | Sí | Verificar edad o estadísticas | Depende | Restringido | Mientras sea necesario |
| ciudad | Sí, asociado a una persona | Ubicación general | Depende | Interno | Mientras sea necesario |
| codigo_postal | Sí, asociado a otros datos | Ubicación o entregas | Depende | Restringido | Mientras sea necesario |
| fecha_alta | Sí, asociada al usuario | Control de registros | Sí | Interno | Mientras exista y sea necesario |

## Actividad 2.  Principio de minimizacion

**1. ¿Todos los campos son necesarios para atención al cliente?**

No, solo se necesitan los datos que ayuden a identificar al cliente y atender sus solicitudes, como el nombre, correo y teléfono.

**2. ¿Por qué soporte necesitaría conocer el RFC?**

Solo si necesita realizar algún trámite fiscal; de lo contrario, no es necesario.

**3. ¿Necesita conocer la edad?**

No, a menos que sea importante para algún servicio específico.

**4. ¿Necesita conocer el código postal?**

Solo si se requiere para verificar una dirección o realizar alguna entrega.

**5. ¿Qué principio de privacidad está relacionado con esta decisión?**

El principio de minimización de datos, que consiste en recopilar y utilizar únicamente los datos personales necesarios para cumplir una finalidad.

## Actividad 3.  Separacion por finalidad


**¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?**

Porque permite obtener estadísticas sin mostrar datos personales como nombres, correos, teléfonos o RFC. Así, se reduce el riesgo de exponer información y se utiliza únicamente lo necesario para el análisis.

## Actividad 4. Control de acceso relacionado con la finalidad

**1. ¿Qué información puede consultar el rol?**

Puede consultar la ciudad y el rango de edad de los clientes mediante la vista `v_analitica_clientes`.

**2. ¿Puede consultar directamente clientes?**

No, porque no tiene permisos para consultar directamente la tabla `clientes`.

**3. ¿Puede obtener nombre, correo y RFC?**

No, porque esos datos no están incluidos en la vista a la que tiene acceso.

**4. ¿Qué principio de privacidad estás aplicando?**

El principio de minimización de datos, porque solo se proporciona la información necesaria para realizar las estadísticas.

**5. ¿Qué principio de seguridad estás aplicando?**

El principio de mínimo privilegio, porque el rol solo tiene los permisos necesarios para realizar su función. 

