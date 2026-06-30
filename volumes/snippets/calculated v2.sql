UPDATE "catAnalisis" p
SET autoupdate = c.codigo_lab
FROM "catLabos" c
WHERE p."id_catLabos" = c.nombre_lab;

SELECT
    CONCAT(
        COALESCE(t2.codigo_lab, ''),
        COALESCE(t1.codigo_analisis, '')
    ) AS atributo_calculado
FROM "catAnalisis" t1
JOIN "catLabos" t2
    ON t1."id_catLabos" = t2.nombre_lab;


UPDATE "catAnalisis" AS t1
SET "codigo_completo" = CONCAT(
    COALESCE(t2.codigo_lab, ''),
    COALESCE(t1.codigo_analisis, '')
)
FROM "catLabos" AS t2
WHERE t1."id_catLabos" = t2.nombre_lab;