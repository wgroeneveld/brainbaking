package be.kuleuven.ses.factory;

import be.kuleuven.ses.factory.tickets.Ticket;

public class AgeBasedTicketSeller implements TicketSeller {

    @Override
    public Ticket buyTicketFor(Person person) {
        throw new UnsupportedOperationException();
    }
}
