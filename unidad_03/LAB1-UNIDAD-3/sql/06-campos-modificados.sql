
-- LAB-01 - Actividad 12
-- Archivo: 06-campos-modificados.sql
-- Identificar los campos modificados en la auditoria

-- 1. Consultar los eventos registrados
SELECT
    id,
    fecha_evento,
    usuario_sesion,
    usuario_efectivo,
    aplicacion,
    ip_cliente,
    operacion,
    id_cliente
FROM auditoria.cambios_clientes
ORDER BY id;

-- 2. Comparar los valores anteriores y posteriores
--    para mostrar solamente los campos que cambiaron
SELECT
    a.id,
    a.fecha_evento,
    a.usuario_sesion,
    a.ip_cliente,
    d.key AS campo,
    a.valores_antes ->> d.key AS antes,
    d.value #>> '{}' AS despues
FROM auditoria.cambios_clientes a
CROSS JOIN LATERAL jsonb_each(a.valores_despues) d
WHERE a.operacion = 'UPDATE'
  AND a.valores_antes -> d.key IS DISTINCT FROM d.value
ORDER BY a.id;
