---
title: Custom Webdriver Page Factories
bigimg: /img/Custom Webdriver Page Factories.jpg
date: '2014-09-22'
subtitle: Wrapping WebElements to reduce boilerplate clutter
tags: ['unit testing', 'java', 'C#', 'webdriver', 'scenario testing' ]
---
The problem: Webdriver elements returned by `driver.FindElement()` are too generic. There're the `Text`, `SendKeys()` and `Click()` methods/properties (depending your on C#/Java implementation). The solution is to simply wrap all elements inside custom HTML objects which contain specific methods like `ShouldContainValue` or `Type` (okay, that's a one-to-one mapping with `SendKeys()`, but it's a lot less technical!). Instead of

        [FindsBy(How = How.CssSelector, Using = ".ux-desktop-taskbar-startbutton")]
        private IWebElement startButton;

        [FindsBy(How = How.CssSelector, Using = ".other")]
        private IWebElement whatever;

You'd find code like

        [FindsBy(How = How.CssSelector, Using = ".ux-desktop-taskbar-startbutton")]
        private HTMLSubmitButton startButton;

        [FindsBy(How = How.CssSelector, Using = ".other")]
        private HTMLInputBox whatever;

In java, this is not that difficult. Normally all fields annotated with FindsBy are filled in via reflection with `PageFactory.InitElements()`. (warning: this creates proxies and does not yet actually do the lookup in the DOM tree. This is a good thing, as filling the fields usually happens inside the constructor of a page object.). `initElements` returns the filled page, you can do a few things from there:

- postprocess the page and decorate your fields
- create your own page factory and create your own fields, wrapped around the webdriver proxies

In C#, you're in trouble - the class is sealed, and the proxy classes are internal. Creating your own factory is possible, but produces fuzzy code:

    internal class PageFactory
    {
        private PageFactory()
        {
        }

        private static By FindsByAttributeToBy(FindsByAttribute attribute)
        {
            return (By) typeof (FindsByAttribute).GetProperty("Finder", BindingFlags.NonPublic | BindingFlags.Instance).GetValue(attribute);
        }

        public static void InitElements(IWebDriver driver, object page)
        {
            foreach (FieldInfo field in FindAllFieldsAndProperties(page.GetType()))
            {
                Attribute[] findsByAttribs = Attribute.GetCustomAttributes(field, typeof (FindsByAttribute), true);
                if (findsByAttribs.Length > 0)
                {
                    var findsByAttribute = (findsByAttribs[0] as FindsByAttribute);
                    if (field.FieldType == typeof (IWebElement))
                    {
                        field.SetValue(page, FindElement(driver, FindsByAttributeToBy(findsByAttribute)));
                    }
                    else if (typeof (IEnumerable).IsAssignableFrom(field.FieldType))
                    {
                        field.SetValue(page, FindElements(driver, FindsByAttributeToBy(findsByAttribute)));
                    }
                }
            }
        }

        private static IWebElement FindElement(IWebDriver driver, By by)
        {
        	// warning: create WebProxyElement instead of directly doing a lookup
            return driver.FindElement(by);
        }

        private static IReadOnlyCollection<IWebElement> FindElements(IWebDriver driver, By by)
        {
        	// warning: create WebListProxyElement instead of directly doing a lookup
            return driver.FindElements(by);
        }

        private static IEnumerable<FieldInfo> FindAllFieldsAndProperties(Type type)
        {
            var list = new List<FieldInfo>();
            list.AddRange(type.GetFields(BindingFlags.Instance | BindingFlags.Public));
            for (; type != (Type) null; type = type.BaseType)
            {
                list.AddRange(type.GetFields(BindingFlags.Instance | BindingFlags.NonPublic));
            }
            return list;
        }
    }

If you have a keen eye, you notice a few things:

- caching of the attribute wouldn't work anymore. The default C# WebDriver implementation is fuzzy and I didn't want to copypaste code I won't use.
- proxying won't work anymore, you'd have to use reflection to instantiate internal classes.
- reflection has been used to fetch the `By` instance of the `FindsByAttribute`. Yay.

The above solution is too complex to solve a simple thing. Instead of a custom page factory, in C# we now use extension methods on `IWebElement`. Another possibility would to create wrapper objects on-the-fly but you'd still have to map the "raw" web elements on page objects.
