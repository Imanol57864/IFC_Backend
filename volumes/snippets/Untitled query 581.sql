SELECT id, name FROM storage.objects WHERE id = ANY(ARRAY['b648193b-d03d-4242-9108-50553927ec06']::uuid[]);


-- 1. Asegúrate de que el RLS esté activo (normalmente lo está por defecto)
ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

-- 2. Crea la política para que los usuarios puedan "ver" los objetos
CREATE POLICY "Cualquier usuario autenticado puede ver archivos" 
ON storage.objects 
FOR SELECT 
TO authenticated 
USING (true);