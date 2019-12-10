---
title: 'Versiebeheer'
accent: "#008eb3"
disableList: true
---

&laquo;&nbsp;[Terug naar Software Engineering Skills](/teaching/ses)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## Wat is versiebeheer of _source control_?

**[Source Control](https://en.wikipedia.org/wiki/Version_control)** is een sleutelbegrip voor ontwikkelteams. Het stelt iedereen in staat om aan dezelfde source file te werken zonder bestanden op- en neer te sturen, voorziet backups, maakt het mogelijk om releases en branches uit te rollen, ...

Een versiebeheer systeem bewaart alle _wijzigingen_ aan (tekst)bestanden. Dat betekent dat eender welke wijziging, door wie dan ook, teruggedraaid kan worden. Zonder versiebeheer is het onmogelijk om code op één centrale plaats te bewaren als er met meerdere personen aan wordt gewerkt. Zelfs met maar één persoon is het toch nog steeds sterk aan te raden om te werken met versionering. Fouten worden immers snel gemaakt. Een bewaarde wijziging aan een bestand is permanent op je lokale harde schijf: de volgende dag kan je niet het origineel terug boven halen. Er wordt samen met delta's ook veel metadata bewaard (tijdstippen, commit comments, gebruikers, bestandsgroottes, ...)

### Waarom versioneren?

Dat verduidelijkt Geek & Poke:

<center>
    <img src="/img/teaching/ses/sourcecontrol.jpg" style="width: 70%" />
</center>

Zonder versionering stuurt iedereen e-mail attachments door naar elkaar, in de verwachting een aangepaste versie terug te ontvangen. Maar, wat gebeurt er met:

- Conflicten? (iemand wijzigt iets in dezelfde cel als jij)
- Meerdere bestanden? (je ontvangt verschillende versies, welke is nu relevant?)
- Nieuwe bestanden? (je ontvangt aparte bestanden met nieuwe tabbladen)
- Bestandstypes? (iemand mailt een `.xslx`, iemand anders een `.xls`)
- ...

Het wordt al snel duidelijk dat het delen van celdata beter wordt overgelaten aan Google Sheets, waar verschillende mensen tegelijkertijd gegevens in kunnen plaatsen. Hetzelfde geldt voor source code: dit wordt beter overgelaten aan een versiebeheer systeem. 

## In de praktijk: Git

Git is een _gedecentraliseerd_ versiebeheer systeem waarbij de hele repository inclusief historiek lokaal wordt geplaatst zodra een `clone` commando wordt uitgevoerd. Oudere _gecentraliseerde_ systemen zoals SVN en CVS bewaren (meta-)data op één centrale plaats: de version control server. Voor dit vak wordt resoluut voor git gekozen. 

Vanaf nu wordt verondersteld dat labo oefeningen gecommit worden in `git` op [Github](https://github.com): een zeer populair open source software ontwikkelingsplatform dat gebruiksvriendelijk is. Het [Pro Git](https://git-scm.com/book/en/v2) handboek leert je alles over de werking van git. 

### De Git workflow

Een typische workflow is als volgt:

1. `git clone [url]`: Maakt een lokale repository aan die je op Github hebt gecreëerd. Het commando maakt een subdirectory aan.
2. Doe je programmeerwerk.
3. `git status` en `git diff`: Bekijk lokale changes voordat ze naar de server gaan.
4. `git add [.]`: Geef aan welke changes staged worden voor commit
5. `git commit -m [comment]`: commit naar je **lokale** repository. Wijzingen moeten nu nog naar de Github server worden gesynchroniseerd. 
6. `git push`: push lokale commits naar de Github server. Vanaf nu kan eender wie die meewerkt aan deze repository de wijzigingen downloaden op zijn lokaal systeem.
7. `git pull`: pull remote changes naar je lokale repository. Wijzigingen moeten altijd eerst gepushed worden voordat iemand anders kan pullen. 

De output van `git status` ziet er zo uit:

<pre>
Wouters-MacBook-Air:brainbaking wgroenev$ git status
On branch master
Your branch is up-to-date with 'origin/master'.

Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   content/teaching/cpp/labo-1.md
    modified:   content/teaching/cpp/labo-2.md
    modified:   content/teaching/cpp/labo-3.md
    modified:   content/teaching/cpp/labo-4.md
    modified:   content/teaching/cpp/labo-5.md
    modified:   content/teaching/cpp/labo-6.md
    deleted:    docs/CNAME
    deleted:    docs/essays/i-am-jealous-of-my-dog/index.html
</pre>

De output van `git diff` ziet er zo uit:

<pre>
    Wouters-MacBook-Air:brainbaking wgroenev$ git diff
diff --git a/content/teaching/cpp/labo-1.md b/content/teaching/cpp/labo-1.md
index 654a4f6..11f0597 100644
--- a/content/teaching/cpp/labo-1.md
+++ b/content/teaching/cpp/labo-1.md
@@ -4,7 +4,7 @@ accent: "#008eb3"
 disableComments: true
 ---
</pre>

Waarbij de `+++` regels wijzigingen zijn die zijn toegevoegd, en `---` die zijn verwijderd. Zowel bestanden als regels binnen bestanden zijn zichtbaar in de _difference_ tool. 

### Conflicten oplossen

Zie hoofdstuk 2 van het Pro Git boek.

### Branches

Zie hoofdstuk 3 van het Pro Git boek.

## <a name="oef"></a>Labo oefeningen

1. Maak een Github.com account aan, als je dat nog niet hebt. Download zowel de UI - [Github Desktop](https://desktop.github.com) - als de commandline tools [Git for Windows](https://gitforwindows.org), en probeer de [SESsy library](/teaching/ses/sessy) te clonen: `git clone https://github.com/KULeuven-Diepenbeek/sessylibrary.git`
2. Maak een nieuwe repository aan onder je eigen account. Commit enkele test `.java` betsanden. Maak een branch, wijzig een bestand, en push dat naar die branch. Probeer daarna de branch terug te mergen met de main branch (= de master).
3. Vraag aan je rechterbuur om _collaborator_ te worden op een nieuwe repository. (Github.com -> settings van repository -> Add collaborators). Dit betekent dat die persoon voldoende rechten krijgt om bestanden te wijzigen. Schrijf samen een `README.md` bestand met een verhaaltje in. De eerste die commit en pusht krijgt zijn wijziging er door, de volgende moet eerst conflicten oplossen. 

## Denkvragen

- In welk geval is het aanmaken van een branch een goed idee, in plaats van verder te werken op de (enige) master branch? Lees eerst het Pro Git boek hoofdstuk over branches.
- In welk geval is het pushen van wijzigingen vanuit een branch naar de master branch een goed idee? Wanneer niet?

## Extra leermateriaal

- [Pro Git](https://git-scm.com/book/en/v2) handboek, hoofdstuk 1 tot en met 3.

