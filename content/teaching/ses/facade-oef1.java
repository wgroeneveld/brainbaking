
public class Chicken {
	private int amountOfSeedsEaten = 0;
	public void feed() {
		amountOfSeedsEaten++;
		System.out.println("Pook pok? Pok! " + amountOfSeedsEaten);
	}
}

public class Cow {
	// you know the drill
}

// I also want a Pig and two Cats

public class Main {
	public static void main(String[] args) {
		Chicken chick = new Chicken();
		System.out.println("Feeding the chicken");
		chick.feed();
	}
}
