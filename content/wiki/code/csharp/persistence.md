+++
title = "persistence"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "csharp",
    "persistence"
]
date = "2015-07-13"
+++
# Persistence 

## NHibernate 

### Second level caching 

Gebruik [SysCache2](http://www.codeproject.com/Articles/529016/NHibernate-Second-Level-Caching-Implementation) voor Web projecten. Hoe enablen? DLL ref + in config: 

```csharp
            Configuration.SessionFactory().Caching.Through<SysCacheProvider>().WithDefaultExpiration(60);
            Configuration.SetProperty(Environment.UseSecondLevelCache, "true");
            Configuration.SetProperty(Environment.UseQueryCache, "true");
```

In hbm mappings moet je entiteiten cache-baar markeren (read-only, read-write, ... zie docs) met `<cache usage="read-write" />`. Vanaf dan kan je aan Criteria of LINQ queries dingen doen als:

  1. `Session.Query<Obj>().Cachable().List()` of
  2. `Session.CreateCriteria<Obj>().SetCachable(true)`

Groeperen in "regions" is ook mogelijk, mee te geven met criteria.

#### Clearing everything 

```csharp
            SessionFactory.EvictQueries();
            foreach (var collectionMetadata in SessionFactory.GetAllCollectionMetadata())
                SessionFactory.EvictCollection(collectionMetadata.Key);
            foreach (var classMetadata in SessionFactory.GetAllClassMetadata())
                SessionFactory.EvictEntity(classMetadata.Key);
```

#### Using regions 

Sectie toevoegen in `configSections`:

```
<section name######"syscache2" type"NHibernate.Caches.SysCache2.SysCacheSection, NHibernate.Caches.SysCache2"/>
```

En dan dit stuk bijvoorbeeld om syscache2 te configureren:

```
  <syscache2>
    <cacheRegion name######"RegionName" priority"High">
      <dependencies>
        <commands>
          <add name="test"
            command="Select col from dbo.[Table]"
            connectionName="default"
            connectionStringProviderType="Utilities.Connection.SysCache2ConnectionStringProvider, PFW.Utilities"/>
        </commands>
      </dependencies>
    </cacheRegion>
  </syscache2>
```

Queries en entiteiten laten cachen via die naam. 

Er is een standaard connectionStringProvider die uit het `connectionStrings` stuk uit de web/app.config uw string uitleest geïmplementeerd: `ConfigConnectionStringProvider`. Indien iets custom nodig zoals in bovenstaand voorbeeld, afleiden van `IConnectionStringProvider` en zelf de connectionstring voorzien (connectionName wordt als parameter meegegeven maar is in dit geval nutteloos). 

Op database niveau moet je ook nog een aantal dingen nagaan:

  1. Is de dbo user eigenaar van de database voor het region command uit te voeren? (`use [DbName] EXEC sp_changedbowner 'sa`')
  2. Is de broker service actief? Indien neen zet aan, zie [code/db/mssql]({{< relref "wiki/code/db/mssql.md" >}})

### LINQ OR queries schrijven 

AND queries zijn makkelijk te schrijven met `.Where()` chaining in LINQ. Hoe doe je dit met SQL ORs? Met de PredicateBuilder:

```csharp
    /// <summary>
    */ http:*www.albahari.com/nutshell/predicatebuilder.aspx
    /// </summary>
    public static class PredicateBuilder
    {
        public static Expression<Func<T, bool>> And<T>(this Expression<Func<T, bool>> expr1,
            Expression<Func<T, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters);
            return Expression.Lambda<Func<T, bool>>
                (Expression.AndAlso(expr1.Body, invokedExpr), expr1.Parameters);
        }

        public static Expression<Func<T, bool>> False<T>()
        {
            return f => false;
        }

        public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> expr1,
            Expression<Func<T, bool>> expr2)
        {
            var invokedExpr = Expression.Invoke(expr2, expr1.Parameters);
            return Expression.Lambda<Func<T, bool>>
                (Expression.OrElse(expr1.Body, invokedExpr), expr1.Parameters);
        }

        public static Expression<Func<T, bool>> True<T>()
        {
            return f => true;
        }
    }
```

Voorbeeld:

```csharp
            var pred = PredicateBuilder.False<IOccupation>();
            pred ###### pred.Or(occ > new List<decimal>() {1, 2}.Contains(occ.Id));
            pred ###### pred.Or(occ > new List<decimal>() {1, 2}.Contains(occ.Id));
            Session.Query<IOccupation>()
                .Where(pred)
                .ToList();
```

### Sessie contexten 

  * [Current session architecture](http://www.nhforge.org/doc/nh/en/index.html#architecture-current-session)

Te mappen in xml:

```xml
    <property name="current_session_context_class">thread_static</property>
```

Zelf te (un-)binden via:

```csharp
            var session = sessionFactory.OpenSession();
            if (!CurrentSessionContext.HasBind(sessionFactory))
            {
                CurrentSessionContext.Bind(session);
            }
```

Dan kan je `SessionFactory.GetCurrentSession()` gebruiken. 

Een typische manier van werken is session-per-request, in begin van request een sessie openen & binden, en op het einde sluiten. Dit zorgt voor problemen bij asynchrone calls omdat de sessie gebind wordt op `HttpContext` die dan uiteraard verdwenen is. Een tussenoplossing is werken met een hybride sessie context: gebruik de HTTP context indien mogelijk, werk anders met een `ThreadStatic` variabele. Bijvoorbeeld:

```csharp
    public class HybridWebSessionContext : WebSessionContext
    {
        private const string _SessionFactoryMapKey = "NHibernate.Context.WebSessionContext.SessionFactoryMapKey";

        [ThreadStatic]
        private static IDictionary _ThreadSessionMap;

        private ISession ThreadSession
        {
            set
            {
                if (_ThreadSessionMap ###### null)
                {
                    _ThreadSessionMap = new Dictionary<ISessionFactoryImplementor, ISession>();
                }
                if (value ###### null)
                {
                    _ThreadSessionMap.Remove(_Factory);
                }
                else
                {
                    _ThreadSessionMap[_Factory] = value;
                }
            }
        }

        private readonly ISessionFactoryImplementor _Factory;

        // This constructor should be kept, otherwise NHibernate will fail to create an instance of this class.
        public HybridWebSessionContext(ISessionFactoryImplementor factory) : base(factory)
        {
            _Factory = factory;
        }

        protected override IDictionary GetMap()
        {
            var currentContext = ReflectiveHttpContext.HttpContextCurrentGetter();
            if (currentContext != null)
            {
                return ReflectiveHttpContext.HttpContextCurrentItems[_SessionFactoryMapKey] as IDictionary;
            }

            return _ThreadSessionMap;
        }

        protected override ISession Session
        {
            set
            {
                base.Session = value;
                ThreadSession = value;
            }
        }

        protected override void SetMap(IDictionary value)
        {
            var currentContext = ReflectiveHttpContext.HttpContextCurrentGetter();
            
            if (currentContext != null)
            {
                ReflectiveHttpContext.HttpContextCurrentItems[_SessionFactoryMapKey] = value;
                return;
            }
            _ThreadSessionMap = value;
        }
    }
```

Die dan in de hibernate config injecteren:

```csharp
configuration.SetProperty(NHibernate.Cfg.Environment.CurrentSessionContextClass, typeof(HybridWebSessionContext).AssemblyQualifiedName);
```

Op die manier werkt `Bind()` altijd. 

:exclamation: Geen sessie factory sluiten op het einde van de request maar enkel de `ISession` - uw pooling zit in de factory! 

############ Transacties ############

  * [Getting TransactionScope to play nice with NHibernate](http://www.mattwrock.com/post/2010/12/26/Getting-TransactionScope-to-play-nice-with-NHibernate.aspx)
  * [Batching NHibernate's DML Statements](http://thatextramile.be/blog/2008/10/batching-nhibernates-dm-statements/)
  * [NHibernate IPreUpdateEventListener & IPreInsertEventListener](http://ayende.com/blog/3987/nhibernate-ipreupdateeventlistener-ipreinserteventlistener)

######= Multiple nested transactions ######=

is **niet** mogelijk in NHibernate! Hier kan je rond werken door een dummy te retourneren (wel `ISession.BeginTransaction()` decoreren op de onderstaande manier)

```csharp
        public ITransaction BeginTransaction()
        {
            if (_Session.Transaction.IsActive)
            {
                // bad programmer's code, nice going. nested transactions are not supported in NHibernate! 
                * see http:*rajputyh.blogspot.be/2011/02/nested-transaction-handling-with.html and http://stackoverflow.com/questions/1192111/how-do-i-do-nested-transactions-in-nhibernate
                return new HibernateTransactionDummy();
            }

            var newTransaction = _Session.BeginTransaction();
            return newTransaction;
        }
```

######= Locking ######=

[NHibernate mapping & concurrency](http://ayende.com/blog/3946/nhibernate-mapping-concurrency) - pessimistic locking kan gedaan worden door in een query de `LockMode` mee te geven:

```csharp
var person = session.Get<Person>(1,LockMode.Upgrade);
```

Binnen een transactie uiteraard. Dit genereert `with(updlock, rowlock)` in de `SELECT` statements. De lock wordt gereleased wanneer de transactie gecommit wordt. Dit is [blijkbaar geen table lock](http://stackoverflow.com/questions/19873880/understanding-effects-of-with-updlock-rowlock-on-a-query-in-sql-server):

> The `updlock` will place update locks on every row being touched (selected) - so this means until the end of the transaction (explicit or implicit), the row(s) touched by the SELECT will have an update lock on them which allows for other transactions to read, but not update or delete the row. The `rowlock` just indicates that you want row-level locks instead of page or table locks. That lock makes sense if you need to select first, then update a row within the same explicit transaction.

It doesn't make it run any faster, and can cause other transactions to be blocked

############ Event listeners ############

:exclamation: in events als `IPreInsertEventListener` moet je zowel het object (via `@Event.Entity`) als de state (via `@Event.State`) wijzigen. Hoe werkt dit met `IPersistEventListener`?

Custom event listener die de Java annotaties zoals `@PrePersist` ea mogelijk maakt in C# met attributes:

```csharp
    public class HibernateAttributeEventListener : IPreUpdateEventListener, IPreInsertEventListener, IPersistEventListener, IFlushEntityEventListener
    {
        public bool OnPreUpdate(PreUpdateEvent @event)
        {
            InvokeMethodsWithAttribute(@event.Entity, @event.Session, typeof(PreUpdate));
            return false;
        }

        public bool OnPreInsert(PreInsertEvent @event)
        {
            InvokeMethodsWithAttribute(@event.Entity, @event.Session, typeof(PreInsert));
            return false;
        }

        public void OnPersist(PersistEvent @event)
        {
            InvokeMethodsWithAttribute(@event.Entity, @event.Session, typeof(PrePersist));
        }

        public void OnPersist(PersistEvent @event, IDictionary createdAlready)
        {
        }

        public void OnFlushEntity(FlushEntityEvent @event)
        {
        }

        private static void InvokeMethodsWithAttribute(object entity, ISession session, Type attributeType)
        {
            entity.GetType()
                .GetMethods()
                .Where(method => method.GetCustomAttributes(attributeType, false).Length > 0)
                .ForEach(method => Invoke(entity, session, method));
        }

        private static void Invoke(object entity, ISession session, MethodInfo method)
        {
            var parameters = method.GetParameters();
            if (parameters.Length ###### 0)
            {
                method.Invoke(entity, new object[] {});
            } else if (parameters.Length ###### 1 && parameters[0].ParameterType ###### typeof (ISession))
            {
                method.Invoke(entity, new object[] {session});
            }
            else
            {
                throw new ArgumentException("Error while invoking attribute event method, only 0 or 1 params (ISession) is supported!");
            }
        }
```

Dit kan je dan aan de config hangen met `_Configuration.EventListeners.PreInsertEventListeners = new IPreInsertEventListener[] {new HibernateAttributeEventListener()};` - moet per type listener dat je wenst te gebruiken. De attributes zijn zo gedefiniëerd (enkel op method):

```csharp
    [AttributeUsage(AttributeTargets.Method)]
    public class PrePersist : Attribute
    {
    }
```

:exclamation: Indien state wijzigt in `PrePersist` of `PreUpdate` moet je ook de @event.State wijzigen, naast de state van het object zelf. 

Voor details zie [http:*ayende.com/blog/3987/nhibernate-ipreupdateeventlistener-ipreinserteventlistener](http:*ayende.com/blog/3987/nhibernate-ipreupdateeventlistener-ipreinserteventlistener)

Een manier is bvb om dirty field checks te doen met reflectie:

```csharp
        public static Dictionary<string, object> GetFieldValues(this Type type, object obj)
        {
            return type.GetProperties().ToDictionary(
                property => property.Name,
                property => property.GetValue(obj, null));
        }

        private static void Set(IEntityPersister persister, object[] state, string propertyName, object value)
        {
            var index = Array.IndexOf(persister.PropertyNames, propertyName);
            if (index ###### -1)
                return;
            state[index] = value;
        }

// ...
var initialFieldValues = @event.Entity.GetType().GetFieldValues(@event.Entity);
// invoke [makes some fields dirty]
UpdateDirtyFieldValuesInState(@event, state, initialFieldValues);

        private static void UpdateDirtyFieldValuesInState(AbstractPreDatabaseOperationEvent @event, object[] state, Dictionary<string, object> initialFieldValues)
        {
            foreach (var actualValue in @event.Entity.GetType().GetFieldValues(@event.Entity))
            {
                if (!Equals(initialFieldValues[actualValue.Key], actualValue.Value))
                {
                    Set(@event.Persister, state, actualValue.Key, actualValue.Value);
                }
            }
        }

```

############ Identity generators ############

:exclamation: `identity` gebruikt de native autoincrement aan de DB maar is helemaal niet performant, maakt `batch_size` redundant - veel roundtrips nodig. Een alternatief bijvoorbeeld:

  * [NHibernate – Custom Id-generator based on hilo](http://daniel.wertheim.se/2011/03/08/nhibernate-custom-id-generator/)

Zie ook [Hibernate doc: mappings](http://docs.jboss.org/hibernate/orm/3.3/reference/en/html/mapping.html) voor alle mogelijkheden. 

Een custom generator die een tabel gebruikt met een kolom die de entity weergeeft werkt zo:

```csharp
    public class NHibIdGenerator : TableHiLoGenerator
    {
        public override void Configure(IType type, IDictionary<string, string> parms, Dialect dialect)
        {
            if (!parms.ContainsKey("table"))
                parms.Add("table", "NHibHiLoIdentities");

            if (!parms.ContainsKey("column"))
                parms.Add("column", "NextHiValue");

            if (!parms.ContainsKey("max_lo"))
                parms.Add("max_lo", "100");

            if (!parms.ContainsKey("where"))
                parms.Add("where", string.Format("EntityName='{0}'", parms["target_table"]));

            base.Configure(type, parms, dialect);
        }
    }
```

En dan in de hibernate mapping:

```xml
    <id name######"Id" column"`id`">
      <generator class="Utilities.Database.NHibIdGenerator, Utilities" />
    </id>
```

Na de komma staat de full-qualified assembly. 

############ Probleemoplossing ############

###### can only generate ids as part of bulk insert with either sequence or post-insert style generators ######

Identity generator voor die bepaalde tabel moet een custom post-insert generator zijn (zoals bovenstaande `hilo` generator). Waarom? Dit gaat:

  1. eerst in bluk inserts doen
  1. dan in bulk ids bepalen afhankelijk van custom generator (bvb tabel met next id)
  1. dan in bulk update uitvoeren om id te plaatsten in db

Dit betekent ook dat de ID kolom nullable moet zijn en er geen native generator in de weg mag zitten. 

###### There is already an open DataReader associated with this Connection which must be closed first ######

```
Exception: 
Exception has been thrown by the target of an invocation.
Inner Exception: 
MySql.Data.MySqlClient.MySqlException (0x80004005): There is already an open DataReader associated with this Connection which must be closed first. at MySql.Data.MySqlClient.ExceptionInterceptor.Throw(Exception exception) at MySql.Data.MySqlClient.MySqlCommand.Throw(Exception ex) at MySql.Data.MySqlClient.MySqlCommand.ExecuteReader(CommandBehavior behavior) at MySql.Data.MySqlClient.MySqlCommand.ExecuteNonQuery() at MySql.Data.MySqlClient.MySqlTransaction.Rollback() at NHibernate.Transaction.AdoTransaction.Dispose(Boolean isDisposing) in d:<br/>BuildAgents<br/>BuildAgentTwo<br/>work<br/>9126a46c2421d993<br/>PFW.Base<br/>NHibernate<br/>Transaction<br/>AdoTransaction.cs:line 368 at NHibernate.Transaction.AdoTransaction.Dispose() in d:<br/>BuildAgents<br/>BuildAgentTwo<br/>work<br/>9126a46c2421d993<br/>PFW.Base<br/>NHibernate<br/>Transaction<br/>AdoTransaction.cs:line 340 at 
...

Exception:Exception has been thrown by the target of an invocation.Inner Exception:System.InvalidOperationException: There is already an open DataReader associated with this Command which must be closed first. at System.Data.SqlClient.SqlInternalConnectionTds.ValidateConnectionForExecute(SqlCommand command) at System.Data.SqlClient.SqlInternalTransaction.Rollback() at System.Data.SqlClient.SqlInternalTransaction.Dispose(Boolean disposing) at System.Data.SqlClient.SqlTransaction.Dispose(Boolean disposing) at NHibernate.Transaction.AdoTransaction.Dispose(Boolean isDisposing) at PFW.Utilities.Layers.ServiceLayer.TransactionalAttribute.OnExit(MethodExecutionArgs args) at ServiceLayer.Person.PersonBaseSL.Persist(IPersonBase person) at FacadeLayer.Person.PersonBaseRF.Persist(HttpRequest request)  Exception:Exception has been thrown by the target of an invocation.Inner Exception:System.InvalidOperationException: There is already an open DataReader associated with this Command which must be closed first. at System.Data.SqlClient.SqlInternalConnectionTds.ValidateConnectionForExecute(SqlCommand command) at System.Data.SqlClient.SqlInternalTransaction.Rollback() at System.Data.SqlClient.SqlInternalTransaction.Dispose(Boolean disposing) at System.Data.SqlClient.SqlTransaction.Dispose(Boolean disposing) at NHibernate.Transaction.AdoTransaction.Dispose(Boolean isDisposing) at
...
```

Als we kijken in de code van `MySqlCommand` vinden we:

```csharp
    private void CheckState()
    {
      if (this.connection ###### null)
        this.Throw((Exception) new InvalidOperationException("Connection must be valid and open."));
      if (this.connection.State != ConnectionState.Open && !this.connection.SoftClosed)
        this.Throw((Exception) new InvalidOperationException("Connection must be valid and open."));
      if (!this.connection.IsInUse || this.internallyCreated)
        return;
      this.Throw((Exception) new MySqlException("There is already an open DataReader associated with this Connection which must be closed first."));
    }
```

`IsInUse` wordt gezet in de setter van `Reader` in `MySqlConnection`

  * Zowel in `MySqlClient` als `SqlClient`, dus client onafhankelijk
  * Volgens google betekent dit dat we `ISession` objecten delen over verschillende threads/requests

:exclamation: Probleem was dat wij [PostSharp](http://www.postsharp.net/aspects/examples/transaction) gebruiken maar op de attribute class state bijhielden (de transactie zelf) om die bij onexit te kunnen committen. Andere users herbruiken diezelfde klasse blijkbaar, waarbij user1 transacties van user2 gaat committen etc. Correcte implementatie - zie link postsharp als voorbeeld; of:

```csharp
    [Serializable]
    public class TransactionalAttribute : OnMethodBoundaryAspect
    {
        public override void OnEntry(MethodExecutionArgs args)
        {
            NHibernateFactory.CurrentSession.BeginTransaction();
            base.OnEntry(args);
        }

        public override void OnExit(MethodExecutionArgs args)
        {
            NHibernateFactory.CurrentSession.Transaction.Dispose();
            base.OnExit(args);
        }

        public override void OnSuccess(MethodExecutionArgs args)
        {
            NHibernateFactory.CurrentSession.Transaction.Commit();
            base.OnSuccess(args);
        }
    }
```

Blijkbaar mag ook `MethodExecutionArgs` gebruikt worden om tijdelijk state in te storen die je bij `OnExit()` terug kan resolven - zie voorbeeld op de [PostSharp website](http://www.postsharp.net/aspects/examples/transaction).

###### Detached entity passed to persist (in een test) ######

Uw Id niet zelf meegeven, steekt een generator in uw mapping... 

###### System.ArgumentOutOfRangeException : Index was out of range. Must be non-negative and less than the size of the collection. ######

Oplossing: in hibernate mapping file staan twee keer kolommen gedefiniëerd (eventueel onder een `composite-id`) - deze moet `update` en `insert` attributes op `false` hebben, of niet dubbel gemapped worden, hier kan Hibernate blijkbaar niet mee om gaan... 

###### No data type for node [entityProperty] ######

Bij een `HQL` query, wanneer je meer dan 8 properties select, **moet** je een alias gebruiken:

```
select entity.one, entity.two, entity.three, ... from Entity entity where entity.Id in (10, 11)
```

en dus niet

```
select one, two, three from Entity where Id in (10, 11)
```

######  The multi-part identifier "occupation0_.functieid" could not be bound. ######

Impliciete en expliciete joins worden gemixed in uw select statement (al dan niet gewild door NHibernate). Probleem:

```sql
SELECT tbl1.col1, tbl2.col2, tbl3.col3
FROM tbla tbl1, tblb tbl2
   INNER JOIN tblc tbl3 on tbl1.joincol = tbl1.joincol
WHERE tbl1.joincol2 = tbl2.joincol2
AND tbl2.joincol3 = tbl3.joincol3
```

er wordt zowel met `INNER JOIN` als met `WHERE` een join gelegd naar andere tabellen. In MSSQL geeft dit problemen (sommige andere DBs niet?). Mogelijke oplossingen in NHibernate:

  1. Gebruik Criteria om alles expliciet te joinen (joepie...)
  1. Selecteer in een LINQ query geen entiteit maar de Id en map die achteraf 

###### Error Code: 1054. Unknown column 'personlite2_.WerknemerID' in 'on clause' ######

  * Multiple join in HQL die in de verkeerde volgorde staat? Draai `join x as y join y as z` eens om, zodat de joins andersom gelegd worden.

Concreet voorbeeld:

```sql
SELECT col1, col2, col3 
FROM bliebloe
INNER JOIN tabel alias ON alias.x = bliebloe.y,
col4,
INNER JOIN tabel2 alias2 ON alias2.x = bliebloe.y
```

Zou moeten zijn:

```sql
SELECT col1, col2, col3 
FROM bliebloe
INNER JOIN tabel alias ON alias.x = bliebloe.y,
INNER JOIN tabel2 alias2 ON alias2.x = bliebloe.y,
col4
```

Maar hoe vertellen we `Hibernate` dit? **zet expliciete joins in uw HQL** in de gewenste volgorde:

''select a.x, b.y, c.z
from a
join a.h as b
join a.i as c''

  * In MySQL: syntax join mixen ###### no go, zoals select * from table1, table2 where table1.id  table2.key join bla join blie - zowel met komma als met de join operator joinen. Doet Hibernate normaal niet. 