-- Alter protected schema
ALTER TABLE storage.objects
ADD COLUMN archivo_analisis_id INT,
ADD CONSTRAINT archivo_analisis_id_key
    FOREIGN KEY (archivo_analisis_id)
    REFERENCES public."Archivo_Analisis"(id)
    ON DELETE CASCADE;

-- Trigger, update automatic storage.objects fk_id so on delete cascade works
CREATE OR REPLACE FUNCTION public.link_storage_object()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE storage.objects
    SET archivo_analisis_id = NEW.id
    WHERE id = NEW.uuid_archivo;

    RETURN NEW;
END;
$$;

-- attach
CREATE TRIGGER trg_link_storage_object
AFTER INSERT ON public."Archivo_Analisis"
FOR EACH ROW
WHEN (NEW.uuid_archivo IS NOT NULL)
EXECUTE FUNCTION public.link_storage_object();

-- Revert
ALTER TABLE storage.objects
DROP CONSTRAINT archivo_analisis_id_key,
DROP COLUMN archivo_analisis_id;

-- method, trigger
CREATE OR REPLACE FUNCTION public.delete_storage_object()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM storage.objects
    WHERE id = OLD.uuid_archivo;
    RETURN OLD;
END;
$$;

-- Attach the trigger to Archivo_Analisis
CREATE TRIGGER trg_delete_storage_object
AFTER DELETE ON public."Archivo_Analisis"
FOR EACH ROW
WHEN (OLD.uuid_archivo IS NOT NULL)
EXECUTE FUNCTION public.delete_storage_object();

-- Denied by supabase
DROP TRIGGER IF EXISTS trg_delete_storage_object
ON public."Archivo_Analisis";
DROP FUNCTION IF EXISTS public.delete_storage_object();

DROP TRIGGER IF EXISTS trg_link_storage_object
ON public."Archivo_Analisis";
DROP FUNCTION IF EXISTS public.link_storage_object();