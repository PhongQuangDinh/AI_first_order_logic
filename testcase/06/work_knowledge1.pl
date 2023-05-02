/*Facts*/
/*Male*/
male(uranus).
male(cronus).
male(hades).
male(zeus).
male(poseidon).
male(ares).
male(hephaestus).
male(triton).
male(hermes).
male(apollo).
male(dionysus).

/*Female*/
female(gaia).
female(rhea).
female(demeter).
female(hera).
female(hestia).
female(amphitrite).
female(persephone).
female(hebe).
female(ilithyia).
female(leto).
female(benthesikyme).
female(athena).
female(aphrodite).
female(artemis).
female(unknown).

/*Married*/
married(uranus,gaia).
married(gaia,uranus).

married(cronus,rhea).
married(rhea,cronus).

married(zeus,demeter).
married(demeter,zeus).
married(zeus,hera).
married(hera,zeus).
married(zeus,leto).
married(leto,zeus).

married(poseidon,amphitrite).
married(amphitrite,poseidon).

married(hades,persephone).
married(persephone,hades).

married(ares,aphrodite).
married(aphrodite,ares).

/*Parent*/
parent(chaos,uranus).
parent(chaos,gaia).
parent(uranus,cronus).
parent(uranus,rhea).
parent(gaia,cronus).
parent(gaia,rhea).

parent(cronus,zeus).
parent(cronus,demeter).
parent(cronus,hera).
parent(cronus,poseidon).
parent(cronus,hades).
parent(cronus,hestia).
parent(rhea,zeus).
parent(rhea,demeter).
parent(rhea,hera).
parent(rhea,poseidon).
parent(rhea,hades).
parent(rhea,hestia).

parent(zeus,persephone).
parent(demeter,persephone).
parent(zeus,ares).
parent(zeus,hephaestus).
parent(zeus,hebe).
parent(zeus,ilithyia).
parent(hera,ares).
parent(hera,hephaestus).
parent(hera,hebe).
parent(hera,ilithyia).
parent(zeus,artemis).
parent(zeus,apollo).
parent(leto,artemis).
parent(leto,apollo).

parent(zeus,athena).
parent(zeus,hermes).
parent(zeus,dionysus).
parent(zeus,aphrodite).
parent(unknown,athena).
parent(unknown,hermes).
parent(unknown,dionysus).
parent(unknown,aphrodite).

parent(poseidon,triton).
parent(poseidon,benthesikyme).
parent(amphitrite,triton).
parent(amphitrite,benthesikyme).


/*Rules*/
husband(Person,Wife):-married(Person,Wife), male(Person).
wife(Person,Husband):-married(Person,Husband), female(Person).
father(Parent,Child):-parent(Parent,Child), male(Parent).
mother(Parent,Child):-parent(Parent,Child), female(Parent).
child(Child,Parent):-parent(Parent,Child).
son(Child,Parent):-child(Child,Parent), male(Child).
daughter(Child,Parent):-child(Child,Parent), female(Child).
grandparent(GP,GC):-parent(GP,P), parent(P,GC).
grandmother(GM,GC):-grandparent(GM,GC), female(GM).
grandfather(GF,GC):-grandparent(GF,GC), male(GF).
grandchild(GC,GP):-grandparent(GP,GC).
grandson(GS,GP):-grandchild(GS,GP), male(GS).
granddaughter(GD,GP):-grandchild(GD,GP), female(GD).
greatgrandparent(GGP,GGC):-parent(GGP,GP),grandparent(GP,GGC).
greatgrandfather(GGF,GGC):-greatgrandparent(GGF,GGC),male(GGF).
greatgrandmother(GGM,GGC):-greatgrandparent(GGM,GGC),female(GGM).
greatgrandchild(GGC,GGP):-greatgrandparent(GGP,GGC).
greatgrandson(GGS,GGP):-greatgrandchild(GGS,GGP),male(GGS).
greatgranddaughter(GGD,GGP):-greatgrandchild(GGD,GGP),female(GGD).
sibling(Person1,Person2):-parent(P,Person1), parent(P,Person2), Person1\=Person2.
brother(Person,Sibling):-sibling(Person,Sibling), male(Person).
sister(Person,Sibling):-sibling(Person,Sibling), female(Person).
aunt(Person,NieceNephew):-parent(P,NieceNephew), sibling(P,Person), female(Person).
uncle(Person,NieceNephew):-parent(P,NieceNephew), sibling(P,Person), male(Person).
greataunt(Person,GN):-grandparent(GP,GN),sibling(GP,Person),female(Person).
greatuncle(Person,GN):-grandparent(GP,GN),sibling(GP,Person),male(Person).
niece(Person,AuntUncle):-(aunt(AuntUncle,Person);uncle(AuntUncle,Person)), female(Person).
nephew(Person,AuntUncle):-(aunt(AuntUncle,Person);uncle(AuntUncle,Person)), male(Person).
greatniece(Person,GAU):-(greataunt(GAU,Person);greatuncle(GAU,Person)),female(Person).
greatnephew(Person,GAU):-(greataunt(GAU,Person);greatuncle(GAU,Person)),male(Person).
marriedSibling(Person1, Person2):-married(Person1,Person2),sibling(Person1,Person2).