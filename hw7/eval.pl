% EVAL
eval(X, X) :-
  atom(X);
  integer(X).

eval(Num1 + Num2, R) :-
  write("adding: "), write(Num1), write(" and "), write(Num2), nl,
  eval(Num1, Num1Result),
  eval(Num2, Num2Result),
  R is Num1Result + Num2Result.

eval(Num1 - Num2, R) :-
  write("subtracting: "), write(Num1), write(" and "), write(Num2), nl,
  eval(Num1, Num1Result),
  eval(Num2, Num2Result),
  R is Num1Result - Num2Result.

eval(Num1 * Num2, R) :-
  write("multiplying: "), write(Num1), write(" and "), write(Num2), nl,
  write("evaluating Num1"),nl,
  eval(Num1, Num1Result),
  write("evaluating Num2"),nl, 
  eval(Num2, Num2Result),
  R is Num1Result * Num2Result.

eval(Num1 / Num2, R) :-
  write("dividing: "), write(Num1), write(" and "), write(Num2), nl,
  eval(Num1, Num1Result),
  eval(Num2, Num2Result),
  R is Num1Result / Num2Result.

eval(Num1 ^ Num2, R) :-
  eval(Num1, Num1Result),
  eval(Num2, Num2Result),
  R is Num1Result ^ Num2Result.
