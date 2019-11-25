package be.kuleuven.ses.singleton;

public class Main {

    public static void main(String[] args) {
        // simulate GET call to shopping-cart by 10 users

        System.out.println("getting the shopping cart for 10 users...");
        for(int i = 1; i <= 10; i++) {
            new ShoppingCartResource().get();
        }

        System.out.println("done!");
    }
}
