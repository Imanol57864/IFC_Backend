CREATE VIEW catanalisis_area1
WITH (security_invoker = true)
AS
SELECT *
FROM "catAnalisis" c
WHERE EXISTS (
    SELECT 1
    FROM "Area_Usuario" au
    WHERE au.user_id = auth.uid()
      AND au.area_id = 1
);

CREATE VIEW catanalisis_area3
WITH (security_invoker = true)
AS
SELECT
    c.id_analisis,
    c.codigo_completo,
    c."id_catLabos",
    c.y_categoria,
    c.desc_toptext, 
    c.desc_metodo,
    c.desc_muestra_tipo,
    c.desc_bottomtext,
    c.desc_respuesta,
    c.desc_muestra_cantd,
    c.desc_acred
FROM "catAnalisis" c
WHERE EXISTS (
    SELECT 1
    FROM "Area_Usuario" au
    WHERE au.user_id = auth.uid()
      AND au.area_id = 3
);

DROP VIEW IF EXISTS catanalisis_area3;