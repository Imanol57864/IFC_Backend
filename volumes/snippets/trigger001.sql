-- Función del trigger
CREATE OR REPLACE FUNCTION actualizar_codigo_completo()
RETURNS TRIGGER AS 
$$
BEGIN
    UPDATE "catAnalisis" ca
    SET "codigo_completo" = CONCAT(
        COALESCE(NEW.codigo_lab, ''),
        COALESCE(ca.codigo_analisis, '')
    )
    WHERE ca."id_catLabos" = NEW.nombre_lab;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql
SET search_path = public;

CREATE TRIGGER trg_actualizar_codigo_completo
AFTER UPDATE OF codigo_lab
ON "catLabos"
FOR EACH ROW
EXECUTE FUNCTION actualizar_codigo_completo();



---------------
CREATE TRIGGER trg_actualizar_codigo_completo_catAnalisis 
AFTER INSERT 
ON "catAnalisis" 
FOR EACH ROW 
EXECUTE FUNCTION actualizar_codigo_completo_catAnalisis();

DROP TRIGGER IF EXISTS trg_actualizar_codigo_completo_catAnalisis
ON public."catAnalisis";