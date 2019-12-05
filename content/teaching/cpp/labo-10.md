---
title: 'Labo 10: Een introductie in GUI ontwerp met C++ in Qt'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## UI Frameworks

De C++ taal is een krachtige tool om native code te compileren voor specifieke CPU en OS systemen. Daardoor is het ook vaak een logische keuze om complexe interfaces in te ontwerpen en ontwikkelen, van Photoshop tot Google Chrome. Interfaces brengen echter weer andere problemen met zich mee: elk besturingssysteem heeft ondertussen zijn eigen interpretatie.

De Windows standaard was MFC die de WinAPI wrapt, voor OSX was dit de Carbon API. Ondertussen zijn beide frameworks vervangen door WPF (Ook in C#) en Cocoa (enkel in Objective-C). Voor Linux waren er 2 grote Window Managers: KDE en Gnome, die beiden hun eigen UI framework implementeerden: Qt en GTK.

We betreden nu het domein van "frameworks": libraries die we samen met een programmeertaal gebruiken om sneller tot het gewenst resultaat te komen. Het zou nogal dom zijn om elke keer opnieuw een Button in de UI te moeten "uitvinden" - die zijn gewoon meegeleverd als predefined klasse in elk framework.

Wat is een Framework?

> a basic structure underlying a system, concept, or text.

In ons geval een set van libraries waar we mee linken (met `g++`) zodat we `#include <ui_component.h>` in onze code kunnen gebruiken zonder die zelf te moeten maken. Dat brengt buiten een hoop componenten en includes, een aantal erg belangrijke **nadelen** met zich mee:

1. Frameworks leggen vaak een stricte structuur op. Code moet op een bepaalde manier geschreven zijn, zoals voor Qt de `Q_OBJECT` macro in je klasse.
2. Frameworks leven: ze ontstaan, groeien en gaan dood. Dat betekent dat wij als ontwikkelaar een doordachte keuze moeten maken, en na x jaar ons moeten aanpassen.

Qt en GTK zijn _cross-platform_ UI frameworks: die kan je zowel op UNIX als op Windows compilen. Schrijf je je programma met behulp van Qt, dan zal (met minimale aanpassingen) het zowel voor UNIX als voor Windows kunnen compileren, en dan zal je doelpubliek vergroten. Qt werkt zelfs op [iOS](http://doc.qt.io/qt-5/ios-support.html) en [Android](http://doc.qt.io/qt-5/android-support.html) - dus waarom ooit Android-specifieke Widgets leren?

## Het Qt ecosysteem

[Download Qt](https://www.qt.io/download) hier. Je zal merken dat 2gb aan HDD ruimte opgeslokt wordt: dat is erg veel voor een framework! Er zit echter een gigantische hoeveelheid aan bruikbare spullen in:

* Standaard UI componenten
* 2D en 3D rendering in OpenGL
* Een SQL object-mapper interface naar verschillende databases
* XML, JSON, ... support
* Mobile OS support
* Web specifieke componenten
* Netwerk integratie
* Een eigen concurrency model
* ...

Met als belangrijkste extra's Qt Designer en Qt Creator, de grafische UI designer (zoals je SceneGraph kent van JavaFX) en een hele eigen IDE.

<img src="/img/teaching/cpp/qtcreator.png" class="bordered" />

## Een minimale interface ontwerpen

Er zijn zéér veel goede Qt tutorials te vinden, waaronder:

* De ingebouwde tutorials bij het opstarten van Qt Creator
* Qt.io: [Qt for beginners](https://wiki.qt.io/Qt_for_Beginners)
* Qt.io: [Signal Slot syntax](https://wiki.qt.io/New_Signal_Slot_Syntax)
* YouTube: [Qt for beginners video series](https://www.youtube.com/watch?v=VigUMAfE2q4)
* BogoToBogo [Qt5 tutorials](http://www.bogotobogo.com/Qt/Qt5_MainWindowTriggerAction.php)

De beste manier om te leren hoe Qt werkt is met experimentjes in de Creator.

### De layout van een Qt applicatie

In de main.cpp file zal je altijd dit vinden:

```C
#include "mainwindow.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
```

Dit noemen we het **bootstrappen** van de Qt applicatie waarbij je een specifiek scherm aanmaakt en toont. `a.exec()` blokkeert de main thread totdat de UI stopt (bij het afsluiten van alle schermen bijvoorbeeld).

`MainWindow` is een subklasse van `QMainWindow`:

```C
namespace Ui {
  class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_slider_sliderMoved(int position);

private:
    Ui::MainWindow *ui;
};
```

Merk hier framework-specifieke zaken op:

1. De `Q_OBJECT` macro moet in elk Qt object aanwezig zijn dat _signals_ en _slots_ gebruikt.
2. Een private reference naar... jezelf? De Qt Designer genereert code! De forward reference is een reference naar een gegenereerde header file die je zelf nooit mag wijzigen.
3. De `private slots` accessor bestaat natuurlijk niet in C++. Qt voorziet een aparte plek om slots te definiëren.

Qt genereert deze code voor jou - de destructor verwijdert de onderliggende ui pointer met `delete`.

In de source file include je beide headers:

```C
#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}
```

De `setupUi` methode voegt de componenten toe aan het scherm die jij met de Qt Designer op het scherm gesleept hebt. Dankzij deze (ietwat vreemde) manier kan je overal in `MainWindow` met de `ui->` pointer reference aan componten geraken. Merk op dat je dus géén definities van componenten in je eigen header terugziet, die leven allemaal in `ui_mainwindow.h`.

### Slots en Signals

Een actie aan een knop hangen kan op twee manieren: in de Designer of manueel. In beide gevallen gebruik je Qt's **slots** en **signals**. Een "Signal" is een bericht dat uitgestuurd wordt, waarop eender wie kan luisteren. Een "slot" definiëert de ruimte die gebruikt wordt om dat signaal op te vangen. Het concept is hetzelfde als het **observer pattern**.

De volgende code verbindt een progress bar `valueChanged` slot met een C++11 lambda callback als signal:

```C
    connect(ui->progress, &QProgressBar::valueChanged, [](const int &newVal) {
        std::cout << newVal << std::endl;
    });
```

Dit kan je zelf in de constructor van je window toevoegen. `connect` geeft een `QMetaObject::Connection` object terug, zodat je dit kan disconnecten wanneer je zelf wilt.

Een eenvoudigere manier om zaken met elkaar te verbinden is via de UI designer rechtermsuiknop op een element -> "Go to slot..." en een voorstel selecteren. Op dat moment wordt de juiste slot code gegenereerd.

Vergeet `Q_OBJECT` niet als je gebruik maakt van slots en signals.

### Qt's objectenboom

Elk UI object leidt af van `QObject`, net zoals in JavaFX. De [Qt Inheritance Hierarchy](http://doc.qt.io/qt-5/hierarchy.html) is in de documentatie beschikbaar, waarvan voor ons de belangrijkste klassen bijvoorbeeld `QTextEdit` en `QLabel` zijn:

{{<mermaid>}}
graph TD;
  A[QObject]
  B[QThread]
  C[QWidget]
  D[QFrame]
  E[QProgressBar]
  F[QLabel]
  G[QAbstractScrollArea]
  H[QTextEdit]
  I[QGraphicsView]
  J[QAbstractButton]
  K[QPushButton]
  L[QRadioButton]
  B --> A
  C --> A
  D --> C
  E --> C
  F --> D
  G --> D
  I --> G
  H --> G
  J --> C
  K --> J
  L --> J
{{< /mermaid >}}

Voor een eigen widget implementatie lijkt ons overerven van `QWidget` dus een goede keuze.

## Een kijkje achter de C++ extensions

Waar dient die vreemde macro nu eigenlijk voor? Hoe werkt `private slots:`? Qt gebruikt een Meta-Object Compiler ([MOC](http://doc.qt.io/qt-5/moc.html)). Dit programma scant header files en genereert C++ source files met metadata die nodig is om onder andere:

* Slots en signals te laten werken (`signal:`)
* Dynamische properties te kunnen gebruiken (`Q_PROPERTY`)
* Run-time type informatie te kunnen lezen (`Q_CLASSINFO`)

Die gegenereerde source file moet ook meegecompileerd worden. Qt projecten worden meestal met `QMake` gecompileerd die de MOC automatisch afhandelt. Lees ook [Why Does Qt Use Moc for Signals and Slots?](http://doc.qt.io/qt-5/why-moc.html)

Qt komt met een eigen `Makefile` generator in de vorm van `QMake` in plaats van `CMake` dat centraal staat in CLion. [Het is mogelijk](https://stackoverflow.com/questions/30235175/how-to-configure-clion-ide-for-qt-framework) om CLion Qt projecten te laten builden gegeven enkele wijzigingen in de `CMakeLists.txt` file om Qt libraries te linken. Het probleem is echter de gegenereerde source files door MOC. Dit zou ons echter te ver leiden.

## <a name="oef"></a>Labo oefeningen

1. Maak een programma dat de gebruiker 2 breuken laat ingeven in de vorm van 4 aparte textfields. Een knop "som" drukt het resultaat af in een output textfield. Valideer de input en geef een foutboodschap in de vorm van een `QMessageBox` indien een ongeldige waarde ingegeven.
2. Als uitbreiding moet een tweede window openen die bereken knoppen bevat als een rekenmachine. Scherm 1: input fields, output. Scherm 2: knop "plus", knop "maal". Het tweede scherm kan men openen via een menu "Bestand -> Acites" in scherm 1.  

## Denkvragen

1. Beargumenteer waarom ik als software ontwikkelaar voor een UI framework als Qt zou kiezen in plaats van het _native_ alternatief voor mijn ontwikkelplatform. Zijn hier ook nadelen aan verbonden?
2. Hoe komt het dat ik `connect()` in de constructor van een `QMainWindow` klasse kan uitvoeren? Waar is deze methode gedefiniëerd?
