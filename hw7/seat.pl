male(klefstad).
male(bill).
male(mark).
male(isaac).

female(emily).
female(heidi).
female(beth).
female(susan).
female(jane).

speaks(klefstad, english).
speaks(bill, english).
speaks(emily, english).
speaks(heidi, english).
speaks(isaac, english).

speaks(beth, french).
speaks(mark, french).
speaks(susan, french).
speaks(isaac, french).

speaks(klefstad, spanish).
speaks(bill, spanish).
speaks(susan, spanish).
speaks(fred, spanish).
speaks(jane, spanish).

same_language(X, Y) :- 
    speaks(X, XLanguage),
    speaks(Y, YLanguage),
    XLanguage == YLanguage.

both_females(X, Y) :-
    female(X),
    female(Y).

diff_first_and_last([First,_,_,_,_,_,_,_,_,Last]) :-
    not(both_females(First, Last)).

last_diff_from_X([LastPerson],X) :-
    not(both_females(X, LastPerson)),
	same_language(X, LastPerson),
    write("LastPerson and X: "), write(LastPerson), write(" "), write(X), nl.
last_diff_from_X([_|T],X):- 
    write("TAIL: "), write(T), nl,
    last_diff_from_X(T,X).

seating_helper(L, L) :-
    length(L, 10),
    diff_first_and_last(L).


seating_helper(L, R) :-
    % speaks same language
    length(L, 0),
    same_language(X, Y),
    % no two females
    not(both_females(X, Y)),
    % not already in list
    not(member(X, L)),
    not(member(Y, L)),
	% two different people
	X \== Y,
    % do the same checks for the last person in the list
    write("LIST: "), write(L),nl,
    append(L, [X, Y], SubR),
    write("CHOSE: "), write(X), write(" "), write(Y), nl,
    seating_helper(SubR, R).

seating_helper(L, R) :- 
	% speaks same language
    same_language(X, Y),
    % no two females
    not(both_females(X, Y)),
    % not already in list
    not(member(X, L)),
    not(member(Y, L)),
	% two different people
	X \== Y,
    % do the same checks for the last person in the list
    last_diff_from_X(L, X),
    write("LIST: "), write(L),nl,
    append(L, [X, Y], SubR),
    write("CHOSE: "), write(X), write(" "), write(Y), nl,
    seating_helper(SubR, R).


party_seating(L) :-
    seating_helper([], L).