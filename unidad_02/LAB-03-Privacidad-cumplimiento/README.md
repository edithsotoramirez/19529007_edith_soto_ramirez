# Informe final del laboratorio

## 1. Introducción

En este laboratorio se trabajo con los problemas de privacidad que pueden presentarse al almacenar y utilizar datos personales en una base de datos. Se analizaron medidas para proteger la información, controlar los accesos y evitar el uso innecesario de los datos.

## 2. Inventario de datos

Se identificaron datos como nombre, correo, teléfono, RFC, edad, ciudad y código postal. Algunos son datos de identificación y contacto, mientras que otros contienen información fiscal o permiten conocer características de los clientes.

## 3. Finalidades

Los datos deben utilizarse para actividades específicas, como atender clientes, emitir facturas y generar estadísticas. Cada uso debe tener una finalidad justificada.

## 4. Minimización

Se pueden eliminar o limitar los datos que no sean necesarios, como el salario, la ocupación o el estado civil, si no existe una finalidad que justifique recopilarlos. Así se reduce el riesgo de exposición de información personal.

## 5. Control de acceso

Los permisos deben asignarse según las funciones de cada área. Por ejemplo, Facturación puede consultar el RFC cuando lo necesita, mientras que Analítica puede trabajar con datos agregados o anonimizados.

## 6. Derechos ARCO

Los derechos ARCO permiten acceder a los datos personales, corregirlos, solicitar su cancelación y oponerse a su uso en determinadas situaciones. Técnicamente, se necesitan procedimientos para localizar, modificar, cancelar o limitar el tratamiento de los datos según corresponda.

## 7. Retención

El periodo de conservación debe establecerse según la finalidad de los datos y las obligaciones legales. Cuando ya no sea necesario conservarlos y no exista una obligación legal, deben eliminarse de forma segura o anonimizarse cuando corresponda.

## 8. Gobierno de datos

Las responsabilidades deben distribuirse entre las áreas según sus funciones. El DBA administra los permisos y la seguridad técnica; Facturación utiliza los datos fiscales; Analítica trabaja con estadísticas y las áreas responsables de privacidad y asuntos jurídicos apoyan en las decisiones sobre el tratamiento de los datos.

## 9. Evaluación integral

Se encontraron riesgos como accesos demasiado amplios, conservación de datos durante muchos años, copias reales en desarrollo y falta de claridad sobre las finalidades. Se propusieron controles de acceso, anonimización, auditoría y políticas de retención.

## 10. Conclusiones

Aprendí que proteger una base de datos no consiste solamente en evitar accesos no autorizados, sino también en controlar qué información se recopila, para qué se utiliza y cuánto tiempo se conserva. La privacidad y la seguridad deben trabajar juntas para proteger los datos personales.

# 27. Preguntas de reflexión

### 1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?

No, porque puede estar protegida contra ataques, pero utilizar los datos para fines no justificados o conservar información innecesaria.

### 2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?

Porque cada usuario accede únicamente a los datos que necesita, reduciendo la exposición de información personal.

### 3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?

Porque esa decisión corresponde a los responsables del tratamiento y debe considerar las necesidades del negocio, la privacidad y las obligaciones legales.

### 4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?

Porque podrían acceder a información personal que no necesitan para desarrollar o probar el sistema.

### 5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?

Porque puede contener datos reales y quedar expuesta a accesos no autorizados o filtraciones durante las pruebas.

### 6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?

Porque los datos no deben conservarse para siempre, sino eliminarse cuando dejan de ser necesarios y no existe una obligación de mantenerlos.

### 7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?

La privacidad por diseño permite considerar desde el inicio qué datos almacenar, quién puede acceder a ellos y cómo protegerlos.

### 8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?

Implementaría roles y permisos, cifrado, vistas con información limitada, registros de auditoría y eliminación segura de los datos.

### 9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?

Debería conocer dónde están almacenados los datos, cómo identificar los registros de la persona y qué procedimientos existen para consultarlos, corregirlos o cancelarlos según corresponda.

### 10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos?

El DBA administra la seguridad técnica; privacidad supervisa el tratamiento de los datos; el área jurídica revisa las obligaciones legales y el propietario de los datos define las necesidades de uso junto con las áreas responsables.

