package be.kuleuven.ses.factory.tickets;

public class FamilyTicket extends Ticket {

    @Override
    public String getMovie() {
        return "Snow White";
    }

    @Override
    public int getPrice() {
        return 7;
    }
}
