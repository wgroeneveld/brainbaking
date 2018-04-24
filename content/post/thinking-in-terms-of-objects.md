---
title: 'Denken in termen van objecten'
date: '2018-04-25'
subtitle: Software ontwerp in termen van objecten
tags:
- tech
- teaching
published: true
---

Software schrijven is niet veel anders dan een wereld beschrijven. Dé wereld, waarin wij leven, is één wereld. Met software kunnen we dus theoretisch gezien onze wereld beschrijven. Als we even niet aan software ontwikkeling denken, hoe beschrijven we dan een of de wereld? Hoe bouw ik een fantasie wereld op in een roman waarbij mijn lezers zich comfortabel kunnen inleven in die wereld? 

Door **beschrijvingen** met behulp van onze **taal**. Of deze beschrijving een a priori of a posteriori redenering is maarkt niet uit. 

Ik kan het volgende beweren:

	"twee plus drie is vijf" 

Hier zijn geen zintuigen mee gemoeid, en dit is een tautologie. (A = A, 2 + 3 = 5, de linkerkant van de vergelijking is de rechterkant en omgekeerd.) 
Deze uitspraak kan je moeilijk in een object steken, want als we deze zin deconstrueren, kunnen we de volgende elementen er uit halen:

- wat is "plus" (een operatie)
- wat is "twee" en "drie" en "vijf" (een getal)
- wat is "is" (de gelijkstelling)

De "operatie" is iets wat we met "getallen" kunnen doen. Ik zet hier "operatie" tussen haakjes omdat het een eigenschap aanduidt op het tweede woord tussen haakjes, "getal". We leiden dus het volgende object af met de volgende eigenschappen:

	Getal {
		plus(Getal ander);
	}

Ik kan als tweede voorbeeld het volgende beweren:

	"Een boom heeft een groen blad"

Dit is duidelijk een a posteriori uitspraak: om dit te kunnen verifiëren zou ik met mijn ogen moeten zien dat het blad "groen" is. 
Hier kunnen we veel makkelijker eigenschappen en objecten uit deduceren:

- wat is "boom" (een "iets")
- wat is "heeft" (de eigenschap toekennend)
- wat is "groen" (een eigenschap)
- wat is "blad" (een eigenschap van boom, én een "iets" op zichzelf)

Zodra we ergens in een zin **heeft een x** tegen komen weten we dat we een eigenschap van een "iets" aan het beschrijven zijn. Dus:

	Boom {
		groen blad
	}

Alles tussen de haakjes beschrijft hoe het object genaamd Boom er uit ziet. Een boom heeft een groen blad. Wat is een groen blad?

	Boom {
		Blad {
			groen
		}
	}

"Een boom heeft een groen blad" betekent "Een boom heeft een blad, dat blad **is groen**". Wat betekent "is groen"? "Een boom heeft een blad, dat blad heeft een **kleur**, die kleur **is groen**." We hebben dus nog een extra eigenschap nodig die impliciet uit in de structuur "een groen blad" verborgen zit! 

	Boom {
		Blad {
			kleur: groen
		}
	}

Het schema is verwarrend als we spreken over "Een boom heeft een groen blad" en "Een struik heeft een bruin blad", want dan moeten we:

	Struik {
		Blad {
			kleur: bruin
		}
	}

ook definiëren, en zijn twe twee keer het object "blad" aan het beschrijven, terwijl we het over hetzelfde object hebben. Een "blad" kan ook een "bladzijde" of een A4 pagina betekenen, maar **in context van** struiken en bomen is het duidelijk dat "blad" het blad met fotosynthese betekent. 

	Boom {
		blad(groen)
	}

	Struik {
		blad(bruin)
	}

	Blad {
		kleur
	}

In feite kan ik in mijn eerste bewering dit afleiden: "getallen kun je met elkaar optellen" verder vereenvoudigd tot "getallen kun je met elkaar plussen" en dus "Een getal heeft een plus met een ander getal". 

Merk op dat, in een **formele taal** zoals een programmeertaal, we objecten niet syntactisch exact zoals we de spreektaal hanteren. 

- "Een groen blad" wordt "**object** blad met **eigenschap** kleur die groen **is**"
- "Een luie ambtenaar" wordt "**object** ambtenaar met **eigenschap** karakter die lui **is**"

De impliciete extra eigenschappen die we nodig hebben, "kleur" en "karakter", kunnen op zichzelf staande objecten zijn!

	Kleur {
		Roodwaarde
		Groenwaarde
		Blauwwaarde
		Alfawaarde
	}

	Karakter {
		Goedgezindheid
		Werkgezindheid
	}

De zuivere kleur "groen" is dan Kleur(rood: 0, groen: max, blauw: 0, alfa: max). Het karakter "lui" is dan Karakter(goedgezindheid: ?, werkgezindheid: laag). Een 