---
title: Hiding Code Complexity
bigimg: /img/complexity.png
aliases:
        - /post/hiding-complexity/
date: '2018-02-26'
subtitle: Do make it easy to read. Don't expose inner workings.
tags: ['domain driven design' ]
---

We like to talk about the architecture of our software because we like complexity. Software developers are the bears, and complex patterns seem to be the honey. The more I pair with people the more I wonder: "what makes us decide to take on a simple question with a difficult answer"? Why would anyone choose to implement something so complex, that it cannot be easily understood even the day after it's committed? 

#### Answer 1: because the underlying model is complex

**Legacy** systems. They always take the blame. But by introducing more complexity to work with, on the surface, we create even more legacy. The inner workings should never, ever, be exposed. I don't care about status 40 or 70 or 10 simply because it's persisted like that and you can't change it. That doesn't mean you should simply return that status and check the flags: instead we could try to **hide that complex matter** and encapsulate it in **simple methods**. That sounds simple. And it is. And yet, it almost never pops into people's minds. 

Let's say that I've written a system that, based on certain statuses, should execute an action. For instance, I can only delete something in my shopping cart if the status is 40, 53 or 70. 

        if(shoppingCart.status == 40 || shoppingCart.status == 53 || shoppingCart.status == 70) {
        	delete();
        }

Extract method to the rescue: 

        if(isPossibleToDelete(shoppingCart)) {
        	delete();
        }
        private bool isPossibleToDelete(shoppingCart) {
        	return shoppingCart.status == 40 || shoppingCart.status == 53 || shoppingCart.status == 70
        }

But what do those numbers even mean? 

        private bool isPossibleToDelete(shoppingCart) {
        	return shoppingCart.status == CartStatus.NEW_CART || shoppingCart.status == CartStatus.BLOCKED || shoppingCart.status == CartStatus.MERGED
        }

Ban those numbers to an enum and give them a **meaningful name**.<br/>
We're not done yet:

        if(shoppingCart.isPossibleToDelete()) {
        	delete();
        }

It's a subtle difference, but the cart knows about it's status and that means you can hide that complexity behind the ShoppingCart class implementation. Most developers will know enough if they read "isPossibleToDelete" and those who need to know the details can dive deep. See how simple that was? **Hidden within a method**, no other tricks used. Even if the underlying model still uses the ugly status checks, the rest of your software should never check on 40, 53 or 70 again. Ban those numbers to the enum and don't even use the enum values at your leisure. 

If possible, go as far as making the status property private. 

Another example. What if your legacy database structure doesn't allow an easy-to-read persistent layer but forces you to write in four different tables to get something done? The answer is the same as above: encapsulate everything. Don't simply implement (or generate, for that matter) CRUD operations based on your tables. Don't let your tables (or boss) rule your codebase! 

        public void Save(RosterClientLink link) {
        	Persist(link);
        	var client = GetClientById(link.client.Id);
        	var roster = getRosterById(link.roster.Id);
        	client.Rosters.Add(roster);
        	Update(client);
        }

Having such a method gives away that you're leaning on a CRUD operation too much. The link class doesn't say anything and it's not even clear that it modifies client data unless you take a look. A second attempt:

        public void attachWorkRosterToClient(Client client, Roster roster) {
        	Persist(new RosterClientLink(client.Id, roster.Id));
        	Persist(roster);
        	client.Rosters.Add(roster);
        	Update(client);
        }

Simply having this method is better than nothing - it makes the intention to attach the roster to a client visible. Instead of requiring every developer to know the inner workings of those tables, they can simply "attach". Your business should also be speaking about "attaching" then. But again, we're not done yet:

        public void attach(Roster roster) {
        	Persist(new RosterClientLink(this.Id, roster.Id));
        	Persist(roster);
        	this.Rosters.Add(roster);
        	Update(this);
        }

That makes ``client.attach(roster);`` possible, and that's easier to read and ultimately, understand. One could argue that ``roster.attachTo(client)`` makes more sense but think about **responsibilities** here: who owns what? Why would the roster be able to attach itself to a client, while a client owns and creates the rosters?


#### Answer 2: because we want to prove ourselves

You might think you look cool if you can handle a pattern in a pattern. You might be proud of yourself once you managed to generalize one callback that will never be re-used. Hoping others would be proud of you to. If those others can't make much of your code, I would dare to say that it won't be the case. 

Using a factory because you're convinced that creating _anything_ has to be done by a factory might not be the best move to make. Using dependency injection because it's _best practice_ doesn't make much sense to me either and that's a trap that almost everyone falls in. What's wrong with this:

        public class Stuff {
        	private readonly IDep _One;
        	private readonly IDep two;

        	public Stuff(IDep one, IDep two) {
        		_One = one;
        		_Two = two;
        	}

        	public Stuff() : this(new One(), new Two()) {

        	}
        }

The first constructor is used in unit testing and allows us to _inject_ (aha!) mocks into the loaded instance, while the second constructor is used in production. This approach has some drawbacks, like any other approach - like the cascading effect of object creation. But that might be enough for your application. 

[Keep it simple, stupid](https://en.wikipedia.org/wiki/KISS_principle).