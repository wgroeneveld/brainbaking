import be.kuleuven.ses.di.ShoppingCartResource;
import org.junit.Assert;
import org.junit.Test;

import static org.hamcrest.Matchers.notNullValue;
import static org.hamcrest.core.Is.is;

public class ShoppingCartResourceTest {

    @Test
    public void getCart_fetchesFromDb() {
        var cart = new ShoppingCartResource();
        var result = cart.getCart();

        // TODO this is not enough; we have to check whether DBHandle was actually called!
        Assert.assertThat(result, is(notNullValue()));
    }
}
