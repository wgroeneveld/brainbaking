package be.kuleuven.ses.decorator.cars;

import java.util.Arrays;
import java.util.List;

public class CustomCarDecorator implements Car {
    private final List<Car> carsToAssemble;

    public CustomCarDecorator(Car... carTypes) {
        this.carsToAssemble = Arrays.asList(carTypes);
    }

    @Override
    public void assemble() {
        for(Car car : carsToAssemble) {
            car.assemble();
        }
    }
}
