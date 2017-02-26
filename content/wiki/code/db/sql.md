+++
title = "sql"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "db",
    "sql"
]
date = "2013-09-03"
+++
# code:db >> Sql 

## Stored procedures  

### Oproepen 

Zie http://stackoverflow.com/questions/3991721/run-stored-procedure-in-sql-developer

Gegeven: een procedure `GETPERMISSIONSALL` als volgt gedeclareerd:

```sql
create or replace 
PROCEDURE "GETPERMISSIONALL" ( v_actCreator in VARCHAR2, v_repGuid in VARCHAR2, v_userid INT, v_retHasPermission out SMALLINT)
```

De laatste parameter is de return waarde (kunnen meerdere dingen zijn dus). Hoe roep ik nu zoiets aan?

#### In SQL Developer 

Definiëer eerst uw variabelen, om ze daarna eventueel af te drukken - 

```sql
SET serveroutput on;
DECLARE
    v_actCreator VARCHAR2(100);
    v_repGuid VARCHAR2(100);
    v_userid int;
    Output smallint;
BEGIN
    /* Assign values to IN parameters */
    v_actCreator := '19980121164845.106.1 7';
    v_repGuid := '2466B39EFDA94D5E9249D252FF25C4D6';
    v_userid := 540;

    /* Call procedure within package, identifying schema if necessary */
    GETPERMISSIONALL(v_actCreator, v_repGuid, v_userid, Output);

    /* Display OUT parameters */
    dbms_output.put_line('Output: ' || Output);
END;
/
-- Display OUT parameters
-- print :Output;
```

##### Werken met REF CURSOR 

Probleemstelling:

  1. Uw procedure retourneert een `REF CURSOR` als IN en OUT variabele
  2. Je wil over deze gaan loopen en ergens een resultaat afdrukken of vergelijken
  3. openen van een `REF CURSOR` gaat niet.

Gebruik in een `LOOP` dadelijk `FETCH` `INTO`:

```sql
SET serveroutput ON;
DECLARE
  P_USERID NUMBER;
  MY_P_CURSOR C2MV5_DEV.PKG_WFSEC.Validation_Send_Item_Cursor;
  cursor_element C2MV5_DEV.PKG_WFSEC.WFSEC_Send_Item_T;
BEGIN
  P_USERID := 11;
  
  PKG_WFSEC.FETCHSENDITEMS(
    P_USERID => P_USERID,
    P_CURSOR => MY_P_CURSOR
  );

 WHILE TRUE LOOP
    FETCH MY_P_CURSOR INTO cursor_element;
    EXIT WHEN MY_P_CURSOR%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(cursor_element.executingdoctorname);
  END LOOP;

END;
```

Merk op dat hier bijvoorbeeld `cursor_element` van een bepaald type is dat in een package gedefinieerd is, dat de cursor ook retourneert (`TYPE Validation_Send_Item_Cursor IS REF CURSOR RETURN WFSEC_Send_Item_T;`)

#### In C# 

```csharp
        public object QueryProcedure(string procedure, IDictionary<string, object> parameters, string outputParameter)
        {
            var command = new OleDbCommand(procedure);
            foreach (var item in parameters)
            {
                   command.Parameters.AddWithValue(item.Key, item.Value);
            }
            var output = command.Parameters.AddWithValue(outputParameter, 0);
            output.Direction = ParameterDirection.Output;

            QueryProcedure(command);
            return output.Value;
        }
```

### Unit testen 

#### Met SQL Developer  

