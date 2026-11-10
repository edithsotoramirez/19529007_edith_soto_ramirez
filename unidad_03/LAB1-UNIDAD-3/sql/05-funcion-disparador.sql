-- LAB-01
-- Actividad 11: Funcion y disparador de auditoria
-- No volver a ejecutar CREATE TRIGGER si ya existe.
-- SECURITY DEFINER requiere un propietario confiable.

CREATE OR REPLACE FUNCTION auditoria.registrar_cambio_cliente()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
BEGIN
    INSERT INTO auditoria.cambios_clientes (
        usuario_sesion,
        usuario_efectivo,
        aplicacion,
        ip_cliente,
        operacion,
        id_cliente,
        valores_antes,
        valores_despues
    )
    VALUES (
        session_user,
        current_user,
        current_setting('application_name'),
        inet_client_addr(),
        TG_OP,
        CASE
            WHEN TG_OP = 'DELETE' THEN OLD.id
            ELSE NEW.id
        END,
        CASE
            WHEN TG_OP IN ('UPDATE', 'DELETE')
            THEN to_jsonb(OLD)
            ELSE NULL
        END,
        CASE
            WHEN TG_OP IN ('INSERT', 'UPDATE')
            THEN to_jsonb(NEW)
            ELSE NULL
        END
    );

    RETURN COALESCE(NEW, OLD);
END;
$$;

REVOKE ALL ON FUNCTION auditoria.registrar_cambio_cliente()
FROM PUBLIC;

CREATE TRIGGER trg_auditoria_clientes
AFTER INSERT OR UPDATE OR DELETE
ON public.clientes
FOR EACH ROW
EXECUTE FUNCTION auditoria.registrar_cambio_cliente();

-- Verificar los eventos del disparador
SELECT
    trigger_name,
    event_manipulation,
    event_object_table
FROM information_schema.triggers
WHERE trigger_name = 'trg_auditoria_clientes'
ORDER BY event_manipulation;