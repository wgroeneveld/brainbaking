package be.kuleuven.ses.facade;// I also want a Pig and two Cats

import be.kuleuven.ses.facade.animals.Chicken;

public class Main {
	public static void main(String[] args) {
		Chicken chick = new Chicken();
		System.out.println("Feeding the chicken");
		chick.feed();
	}
}
