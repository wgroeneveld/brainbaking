package be.kuleuven.ses.facade.animals;

public class Chicken {
	private int amountOfSeedsEaten = 0;
	public void feed() {
		amountOfSeedsEaten++;
		System.out.println("Pook pok? Pok! " + amountOfSeedsEaten);
	}
}
