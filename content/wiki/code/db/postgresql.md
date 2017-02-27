+++
title = "postgresql"
draft = false
tags = [
    "code",
    "db",
    "postgresql"
]
date = "2013-08-09"
+++
# PostgreSQL 

Documentatie: http://www.postgresql.org/docs/9.1/static/view-pg-locks.html
pgAdmin: http://www.pgadmin.org/

:exclamation: Heeft géén commit & rollbacks, alles wat uitgevoerd wordt kan niet teruggedraaid worden!

#### Metadata tabellen bekijken 

##### Alle views van een bepaald schema 

`SELECT count(*) FROM information_schema.views where table_schema = 'public';`, vergeet niet dat `table_schema` `pg_catalog` is voor de metadata tabellen die altijd bestaan in postgres. 

##### Alle kolommen 

Voorbeeld om alle floats te selecteren (kan afrondingsfouten bevatten, gebruik `numeric` in de plaats):

```sql
SELECT * FROM information_schema.columns where
(data_type = 'real' or
 data_type like 'double%')
 and table_schema = 'public'
 and table_name not like 'view_%'
 and table_name not like 'lookup_%';
```

#### Dump van DB nemen 

Gebruik hiervoor `pgdump` in bin folder van postgres install dir:

```
C:<br/>Program Files<br/>PostgreSQL<br/>9.1<br/>bin>pg_dump --host######10.16.42.35 --port5432 --username######postgres --schemapublic --format=c --schema-only repository.db > postgresdump_20111020.dmp
```

Verklaring:

  * `--format`: c (custom), d (directory), t (tar), p (plain text)
  * `--schema`: dump enkel dit stuk
