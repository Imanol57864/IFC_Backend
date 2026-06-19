SELECT
  pol.polname AS policy_name,
  tab.relname AS table_name,
  pol.polcmd AS command,
  pg_get_expr(pol.polqual, pol.polrelid) AS using_expression,
  pg_get_expr(pol.polwithcheck, pol.polrelid) AS with_check_expression,
  rol.rolname AS role_name
FROM pg_policy pol
JOIN pg_class tab ON tab.oid = pol.polrelid
JOIN pg_roles rol ON rol.oid = pol.polrole;