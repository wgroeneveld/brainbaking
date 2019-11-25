package be.kuleuven.ses.decorator.cars;

public class VWPassat implements Car {
    @Override
    public void assemble() {
        System.out.println("do not forget all the leather!");
    }
}
