+++
title = "logging"
draft = false
tags = [
    "code",
    "java",
    "logging"
]
date = "2013-03-12"
+++
# code:java >> Logging 

## Log4j Gebruiken over verschillende threads heen 

**Probleem**: JMS handlers die bijvoorbeeld tegelijk starten en loggen naar éénzelfde file met `Logger.getLogger(x)`. Als een thread crasht en de andere afwerkt, maar we de volgorde van wegschrijven niet kunnen garanderen, hoe kunnen we dan dit onerscheid maken? 

Oplossing: met `NDC` (Nested Diagnostic Context) - zie http://logging.apache.org/log4j/1.2/manual.html

Voorbeeld:

```java
	protected static final Logger jmsLogger = Logger.getLogger("jmsLogger");

	private void log(String message) {
		jmsLogger.info("Incoming JMS Message (" + getClass().getSimpleName() + "): " + message);
	}

	@Override
	public void doHandle(String textMessage) {
		try {
			String usernameFromTextMessage = getUsernameFromTextMessage(textMessage);
			NDC.push(currentThread().getName() + "#" + currentThread().getId() + "@" + usernameFromTextMessage);
			log("Started handling: " + textMessage);

			VacatureSecurityInitializer.initConsulentUserInContext(usernameFromTextMessage);
			handleTextMessage(textMessage);

			log("Completed handling");
		} finally {
			resetSecurityContext();
			NDC.pop();
		}
	}
```

`NDC.push()` zou een unieke parameter moeten binnen pakken, dit wordt geprepend aan de log ouput:

```
[INFO ] 23/03/2012 15:19:07 jmsLogger        - JZAMAN - Incoming JMS Message (VerwijzingVersieVerhoogdHandler): Completed handling
```