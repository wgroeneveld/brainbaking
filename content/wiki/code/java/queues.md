+++
title = "queues"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "queues"
]
date = "2013-03-12"
+++
# code:java >> Queues 

Zie ook [code/java/monitoring]({{< relref "wiki/code/java/monitoring.md" >}}) om JMX te enablen.

## Via JMX (HornetQ) queues leegmaken 

Dit is een `TestExecutionListener` die je met `@TestExecutionListeneres` kan gebruiken om na elke test de queues leeg te maken:

```java
public class QueueCleanerContextListener extends AbstractTestExecutionListener {

	public void cleanQueues() throws Exception {
		InitialContext initialContext = null;
		JMXConnector connector = null;
		try {
			connector = connectToQueue();
			for (String queue : getJMSServerControl(connector).getQueueNames()) {
				getJMSQueueControl(connector, queue).removeMessages(null);
			}
		} finally {
			connector.close();
			if (initialContext != null) {
				initialContext.close();
			}
		}
	}

	private JMXConnector connectToQueue() throws IOException, MalformedURLException {
		return JMXConnectorFactory.connect(new JMXServiceURL(buildJMXUrl()), new HashMap<String, Object>());
	}

	private String buildJMXUrl() {
		return "service:jmx:rmi:*/jndi/rmi:*localhost:3000/jmxrmi";
	}

	private JMSQueueControl getJMSQueueControl(JMXConnector connector, String queueNaam) throws IOException, Exception {
		MBeanServerConnection mbsc = connector.getMBeanServerConnection();

		return (JMSQueueControl) MBeanServerInvocationHandler.newProxyInstance(mbsc,
				ObjectNameBuilder.DEFAULT.getJMSQueueObjectName(queueNaam), JMSQueueControl.class, false);
	}

	private JMSServerControl getJMSServerControl(JMXConnector connector) throws IOException, Exception {
		MBeanServerConnection mbsc = connector.getMBeanServerConnection();

		return (JMSServerControl) MBeanServerInvocationHandler.newProxyInstance(mbsc,
				ObjectNameBuilder.DEFAULT.getJMSServerObjectName(), JMSServerControl.class, false);
	}

	@Override
	public void afterTestMethod(TestContext testContext) throws Exception {
		cleanQueues();
	}
}
```

## Hoeveel berichten zitten er nog op mijn queue? 

Zie boven, gebruik `JMSQueueControl`:

```java
String filter = ""; // if subset counting is required
JMSQueueControl control = fetchQueue(); // see above
control.countMessages(filter); // is a long
```