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
    "queues"
]
date = "2013-03-12"
+++
# Queues 

## HornetQ 

##### queues definiëren 

in `hornetq-jms.xml`: 

```xml
 <queue name="blaQuezue">
      <entry name="/queue/app/queueName"/>
   </queue>
```

### store-and-forward systeem opzetten 

HornetQ werkt met `bridges` die je moet configureren in de `hornetq-configuration.xml`:

```xml
	<bridges>   
		<bridge name="system1-store-and-forward">
			<queue-name>jms.queue.fromQueue</queue-name>
			<forwarding-address>jms.queue.toQueue</forwarding-address>
			<static-connectors>
				<connector-ref>forward-to-hornetq-connector</connector-ref>
			</static-connectors>     
		</bridge>    
  	</bridges>

   <connectors>
      <connector name="forward-to-hornetq-connector">
         <factory-class>org.hornetq.core.remoting.impl.netty.NettyConnectorFactory</factory-class>
         <param key######"host"  value"forwardToAddress"/>
         <param key######"port"  value"5445"/>
      </connector>
  </connectors>
```

Waarbij de bridge die gebouwd wordt verwijst naar een connector, hier dus `connector-ref` **forward-to-hornetq-connector** die op een andere server kan draaien (`forwardToAddress`) - maar dat kan evengoed localhost zijn. 