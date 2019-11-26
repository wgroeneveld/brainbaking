package be.kuleuven.ses.factory;

import be.kuleuven.ses.factory.tickets.Ticket;

public interface TicketSeller {

    Ticket buyTicketFor(Person person);
}
