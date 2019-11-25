package be.kuleuven.ses.decorator;

import be.kuleuven.ses.decorator.cars.Car;

public class Factory {
    public Car create(Car car) {
        car.assemble();  // works, since it's an interface
        paint(car);
        finish(car);
        System.out.println("done creating! Here's your new car.");
        return car;
    }

    private void paint(Car car) {
        System.out.println("painting...");
    }

    private void finish(Car car) {
        System.out.println("finishing up creation of car...");
    }
}
