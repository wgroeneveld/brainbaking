+++
title = "strategie"
draft = false
tags = [
    "code",
    "java",
    "testing",
    "strategie"
]
date = "2013-05-17"
+++
# Test strategie 

Er zijn verschillende soorten testen en deze komen (eventueel) in elke laag terug.

## Unit testen 

	* Wat? Testen of een kleine unit/component op zich werkt.
	* Welke gevallen? alle gevallen: elk successpad (alle boundary conditions), alle mogelijke failure paden
	* Eventueel vriendjes van deze component wegmocken (let op voor mockitis!)
	* Testen zonder databank of andere integratie (rest calls)
	* Extenden van BaseTestCase -> NOOIT meer `[MockitoAnnotations.initMocks(this)](http://mockito.googlecode.com/svn/branches/1.6/javadoc/org/mockito/MockitoAnnotations.html)` uitvoeren!! We gebruiken nu de PowerMockRunner.
	* Elke entity/aggregate root moet een xxxBuilder klasse hebben om test data te maken.

Bijvoorbeeld bij web testen is het meestal beter om de stubs van ActionMapping, HttpServletRequest etc te gebruiken dan een mock aan te maken. -> 

```java
public void BlaActionTest extends StrutsTestCase {
  @Test
  public void testDit() {
	 action.doeIets(mappingStub, requestStub, ...) // ipv mock
  }
}
```

Opletten met PowerMock static mocks - zo weinig mogelijk gebruiken, de `PowerMock` class loader is nogal een memory-hog.

We gebruiken nu in plaats van Hamcrest assertThat altijd FEST Assert.
Manual/wiki hier: http://docs.codehaus.org/display/FEST/FEST-Assert
Het komt erop neer dat je nooit meer dan 1x hoeft te static-importen door `assertThat(blabla).isX().hasY()`... en alles (indien gewenst) te chainen.

## Integratie testen 
	* Testen dat de integratie van een aantal componenten met een extern infrastructure systeem correct werkt
	* Test persistentie van domain objecten + queries : d.i. integratie met databank
	* Extenden van IntegrationTestCase

## Postdeploy testen 
	* Testen dat de applicatie als geheel werkt.
	* Testen vereisen een gedeployde applicatie 
	* [code/java/testing/selenium]({{< relref "wiki/code/java/testing/selenium.md" >}}). Voor specifieke commando's van selenium en pitfalls, zie de wiki link!

:exclamation: **Argument Catching matchers** - Indien je denkt deze matcher nodig te hebben bij het unit testen is het misschien beter om na te denken over de implementatie die getest wordt. Zit deze OK in elkaar qua design? Meestal helpt een beetje refactoren beter dan die matcher te schrijven of je integratie-test een klein stukje.

:exclamation: **Falende Selenium Testen** - Best eens nakijken of er geen testen ontbreken in de code die dit zou moeten opvangen. Anders wordt er te veel berust op de selenium testen die alles zouden moeten afdekken. 

# Testen per Laag 

## Domein 

Alle domain code wordt geunit-tested.

Alle persistentie code (elk veld) wordt geïntegratietested
	* elk field op een entity/aggregateroot
	* elke relatie tussen entities/aggregateroots
	* elke query + fields waar men op kan filteren

## Presentatie 

Dit zijn selenium testen, waarbij men het volgende wil testen:
	* Of het scherm in het algemeen "werkt" door de titel te asserten (ipv verify: direct falen dan)
	* Of ik velden kan invullen en saven, en daarna terug kan opvragen
	* Of ik wanneer het kan bepaalde velden *in bepaalde gevallen al dan niet kan zien* (combobox hide/show)<br/><br/>Dit is belangrijk!
	* Belangrijke validaties (bijvoorbeeld datum van < datum tot, maar niet ingeldige datum)
	* Of ik records kan verwijderen uit een lijst wanneer mogelijk
	* Flow tussen verschillende schermen: bvb. van aanmaken vreemdeling naar aanvraag naar bepaalde tab
	* Effecten van struts configuratie bvb: errorhandler `DomainValidationExceptionHandler` correct geconfigureerd?

Het is belangrijk om voor Javascript-specifieke zaken ook testen te schrijven omdat bijvoorbeeld [code/jsp/jstl]({{< relref "wiki/code/jsp/jstl.md" >}}) geen exception throwt indien er geen bean gevonden is met dollar.

Unit testen voor de weblaag:
	* Op de form de init aggregate root en update aggregate root (create/update) (en eventueel andere methods)
	* Eventueel: action methodes testen (indien eenvoudig te testen, anders via selenium integratie test)

## Application 

	* In principe zou deze laag heel dun moeten zijn, de logica bevindt zich in de domein laag. De applicatie laag zou enkel mogen delegeren, voor zo'n zaken zijn we eerder pragmatisch en schrijven we geen testen. <br/><br/>
:exclamation: **Let Op** - Wanneer er toch logica in dreigt te komen (bvb `if()... {}`) -> natuurlijk wél testen!

## Infrastructure 
	* Alle code unit testen
	* Hera gateway integratie testen: eventueel in HeraStub een 'speciaal geval' zetten dat een fout genereert zodat je de correct de foutafhandeling test
