/*Facts*/
own(nono, b52).
missile(b52).
/*FUCK*/
american(west).
enemy(nono, america).

/*Rules*/
criminal(X) :- american(X), weapon(Y), sell(X, Y, Z), hostile(Z).
sell(west, X, nono) :- missile(X), own(nono, X).
weapon(X) :- missile(X).
hostile(X) :- enemy(X, america).