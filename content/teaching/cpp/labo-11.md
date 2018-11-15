---
title: 'Labo 11: een GBA spel porten naar Qt'
accent: "#008eb3"
disableComments: true
---

&laquo;&nbsp;[Terug naar Software ontwerp in C/C++](/teaching/cpp)<br/>
&raquo;&nbsp;[Naar de labo opgave](#oef)

## Eigen widgets implementeren

De objectenboom uit [labo 10](/teaching/cpp/labo-10) leert ons dat heel wat Qt objecten afleiden van `QWidget`. Dat is de ideale startplaats om zelf een widget te implementeren. Veel Qt objecten voorzien een `override` om het tekenen zelf af te kunnen handelen, vergelijkbaar met de while loop in een typisch gameboy spel.

```C
void paintEvent(QPaintEvent *event) override;
```

In het [Textrix Qt Voorbeeld](http://doc.qt.io/qt-5/qtwidgets-widgets-tetrix-example.html) wordt er gebruikt gemaakt van custom `QFrame` en `QWidget` implementaties die eigen objecten bijhouden die de tetris blokken voorstellen. Het tekenen van die blokken wordt aan de eigen code overgelaten. De `QPainter` klasse handelt het low-level tekenen af.

Dit voorbeeld, uit het voorbeeld genomen, tekent een tetris "shape" op het spelbord voor een gegeven painter instantie:

```C
void TetrixBoard::drawSquare(QPainter &painter, int x, int y, TetrixShape shape)
{
    static const QRgb colorTable[8] = {
        0x000000, 0xCC6666, 0x66CC66, 0x6666CC,
        0xCCCC66, 0xCC66CC, 0x66CCCC, 0xDAAA00
    };

    QColor color = colorTable[int(shape)];
    painter.fillRect(x + 1, y + 1, squareWidth() - 2, squareHeight() - 2,
                     color);

    painter.setPen(color.light());
    painter.drawLine(x, y + squareHeight() - 1, x, y);
    painter.drawLine(x, y, x + squareWidth() - 1, y);

    painter.setPen(color.dark());
    painter.drawLine(x + 1, y + squareHeight() - 1,
                     x + squareWidth() - 1, y + squareHeight() - 1);
    painter.drawLine(x + squareWidth() - 1, y + squareHeight() - 1,
                     x + squareWidth() - 1, y + 1);
}
```

Dit is redelijk _low-level_: `drawLine` , `setPen` en `fillRect` verwachten coördinaten als input. In Qt is het ook mogelijk om met [OpenGL](http://doc.qt.io/qt-5/qtopengl-index.html) te werken maar dat valt buiten deze cursus.

## Gebruik maken van een abstractielaag

Herinner je uit [labo 7](/teaching/cpp/labo-7) en [labo 8](/teaching/cpp/labo-8) het gebruik van een abstractielaag om de Gameboy Advance specifieke implementatie te verbergen in een tweede schil. Dit heeft als doel om makkelijk te kunnen switchen van _front-end_: als wij beslissen om onze GUI logica in Qt te schrijven, kunnen we de meeste logica, onze domein objecten, zonder meer overnemen! Dit bespaart ons véél moeite en duplicatie.

Een schematische voorstelling van de context met als voorbeeld het Arkanoid spel uit [labo 4](/teaching/cpp/labo-4):

{{<mermaid>}}
graph LR;
    subgraph Arkanoid model
        A[<u>Paddle</u><br/>posx, posy]
        B[<u>Ball</u><br/>posx, posy]
        C[<u>BreakableBlocks</u><br/>posx, posy]
    end
    subgraph Qt Frontend
        F[QtArkanoidGame]
        A --> F
        B --> F
        C --> F
    end
    subgraph GBA Frontend
        D[GBAArkanoidGame]
        A --> D
        B --> D
        C --> D
    end
{{< /mermaid >}}

Als alles perfect gescheiden is kan je de klassen aan de linkerkant van het schema volledig herbruiken. Dit betekent dat we géén specifieke GBA of Qt `#include` gebruiken en alle logica puur op de objecten zelf doen! Een potentiële `collidesWith()` zal dus op `posx` en `posy` checken en **niet in OAM** gaan kijken want dat bestaat niet in Qt. Omgekeerd zal het ook niet de QWidget of QFrame positie gebruiken want dat bestaat niet op de GBA.

Dit concept van stricte scheiding noemen we "**separation of concerns**" en is een veel gebruikt [Design Pattern](https://en.wikipedia.org/wiki/Separation_of_concerns). In de industrie wordt logica vaak gesplitst om een HTML frontend of een Android of iOS frontend makkelijk te kunnen opbouwen. Op die manier heb je 3 applicaties waarvan de belangrijkste basis, het domein, hetzelfde blijft.

Merk op dat dit eenvoudiger klinkt dan het in werkelijkheid er aan toe gaat: de [gba-sprite-engine](https://github.com/wgroeneveld/gba-sprite-engine) die jullie gaan gebruiken voor het project voorziet wel degelijk een scheiding van low-level en high-level GBA implementatie, maar géén stricte scheiding: in scenes gebruik je sprites (zie [demo voorbeeld code](https://github.com/wgroeneveld/gba-sprite-engine/blob/master/demos/demo1-basicfeatures/src/flying_stuff_scene.h), en die sprites hebben een OAM buffer. Die zijn dus ongeschikt om in Qt te kunnen werken. Waarom is dit hier niet gedaan? Omdat het natuurlijk nooit voorkomt dat iemand die een GBA spel ontwerpt dit wil porten naar Qt. Wanneer is dit wel van belang? Als iemand een Nintendo Switch spel maakt en het ook op Steam of in de Playstation Store wil publiceren.

## Werken met timers voor updates

In ons GBA spel hebben we één centrale `while(1) {}` loop waar constant alles opnieuw getekend wordt. In Qt wordt de paint methode automatisch aangeroepen, maar daarvoor moeten natuurlijk wel nog variabelen van waarde veranderen. In het Tetrix voorbeeld wordt hiervoor een `QBasicTimer` instance gebruikt:

```C
QBasicTimer timer;
timer.start(timeoutTime(), this);
```

Om `this` te kunnen meegeven moet je een `void timerEvent(QTimerEvent *event)` implementatie voorzien waarin je je logica schrijft om bijvoorbeeld zwaartekracht te imiteren. Elk `QObject` heeft zo'n implementatie: het is dus zaak om je niet te vergissen en enkel je eigen timer specifieke dingen af te handelen:

```C
void TetrixBoard::timerEvent(QTimerEvent *event) {
    if (event->timerId() == timer.timerId()) {
        // do stuff, evt timer restarten
    } else {
        // parent timing
        QFrame::timerEvent(event);
    }
}
```

## <a name="oef"></a>Labo oefeningen

1. Teken in een eigen `QWidget` implementatie een eenvoudig mannetje met hulp van wat simpele rechthoeken. Laat dat mannetje naar links en rechts bewegen door keyboard events op te vangen. Herinner je vanuit [labo 10](/teaching/cpp/labo-10) dat dit met slots en signals kan. Implementeer hiervoor `void keyPressEvent(QKeyEvent *event);` en luister naar `event->key()`.
2. Download [gba-arkanoid](/teaching/cpp/gba-arkanoid.zip), een C++ implementatie van de oefening uit [labo 4](/teaching/cpp/labo-4#oef). Dit CMake/CLion project is opgesplitst in 2 submappen: _domain_ en _gba_. Het domein bevat methodes als `collidesWith` en `updatePosition`. De OAM GBA impelemntatie leeft in de gba submap. <br/>Port dit werkend minimalistisch spel naar Qt door de domein submap volledig _intact_ te laten! De makkelijkste start is een nieuw project via Qt Creator waarbij je de domein code kopiëert.

## Denkvragen

1. Beargumenteer waarom het principe van "separation of concerns" belangrijk kan zijn. Geef twee concrete voorbeelden waarom dit het geval is.
2. Wanneer beslis je om code te kopiëren, en wanneer beslis je om code te herbruiken? Beschrijf twee situaties waarin je het ene of het andere zou handhaven.
