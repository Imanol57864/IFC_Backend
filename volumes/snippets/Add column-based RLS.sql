CREATE VIEW catanalisis_full
WITH (security_invoker = true)
AS
SELECT *
FROM "catAnalisis" c;

CREATE VIEW catanalisis_area3
WITH (security_invoker = true)
AS
SELECT
    c.id_analisis,
    c.codigo_completo,
    c."id_catLabos",
    c.desc_toptext, 
    c.desc_metodo,
    c.desc_muestra_tipo,
    c.desc_bottomtext,
    c.desc_respuesta,
    c.desc_muestra_cantd,
    c.desc_acred
FROM "catAnalisis" c;

DROP VIEW IF EXISTS catanalisis_area3;