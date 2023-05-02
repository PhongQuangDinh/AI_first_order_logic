/*Facts*/
/*Females*/
female(queenElizabethII).
female(princessDiana).
female(camillaParkerBowles).
female(princessAnne).
female(sarahFerguson).
female(sophieRhys-jones).
female(kateMiddleton).
female(autumnKelly).
female(zaraPhillips).
female(princessBeatrice).
female(princessEugenie).
female(ladyLouise).
female(princessCharlotte).
female(savannahPhillips).
female(islaPhillips).
female(miaGraceTindall).

/*Males*/
male(princePhillip).
male(princeCharles).
male(captainMarkPhillips).
male(timothyLaurence).
male(princeAndrew).
male(princeEdward).
male(princeWilliam).
male(princeHarry).
male(peterPhillips).
male(mikeTindall).
male(jamesViscountSevern).
male(princeGeorge).

/*Married*/
married(queenElizabethII,princePhillip).
married(princePhillip, queenElizabethII).

married(princeCharles,camillaParkerBowles).
married(camillaParkerBowles,princeCharles).

married(princessAnne,timothyLaurence).
married(timothyLaurence,princessAnne).

married(sophieRhys-jones,princeEdward).
married(princeEdward,sophieRhys-jones).

married(princeWilliam,kateMiddleton).
married(kateMiddleton,princeWilliam).

married(autumnKelly,peterPhillips).
married(peterPhillips,autumnKelly).

married(zaraPhillips,mikeTindall).
married(mikeTindall,zaraPhillips).

/*Divorced*/
divorced(princeCharles,princessDiana).
divorced(princessDiana,princeCharles).

divorced(captainMarkPhillips,princessAnne).
divorced(princessAnne,captainMarkPhillips).

divorced(sarahFerguson,princeAndrew).
divorced(princeAndrew,sarahFerguson).

/*Parent*/
parent(queenElizabethII,princeCharles).
parent(princePhillip,princeCharles).
parent(queenElizabethII,princessAnne).
parent(princePhillip,princessAnne).
parent(queenElizabethII,princeAndrew).
parent(princePhillip,princeAndrew).
parent(queenElizabethII,princeEdward).
parent(princePhillip,princeEdward).

parent(princessDiana,princeWilliam).
parent(princeCharles,princeWilliam).
parent(princessDiana,princeHarry).
parent(princeCharles,princeHarry).
parent(captainMarkPhillips,peterPhillips).
parent(princessAnne,peterPhillips).
parent(captainMarkPhillips,zaraPhillips).
parent(princessAnne,zaraPhillips).
parent(sarahFerguson,princessBeatrice).
parent(princeAndrew,princessBeatrice).
parent(sarahFerguson,princessEugenie).
parent(princeAndrew,princessEugenie).
parent(sophieRhys-jones,jamesViscountSevern).
parent(princeEdward,jamesViscountSevern).
parent(sophieRhys-jones,ladyLouise).
parent(princeEdward,ladyLouise).

parent(princeWilliam,princeGeorge).
parent(kateMiddleton,princeGeorge).
parent(princeWilliam,princessCharlotte).
parent(kateMiddleton,princessCharlotte).
parent(autumnKelly,savannahPhillips).
parent(peterPhillips,savannahPhillips).
parent(autumnKelly,islaPhillips).
parent(peterPhillips,islaPhillips).
parent(zaraPhillips,miaGraceTindall).
parent(mikeTindall,miaGraceTindall).

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
sibling(Person1,Person2):-parent(P,Person1), parent(P,Person2), Person1\=Person2.
brother(Person,Sibling):-sibling(Person,Sibling), male(Person).
sister(Person,Sibling):-sibling(Person,Sibling), female(Person).
aunt(Person,NieceNephew):-parent(P,NieceNephew), sibling(P,Person), female(Person).
uncle(Person,NieceNephew):-parent(P,NieceNephew), sibling(P,Person), male(Person).
niece(Person,AuntUncle):-(aunt(AuntUncle,Person);uncle(AuntUncle,Person)), female(Person).
nephew(Person,AuntUncle):-(aunt(AuntUncle,Person);uncle(AuntUncle,Person)), male(Person).