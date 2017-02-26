+++
title = "linqtosql"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "csharp",
    "linqtosql"
]
date = "2015-07-14"
+++
# code:csharp >> Linqtosql 

Zie ook [MSDN LinqToSql pagina](https://msdn.microsoft.com/en-us/library/bb425822.aspx)

## Basic 

Principe is een **DataContext** object aanmaken waar je je connectionstring aan meegeeft (`Log` kan naar `Console.Out` ofzo). Vanaf dan via het context object werken:

  * `context.GetTable<T>().Where(t ######> t.Property  x).ToList()` om te queryen
  * bij deleten of wijzigen: `.Attach(entity)` en `.DeleteOnSubmit(entity)`
  * ...

Modellen: annoteren met `[Table(Name######"tabelnaam")]`, kolommen met `[Column(Name"kolomnaam", IsPrimaryKey ###### true, IsDbGenerated  true)]`

Wijzigingen doorvoeren met `SubmitChanges()` door simpelweg properties van modellen te wijzigen, zoals een "echte" ER tool. 

## Advanced 

#### ManyToOne relaties en domain driven design 

In het model: `[Association(ThisKey ###### "ReferenceId", IsForeignKey  true)]` attribuut toevoegen. 

Als je een Fetch wil doen en associaties ook wenst op te halen moet je dit **altijd meegeven**: `new DataLoadOptions().LoadWith<T>(t => t.AssociationProperty)`. Ook deze loadoptions meegeven aan de context. 

Indien dit overgeslagen wordt, zal bij een ToList in LINQ die property niet opgehaald worden. Dit is vervelend om elke keer mee te geven - kan ook generiek, bijvoorbeeld zo:

```csharp
        private static void AddLoadOptions<T>(DataContext context) where T : class, new()
        {
            if (IsAssociation<T>())
            {
                var loadOps = new DataLoadOptions();
                ((IAssociationModel)new T()).AssociationsToLoad(loadOps);
                context.LoadOptions = loadOps;
            }
        }

        private static bool IsAssociation<T>() where T : class, new()
        {
            return typeof(IAssociationModel).IsAssignableFrom(typeof(T));
        }
```

`AddLoadOptions` altijd aanroepen wanneer een fetch in een repository zou gebeuren. Dit zit er op de interface:

```csharp
    public interface IAssociationModel
    {
        IList<object> AssocationsToAttach();

        void AssociationsToLoad(DataLoadOptions loadOps);
    }
```

Zo kan iedere entiteit zijn eigen `LoadWith` oproepen. 

#### Transacties 

Gebruik `TransactionScope` object, aanmaken voor je iets doet en `.Complete()` of `.Dispose()` oproepen. <br/><br/>
Om dit niet de helel tidj zelf te moeten beheren, complexiteit opbergen in een basis Repository klasse, zoiets:

```csharp
            using (var repo = Repository.Instance.Transactional())
            {
               Fetch(); // ...
               Delete(); 
               // ...
            }
```

om dan in de `Dispose()` de transactie te completen. De transactionele method maakt een scope aan. 


## Compleet voorbeeld repository 

```chsarp
    public class Repository : IRepository
    {
        private readonly string _ConnectionString;

        private DataContext _CurrentContext;
        private TransactionScope _TransactionScope;

        public Repository(string connectionString)
        {
            _ConnectionString = connectionString;
        }

        private Repository(Repository baseRepo)
            : this(baseRepo._ConnectionString)
        {
            _CurrentContext = CreateContext();
            _TransactionScope = new TransactionScope();
        }

        public static IRepository Instance { get; set; }

        private bool InTransaction
        {
            get { return _TransactionScope != null; }
        }

        public void Add<T>(T entity) where T : class, new()
        {
            InContext(context =>
            {
                var table = context.GetTable<T>();

                if (IsAssociation<T>())
                {
                    foreach (var toAttach in ((IAssociationModel)entity).AssocationsToAttach())
                    {
                        context.GetTable(toAttach.GetType()).Attach(toAttach);
                    }
                }
                table.InsertOnSubmit(entity);
            });
        }

        public void Add<T>(IEnumerable<T> entities) where T : class
        {
            InContext(context => context.GetTable<T>().InsertAllOnSubmit(entities));
        }

        public void CommitChanges<T>(T entity) where T : class
        {
            InContext(context =>
            {
                var entityTable = context.GetTable<T>();
                if (!InTransaction)
                {
                    entityTable.Attach(entity);
                }
                context.Refresh(RefreshMode.KeepCurrentValues, entity);
            });
        }

        public int Count<T>(ICanModifyIQueryable<T> queryModifier) where T : class, new()
        {
            return InContext(context =>
            {
                AddLoadOptions<T>(context);

                IQueryable<T> list = context.GetTable<T>();

                list = queryModifier.ModifyForCount(list);

                return list.Count();
            });
        }

        public void Delete<T>(T entity) where T : class
        {
            InContext(context =>
            {
                var entityTable = context.GetTable<T>();
                if (!InTransaction)
                {
                    entityTable.Attach(entity);
                }
                entityTable.DeleteOnSubmit(entity);
            });
        }

        public void Dispose()
        {
            CompleteTransaction();
        }

        public List<T> Fetch<T>() where T : class, new()
        {
            return InContext(context =>
            {
                AddLoadOptions<T>(context);
                return context.GetTable<T>().ToList();
            });
        }

        public List<T> FetchBy<T>(Expression<Func<T, bool>> whereClause) where T : class, new()
        {
            return InContext(context =>
            {
                AddLoadOptions<T>(context);

                return context.GetTable<T>()
                    .Where(whereClause)
                    .ToList();
            });
        }

        public List<T> FetchBy<T>(ICanModifyIQueryable<T> queryModifier) where T : class, new()
        {
            return InContext(context =>
            {
                AddLoadOptions<T>(context);

                IQueryable<T> list = context.GetTable<T>();

                list = queryModifier.Modify(list);

                return list.ToList();
            });
        }

        public IRepository Transactional()
        {
            return new Repository(this);
        }

        private static void AddLoadOptions<T>(DataContext context) where T : class, new()
        {
            if (IsAssociation<T>())
            {
                var loadOps = new DataLoadOptions();
                ((IAssociationModel)new T()).AssociationsToLoad(loadOps);
                context.LoadOptions = loadOps;
            }
        }

        private static bool IsAssociation<T>() where T : class, new()
        {
            return typeof(IAssociationModel).IsAssignableFrom(typeof(T));
        }

        private void CompleteTransaction()
        {
            if (_CurrentContext ###### null || !InTransaction)
            {
                return;
            }

            try
            {
                _CurrentContext.SubmitChanges();
                _TransactionScope.Complete();
            }
            finally
            {
                _TransactionScope.Dispose();
                _CurrentContext.Dispose();

                _TransactionScope = null;
                _CurrentContext = null;
            }
        }

        private DataContext CreateContext()
        {
            return new DataContext(_ConnectionString) { Log = Console.Out };
        }

        private void InContext(Action<DataContext> action)
        {
            InContext(context =>
            {
                action(context);
                return true;
            });
        }

        private T InContext<T>(Func<DataContext, T> action)
        {
            var context = _CurrentContext;
            var newContext = false;

            if (context ###### null)
            {
                context = CreateContext();
                newContext = true;
            }

            try
            {
                //      context.Log = Console.Out;
                var value = action(context);
                if (newContext)
                {
                    context.SubmitChanges();
                }
                return value;
            }
            finally
            {
                if (newContext)
                {
                    context.Dispose();
                }
            }
        }
    }
```
