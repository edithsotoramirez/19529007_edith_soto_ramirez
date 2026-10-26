CREATE TABLE clientes_soporte (
    id INT,
    nombre VARCHAR(100),
    correo VARCHAR(150),
    telefono VARCHAR(20)
);

INSERT INTO clientes_soporte (id, nombre, correo, telefono)
SELECT id, nombre, correo, telefono
FROM clientes;

SELECT *
FROM clientes_soporte;