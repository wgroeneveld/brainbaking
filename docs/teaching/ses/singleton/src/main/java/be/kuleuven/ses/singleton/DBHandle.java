package be.kuleuven.ses.singleton;

import java.util.Random;

public class DBHandle {

    public static int dbInstances;

    public DBHandle() {
        dbInstances++;
    }

    public ShoppingCart getShoppingCart() {
        final var i1 = new Random().nextInt(1000 - 10) + 10;
        final var i2 = new Random().nextInt(1000 - 10) + 10;

        // "fetches" from db - fake implemented...
        return new ShoppingCart(i1, i2);
    }
}
