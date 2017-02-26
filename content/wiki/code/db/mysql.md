+++
title = "mysql"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "db",
    "mysql"
]
date = "2014-09-11"
+++
# MySQL 

### DB Syncing 

Mogelijk met verschillende tools, over verschillende DB types heen. Bvb om schema's te syncen tussen MSSQL DBs en MySQL DBs, etc etc. Enkele voorbeeldtools:

  * MSSQL: AdeptSQL Diff [http:*www.adeptsql.com/](http:*www.adeptsql.com/)
  * MYSQL: SQLyog [https:*www.webyog.com/](https:*www.webyog.com/)

Maakt een SQL DDL aan met het verschil tussen database schema's naar keuze. 

<img style='float: left; width: nolink |px;' src='/img//code/db/powertools.png'>

### ADO.NET connection 

##### Pooling 

Enabled by default, zie [Connector .NET Connection options](http://dev.mysql.com/doc/connector-net/en/connector-net-connection-options.html); voorbeeld:

`Server######server; Port3306; Database######db; Uidroot; Pwd######root; Poolingtrue;`

Dingen als maximum pool size, initial size etc ook instelbaar (zie link)

### Monitoring 

##### configuratie properties via SQL uitlezen 

Bijvoorbeeld **max connections**: `show variables like "max_connections";`

Allemaal aanpasbaar via `set global max_connections = 200;` (root rechten required)

##### Aantal momenteel actieve threads bezien 

`SHOW GLOBAL STATUS where variable_name like '%Threads%';` geeft:

```
Variable_name          value
----------------------------
Delayed_insert_threads	0
Slow_launch_threads	0
Threads_cached	8
Threads_connected	56
Threads_created	138
Threads_running	2
```

##### Huidige connecties killen 

Zie [Mass killing of MySQL connections](http://www.mysqlperformanceblog.com/2009/05/21/mass-killing-of-mysql-connections/)

Gaat **niet rechtstreeks**; eerst een file maken met `kill` commands en die dan sourcen in een mysql command line:

`select concat('KILL ', id, ';') from information_schema.processlist where host like '%myhost%' into outfile 'c:<br/>a.txt';`

:exclamation: Forward slashen in Windows gebruiken, of dubbele backslash.

Stap 2: `source c:/a.txt` - géén single quotes hierrond (anders error code 22) en geen single baskslash (anders error code 2, = file not found)

MySQL command line opstarten: ga naar bin dir van installed server, en execute `mysql --user###### --pass`.