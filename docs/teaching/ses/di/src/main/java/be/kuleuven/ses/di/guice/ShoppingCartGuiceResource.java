package be.kuleuven.ses.di.guice;

import be.kuleuven.ses.di.DBHandle;
import be.kuleuven.ses.di.ShoppingCart;
import be.kuleuven.ses.di.annotations.GET;
import be.kuleuven.ses.di.annotations.Path;
import com.google.inject.Inject;

@Path(url = "/shopping-cart")
public class ShoppingCartGuiceResource {

    private final DBHandle dbHandle;

    @Inject
    public ShoppingCartGuiceResource(DBHandle handle) {
        this.dbHandle = handle;
    }

    @GET
    public ShoppingCart getCart() {
        return dbHandle.getCart();
    }

}
