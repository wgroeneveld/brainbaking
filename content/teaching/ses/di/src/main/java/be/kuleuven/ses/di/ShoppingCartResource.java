package be.kuleuven.ses.di;

import be.kuleuven.ses.di.annotations.GET;
import be.kuleuven.ses.di.annotations.Path;

@Path(url = "/shopping-cart")
public class ShoppingCartResource {

    @GET
    public ShoppingCart getCart() {
        // TODO we should not be able to create DBHandle, but inject it instead.
        return new DBHandle("bla").getCart();
    }
}
