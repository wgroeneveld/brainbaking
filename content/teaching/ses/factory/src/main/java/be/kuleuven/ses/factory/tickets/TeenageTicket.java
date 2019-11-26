package be.kuleuven.ses.factory.tickets;

public class TeenageTicket extends Ticket {
    @Override
    public String getMovie() {
        // Kowabunga!
        return "Teenage Mutant Ninja Heroes";
    }

    @Override
    public int getPrice() {
        return 9;
    }
}
