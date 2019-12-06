package be.kuleuven.scorebord;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Scorebord {

    private List<Speler> spelers;
    private Gson gsonInstance;

    public Scorebord() {
        spelers = new ArrayList<>();
        gsonInstance = new Gson();

        if(Files.exists(Paths.get("score.json"))) {
            loadFromFile();
        }
    }

    /**
     * Voegt speler toe aan scorebord. Indien reeds aanwezig, telt score op bij huidige score.
     * @param spelerNaam de naam van de speler.
     * @param score de score van de speler.
     */
    public void voegToe(String spelerNaam, int score) {
        var current = spelers.stream().filter(s -> s.getNaam().equals(spelerNaam)).findFirst();
        if(current.isPresent()) {
            current.get().scoor(score);
        } else {
            spelers.add(new Speler(spelerNaam, score));
        }
        save();
    }

    private void save() {
        try {
            var json = gsonInstance.toJson(spelers);
            Files.write(Paths.get("score.json"), json.getBytes());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * Wie is gewonnen? (huidige speler met hoogste score)
     * @return naam van speler in tekst
     */
    public String getWinnaar() {
        return spelers.stream()
                .sorted(Comparator.comparing(Speler::getScore))
                .findFirst()
                .orElseGet(() -> new Speler("GEEN")).getNaam();
    }

    /**
     * Geef huidige totale score van de speler
     * @param spelerNaam speler naam
     * @return score vanuit het bord
     */
    public int getTotaleScore(String spelerNaam) {
        var result = spelers.stream().filter(s -> s.getNaam().equals(spelerNaam)).findFirst();

        return result.isEmpty() ? 0 : result.get().getScore();
    }

    private void loadFromFile() {
        try {
            var collectionType = new TypeToken<List<Speler>>(){}.getType();
            var json = Files.readString(Paths.get("score.json"));

            spelers = gsonInstance.fromJson(json, collectionType);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
