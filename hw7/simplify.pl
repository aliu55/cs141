
% SIMPLIFY

simplify(X, X) :-
  atom(X);
  integer(X).

% EXPONENT
simplify(X ^ Y, R) :-
  exponent(X, Y, R).

% MULTIPLY
simplify(X * Y, R) :-
    write("multiplying: "), write(X), write(" and "), write(Y), nl,
  multiply(X, Y, R).

% DIVIDE
simplify(X / Y, R) :-
    write("dividing: "), write(X), write(" and "), write(Y), nl,
  divide(X, Y, R).

% ADD
simplify(X + Y, R) :-
      write("adding: "), write(X), write(" and "), write(Y), nl,
  add(X, Y, R).

% SUBTRACT
simplify(X - Y, R) :-
      write("subtracting: "), write(X), write(" and "), write(Y), nl,
  subtract(X, Y, R).


% EXPONENT HELPER
exponent(X, Y, R) :-
  integer(X), integer(Y),
  R is X ^ Y.
exponent(X, 0, 1) :- 
  atom(X).
exponent(X, 1, X ^ 1) :-
  atom(X).
exponent(X, Y, X ^ YR) :-
  atom(X),
  simplify(Y, YR).

% MULTIPLY HELPER
multiply(X, Y, 0) :- 
  atom(X),
  simplify(Y, YR),
  YR == 0.
multiply(X, Y, X) :-
  atom(X),
  simplify(Y, YR),
  YR == 1.
multiply(X, Y, X * YR) :-
  atom(X),
  simplify(Y, YR).

multiply(Y, X, 0) :- 
  atom(X),
  simplify(Y, YR),
  YR == 0.
multiply(Y, X, X) :-
  atom(X),
  simplify(Y, YR),
  YR == 1.
multiply(Y, X, X * YR) :-
  atom(X),
  simplify(Y, YR).

multiply(X, Y, R) :-
  simplify(X, XR),
  simplify(Y, YR),
  integer(XR),
  integer(YR),
  R is XR * YR.
multiply(X, Y, XR * YR) :-
  simplify(X, XR),
  simplify(Y, YR).

% DIVIDE HELPER
divide(X, Y, R) :-
  integer(X), integer(Y),
  R is X / Y.
divide(X, X, 1) :-
  atom(X).
divide(X, Y, X / YR) :-
  atom(X),
  simplify(Y, YR).
divide(Y, X, YR / X) :-
  atom(X),
  simplify(Y, YR).
divide(X, Y, XR / YR) :-
  simplify(X, XR),
  simplify(Y, YR).

% ADD HELPER
add(X, Y, X) :-
    atom(X),
    simplify(Y, YR),
    YR == 0.
add(Y, X, X) :-
    atom(X),
    simplify(Y, YR),
    YR == 0.
add(X, Y, X + YR) :-
  atom(X),
  simplify(Y, YR).
add(Y, X, YR + X) :-
  atom(X),
  simplify(Y, YR).
add(X, Y, R) :-
    write("trying out fjsdfkljs"),nl,
  simplify(X, XR),
  simplify(Y, YR),
  integer(XR),
  integer(YR),
  R is XR + YR.
add(X, Y, XR + YR) :-
  write("afsdfasd"),nl,
  simplify(X, XR),
  simplify(Y, YR).

% SUBTRACT HELPER
subtract(X, X, 0) :- atom(X).
subtract(X, Y, X) :-
    atom(X),
    simplify(Y, YR),
    YR == 0.
subtract(Y, X, -1 * X) :-
    atom(X),
    simplify(Y, YR),
    YR == 0.
subtract(X, Y, X - YR) :-
  atom(X),
  simplify(Y, YR).
subtract(Y, X, YR - X) :-
  atom(X),
  simplify(Y, YR).
subtract(X, Y, R) :-
  simplify(X, XR),
  simplify(Y, YR),
  integer(XR),
  integer(YR),
  R is XR - YR.

subtract(X, Y, XR) :-
  simplify(X, XR),
  simplify(Y, YR),
	atom(XR),
    YR == 0,
    write("x-0 case subtract"), nl.
subtract(X, Y, XR - YR) :-
  simplify(X, XR),
  simplify(Y, YR),
    write("put together in subtract"), nl.
