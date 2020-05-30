---
title: Metaprogramming instead of duplication
bigimg: /img/Metaprogramming instead of duplication.jpg
date: '2014-03-14'
subtitle: convention over duplication, good or bad?
tags: [ 'CSharp', 'java', 'metaprogramming', 'reflection', 'unit testing', 'mocking' ]
---

So... What's up with all that duplication in your unit tests? Let's take a look at a very recognizable pattern when for instance using `RhinoMock` in `C#`:

        [TestInitialize]
        public void SetUp()
        {
            dbConfigurationMock = MockRepository.GenerateMock<IDbConfiguration>();
            mountPointLoaderMock = MockRepository.GenerateMock<IMountPointLoader>();
            userEnvironmentFactoryMock = MockRepository.GenerateMock<IUserEnvironmentFactory>();
            userEnvironmentLoaderMock = MockRepository.GenerateMock<IUserEnvironmentLoader>();
            // ...

We agreed to suffix each instance variable with 'Mock' if it's a mock. That way, when you scroll down to an actual test case, it's clear to everyone what's what: mocks, stubs, actual implementations, and so forth. So why should I repeat myself again and again but initializing a bunch of mocks using `GenerateMock`? 

In Java using Mockito, the `@Mock` annotation automagically instantiates a mock for you, provided you annotated your test class with `@RunWith(MockitoJUnitRunner.class)`. I would like to apply this pattern to MSTest but there's not a single hook to be found where I can plug in my initialization code. Thanks a bunch. 

Example taken from [Mockito docs](http://docs.mockito.googlecode.com/)

	public class ArticleManagerTest {
	   
	    @Mock private ArticleCalculator calculator;
	    @Mock private ArticleDatabase database;
	    @Mock private UserProvider userProvider;
	   
	    private ArticleManager manager;

Now, this "problem" is easily solved with a bit of metaprogramming and an abstract class:

  - Loop over (private) fields
  - Filter out suffixed with 'Mock'
  - Initialize.

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

Very easy with `LINQ`. The question is - is metaprogramming or reflection in this case "allowed"? Do you think this is "bad" (because it's implicit), or is the convention of suffixing your fields with 'Mock' good enough? The base test case could also be named something like `MockInitializingTestCase` if that makes you feel better. 
