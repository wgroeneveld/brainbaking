// main.cpp

#include <iostream>

#include "punt2d.h"
#include "punt3d.h"

using namespace std;

int main() {

    iPunt p(1, 3);
    iPunt3d p2(1, 3, 5);

    auto som = p2 + p;	// omgekeerd gaat nog niet

    cout << p << endl;
    cout << p2 << endl;

    cout << "som: " << som << endl;

    return 0;
}

// punt2d.h

#ifndef TESTJE_PUNT2D_H
#define TESTJE_PUNT2D_H

#include <iostream>

// forward definitie nodig om vriendje te maken.
template <typename U> class Punt3D;

template<typename T> class Punt {
protected:
    T x, y;
public:
    Punt(T x, T y) : x(x), y(y) {}
    template<typename U> friend std::ostream& operator<<(std::ostream& os, Punt<U>& p);
    // vriendje nodig: https://stackoverflow.com/questions/16785069/why-cant-a-derived-class-call-protected-member-function-in-this-code
    friend class Punt3D<T>;
};

template<typename T> std::ostream& operator<<(std::ostream& os, Punt<T>& p) {
    os << "(" << p.x << "," << p.y << ")";
    return os;
}

typedef Punt<int> iPunt;
typedef Punt<double> dPunt;


#endif //TESTJE_PUNT2D_H

// punt3d.h

#ifndef TESTJE_PUNT3D_H
#define TESTJE_PUNT3D_H

#include <iostream>
#include "punt2d.h"

template<typename T> class Punt3D : public Punt<T> {
private:
    T z;
public:
    T getZ() const { return z; }
    Punt3D(T x, T y, T z) : Punt<T>(x, y), z(z) { }
    template<typename U> friend std::ostream& operator<<(std::ostream& os, Punt3D<U>& p);
    Punt3D<T> operator+(const Punt3D<T> &other) {
        return Punt3D(this->x + other.x, this->y + other.y, this->z + other.z);
    }
    Punt3D<T> operator+(const Punt<T> &other) {
        return Punt3D(this->x + other.x, this->y + other.y, this->z);
    }
};

template<typename T> std::ostream& operator<<(std::ostream& os, Punt3D<T>& p) {
    os << "(" << p.x << "," << p.y << "," << p.x << ")";
    return os;
}

typedef Punt3D<int> iPunt3d;
typedef Punt3D<double> dPunt3d;

#endif //TESTJE_PUNT3D_H
