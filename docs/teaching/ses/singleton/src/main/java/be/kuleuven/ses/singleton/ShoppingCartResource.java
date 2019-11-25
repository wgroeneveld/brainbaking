package be.kuleuven.ses.singleton;

public class ShoppingCartResource {

    public ShoppingCart get() {
        return new DBHandle().getShoppingCart();
    }

}
