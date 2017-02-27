+++
title = "releasing"
draft = false
tags = [
    "code",
    "build",
    "maven",
    "releasing"
]
date = "2013-03-28"
+++
# Maven Releasing 

Opmerking: de te releasen code zetten onder een folder C:/xxx en niet te diep nesten (CVS kan te lange folder structuur niet uitchecken) 

####  Hoe een maven release uitvoeren ?

  1. (**eenmalig uit te voeren** :exclamation:) voor elke nieuwe release maken we op een gepast moment een CVS 'maintenance release branch' waarop we de laatste bugfixen uitvoeren :
    1. deze zal steeds de vorm 'versiez_y_x' hebben waarbij we z_y vervangen door een TOP release nummer b.v. 'versie2_7_x'
    2. deze branch wordt later ook gebruikt om maintenance releases op uit te voeren (emergency / extra TOP's om bugfixes door te voeren)
    3. gebruik volgend maven commando om de branch aan te maken (gebruik wel de juiste branchname en username/password voor cvs !) :
      1. CVS -->   mvn release:branch -DupdateBranchVersions######true -DupdateWorkingCopyVersionstrue -DbranchName######versiez_y_x -DautoVersionSubmodulestrue -Dusername######xxxx -Dpasswordyyyyy
      2. SVN -->   zelfde als CVS, maar zonder username en password
    4. bij het uitvoeren van het commando komt maven vragen achter het versienummer in de branch en de nieuwe versie in de hoofdbranch.
    5. De branch versie nummer zal 'z.y.0-SNAPSHOT' zijn (in dit voorbeeld '2.7.0-SNAPSHOT')
    6. De hoofdbranch versie zal 'z.y+1-SNAPSHOT' zijn (in dit voorbeeld '2.8-SNAPSHOT'
  2. update het project via wincvs naar de correcte branch 'versiez_y_x' (in het voorbeeld versie2_7_x).
  3. bereidt de nieuwe release voor door het commando mvn release:prepare -Dresume######false  -DpreparationGoals"clean install"  -DautoVersionSubmodules=true -Dusername######xxxx -Dpasswordyyyyy uit te voeren.
  4. Als dit niet lukt met de fout 'address in use', dan moet je de maven opts aanpassen (remote debugging weghalen). Maven zal je vragen achter de release versie nummer (in het voorbeeld wordt dit 2.7.0) en achter de volgende development versie (in het voorbeeld 2.7.1-SNAPSHOT).
  5. finaliseer de release via het commando mvn release:perform  -Dusername######xxxx -Dpasswordyyyyy
  6. pas de pom.xml van relevant projecten aan
  7. pas eventueel de prj/pom.xml & vdabbuild.xml aan om je EAR / WAR automatisch in de deployment TAR te stoppen.

#### Hoe skip ik mijn testen bij een release? 

`-Darguments="-DskipTests"` meegeven