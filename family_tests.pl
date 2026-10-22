% SWI-Prolog автомат шалгалт: swipl -q -s family_tests.pl -g run_tests -t halt
:- encoding(utf8).
:- ensure_loaded(family).
:- use_module(library(plunit)).

:- begin_tests(family).

% Бүх баталгаанаас ялгаатай утгуудыг тоолно.
unique_count(Template, Goal, Count) :-
    findall(Template, Goal, Raw), sort(Raw, Unique), length(Unique, Count).

test(facts) :-
    unique_count(X,male(X),8), unique_count(X,female(X),7),
    unique_count(X,person(X),15), unique_count(X-Y,parent(X,Y),18).
test(bataa_children) :- setof(X,parent(bataa,X),[bold,oyuna,tomor]).
test(father) :- setof(X,father(X,anar),[bold]).
test(mother) :- setof(X,mother(X,bold),[saraa]).
test(son) :- setof(X,son(X,oyuna),[munkh]).
test(daughter) :- setof(X,daughter(X,oyuna),[naraa]).
test(parent_gender_counts) :-
    unique_count(X-Y,father(X,Y),9), unique_count(X-Y,mother(X,Y),9).
test(grandparent) :- setof(X,grandparent(X,temuulen),[bold,tsetseg]).
test(grandparent_count) :- unique_count(X-Y,grandparent(X,Y),12).
test(sibling_munkh) :- setof(X,sibling(X,munkh),[naraa]).
test(sibling_bold) :- setof(X,sibling(X,bold),[oyuna,tomor]).
test(sibling_count) :- unique_count(X-Y,sibling(X,Y),10).
test(no_self_sibling, [fail]) :- sibling(X,X).
test(unchecked_sibling_count) :- unique_count(X-Y,sibling_unchecked(X,Y),19).
test(self_siblings) :-
    setof(X,sibling_unchecked(X,X),[anar,bold,enkhee,munkh,naraa,oyuna,temuulen,tomor,zolboo]).
test(prolog_duplicate_proofs) :-
    findall(Y,sibling(oyuna,Y),L), length(L,4), sort(L,[bold,tomor]).
test(brother) :- setof(X,brother(X,oyuna),[bold,tomor]).
test(sister) :- setof(X,sister(X,zolboo),[anar]).
test(uncle_anar) :- setof(X,uncle(X,anar),[tomor]).
test(aunt_anar) :- setof(X,aunt(X,anar),[oyuna]).
test(uncle_temuulen) :- setof(X,uncle(X,temuulen),[zolboo]).
test(uncle_munkh) :- setof(X,uncle(X,munkh),[bold,tomor]).
test(dorj_not_blood_uncle, [fail]) :- uncle(dorj,anar).
test(cousin_enkhee) :- setof(X,cousin(X,enkhee),[anar,munkh,naraa,zolboo]).
test(cousin_anar) :- setof(X,cousin(X,anar),[enkhee,munkh,naraa]).
test(cousin_count) :- unique_count(X-Y,cousin(X,Y),16).
test(ancestor_temuulen) :- setof(X,ancestor(X,temuulen),[anar,bat,bataa,bold,saraa,tsetseg]).
test(descendants_bataa) :-
    setof(X,descendant(X,bataa),[anar,bold,enkhee,munkh,naraa,oyuna,temuulen,tomor,zolboo]).
test(ancestor_anar) :- setof(X,ancestor(X,anar),[bataa,bold,saraa,tsetseg]).
test(ancestor_count) :- unique_count(X-Y,ancestor(X,Y),32).
test(ancestor_chain) :- once(ancestor(bataa,temuulen)).
test(childless) :- setof(X,childless(X),[enkhee,munkh,naraa,temuulen,zolboo]).
test(childless_bataa, [fail]) :- childless(bataa).
test(childless_temuulen) :- once(childless(temuulen)).
test(great_grandparent) :- setof(X,great_grandparent(X,temuulen),[bataa,saraa]).
test(has_cousin) :- setof(X,has_cousin(X),[anar,enkhee,munkh,naraa,zolboo]).
test(has_grandchild) :- setof(X,has_grandchild(X),[bataa,bold,saraa,tsetseg]).
test(spouse_count) :- unique_count(X-Y,spouse(X,Y),10).
test(spouse_pairs) :-
    setof(X-Y,(spouse(X,Y),X@<Y),[anar-bat,bataa-saraa,bold-tsetseg,dorj-oyuna,ganaa-tomor]).
test(uncle_in_law) :-
    setof(X-Y,uncle_in_law(X,Y),[dorj-anar,dorj-enkhee,dorj-zolboo]).
test(aunt_in_law) :-
    setof(X-Y,aunt_in_law(X,Y),[ganaa-anar,ganaa-munkh,ganaa-naraa,ganaa-zolboo,
                              tsetseg-enkhee,tsetseg-munkh,tsetseg-naraa]).
test(dulguun, [setup(add_dulguun),cleanup(remove_dulguun)]) :-
    setof(X,sibling(X,temuulen),[dulguun]),
    setof(X,ancestor(X,dulguun),A), setof(X,ancestor(X,temuulen),A),
    A=[anar,bat,bataa,bold,saraa,tsetseg],
    unique_count(X,person(X),16), unique_count(X-Y,parent(X,Y),20),
    unique_count(X-Y,sibling(X,Y),12), unique_count(X-Y,ancestor(X,Y),38),
    unique_count(X,childless(X),6).
test(dulguun_repeat, [cleanup(remove_dulguun)]) :-
    add_dulguun, add_dulguun,
    findall(X,parent(X,dulguun),L), sort(L,[anar,bat]), length(L,2).
test(restored) :-
    unique_count(X,person(X),15), unique_count(X-Y,parent(X,Y),18),
    unique_count(X-Y,ancestor(X,Y),32), \+ person(dulguun).
test(no_recorded_parent_bataa, [fail]) :- parent(_,bataa).

:- end_tests(family).
