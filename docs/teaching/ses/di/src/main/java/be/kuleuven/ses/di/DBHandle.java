package be.kuleuven.ses.di;

import java.util.Random;

public class DBHandle {

    private final String connectionString;

    public DBHandle(String str) {
        this.connectionString = str;
    }

    public ShoppingCart getCart() {
        // select * from ... - faking it here...
        var i1 = new Random().nextInt(1000 - 10) + 10;
        var i2 = new Random().nextInt(1000 - 10) + 10;

        return new ShoppingCart(i1, i2);
    }
}
