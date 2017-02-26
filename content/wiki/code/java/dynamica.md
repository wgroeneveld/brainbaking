+++
title = "dynamica"
draft = false
tags = [
    "",
    "Users",
    "jefklak",
    "Downloads",
    "pages",
    "code",
    "java",
    "dynamica"
]
date = "2013-03-12"
+++
# Dynamica 

Hier zitten stukjes code om java meer dynamiek te geven (voorzover dat mogelijk is...)

Veel collectie gerelateerde dingen (`filter`, `map` etc) is reeds geïmplementeerd: http://code.google.com/p/guava-libraries/

### Reduce met optellen 

```java
public class CollectionUtil {

	public static interface EnkelvoudigeTeller<TellerType> {
		boolean magMeegeteldWorden(TellerType object);
	}

	public static interface MeervoudigeTeller<TellerType> {
		int geefAantalMeegeteld(TellerType object);
	}

	public static <TellerType> int tel(Collection<TellerType> objecten, MeervoudigeTeller<TellerType> teller) {
		int geteld = 0;
		for (TellerType object : objecten) {
			geteld += teller.geefAantalMeegeteld(object);
		}
		return geteld;
	}

	public static <TellerType> int tel(Collection<TellerType> objecten, final EnkelvoudigeTeller<TellerType> teller) {
		return tel(objecten, new MeervoudigeTeller<TellerType>() {

			@Override
			public int geefAantalMeegeteld(TellerType object) {
				return teller.magMeegeteldWorden(object) ? 1 : 0;
			}
		});
	}
}
```