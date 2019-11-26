package be.kuleuven.ses.factory.tickets;

public class AdultRatedTicket extends Ticket {

    @Override
    public String getMovie() {
        return "Lord of the Strings";
    }

    @Override
    public int getPrice() {
        return 12;
    }
}
