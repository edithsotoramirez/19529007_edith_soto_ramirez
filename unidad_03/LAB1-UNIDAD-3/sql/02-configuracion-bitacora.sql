-- LAB-01: Bitacoras y auditoria del dato
-- Actividad 4: Configuracion de bitacoras

-- Activar el registro de conexiones y desconexiones
ALTER SYSTEM SET log_connections = 'on';
ALTER SYSTEM SET log_disconnections = 'on';

-- Configurar la informacion que aparecera en cada registro
ALTER SYSTEM SET log_line_prefix =
    '%m [%p] user=%u db=%d app=%a client=%h ';

-- Registrar instrucciones de estructura (DDL)
ALTER SYSTEM SET log_statement = 'ddl';

-- Aplicar los cambios de configuracion
SELECT pg_reload_conf();

-- Verificar los parametros configurados
-- Abrir una nueva conexion antes de esta consulta
SELECT
    name,
    setting,
    pending_restart
FROM pg_settings
WHERE name IN (
    'log_connections',
    'log_disconnections',
    'log_line_prefix',
    'log_statement'
)
ORDER BY name;