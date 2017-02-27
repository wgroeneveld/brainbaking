+++
title = "testing"
draft = false
tags = [
    "code",
    "csharp",
    "testing"
]
date = "2014-06-27"
+++
# Testing met C#/.NET 

## Test frameworks 

### Selenium/WebDriver 

Zie http://www.joecolantonio.com/2012/07/31/getting-started-using-selenium-2-0-webdriver-for-ie-in-visual-studio-c/ - essentiëel identiek aan Java.

#### Chaining - fluent acceptance criteria definitions 

Een typische test zou er dan zo kunnen uitzien:

```csharp
        [Test]
        public void OpenAdminAuthenticationManagement()
        {
            LogInto()
                .OpenAdministrationAuthenticationManagement()
                .AuthenticationGrid
                .ShouldContainMinAmountRows(1)
                .DoubleClickOnRowNr(0)
                .ExpectOpened<ModifyUserDetailWindow>()
                .UserNameShouldContainSomeValue();
        }
```

  1. Gebruik overal `return this`
  2. Wanneer je niet wil upcasten en in een abstract component `ClickSave()` uw subtype moet retourneren: `public class Panel<T> : Window where T : Panel<T>` en `return (T) this`
  3. Wanneer je niet weet wat het volgend scherm is, gebruik `ExpectOpened<Type>()` dat via [code/csharp/reflectie]({{< relref "wiki/code/csharp/reflectie.md" >}}) een instantie aanmaakt van uw component.

### NUnit 

#### Attributes 

Zoals in JUnit's annotaties `@Before` en `@Test` kan je hier `[SetUp]` en `[Test]` gebruiken. Een test klasse moet met de attribute `[TestFixture]` geplakt worden.

Zie [MSTest en NUnit comparison](http://blogs.msdn.com/b/nnaderi/archive/2007/02/01/mstest-vs-nunit-frameworks.aspx)

**Hoe kan ik dit via command-line uitvoeren?**

Installeer [NUnit](http://nunit.org/?p=download) en pas uw `PATH` aan zodat de install dir er in steekt (program files<br/>nunit). Vanaf dan kan je `nunit-console test.dll` via commandline gebruiken om de test zo uit te voeren. 

### MSTest 

#### Attributes 

Zoals in JUnit's annotaties `@Before` en `@Test` kan je hier `[TestInitialize]` en `[TestMethod]` gebruiken. Er zijn enkele "pitfalls" - 

`[ClassInitialize]`, zogezegd het equivalent van `@BeforeClass`, werkt **niet** op base classes: zie http://blogs.msdn.com/b/densto/archive/2008/05/16/using-a-base-class-for-your-unit-test-classes.aspx

Een mogelijke "oplossing" is dit: (let op, niet helemaal hetzelfde)

```csharp
[TestClass]
public abstract class TestBase
{
    [AssemblyInitializeAttribute]
    public static void Initialize(TestContext context)
    {
        // put your initialize code here
    }
}
```

Of overal de base aanroepen... 

## Mocking en stubbing 

### Microsoft Fakes 

Zie http://msdn.microsoft.com/en-US/library/hh549175

Als je `Fakes` toevoegt als reference, gebeurt er het volgende (enkel voor interfaces):

> The special piece of magic here is the class StubIStockFeed. For every interface in the referenced assembly, the Microsoft Fakes mechanism generates a stub class. The name of the stub class is the derived from the name of the interface, with "Fakes.Stub" as a prefix, and the parameter type names appended.

### Rhino Mocks 

Zie http://www.hibernatingrhinos.com/oss/rhino-mocks

##### Automatisch mocking fields initializeren 

```csharp
    public abstract class AbstractTestCase
    {
        [TestInitialize]
        public void CreateMocksBasedOnNamingConvention()
        {
            this.GetType().GetFields(BindingFlags.NonPublic | BindingFlags.Instance).Where(x => x.Name.EndsWith("Mock")).All(InitMock);
        }

        private bool InitMock(FieldInfo field)
        {
            field.SetValue(this, MockRepository.GenerateMock(field.FieldType, new Type[]{}));
            return true;
        }
    }
```

Hupla. 

## Resources en deployment 

[How to deploy files for tests](http://msdn.microsoft.com/en-us/library/ms182475.aspx)

Er moeten aan een aantal condities voldaan worden:

  * een mstest `.testsettings` XML file waar de tag `<DeploymentEnabled/>` op `true` staat (extra te deployen files zijn daar kinderen van) - dit kan automatisch geëdit worden met VS2010 maar blijkbaar niet meer met VS2012... Als de tag zelf niet voorkomt werkt het in 2012 ook nog (?)
  * een resource hebben die op `Content` en `Copy` staat
  * Een `DeploymentItem` attribute hebben die de te kopiëren file specifiëert (merk op dat subfolders hier ook ingevuld moeten zijn)

```csharp
    [TestClass]
    [DeploymentItem("IEDriverServer.exe")]
    public abstract class EndToEndTestCase
    {
    }
```

De deployment items zijn niet nodig als de testen uitgevoerd worden vanuit de bin folder. Meestal is dit een aparte MSTest locatie (temp zoals `C:<br/>Users<br/>bkwog<br/>AppData<br/>Local<br/>Temp<br/>TestResults<br/>bkwog_HI18261 2013-12-23 10_28_54`) waar dan resources niet bij steken maar enkel DLLs en PDBs - bijgevolg problemen... 