-- LAB-01: Bitacoras y auditoria del dato
-- Actividad 6: Privilegios y estructura
-- Ejecutar como postgres en la base comercial

-- Consultar los privilegios de los usuarios
SELECT
    grantee,
    privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'clientes'
  AND grantee IN ('app_ventas', 'soporte_ana');

-- Configurar los permisos de modificacion
REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;

-- Agregar una columna a la tabla clientes
ALTER TABLE clientes
ADD COLUMN IF NOT EXISTS segmento VARCHAR(20);

-- Crear y eliminar un rol temporal
-- Se utilizo NOLOGIN, sin contrasena.
-- Por ello no se expuso una clave en la bitacora.
CREATE ROLE rol_temporal_lab NOLOGIN;
DROP ROLE rol_temporal_lab;

-- Consultar la estructura de la tabla clientes
SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'clientes'
ORDER BY ordinal_position;

-- Buscar las instrucciones DDL registradas
-- en el archivo de bitacora actual
SELECT
    pg_current_logfile() AS archivo,
    position(
        convert_to('ALTER TABLE clientes', 'UTF8')
        IN pg_read_binary_file(pg_current_logfile())
    ) AS alter_table,
    position(
        convert_to('CREATE ROLE rol_temporal_lab', 'UTF8')
        IN pg_read_binary_file(pg_current_logfile())
    ) AS create_role,
    position(
        convert_to('DROP ROLE rol_temporal_lab', 'UTF8')
        IN pg_read_binary_file(pg_current_logfile())
    ) AS drop_role;