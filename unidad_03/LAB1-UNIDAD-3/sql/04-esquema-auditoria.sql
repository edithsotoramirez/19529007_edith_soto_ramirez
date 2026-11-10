-- LAB-01
-- Actividad 10: Diseno y estructura de auditoria
-- Se mantienen nombres de columnas YA CREADOS en la base real.
-- No volver a ejecutar CREATE TABLE sobre la base existente.

-- Crear esquema
CREATE SCHEMA IF NOT EXISTS auditoria;

-- Restringir acceso publico
REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;

-- Crear tabla para registrar cambios
CREATE TABLE IF NOT EXISTS auditoria.cambios_clientes (
    id BIGSERIAL PRIMARY KEY,
    fecha_evento TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    usuario_sesion TEXT,
    usuario_efectivo TEXT,
    aplicacion TEXT,
    ip_cliente INET,
    operacion TEXT,
    id_cliente BIGINT,
    valores_antes JSONB,
    valores_despues JSONB
);

-- Comprobar estructura
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'auditoria'
  AND table_name = 'cambios_clientes'
ORDER BY ordinal_position;