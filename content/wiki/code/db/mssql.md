+++
title = "mssql"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "db",
    "mssql"
]
date = "2016-05-24"
+++
# MSSQL 

### clustered indexen aanpassen door ze eerst te resolven in een cursor 

Onderstaand stukje code for future reference...


```sql
DECLARE @constraint NVARCHAR(MAX)
DECLARE @cmd NVARCHAR(MAX)
DECLARE @table NVARCHAR(MAX)

DECLARE FKCURSOR CURSOR FOR 
select distinct name,object_name(parent_object_id) from sys.objects where object_id in 
(   select fk.constraint_object_id from sys.foreign_key_columns as fk
    where fk.referenced_object_id = 
    	(select object_id from sys.tables where name = 'Reference')
)

OPEN FKCURSOR

FETCH NEXT FROM FKCURSOR 
INTO @constraint, @table

WHILE @@FETCH_STATUS = 0
BEGIN

	SET @cmd = N'ALTER TABLE [dbo].['+@table+'] DROP CONSTRAINT ' +  @constraint
	EXEC sp_executeSQL @cmd;

   FETCH NEXT FROM FKCURSOR 
    INTO @constraint, @table
END 
CLOSE FKCURSOR;
DEALLOCATE FKCURSOR;
```


### constraints met auto-names verwijderen als een kolom hierop depent 

Gebruik information schemes om de data hier uit te halen.

Bvb onderstaande code verwijdert de kolom 'isDefault', nadat alle constraints hierrond verwijderd zijn. 

```sql
declare @cname varchar(100)
declare @query nvarchar(max)
set @cname = (

SELECT
    default_constraints.name
FROM 
    sys.all_columns

        INNER JOIN
    sys.tables
        ON all_columns.object_id = tables.object_id

        INNER JOIN 
    sys.schemas
        ON tables.schema_id = schemas.schema_id

        INNER JOIN
    sys.default_constraints
        ON all_columns.default_object_id = default_constraints.object_id

WHERE 
        schemas.name = 'dbo'
    AND tables.name = 'tblhtmltemplate'
    AND all_columns.name = 'isdefault')

	set @query = 'alter table tblhtmltemplate drop constraint ' + @cname 

if @cname is not null begin
	exec sp_executesql @query
end

IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name######'tblHtmlTemplate' AND column_name 'isDefault')
BEGIN
	alter table tblhtmltemplate drop column isdefault;
END;

```


### functies aanmaken om MySQL syntax te mimicken 

```sql
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION ifnull 
(
	-- Add the parameters for the function here
	@value1 datetime, @returnvalue int
)
RETURNS datetime
AS
BEGIN
	return isnull(@value1, @returnvalue)

END
GO
```

Zou `IFNull` moeten mimicken, maar je kan enkel `select dbo.ifnull()` doen ipv de native syntax... 


### Waar zijn de DB files op de schijf ergens geplaatst? 

```sql
SELECT name, physical_name AS current_file_location
FROM sys.master_files
```

