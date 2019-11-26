package be.kuleuven.ses.factory;

public class CinemaMain {

    public static void main(String[] args) {
        var seller = new AgeBasedTicketSeller();
        var jefke = new Person(19);

        var ticket = seller.buyTicketFor(jefke);
        System.out.println("Jefke, who's " + jefke.getAge() + " years old, gets to watch " + ticket.getMovie() + ", paying " + ticket.getPrice());
    }
}
