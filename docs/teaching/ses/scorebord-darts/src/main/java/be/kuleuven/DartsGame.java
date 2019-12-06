package be.kuleuven;

import be.kuleuven.scorebord.Scorebord;

public class DartsGame {

    private String currentPlayer = "jaak";
    private Scorebord bord;

    public DartsGame() {
        bord = new Scorebord();
    }

    public int getScore() {
        return bord.getTotaleScore(currentPlayer);
    }

    public void throwDart() {
        var score = (int) (1 + Math.random() * 13);
        bord.voegToe(currentPlayer, score);
    }

}
