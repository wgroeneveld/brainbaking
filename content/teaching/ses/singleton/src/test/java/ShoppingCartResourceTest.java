import be.kuleuven.ses.singleton.DBHandle;
import be.kuleuven.ses.singleton.ShoppingCartResource;
import org.junit.Test;

import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;


public class ShoppingCartResourceTest {

    @Test
    public void get_shouldReturnValidShoppingCart() {
        var cart = new ShoppingCartResource().get();

        assertThat(cart.getAmountOfItems(), greaterThan(1));
    }

    @Test
    public void get_fromMultipleResources_shouldNotIncreaseDBHandleVarCount() {
        new ShoppingCartResource().get();
        new ShoppingCartResource().get();
        new ShoppingCartResource().get();

        assertThat(DBHandle.dbInstances, is(1));
    }
}
