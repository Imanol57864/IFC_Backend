CREATE OR REPLACE FUNCTION get_analisis()
RETURNS SETOF json
LANGUAGE plpgsql
SECURITY INVOKER
AS $$
DECLARE
    v_area integer;
BEGIN
    SELECT area_id 
    INTO v_area FROM "Area_Usuario" WHERE user_id = auth.uid() LIMIT 1;

    CASE v_area
    WHEN 1 THEN RETURN QUERY SELECT row_to_json(v) FROM catanalisis_full v;
    WHEN 2 THEN RETURN QUERY SELECT row_to_json(v) FROM catanalisis_full v;
    WHEN 3 THEN RETURN QUERY SELECT row_to_json(v) FROM catanalisis_area3 v;
    -- WHEN 4
    ELSE RAISE EXCEPTION 'El usuario no tiene permisos para consultar los análisis.';
    END CASE;
    
END;
$$
SET search_path = public;

DROP FUNCTION get_analisis();