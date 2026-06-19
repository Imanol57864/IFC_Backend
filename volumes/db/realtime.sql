\set pguser `echo "$POSTGRES_USER"`

create schema if not exists _realtime;
alter schema _realtime owner to :pguser;

-- Manual replica added
ALTER TABLE "catAnalisis" REPLICA IDENTITY FULL;
ALTER TABLE "catLabos" REPLICA IDENTITY FULL;