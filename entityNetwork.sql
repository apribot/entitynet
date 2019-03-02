

CREATE OR REPLACE VIEW public.entitylist AS 
SELECT 
  ns.nspname AS schema,
  c.oid, 
  c.oid::regclass::text AS object_name, 
  CASE c.relkind
      WHEN 'r' THEN 'TABLE'::text
      WHEN 'i' THEN 'INDEX'::text
      WHEN 'S' THEN 'SEQUENCE'::text
      WHEN 'v' THEN 'VIEW'::text
      WHEN 'm' THEN 'MVIEW'::text
      WHEN 'c' THEN 'TYPE'::text      -- COMPOSITE type
      WHEN 't' THEN 'TOAST'::text
      WHEN 'f' THEN 'FOREIGN'::text
  END AS object_type
FROM 
  pg_class c
  JOIN pg_namespace ns ON ns.oid = c.relnamespace
WHERE ns.nspname in ('master', 'blue')
;



CREATE OR REPLACE VIEW public.entityrelations AS 
SELECT DISTINCT
  dependent_view.oid as parent_oid,
  source_table.oid as child_oid
FROM 
  pg_depend 
  JOIN pg_rewrite ON pg_depend.objid = pg_rewrite.oid 
  JOIN pg_class as dependent_view ON pg_rewrite.ev_class = dependent_view.oid 
  JOIN pg_class as source_table ON pg_depend.refobjid = source_table.oid 
  JOIN pg_attribute ON pg_depend.refobjid = pg_attribute.attrelid 
    AND pg_depend.refobjsubid = pg_attribute.attnum 
  JOIN pg_namespace dependent_ns ON dependent_ns.oid = dependent_view.relnamespace
  JOIN pg_namespace source_ns ON source_ns.oid = source_table.relnamespace
WHERE 
  source_ns.nspname in ('master', 'blue')
  AND pg_attribute.attnum > 0 
ORDER BY 1,2;