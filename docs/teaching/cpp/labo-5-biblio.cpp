
#include <algorithm>
#include <string>
#include <sstream>
#include <vector>
#include <iostream>
#include <cstdlib>


using namespace std;

class Bibliotheek {
private:
    vector<string> boeken;
public:
    vector<string> &getBoeken() { return boeken; }
    void geefIn(string boekenMetSpatie);
    friend ostream& operator<<(ostream& os, Bibliotheek& biblio);
};

class Bibliothecaris {
public:
    void sorteer(Bibliotheek &bib);
};

void Bibliothecaris::sorteer(Bibliotheek &bib) {
    sort(bib.getBoeken().begin(), bib.getBoeken().end());
}

ostream& operator<<(ostream& os, Bibliotheek& biblio) {
    for(auto boek : biblio.getBoeken()) {
        os << "boek: " << boek << " - ";
    }
    os << endl;
    return os;
}

void Bibliotheek::geefIn(string boekenMetSpatie) {
    stringstream stream(boekenMetSpatie);
    string item;
    while(getline(stream, item, ' ')) {
        this->boeken.push_back(item);
    }
}

int main() {
    Bibliotheek bib;
    bib.geefIn("vermeers lekens vermassen vermaelen");

    cout << bib;
    Bibliothecaris jefke;
    jefke.sorteer(bib);

    cout << "nadat jefke het gesorteerd heeft: " << endl;
    cout << bib;

    return 0;
}