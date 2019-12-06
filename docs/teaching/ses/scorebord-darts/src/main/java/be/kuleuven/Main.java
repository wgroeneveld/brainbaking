package be.kuleuven;

public class Main {

    public static void main(String[] args) {
        var game = new DartsGame();

        game.throwDart();
        System.out.println("threw dart. Score: " + game.getScore());
        game.throwDart();
        System.out.println("threw dart. Score: " + game.getScore());
        game.throwDart();
        System.out.println("threw dart. Score: " + game.getScore());


    }
}
