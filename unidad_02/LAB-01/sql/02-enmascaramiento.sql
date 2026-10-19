-- ============================================================
-- Actividad 2 — Enmascaramiento (masking)
-- ============================================================

CREATE ROLE soporte NOLOGIN;


GRANT soporte TO u_20441231_zadkiel_quintero;


CREATE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,
    --
    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,
    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,
    -- RFC: solo los últimos 4 caracteres
    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc
FROM clientes;

SELECT *
FROM v_clientes_soporte;


GRANT USAGE
ON SCHEMA public
TO soporte;

GRANT SELECT
ON v_clientes_soporte
TO soporte;

REVOKE ALL
ON clientes
FROM soporte;


SET ROLE soporte;

SELECT current_user;

SELECT *
FROM v_clientes_soporte;

SELECT *
FROM clientes;

RESET ROLE;

SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'soporte';