/*Facts*/
female(jill).
male(john).
male(jack).

/*Rules*/
married(Person1, Person2):-male(Person1), female(Person2).