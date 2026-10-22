% Нэгдүгээр эрэмбийн логик: гэр бүлийн мэдлэгийн сан.
% parent(P,C): P нь эцэг эх, C нь хүүхэд. UTF-8 encoding.
% swipl -s family.pl
:- encoding(utf8).
:- dynamic male/1, parent/2.

% Эрэгтэй 8 хүн.
male(bataa).
male(bold).
male(tomor).
male(dorj).
male(zolboo).
male(munkh).
male(temuulen).
male(bat).

% Эмэгтэй 7 хүн.
female(saraa).
female(oyuna).
female(tsetseg).
female(ganaa).
female(anar).
female(naraa).
female(enkhee).

% Таван өрхийн эцэг эхийн 18 холбоо.
parent(bataa,bold).
parent(bataa,oyuna).
parent(bataa,tomor).
parent(saraa,bold).
parent(saraa,oyuna).
parent(saraa,tomor).
parent(bold,anar).
parent(bold,zolboo).
parent(tsetseg,anar).
parent(tsetseg,zolboo).
parent(dorj,munkh).
parent(dorj,naraa).
parent(oyuna,munkh).
parent(oyuna,naraa).
parent(tomor,enkhee).
parent(ganaa,enkhee).
parent(bat,temuulen).
parent(anar,temuulen).

% Эрэгтэй бол хүн: ∀x (male(x) → person(x)).
person(X) :- male(X).
% Эмэгтэй бол хүн: ∀x (female(x) → person(x)).
person(X) :- female(X).

% Эцэг: ∀x∀y ((parent(x,y) ∧ male(x)) → father(x,y)).
father(X,Y) :- parent(X,Y), male(X).
% Эх: ∀x∀y ((parent(x,y) ∧ female(x)) → mother(x,y)).
mother(X,Y) :- parent(X,Y), female(X).
% Хүү: ∀x∀y ((parent(y,x) ∧ male(x)) → son(x,y)).
son(X,Y) :- parent(Y,X), male(X).
% Охин: ∀x∀y ((parent(y,x) ∧ female(x)) → daughter(x,y)).
daughter(X,Y) :- parent(Y,X), female(X).

% Өвөө эмээ: ∀x∀y∀z ((parent(x,z) ∧ parent(z,y)) → grandparent(x,y)).
grandparent(X,Y) :- parent(X,Z), parent(Z,Y).
% Ах дүү: ∀x∀y∀p ((parent(p,x) ∧ parent(p,y) ∧ x≠y) → sibling(x,y)).
sibling(X,Y) :- parent(P,X), parent(P,Y), X \= Y.
% X≠Y-г хассан зөвхөн харьцуулах хувилбар.
sibling_unchecked(X,Y) :- parent(P,X), parent(P,Y).
% Эрэгтэй ах дүү: ∀x∀y ((sibling(x,y) ∧ male(x)) → brother(x,y)).
brother(X,Y) :- sibling(X,Y), male(X).
% Эмэгтэй ах дүү: ∀x∀y ((sibling(x,y) ∧ female(x)) → sister(x,y)).
sister(X,Y) :- sibling(X,Y), female(X).
% Эцэг/эхийн эрэгтэй ах дүү: ∀x∀y∀p ((parent(p,y) ∧ brother(x,p)) → uncle(x,y)).
uncle(X,Y) :- parent(P,Y), brother(X,P).
% Эцэг/эхийн эмэгтэй ах дүү: ∀x∀y∀p ((parent(p,y) ∧ sister(x,p)) → aunt(x,y)).
aunt(X,Y) :- parent(P,Y), sister(X,P).
% Үеэл: ∀x∀y∀p∀q ((parent(p,x) ∧ parent(q,y) ∧ sibling(p,q)) → cousin(x,y)).
cousin(X,Y) :- parent(P,X), parent(Q,Y), sibling(P,Q).

% Өвгийн суурь: ∀x∀y (parent(x,y) → ancestor(x,y)).
ancestor(X,Y) :- parent(X,Y).
% Өвгийн рекурс: ∀x∀y∀z ((parent(x,z) ∧ ancestor(z,y)) → ancestor(x,y)).
% Энэ сан циклгүй. parent-ийг рекурсив дуудлагын өмнө шалгана.
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).
% Үр удам: ∀x∀y (ancestor(y,x) → descendant(x,y)).
descendant(X,Y) :- ancestor(Y,X).

% Ядаж нэг хүүхэдтэй: ∀x∀y (parent(x,y) → has_child(x)).
has_child(X) :- parent(X,_).
% Эхлээд X-ийг хүнээр холбоод, хүүхэдтэй эсэхийг үгүйсгэнэ (CWA).
childless(X) :- person(X), \+ has_child(X).
% Элэнц өвөө эмээ: ∀x∀y∀z ((parent(x,z) ∧ grandparent(z,y)) → great_grandparent(x,y)).
great_grandparent(X,Y) :- parent(X,Z), grandparent(Z,Y).
% Ядаж нэг үеэлтэй хүнийг ялгана.
has_cousin(X) :- cousin(X,_).
% Ядаж нэг ач, зээтэй хүнийг ялгана.
has_grandchild(X) :- grandparent(X,_).

% Даалгаврын таамаглал: нэг хүүхдийн хоёр өөр эцэг эх бол хос.
% ∀x∀y∀z ((parent(x,z) ∧ parent(y,z) ∧ x≠y) → spouse(x,y)).
spouse(X,Y) :- parent(X,Z), parent(Y,Z), X \= Y.
% Авга/нагац эгчийн эрэгтэй хань.
uncle_in_law(X,Y) :- aunt(Z,Y), spouse(X,Z), male(X).
% Авга/нагац ахын эмэгтэй хань.
aunt_in_law(X,Y) :- uncle(Z,Y), spouse(X,Z), female(X).

% Шинэ гишүүний туршилт: дүрэм өөрчлөхгүй; давтаж дуудсан ч давхардахгүй.
add_dulguun :-
    remove_dulguun,
    assertz(male(dulguun)),
    assertz(parent(bat,dulguun)),
    assertz(parent(anar,dulguun)).

% Туршилтын гурван баримтыг хасаад үндсэн санг сэргээнэ.
remove_dulguun :-
    retractall(parent(bat,dulguun)),
    retractall(parent(anar,dulguun)),
    retractall(male(dulguun)).
