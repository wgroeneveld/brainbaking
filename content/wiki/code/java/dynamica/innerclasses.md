+++
title = "innerclasses"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "dynamica",
    "innerclasses"
]
date = "2013-03-12"
+++
# code:java:dynamica >> Innerclasses 

Java is geen dynamische taal maar je kan wel gebruik maken van een aantal handige trucjes om duplicatie te vermijden. 
Bijvoorbeeld om **state bij te houden** en de implementatie zelf in een **inner klasse** te voorzien:

```java
    private interface CrmEndpointWorker {
        void call(Holder<Status> status, Holder<String> result);
    }

    public CrmImportGatewayAction forCreation() {
        return new CrmImportGatewayAction(Action.CREATE);
    }

    public CrmImportGatewayAction forUpdating() {
        return new CrmImportGatewayAction(Action.UPDATE);
    }

    public CrmImportGatewayAction forDeletion() {
        return new CrmImportGatewayAction(Action.DELETE);
    }

    public CrmImportGatewayAction forDeactivating() {
        return new CrmImportGatewayAction(Action.DEACTIVATE);
    }

    public class CrmImportGatewayAction {

        private final Action actionType;

        public CrmImportGatewayAction(Action actionType) {
            this.actionType = actionType;
        }

        private CrmEndpointWorker accessdeviceAction(final List<Accessdevice> devices) {
            return new CrmEndpointWorker() {

                @Override
                public void call(Holder<Status> status, Holder<String> result) {
                    getEndpoint().accessdeviceAction(actionType, new CrmConverter().convertDevices(devices), status, result);
                }
            };
        }

        public String sendAccessdevices(List<Accessdevice> devices) {
            return callCrmEndpoint(accessdeviceAction(devices));
        }
    }
```

Wat is hier cool aan?
In plaats van 4 verschillende methods te voorzien op deze klasse:

  * voor creation
  * voor deletion
  * voor updating
  * voor activating

Kan je dit nu zo doen:

```java
service.forCreation().sendAccessdevices();
service.forDeletion().sendAccessdevices();
```

En de `Enum actionType` is toegankelijk binnen die inner klasse en wordt zo mee doorgegeven naar in dit geval de SOAP Endpoint call. 

Prachtig, toch?