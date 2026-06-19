SELECT * FROM pg_publication_tables WHERE pubname = 'supabase_realtime';

-- Esto desconectará momentáneamente el servicio de Realtime de la DB
SELECT pg_drop_replication_slot('supabase_realtime_replication_slot');

-- didnt exist, so gotta create it manually
SELECT pg_create_logical_replication_slot('supabase_realtime_replication_slot', 'wal2json');

-- Activates the full payload information (payload.old will send the full previous object)
ALTER TABLE messages REPLICA IDENTITY FULL;

-- check replication slots
SELECT * FROM pg_replication_slots;

-- check slots status
SELECT slot_name, active, restart_lsn
FROM pg_replication_slots;

-- borrar slot fantasma incorrecto
SELECT pg_drop_replication_slot('supabase_realtime_messages_replication_slot_');
SELECT pg_drop_replication_slot('supabase_realtime_replication_slot');

-- borrar el PID que generó el cuello de botella
SELECT pg_terminate_backend(5919);

-- check replication slots (AGAIN)
SELECT * FROM pg_replication_slots;
-- its working correctly, not a bug

-- Verifica que "schemaname = public" & "tablename = messages"
SELECT schemaname, tablename FROM pg_publication_tables WHERE pubname = 'supabase_realtime';

--- test 3 (worked after removing everything while realtime enabled, then toggle off->on realtime at table)
INSERT INTO messages (content) VALUES ('test realtime');


-- Work #01
ALTER TABLE "catAnalisis" REPLICA IDENTITY FULL;
ALTER TABLE "catLabos" REPLICA IDENTITY FULL;