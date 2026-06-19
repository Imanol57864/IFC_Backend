ALTER TABLE public."catAnalisis"
ADD COLUMN y_precio DECIMAL(10, 2) GENERATED ALWAYS AS (
COALESCE(c_costo * c_factor + c_envio,0)
) STORED;

ALTER TABLE public."catAnalisis"
ADD COLUMN c_utilidad DECIMAL(10, 2) 
GENERATED ALWAYS AS (
COALESCE(c_costo * (c_factor - 1 ) * y_cantidad, 0)
) STORED;