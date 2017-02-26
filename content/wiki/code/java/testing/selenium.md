+++
title = "selenium"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "testing",
    "selenium"
]
date = "2014-07-23"
+++
# Selenium Scenario Testing 

Ter info: Webdriver = selenium 2.x.

## Webdriver samen met PhantomJS 

#### opzet 

Headless webdriver testen draaien gaat met `HTMLUnit` - vanaf 2.x zit `org.openqa.selenium.htmlunit.HtmlUnitDriver` ook in de jar. De JS die daar evaluated wordt is echter `Rhino` JS en niet native browser stuff. We kunnen in de plaats [code/javascript/testing/phantomjs]({{< relref "wiki/code/javascript/testing/phantomjs.md" >}}) gebruiken - deze driver zit in een andere jar. In de centrale maven repo:

```xml
		<dependency>
			<groupId>org.seleniumhq.selenium</groupId>
			<artifactId>selenium-java</artifactId>
			<version>2.32.0</version>
			<scope>test</scope>
		</dependency>
		<dependency>
			<groupId>com.github.detro.ghostdriver</groupId>
			<artifactId>phantomjsdriver</artifactId>
			<version>1.0.3</version>
			<scope>test</scope>
		</dependency>
```

[ghostdriver](https://github.com/detro/ghostdriver) is de ingebouwde koppeling tussen phantomjs en webdriver (selenium server). Dit zit ingebouwd in phantomjs als je deze uitvoert met `--webdriver=[port]` - wat de service voor u doet. 

#### In de java code 

Onderstaande voorbeeldcode maakt het mogelijk om zowel met `chrome` als met `phantomjs` te werken:

```java
public abstract class WebdriverTest extends IntegrationTest {

	private static ChromeDriverService service;
	private static WebDriver driver;

	static {
		Runtime.getRuntime().addShutdownHook(new Thread() {

			@Override
			public void run() {
				driver.quit();
				if (service != null) {
					service.stop();
				}
			}
		});
	}

	private static void startService() {
		try {
			service = new ChromeDriverService.Builder()
					.usingDriverExecutable(new File(properties().getChromeDriverExecutable()))
					.usingAnyFreePort().build();
			service.start();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	@Before
	public void gaNaarStartpagina() {
		getDriver().get(vitrineUrl());
	}

	protected static WebDriver getDriver() {
		if (driver ###### null) {
			driver = startDriver();
			driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		}
		return driver;
	}

	private static RemoteWebDriver startDriver() {
		if (properties().isChromeWebdriverNodig()) {
			startService();
			return new ChromeDriver(service);
		}
		return new PhantomJSDriver(phantomJSCapabilities());
	}

	private static DesiredCapabilities phantomJSCapabilities() {
		DesiredCapabilities capabilities = new DesiredCapabilities();
		capabilities.setJavascriptEnabled(true);
		capabilities.setCapability("takesScreenshot", false);
		capabilities.setCapability(PHANTOMJS_EXECUTABLE_PATH_PROPERTY, properties().getPhantomJSExecutable());
		capabilities.setCapability(PHANTOMJS_CLI_ARGS, new String[] { "--webdriver-loglevel=DEBUG" });
		return capabilities;
	}

	protected String toString(DateMidnight date) {
		return date.toString("dd/MM/yyyy");
	}

	protected ZoekPage startPagina() {
		return new ZoekPage(driver);
	}

}
```

essentiëel is het gewoon `new PhantomJSDriver(new DesiredCapabilities())`. 

############= Webdriver samen met IE ############=

######= Opzet ######=

Bij fouten als "Protected Mode must be set to the same value" (zie [hier](https://code.google.com/p/selenium/issues/detail?id=1795) heb je een specifieke switch nodig:

```java
	private static DesiredCapabilities ieCapabilities() {
		DesiredCapabilities capabilities = new DesiredCapabilities();
		capabilities.setCapability(InternetExplorerDriver.INTRODUCE_FLAKINESS_BY_IGNORING_SECURITY_DOMAINS, true);
		return capabilities;
	}
```

Voor de rest is de setup gelijkaardig aan die van chrome - het maken van de service

```java
	private static void startIEService() {
		ieService = new InternetExplorerDriverService.Builder()
				.usingDriverExecutable(new File(properties().getIEDriverExecutable()))
				.usingAnyFreePort()
				.build();
		try {
			ieService.start();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
```

En het maken van de driver via `return new InternetExplorerDriver(ieService, ieCapabilities());`

############= Selenium IDE scenarios opnemen ############=

Zie [Selenium IDE Plugin voor Firefox](http://seleniumhq.org/projects/ide/)

######= identificatie van elementen ######=
Bij voorkeur dien je elke knop, link, invoerveld, enz... een 'id' te geven zodat Selenium dit object op id kan terugvinden. 

In een aantal gevallen is het niet mogelijk om het object op object id terug te vinden. Dit is bijvoorbeeld gegenereerde code van het metis framework. Hieronder een overzicht en welke oplossing best te nemen

  * bvb op Login scherm: klikken op de knop 'inloggen' genereert als target: img[contains(@src,'http:*localhost:8080/Hospes/static/images/form/buttons/key.png')] => hieruit de http:*localhost:8080 weghalen
  * klikken op een menu item registreert vaak enkel het openen van het menu en niet het menu item zelf. Hiervoor kan je firebug nemen om het desbetreffende menu item te inspecten en manueel in de target de juiste target invullen (bvb menuItemText2)

######=click(AndWait)######=

Bij het opnemen van scenario's gaat Selenium bij elke klik op een link, button een 'click' als command registreren. Indien deze click een pagina refresh genereert, moet je manueel het commando vervangen door clickAndWait. Indien je een dubbelklik deed, gaat Selenium IDE ook een click registreren. Deze moet je vervangen door een doubleClickAndWait.

######=Assert / Verify ######=

Wat is het verschil tussen assertX en verifyX? 
assert stopt de test, verify gaat door.
Zie DOC: http://seleniumhq.org/docs/04_selenese_commands.html#assertion-or-verification

Selenium gaat niet automatisch asserts toevoegen. Je kan als het scenario opgenomen is, manueel asserts toevoegen. assertValue, assertTextPresent, assertEnabled, assertDisabled ... .
Een heel aantal asserts kan je door een snelle muisklik toevoegen. 
* Tekst xxx selecteren in de pagina, rechtermuisknop verifyTextPresent xxx aanklikken voegt een commando toe om deze tekst te asserten.
* Een input field: aanklikken, en rechtermuisknop: verifyElementPresent.
* Rechtermuisknop eender waar: Show all available commands: toont alle mogelijke commando's op huidige pagina

######=assertEnabled vs assertEditable######=

assertEnabled bestaat niet, je moet assertEditable gebruiken.

######= goto(label) en looping ######=

Kan met de [sideflow](https://github.com/darrenderidder/sideflow) Selenium IDE plugin voor firefox (custom js file, zie instructies daar)

############= Troubleshooting ############=

###### element is not currently visible and so may not be interacted with ######

Enkele mogelijke problemen:

  1. Scherm resolutie door element dat vanonder op de pagina zit maar nu van de pagina af valt
  2. Z-index: ander element hangt boven het huidig element en er kan niet mee geïnterageerd worden

############= Known Issues ############=

######= Popup in IE verliest sessie ######=
zie ook: http://jira.openqa.org/browse/SRC-501
In onze seleniumtesten omzeild door elke test waarin waitForPopUp voor IE niet uit te voeren ...
 
######= IE en onchange javascript problemen ######=
Elementen waar javascript achter hangt bij een onchange van een element, worden NIET gefired vanuit IE - wanneer men bij selenium een select commando uitvoert. Om de onclick en onchange eventen te laten triggeren moet men ervoor en erna een gewone click uitvoeren. Dus zo:

click(element)
select(element, value)
click(element)

######= IE en hidden elementen problemen ######=
Het is niet mogelijk om verifyTextNotPresent te gebruiken voor een hidden div met wat tekst. Daarvoor moet assertVisible en assertNotVisible gebruikt worden - let op dat de value nu geen tekst waarde maar een selector is zoals alle anderen.

######= IE en verifyValue problemen die af en toe opduiken######=
Soms faalt een verifyValue, omdat de verwachte waarde ook écht niet in het verwachte inputveldje staat. Vermoedelijk heeft het iets te maken met de rendertijd van IE, en wanneer Selenium beslist van te verifyen.
Op te lossen door waitForTextPresent te gebruiken. Het "waitForValue", noch "waitForElement" + "verifyValue" commands werken eveneens niet.

######= click op een link werkt niet (link optesplitst in 2 lijnen) ######=

Known issue, zie http://code.google.com/p/selenium/issues/detail?id=1020

Het probleem is dat selenium `boundingRect` gebruikt en op het midden daarvan klikt, als een link opgesplitst is kan het zijn dat selenium nét niet op de link zelf maar bvb de cell klikt en er niets gebeurt. 