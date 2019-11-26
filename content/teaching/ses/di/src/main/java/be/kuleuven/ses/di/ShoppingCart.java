package be.kuleuven.ses.di;

public class ShoppingCart {
    private int amountOfItems;
    private int amountOfMoney;

    public ShoppingCart() {
    }

    public ShoppingCart(int amountOfItems, int amountOfMoney) {
        this.amountOfItems = amountOfItems;
        this.amountOfMoney = amountOfMoney;
    }

    public int getAmountOfMoney() {
        return amountOfMoney;
    }

    public void setAmountOfMoney(int amountOfMoney) {
        this.amountOfMoney = amountOfMoney;
    }

    public int getAmountOfItems() {
        return amountOfItems;
    }

    public void setAmountOfItems(int amountOfItems) {
        this.amountOfItems = amountOfItems;
    }
}
