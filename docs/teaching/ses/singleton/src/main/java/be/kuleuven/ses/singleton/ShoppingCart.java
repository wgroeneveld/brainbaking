package be.kuleuven.ses.singleton;

public class ShoppingCart {

    private int totalAmount;
    private int amountOfItems;

    public ShoppingCart(int totalAmount, int amountOfItems) {
        this.totalAmount = totalAmount;
        this.amountOfItems = amountOfItems;
    }

    public int getAmountOfItems() {
        return amountOfItems;
    }

    public void setAmountOfItems(int amountOfItems) {
        this.amountOfItems = amountOfItems;
    }

    public int getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(int totalAmount) {
        this.totalAmount = totalAmount;
    }
}
