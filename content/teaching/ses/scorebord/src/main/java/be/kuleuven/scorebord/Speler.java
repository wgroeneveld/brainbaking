package be.kuleuven.scorebord;

import java.util.Objects;

class Speler {
    private String naam;
    private int score;

    public Speler(String naam) {
        this.naam = naam;
    }

    public Speler(String naam, int score) {
        this.naam = naam;
        this.score = score;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Speler speler = (Speler) o;
        return Objects.equals(naam, speler.naam);
    }

    @Override
    public int hashCode() {
        return Objects.hash(naam);
    }

    public String getNaam() {
        return naam;
    }

    public void scoor(int x) {
        score += x;
    }

    public int getScore() {
        return score;
    }

}
