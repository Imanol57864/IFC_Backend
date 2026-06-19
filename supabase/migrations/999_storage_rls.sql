CREATE POLICY "Enable read access for all autheds" ON "storage"."objects"
AS PERMISSIVE FOR SELECT
TO authenticated
USING (true);

CREATE POLICY "Enable INSERT for AUTHED area.id=1" ON "storage"."objects"
AS PERMISSIVE FOR INSERT
TO authenticated
WITH CHECK ((EXISTS ( SELECT 1 FROM ("Area_Usuario" au JOIN areas a ON ((a.id = au.area_id))) WHERE ((au.user_id = uid()) AND (a.id = 1)))));

CREATE POLICY "Enable DELETE for AUTHED user.id = 1" ON "storage"."objects"
AS PERMISSIVE FOR DELETE
TO authenticated
USING ((EXISTS ( SELECT 1 FROM ("Area_Usuario" au JOIN areas a ON ((a.id = au.area_id))) WHERE ((au.user_id = uid()) AND (a.id = 1)))));

CREATE POLICY "Enable UPDATE for AUTHED area.id = 1" ON "storage"."objects"
AS PERMISSIVE FOR UPDATE
TO authenticated
USING ((EXISTS ( SELECT 1 FROM ("Area_Usuario" au JOIN areas a ON ((a.id = au.area_id))) WHERE ((au.user_id = uid()) AND (a.id = 1)))));