zie [Oracle docs: Unit Testing in SQL Developer 3+](http://docs.oracle.com/cd/E15846_01/doc.21/e15222/unit_testing.htm)

:exclamation: Read this first: [Unit Testing PL/SQL In SQL Developer problems](http://www.fuzzy.cz/en/articles/unit-testing-plsql-code-in-sql-developer-problems/) - toch niet zo geweldig? <br/><br/>
Kan blijkbaar al niet apart gerund worden (mee in de build? een of nadere bat file van SQLDev zelf?)

<img style='float: left;' src='/img//code/db/unittest_sqldev.png |'>

Als uw stored procedure data wijzigt kan je in de startup en teardown process stappen toevoegen: "table or row copy", om die daarna terug te zetten. 

##### Test gerelateerde tabellen opkuisen 

Als je database-onafhankelijk testen wil draaien, kan je deze ook exporteren en importeren, en daarna runnen. Een import verwijdert echter niet oude niet-relevante unit tests, dus opkuisen van de UT repository is wel vereist. Hier is een `SQL` stored proc. om de boel te automatiseren:

```sql
SET serveroutput ON;
DECLARE
    queryStr VARCHAR2(100);
    tableName VARCHAR2(900);
    cursor tableCursor is SELECT table_name FROM dba_tables where owner ='user' and table_name like 'UT_TEST_%' or table_name like 'UT_SUITE_%';
BEGIN

dbms_output.enable(10000);
DBMS_OUTPUT.PUT_LINE('Cleaning unit test tables');

open tableCursor;
fetch tableCursor into tableName;

WHILE (tableCursor%FOUND) LOOP
  queryStr := 'delete from ' ||tableName;
  execute immediate queryStr;
  --DBMS_OUTPUT.PUT_LINE(queryStr);
  fetch tableCursor into tableName;
END LOOP;
close tableCursor;

commit;
DBMS_OUTPUT.PUT_LINE('SUCCESS - all cleaned!');

END;
/
```

Dit kan je runnen met `sqlplus` op de volgende manier:

```
sqlplus user/pass@db @"fullpath_to_filename.sql"
```

:exclamation: Let op met spaties in filename, gebruik daarom dubbele quotes hierboven.

##### Command-line testen runnen 

```
ututil -run -suite -name [name] -repo [repo] -db [db] -log 3
```

Uw repository naam is dezelfde als de DB naam als je Tools > Unit Test > Create/Update Repository... gekozen hebt via SQL Developer. 

:exclamation: `ututil` kan de db connectie namen **niet resolven bij TNS** - Gebruik **Connection Identifier** (copypaste desnoods van `tnsnames.ora`)<br/><br/>
Fout die je anders krijgt:

```
D:<br/>oracle<br/>sqldeveloper<br/>sqldeveloper<br/>bin>ututil -run -test -name GETPERMISSIONALL -repo CHCDEV -db CHCTEST -log 3
SEVERE oracle.jdeveloper.db.ConnectionException: Could not connect to database CHCTEST. The error encountered was: Ongeldige verbindingsgegevens opgeg
even.
Controleer de notatie van de URL voor de opgegeven driver.
        oracle.jdeveloper.db.DatabaseConnections.getUniqueConnection(DatabaseConnections.java:514)
SEVERE null - oracle.dbtools.unit_test.utils.UtUtils.getRunnerConnection(UtUtils.java:141)
Unable to run test
```

##### Integratie met de build: C# 

Een `SqlDeveloperTest` klasse die het volgende doet:

  1. voer `sqlplus` uit met bovenstaande cleanup script dat alle repository tabellen cleart
  2. voer `ututil` uit met `-imp -repo [repo] -file [xmlfile]`
  3. voer `ututil` uit met `-run` zoals boven aangegeven.

De eigenlijke unit testen leven dan in uw source control omgeving zoals `TFS`, in die ene xml file. Op die manier kan je branchen en zo zonder dat die testen vasthangen aan je DB schema. Joepie!
## Problemen  

#### NOT IN retourneert geen enkele resultaten ?? 

voorbeeld:

```sql
select * from sch_vac.VAC_TAKEN 
where  ikl_id is not null
and ikl_id not in (select iklnummer from VAC_WERFRES_KANDIDATEN)
```

> There are serious problems with subqueries that may return NULL values. It is a good idea to discourage the use of the NOT IN clause (which invokes a subquery) and to prefer **NOT EXISTS** (which invokes a correlated subquery), since the query returns no rows if any rows returned by the subquery contain null values.

Oplossing is dus:

```sql
select * from vac_taken taak where ikl_id is not null
and not exists (select 1 from vac_werfres_kandidaten where iklnummer = taak.ikl_id)
```