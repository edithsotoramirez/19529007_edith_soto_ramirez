# LAB-03 — Actividades 8 y 9: Derecho de cancelación y derecho de oposición

## Objetivo

Comprender cómo se deben gestionar las solicitudes de cancelación y oposición al tratamiento de datos personales, considerando el ciclo de vida de la información, las finalidades del tratamiento y las obligaciones de la organización.

## Actividad 8. Derecho de cancelación y ciclo de vida

### Procedimiento

Se analizó qué sucede con la información de un cliente cuando se autoriza la cancelación de sus datos. Antes de eliminar un registro de la tabla principal, es necesario identificar dónde más puede existir esa información, como respaldos, réplicas, reportes, exportaciones y sistemas externos.

Se revisan los lugares donde podrían existir copias de los datos antes de realizar un DELETE en la tabla principal.

clientes
   |
   ├── respaldos
   ├── réplicas
   ├── reportes
   ├── exportaciones
   └── sistemas externos


### Pregunta: ¿Por qué borrar un registro de una tabla no significa que toda la información relacionada desaparezca de la organización?

Porque los datos pueden encontrarse en diferentes lugares, como copias de seguridad, reportes, archivos exportados y otros sistemas conectados. Por eso, eliminar el registro de la tabla principal no garantiza que toda la información haya desaparecido. Es necesario revisar el ciclo de vida de los datos y establecer cómo se manejarán las demás copias.

## Actividad 9. Derecho de oposición

### ¿Es necesario borrar inmediatamente todos los datos del cliente?

No necesariamente. La solicitud consiste en oponerse a un uso específico de sus datos, por lo que pueden existir datos que todavía sean necesarios para prestar el servicio o cumplir obligaciones legales. Se debe revisar qué información puede conservarse y qué uso debe detenerse, de acuerdo con la finalidad y las obligaciones aplicables.

### qué información podría necesitar mantenerse

Podrían conservarse los datos necesarios para mantener el servicio, atender operaciones pendientes o cumplir obligaciones legales. La organización debe justificar su conservación y evitar mantener información que ya no sea necesaria.

### qué información podría dejar de utilizarse para determinada finalidad

Los datos que se utilizan para enviar promociones o realizar actividades de marketing deben dejar de emplearse para esa finalidad cuando proceda la solicitud de oposición. Esto no significa que deban eliminarse automáticamente de todos los sistemas si todavía existe otra finalidad válida para conservarlos.

### qué mecanismos técnicos podrían separar finalidades

Se pueden utilizar permisos por roles, vistas específicas, controles de acceso y registros de auditoría. También es importante identificar qué datos se utilizan para cada finalidad y evitar que las áreas de marketing accedan a información que ya no deben utilizar.

### por qué la decisión final no debe ser tomada únicamente por el DBA

Porque el DBA puede aplicar cambios técnicos y administrar los permisos, pero la decisión también implica aspectos legales, operativos y de privacidad. Por ello, deben participar las áreas responsables para determinar qué datos se pueden conservar y cuáles usos deben detenerse.

## Resultado

Se identificó que la cancelación de datos requiere revisar todo su ciclo de vida, mientras que el derecho de oposición se enfoca en detener determinados usos de la información. Ambas situaciones necesitan coordinación entre las áreas responsables y controles técnicos que permitan administrar los datos correctamente.

## Análisis

Eliminar un registro de la tabla principal no garantiza que la información desaparezca de todos los sistemas. Además, una solicitud de oposición no siempre significa que se deban eliminar todos los datos del cliente, ya que algunos pueden seguir siendo necesarios para otras finalidades válidas. Por eso, es importante identificar dónde se almacenan los datos, para qué se utilizan y quién tiene acceso a ellos.

## Conclusión

Estas actividades permitieron comprender que el manejo de datos personales no consiste solamente en eliminarlos de una tabla. También es necesario revisar las copias existentes, controlar las finalidades de uso y aplicar permisos adecuados. Las decisiones deben tomarse considerando tanto los aspectos técnicos como las obligaciones legales y las necesidades de la organización.