Zie ook [MSDN: MSSQL DB file locations](https://msdn.microsoft.com/en-us/library/ms143547.aspx)

### Alter databases gaan traag 

  1. uitvoeren met `WITH ROLLBACK IMMEDIATE;`
  2. uitvoeren in `SINGLE_USER` mode (set op db niveau, dan terug naar `MULTI_USER` zetten)

### Query notifications 

Service broker aan zetten: `ALTER DATABASE db_name SET ENABLE_BROKER with rollback immediate`

Hoe checken of reeds enabled is? `select name, database_id, service_broker_guid from sys.databases where is_broker_enabled = 1;`

:exclamation: service broker GUIDs zijn dezelfde indien DB gekopiëerd is, bijgevolg krijg je deze fout indien je `ENABLE_BROKER` tracht uit te voeren op zo'n kopie:

```
cannot be enabled because there is already an enabled Service Broker with the same ID
```

Fix: ([bron](http://www.mssqltips.com/sqlservertip/2789/sql-server-service-broker-error-database-cannot-be-enabled/)) maak een nieuwe broker GUID aan met `SET NEW_BROKER`. 

##### In combinatie met NHibernate Syscache2 

Zie 

  * [http:*developer.empinia.org/svn/empinia/vendor/bin/nhibernate/trunk/Doc/html/caches.html](http:*developer.empinia.org/svn/empinia/vendor/bin/nhibernate/trunk/Doc/html/caches.html)
  * [http:*tamingcode.com/2013/07/01/cacheable-queries-pitfalls/](http:*tamingcode.com/2013/07/01/cacheable-queries-pitfalls/)

#### Hoe weet ik nu of notification works? 

We moeten zien of de **Broker:Conversation** berichten correct op- en afgestuurd worden. Dit kan je best nagaan in SQL Server Profiler:

<img style='float: left; width: nolink |px;' src='/img//code/db/sqlprofiling.png'>

Volgende dingen zouden moeten gebeuren:

  1. STARTED_OUTBOUND bericht (conversation)
  2. CONVERSING bericht (conversation) van .Net SqlClient applicationName
  3. QN:Subscription van .Net SqlClient applicationName
  4. QN:Dynamics event subclass Clock run om te zien of het event gequeued is.

#### Pitfalls en errors 

##### System.InvalidOperationException: When using SqlDependency without providing an options value, SqlDependency.Start() must be called prior to execution of a command added to the SqlDependency instance. 

[Bron](http://richarddingwall.name/2009/10/09/nhibernate-caches-syscache2-dont-forget-to-call-sqldependency-start/)

`SqlDependency.Start(conString)` aanroepen vóór de setup van bvb de NHibernate session factory. Dit moet je zelf doen, ook al gebruik je SysCache2 met regions. 

:exclamation: altijd eerst Stop aanroepen! 

##### Cannot execute as the database principal because the principal "dbo" does not exist 

In SQL Server profiler zichtbaar bij broker events - dit komt vanwege te weinig rechten.

`use [DBNAME] EXEC sp_changedbowner 'sa`' lost dit probleem op (zie profiling)

### MSSQL specifieke syntax 

##### Batch processing 

`GO`:

  The GO command isn't a Transact-SQL statement, but a special command recognized by several MS utilities including SQL Server Management Studio code editor.

  The GO command is used to group SQL commands into batches which are sent to the server together. The commands included in the batch, that is, the set of commands since the last GO command or the start of the session, must be logically consistent. For example, you can't define a variable in one batch and then use it in another since the scope of the variable is limited to the batch in which it's defined.

Zie ook [http:*msdn.microsoft.com/en-us/library/ms188037.aspx](http:*msdn.microsoft.com/en-us/library/ms188037.aspx).
  
:exclamation: Dit is blijkbaar ook wijzigbaar naar een karakterset naar keuze in Management studio options:

<img style='float: left; width: nolink |px;' src='/img//code/db/go_option_mssql.png'>
  
##### Rename columns 

```sql
EXEC sp_RENAME 'TableName.OldColumnName' , 'NewColumnName', 'COLUMN'
```

##### werken met datums 

`GETDATE()` is een now timestamp (in MySQL is dit `CURDATE()`. Records selecteren met een bepaalde timestamp ("vanaf"):

```sql
select * from table where datecolumn >= Convert(datetime, '2014-09-11');
```

In Oracle is dit bijvoorbeeld `TO_DATE('26/JAN/2011','dd/mon/yyyy')` in plaats van `Convert()` - in MySQL kan dit rechtstreeks in een bepaald formaat: `WHERE start_date >'2012-11-18';`

### Monitoring 

##### ADO .NET Connection pool monitoring 

Mogelijk met **Performance monitor** in Win32 (Run -> `perfmon`).

Step-by-step uitleg: (oude versie) [Monitoring DB connections using performance counters](http://www.c-sharpcorner.com/uploadfile/CMouli/monitoring-database-connections-using-performance-counters/)

[Mogelijke counters - MSDN](http://msdn.microsoft.com/en-us/library/ms254503.aspx):

  1. NumberOfActiveConnections
  2. NumberOfFreeConnections
  3. NumberOfPooledConnections
  4. ...

<img style='float: left;' src='/img//code/db/addcounters.png |'>

Alles ivm DB connecties in .NET is ook mogelijk te bekijken met de [ANTS Performance profiler](http://www.red-gate.com/products/dotnet-development/ants-performance-profiler/). 

##### Aantal momenteel actieve threads bezien 
```sql
SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame
```