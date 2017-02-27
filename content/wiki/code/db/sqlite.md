+++
title = "sqlite"
draft = false
tags = [
    "code",
    "db",
    "sqlite"
]
date = "2015-07-17"
+++
# SQLite 

### DDLs copypasten van Oracle 

Bijvoorbeeld de gegenereerde versie (SQL tab) van Oracle SQL Developer overnemen gaat niet zomaar.

Er zijn enkele verschillen:

  1. `NOT NULL ENABLE` wegdoen. `NOT NULL` maakt niets uit aangezien het in-memory is om te testen!
  2. `USING INDEX` blabla na de `PRIMARY KEY` statements zijn ook allemaal niet nodig (`STORAGE` etc)
  3. speciale defaults of syscalls zoals `sys_guid()` bestaan niet.
  4. definities van groottes: wegdoen van `BYTE`: `VARCHAR2(26)` dus. 
  5. opletten met datums: zie onder.
  6. Namespace mag ook weg bij `CREATE TABLE "SPACE"."NAME" (`

### Connection strings 

Zie http://www.connectionstrings.com/sqlite/

##### File based 

```
Data Source######c:<br/>mydb.db;Version3;
```

##### In-memory 

```
Data Source######:memory:;Version3;New=True;
```

Conventie `Data Source=` notatie gehanteerd door [http:*www.connectionstrings.com/sqlite/](http:*www.connectionstrings.com/sqlite/)

Andere notatie

```
FullUri######file::memory:?cacheshared
```

Notatie gehanteerd door [https:*www.sqlite.org/inmemorydb.html](https:*www.sqlite.org/inmemorydb.html)

Versie en New hoeft blijkbaar niet (?)

:exclamation: Elke keer als je een connectie opendoet gaat SQLite de inmemory DB state restoren naar default (dus leeg). Als je dus bvb;

  1. connectie open
  2. `CREATE TABLE;` brol uitvoeren
  3. connectie sluiten
  4. roep andere method aan
  1. connectie open
  1. `SELECT * FROM TABLE;` brol uitvoeren

BOEM no such table...

