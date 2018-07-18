#include <string>
#include <vector>
#include <cstdlib>
#include <iostream>

using namespace std;

class Orc {
private:
    int aanval;
    int levens;
public:
    int getAanval() const { return aanval; }
    int getLevens() const { return levens; }
    Orc(int a, int l) : aanval(a), levens(l) { }
    Orc& vecht(Orc &verdediger);
};

Orc& Orc::vecht(Orc &verdediger) {
    verdediger.levens -= this->aanval;
    if(verdediger.levens > 0) {
        return verdediger;
    }
    return *this;
}

vector<Orc> generateOrcs(int aantal) {
    vector<Orc> leger;
    for(int i = 0; i < aantal; i++) {
        leger.push_back(Orc(rand() % 21, rand() % 21));
    }
    return leger;
}


int main() {
    cout << "Hoeveel orcs? " << endl;
    int aantal;
    cin >> aantal;

    cout << aantal << " dus, oké, komt-ie:" << endl;
    auto leger = generateOrcs(aantal);

    int i = 1;
    for(auto orc : leger) {
        cout << "Orc " << i << ": aanval " << orc.getAanval() << ", levens " << orc.getLevens() << endl;
        i++;
    }

    cout << "ze gaan elkaar opfretten..." << endl;
    auto winnaar = leger[0];
    for(int j = 1; j < aantal; j++) {
        Orc beest = leger[j];

        cout << " -- VS: (" << winnaar.getAanval() << "," << winnaar.getLevens() << ") tegen (" << beest.getAanval() << "," << beest.getLevens() << ")" << endl;
        winnaar = winnaar.vecht(beest);

        cout << " --- Orc met " << winnaar.getAanval() << " aanval wint" << endl;
    }

    cout << "Orc met " << winnaar.getAanval() << " is last man standing!" << endl;

    return 0;
}
