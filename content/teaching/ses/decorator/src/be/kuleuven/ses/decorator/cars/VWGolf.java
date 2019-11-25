package be.kuleuven.ses.decorator.cars;

public class VWGolf implements Car {
    @Override
    public void assemble() {
        System.out.println("do not forget the steering wheel!");
    }
}
