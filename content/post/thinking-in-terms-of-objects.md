---
title: 'Thinking in terms of objects'
date: '2018-04-28'
subtitle: An introduction to software design in terms of objects
tags:
- teaching
published: true
---

Writing software isn't much different than describing a world. Thé world, where we live in, is **a** world, not the **only** one. With software, we could, theoretically speaking, describe our own world. If we don't thinkg about software, how would we describe that or another world? How would I build a fantasy world in a noval where my readers can relate to the world and be engaged? 

By **describing** with our **language**. If there descriptions are a priori or a posteriori doesn't really matter. 

I can claim the following

> "Two plus three is five" 

No senses are involed in this claim, and this is a tautology. (A = A, 2 + 3 = 5, the left-hand side of the equation is the right-hand side and the other way around.) This claim is a bit more difficult to put in terms of objects, because when we try to decronstruct the sentence, we can extract the following elements:

- What is "plus" (an operation)
- What is "two", "three" and "five" (numbers)
- What is "is" (the equation)

THe "operation" is something we can do with the "numbers". I put operation between quotes because it denotes a property on the second word between quotes, "numbers". Thus we can deduct the following object with properties:

	Number {
		plus(Number other);
	}

As we know, in any (modern) programming language, the concept of numbers is almost always defined for us. "Things" involving mathematics - or any a priori claim - are usually provided. In _Ruby_, numbers are first-class citizens meaning they are also objects - as they should be.

As a second example, I could also claim:

> "A tree has a green leaf"

This clearly is a posteriori claim: to be able to verify its truthness, you'd have to see with your own eyes that the leaf is in fact green. A posteriori claims are much easier to convert into objects as we have implicitly learned our own language empirically.

So:

- What is "tree" (a "something")
- What is "has" (denoting a property)
- What is "green" (a property)
- What is "leaf" (another property, of the tree, and a "something")

As soon as we encounter **has a** in a sentence, we know it means the left-hand side of the "has a" is the one receiving the property, and the right-hand side is the property we're talking about.

> "(A tree) HAS A (green leaf)"

Gives us:

	Tree {
		green leaf
	}

But what's a green leaf?

	Tree {
		Leaf {
			green
		}
	}

"A tree has a green leaf" means "a tree has a leaf, and that leaf is green". But what does "green" mean?

> "(A tree) HAS A (leaf). (That leaf) HAS A (color), (That color) IS (green)"

So we're missing a few properties that are hidden within the structure of our language! 

	Tree {
		Leaf {
			Color: green
		}
	}

The schematic is confusing when we're talking about "a tree has a green leaf" and "a Shrubbery has a brown leaf". In that case we'd also need to define:

	Shrubbery {
		Leaf {
			Color: brown
		}
	}

, And those "Leaf" objects are one and the same: they describe a leaf that can have the property color. Of course, the leaves of the tree are not the same as the leaves on the shrubbery, but they both can be classified as "Leaf". **in context of** shrubberies and trees, it's obvious that we're talking about leaves as organic material with a color that can wither.

	Tree {
		leaf(green)
	}

	Shrubbery {
		leaf(brown)
	}

	Leaf {
		color
	}

In fact, in my first claim, I can deduct the following: "numbers can be added up with each other" simplified to "numbers can be _plussed_ with each other" and thus "(a Number) HAS A (plus another number)".

Notice that, in a **formal language** such as a programming language, objects aren't handled exactly the same as our syntactically correct speaking language:

- "A green leaf" becomes "**object** leaf with **property** color that **is** green" - I didn't talk about colors at all!
- "A lazy employer" becomes "**object** employer with **property** character that **is** lazy" - I didn't talk about character at all!

Those implicit extra properties that we need, "color" and "character", can be valid objects on their own.

	Color {
		Redvalue
		Greenvalue
		Bluevalue
		Aphavalue
	}

	Character {
		Wellbeingness
		Laborwillingness
	}

The pure color "green" could then be defined as Color(red: 0, green: max, blue: 0, alpha: max). There character "lazy" could then be defined as Character(Wellbeingness: ?, Laborwillingness: low). Notice the first property of the object "character": it's undefined. It's there, but we don't care if we're talking about a lazy character. We do care about the red, blue and alpha values if we're talking about pure green: otherwise a color wouldn't be viewed as "green". 

Organic matter in our own world consists of other organic matter, that can be reduced to chemicals, that can be reduced to subatoms. That doesn't neccecarily mean we should introduce all those concepts in the world we're building. **Only introduce a concept if it has some meaning** in your world. Are you going to do something with it? Will it be able to decide things on it's own? Will it contain logic? If that is not the case, don't bother. 

Remember to make _implicit concepts_ **explicit**. Don't forget "color"!
