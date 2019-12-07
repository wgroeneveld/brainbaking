---
title: 'Labo x: Design Patterns: Facade'
accent: "#008eb3"
disableList: true
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## _"Facade"_ - Design Pattern

### Doelstelling

* Scherm een complex stukje software af met behulp van een simpele interface
* Voorzie éénzelfde interface naar een set van verschillende mogelijke subsystemen. Een Facade is een high-level interface die mogelijks low-level systemen aanspreekt. 

[Dive Into Design Patterns: Facade](https://sourcemaking.com/design_patterns/facade)

### Voorbeeld

#### 1. Opzet

Stel dat we gegevens van de klant moeten versturen naar een overheidsinstantie. Die instantie beschikt jammer genoeg niet over voldoende budgetten om ook een cutting-edge server interface en implementatie aan te bieden. Het komt er op neer dat we verplicht zijn om tekst bestanden op een FTP server te plaatsen. 

```java
class ClientFtpSender {
    public void upload(Client client) {
        // create ftp connection, upload, ...
    }
}
```

Deze code gebruiken we als de gebruiker op een knop genaamd `export`
 klikt:

```java
class ClientHTTPHandler {
    private ClientRepository clientRepository;
    public HTTPResponse onExport(int clientId) {
        Client client = clientRepository.getById(clientId);
        new ClientFtpSender().upload(client);
        return HTTPResponse.success();  // 200 OK
    }
}
```

{{<mermaid>}}
graph LR;
    A[HTTP Handler]
    B[FTP Sender]
    A --> B
{{< /mermaid >}}

#### 2. Probleemstelling

We verkopen onze software aan een andere partij, die niet alleen met de overheid wenst te communiceren, maar ook met een derde instantie. Deze instantie biedt ons de mogelijkheid aan om de klant in de vorm van XML met een `POST` HTTPS call op te sturen. Onze `ClientFTPSender` is dus niet meer genoeg:

```java

class ClientPOSTSender {
    public void upload(Client client) {
        // secure HTTPS, encode client in XML, post...
    }
}
```

Deze complexe stukjes software, de `POST` en `FTP` senders, willen we niet langer rechtstreeks aanspreken in de HTTP handler. Het is zo dat afhankelijk van een bepaalde instelling, het ene of het andere gebruikt kan worden. 


#### 3. Oplossing

We hebben dus **een facade** nodig, die de juiste delegaties voor ons doorvoert, zoals in het volgende schema:

{{<mermaid>}}
graph LR;
    A[HTTP Handler]
    POST[POST Sender]
    FTP[FTP Sender]
    F{Facade}
    A --> F
    F -.-> POST
    F -.-> FTP
{{< /mermaid >}}


Waarbij de Facade een klasse is die de details "wegstopt" voor onze HTTP handler:

```java
class UploadClientFacade {
    public void upload(Client client) {
        if(settings.isPOST()) {
            new ClientPOSTSender().upload(client);
        } else if(settings.isFTP()) {
            new ClientFtpSender().upload(client);
        } else {
            throw new UnsupportedOperationException("settings?");
        }
    }
}
```

### Eigenschappen van dit patroon

* Een Facade is een _nieuwe interface_, niet eentje die oude interfaces herbruikt (Adapter). Beide zijn een soort van **"wrappers"**, die onderliggende implementaties verbergen voor de hogerliggende interface - in ons geval de `ClientHTTPHandler`.
* Het verschil tussen een Facade en een Factory is dat de facade alles verbergt en **logica uitvoert**, terwijl de Factory enkel de juiste instanties **aanmaakt** en teruggeeft. In dat geval zou de handler nog steeds `upload()` zelf moeten uitvoeren, inclusief eventuele encoding stappen.

## <a name="oef"></a>Labo oefeningen

Via [<i class='fa fa-github'></i> Github Classroom](/teaching/ses/github-classroom). 

### Opgave 1

We modelleren een dierentuin, waarvan een `be.kuleuven.ses.facade.animals.Chicken` een gegeven klasse is. Elk dier willen we voederen met de `feed()` methode. Let op! Sommige dieren vereisten veel meer aandracht (lees: complexiteit), die we willen wegwerken met het introduceren van een Facade. 

Voeg klasses `be.kuleuven.ses.facade.animals.Cow` en `Cat` toe, geef deze ook eten, en verberg dan het voederen in een aparte interface. 

### Opgave 2

[sessy library](/teaching/ses/sessy): 

1. identificeer waar jij denkt dat een facade nodig zou kunnen zijn. Waar moet logica worden afgeschermd? 
2. Pas het patroon toe waar jij denkt dat het nodig is. 

## Denkvragen

* Op welk moment beslis je dat een Facade écht nodig is? Is het mogelijk om ook een facade te maken zonder bijvoorbeeld nieuwe dieren in oefening 1 of een nieuwe verzendmethode voor de klant bij de probleemstelling? 
* Kan een Facade een Facade verbergen? Wanneer is dat nodig, of niet?
