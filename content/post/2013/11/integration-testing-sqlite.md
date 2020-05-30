---
title: Integration Testing with SQLite
bigimg: /img/Integration Testing with SQLite.jpg
aliases:
    - /integration-testing-with-sqlite/
    - /post/integration-testing-sqlite/
date: '2013-11-04'
subtitle: Decoupling your integrated database environment from your development.
tags: [ 'unit testing', 'sql', 'CSharp', 'sqlite' ]
---

This article is based on the notes I've collected on [My Wiki](http://brainbaking.com/wiki/code/db/sqlite). 

On previous projects I've worked on, development PCs came with a local version of the database scheme. Each DB change also got rolled out to those computers, which enabled us developers to fool around without breaking anything on the development (or test) environment. This is another step closer to happiness, at least for our proxy customers who didn't have to reinsert their test data every time we flushed something from a table. Sometimes though, there's some lame excuse for not having a local database installed:

- We have a lot of stored procedures and it's too hard to duplicate them locally
- We worked like this for years, why would I want a local DB? 
- But then my data is out of sync! 
- I tried doing that but my manager says I should focus on delivering content
- Blah blah blah

Installing an Oracle XE runtime on your machine might include working around some issues which can take up some time but it's time well invested, compared to multiple developers connecting to one shared database. In any case, there's another possibility: an **in-memory database**, such as [SQLite](http://www.sqlite.org/). This does still require you to keep the upgrade scripts synced, but also enables you to get rid of a lot of annoying things like *foreign key constraints* for testing purposes. 

### Integrating SQLite with .NET

Simply use [System.data.SQLite](http://system.data.sqlite.org/index.html/doc/trunk/www/index.wiki). For each OleDb object, there's an equivalent SQLite one in the correct namespace. The only problem is, some of them don't share an abstract object so you'll have to come up with an anti-corruption layer yourself. Create a connection using this connection string:

        private SQLiteConnection SqLiteDbConnection()
        {
            return new SQLiteConnection()
                {
                    ConnectionString = "Data Source=:memory:;Version=3;New=True;DateTimeFormat=Ticks",
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
		
You need to pay attention to the `DateTimeFormat` substring in the connection string as SQLite is "dynamically typed", compared to Oracle. This means it stores dates exactly the same as chars, otherwise you might encounter an error like `"string was not recognized as a valid DateTime"` when executing a select statement. 

**Watch out with closing the DB Connection** using an in-memory DB; as this completely resets everything. As soon as you open a connection, you can execute create table commands (read your stored DDL file and do it in bulk). 
Your anti-corruption layer between the abstract DB Connection and SQLite/OleDB should expose a few methods. It should be able to query (with or without parameters or providing a `DbCommand`) and possibly stored procedures. This is what I've come up with:

    public interface IdbConnection
    {
        object QueryProcedure(string procedure, IDictionary<string, object> parameters, string outputParameter);
 
        DbParameter CreateParameter(string field, object value);
 
        DbCommand CreateCommand(string query);
 
        DataSet Query(DbCommand command);
 
        DataSet Query(string query);
    }
	
Depending on the implementation, it'll return an `SQLiteCommand` or an `OleDbCommand` instance. 

### Creating integration tests, using Record objects

To be able to quickly insert junk in an in-memory table, I came up with a simple object-table mapping which uses reflection to scan for each property of an object, and map that property to a column in a table. Normally you would simply use your domain objects and issue a `save()` or `persist()` call using for instance `NHibernate` but we didn't have anything like that and this was easy to setup. 

Create an object for each table in your unit test project, extending `DatabaseInsertable`:

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
	
For instance:

    internal class UnitRecord : DatabaseInsertable
    {
        public string creator;
        public string guid;
 
        protected override string GetTable()
        {
            return "UNIT";
        }
    }
	
Now you can simply issue `new UnitRecord() { creator = "bla"; guid = "lala"; }.Save();` and it's saved into the unit table, yay!