Zie ook [SQLite in memory create table does not work](http://stackoverflow.com/questions/17477246/sqlite-in-memory-database-create-table-does-not-work).

:exclamation: Hou dus 1x een connectie open voor unit testen bij een `[SetUp]` en geef referenties door. 

##### Extra opties meegeven via de connection string 

Je kan `PRAGMA` parameters zoals [deze](http://www.sqlite.org/pragma.html#pragma_locking_mode) meegeven.

### Integreren met C# 

#### DB Connectie 

Gebruik http://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki (package `System.data.SQLite (x86/x64)`)

Voor `OleDb` C# code, is er voor elke klasse een equivalent in de `SQLite` namespace, bijvoorbeeld:

```csharp
        private SQLiteConnection SqLiteDbConnection()
        {
            return new SQLiteConnection()
                {
                    ConnectionString ###### "Data Sourcemydb.s3db;",
                    Flags = SQLiteConnectionFlags.LogAll
                };
        }

        public void SetupDb()
        {
            using (var connection = SqLiteDbConnection())
            {
                connection.Open();
                var transaction = connection.BeginTransaction();
                var sqLiteCommand = new SQLiteCommand()
                    {
                        Connection = (SQLiteConnection) connection,
                        CommandType = CommandType.Text,
                        CommandText = GetSchemaCreateSql()
                    };
                sqLiteCommand.ExecuteNonQuery();
                transaction.Commit();
            }
        }
```

#### Builden op x86/x64 systemen 

Afhankelijk van welke package manager je gebruikt (NuGet bvb.) kan een `SQLite.interop.dll` in submapjes `x86` en `x64` geplaatst worden (Copy always als content). Lokaal werkt dit, maar op de build pc (die bijvoorbeeld enkel 32-bit is) niet, omdat de DLL op dezelfde plaats als de executable verwacht wordt. Hier zijn een paar mogelijke oplossingen voor:

  1. Gebruik enkel de 32bit versie. (er is zo'n specifieke package voor)
  2. "Hint" de DLL loader om de juiste te gebruiken

```csharp
[System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet ###### System.Runtime.InteropServices.CharSet.Unicode, SetLastError  true)]
    [return: System.Runtime.InteropServices.MarshalAs(System.Runtime.InteropServices.UnmanagedType.Bool)]
    static extern bool SetDllDirectory(string lpPathName);
```

```csharp
    [STAThread]
    static void Main()
    {
        int wsize = IntPtr.Size;
        string libdir ###### (wsize  4)?"x86":"x64";
        string appPath = System.IO.Path.GetDirectoryName(Application.ExecutablePath);
        SetDllDirectory(System.IO.Path.Combine(appPath, libdir));
        // ...
    }
```

Zie ook [http:*stackoverflow.com/questions/13028069/unable-to-load-dll-sqlite-interop-dll](http:*stackoverflow.com/questions/13028069/unable-to-load-dll-sqlite-interop-dll)

#### .NET dates en SQLite dates 

Als je een `DATE` kolom hebt, en een SQL zoals gewoon `select * from blah;` uitvoert, kan je de volgende fout krijgen:

```
String was not recognized as a valid DateTime
```

Dit komt doordat SQLite dynamisch getypeerd is en voor hem een date hetzelfde als een char is, gebruik daarvoor de `date()` functie om zelf te parsen! Beetje vervelend in de queries...

Een andere mogelijkheid is `DateTimeFormat=Ticks` in de connection string meegeven. 

#### Creating integration tests, using Record objects 

Maak objecten die extenden van `DatabaseInsertable`:

```csharp
    public abstract class DatabaseInsertable
    {
        protected abstract string GetTable();

        public override string ToString()
        {
            var fieldDict = FieldDictionary();
            var fields = "(" + string.Join(",", fieldDict.Keys) + ")";
            var values = "(" + string.Join(",", fieldDict.Values) + ")";

            return "insert into " + GetTable() + fields + " values " + values;
        }

        public void Save()
        {
            DbConnection.Instance.CreateCommand(ToString()).ExecuteNonQuery();
        }

        private Dictionary<string, string> FieldDictionary()
        {
            var dictionary = new Dictionary<string, string>();

            foreach (var info in this.GetType().GetFields())
            {
                if (info.GetValue(this) != null)
                {
                    dictionary.Add(info.Name, "'" + info.GetValue(this).ToString() + "'");
                }
            }

            return dictionary;
        }
    }
```

Zoals bijvoorbeeld

```csharp
    internal class UnitRecord : DatabaseInsertable
    {
        public string creator;
        public string guid;

        protected override string GetTable()
        {
            return "UNIT";
        }
    }
```

Gebruik:

```csharp
new UnitRecord() { creator ###### "bla"; guid  "lala"; }.Save(); // done!
// execute your SUT stuff here
```

`DbConnection` gebruikt dan de SQLite versie om een "unit" record aan te maken in de DB. Merk op dat de properties 100% moeten overeenkomen. 

Het enige speciale wat in `IntegrationTestCase` gedefiniëerd is, is de "gewone" `OleDbConnection` vervangen door de SQLite verie:

```csharp
    public abstract class IntegrationTestCase
    {
        protected SqLitedbConnection connection;

        [TestInitialize]
        public void CleanDb()
        {
            this.connection = new SqLitedbConnection();
            DbConnection.Instance = connection; // instead of OleDbConnection, lazyloaded singleton getter property. 
        }
    }
```

Omdat Ole en SQLite soms andere interfaces hebben moeten we er zelf een anticorruptie laag (de IConnection interface) tussen zetten:

```csharp
    using System.Collections.Generic;
    using System.Data;
    using System.Data.Common;

    public interface IdbConnection
    {
        object QueryProcedure(string procedure, IDictionary<string, object> parameters, string outputParameter);

        DbParameter CreateParameter(string field, object value);

        DbCommand CreateCommand(string query);

        DataSet Query(DbCommand command);

        DataSet Query(string query);
    }
```

Het verschil is altijd een `SQLiteCommand` in plaats van een `OleDbCommand` aanmaken. Er zijn soms ook subtiele verschillen in het aanmaken en doorgeven van de parameters. 