CREATE VIEW third_view WITH (security_invoker = true) AS
SELECT metod_analisis, precio_analisis
FROM catalogo;