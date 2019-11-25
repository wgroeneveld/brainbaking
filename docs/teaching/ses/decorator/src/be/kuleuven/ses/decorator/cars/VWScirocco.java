package be.kuleuven.ses.decorator.cars;

public class VWScirocco implements Car {
    @Override
    public void assemble() {
        System.out.println("do not forget lots of turbo!");
    }
}
