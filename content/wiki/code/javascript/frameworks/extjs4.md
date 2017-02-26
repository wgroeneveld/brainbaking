+++
title = "extjs4"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "javascript",
    "frameworks",
    "extjs4"
]
date = "2013-03-12"
+++
# Extjs4 

Documentatie: http://docs.sencha.com/ext-js/4-0/#!/api/

## Aanmaken van klassen en managers die loaden 

Met `Ext.define` maak je een klasse aan, met `Ext.create` maak je een instantie van die klasse. 

Een klasse heeft:

  * configs
  * methods
  * properties
  * events

Waarbij de `configs` de gegevens zijn doorgegeven met accolades:

```javascript
Ext.define('test', {
  // config stuff
});
```

Die configs worden **herbruikt** voor alle instanties die aangemaakt worden met `Ext.create`!! Dat staat op "klasse" niveau (ook al bestaat dat niet in JS...)

## Stores herbruiken 

Gegeven een store:

```javascript
Ext.define('Evita.store.masterdata.KeywordType', {
    extend: 'Ext.data.EvitaStore',
	model: 'Evita.model.parkingfacility.MasterdataType',
    proxy: {
		type: 'evitaAjax',
		api:{
			read: 'getMasterdataKeywordByTypeName.json'
		}
	}
});
```

Gevraagd: hoe herbruik ik die store definitie, terwijl telkens **nieuwe instanties** op de view gebruikt worden, om dan `extraParams` die telkens anders zijn mee te geven met ajax?

:exclamation: reeds `extraParams` opgeven in de store definitie zorgt ervoor dat die proxy herbruikt wordt, wat je hier niet wilt. 

Oplossing: gebruik `Ext.create` in plaats van te refereren naar de `xtype`, die gaat door de `StoreManager` opgezocht & hetbruikt worden anders (1 instantie). 

```javascript
{
		    			xtype : 'combo',
			    		store : Ext.create('Evita.store.masterdata.KeywordType'),
			    		storeMasterdataTypeName: 'MaturityOfParkingFacility',
			    		valueField : 'code',
			    		displayField : 'value',
		    			name : 'maturity',
		    			id: 'ParkingFacilityCreate_masterdata_maturity',
		    		}
```

Loop in de controller over alle stores om dan bvb `extraParams` in te stellen:

```javascript
    	view.down('form').query('combo').forEach(function(combo) {
			combo.getStore().proxy.extraParams['masterdataTypeName'] = combo.storeMasterdataTypeName;
			combo.getStore().proxy.extraParams['countryId'] = wizardData.general.countryId;
    	});
```