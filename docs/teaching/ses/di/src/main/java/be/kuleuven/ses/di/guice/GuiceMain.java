package be.kuleuven.ses.di.guice;

import com.google.inject.Guice;

public class GuiceMain {

    public static void main(String[] args) {

        var injector = Guice.createInjector(new GuiceConfigModule());

        System.out.println("Fetching resource and cart...");
        var shoppingCartResource = injector.getInstance(ShoppingCartGuiceResource.class);
        var cart = shoppingCartResource.getCart();

        System.out.println();
        System.out.println("got cart; total items: " + cart.getAmountOfItems());
    }
}
