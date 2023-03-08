% SIMPLIFY

simplify(X, X) :-
  atom(X);
  integer(X).

simplify(-X, -X) :-
  atom(X);
  integer(X).

% EXPONENT
simplify(X ^ Y, R) :-
  exponent(X, Y, R).

% MULTIPLY
simplify(X * Y, R) :-
  multiply(X, Y, R).

% DIVIDE
simplify(X / Y, R) :-
  divide(X, Y, R).

% ADD
simplify(X + Y, R) :-
  add(X, Y, R).

% SUBTRACT
simplify(X - Y, R) :-
  subtract(X, Y, R).


% EXPONENT HELPER
exponent(X, Y, R) :-
  integer(X), integer(Y),
  R is X ^ Y.
exponent(X, 0, 1) :- 
  atom(X).
exponent(X, 1, X) :-
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



multiply(X, Y, 0) :- 
  atom(Y),
  simplify(X, XR),
  XR == 0.
multiply(X, Y, Y) :-
  atom(Y),
  simplify(X, XR),
  XR == 1.
multiply(X, Y, XR * Y) :-
  atom(Y),
  simplify(X, XR).

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
  simplify(X, XR),
  simplify(Y, YR),
  integer(XR),
  integer(YR),
  R is XR + YR.
add(X, Y, XR + YR) :-
  simplify(X, XR),
  simplify(Y, YR).

% SUBTRACT HELPER
subtract(X, X, 0) :- atom(X).
subtract(X, Y, X) :-
    atom(X),
    simplify(Y, YR),
    YR == 0.
subtract(X, Y, -Y) :-
    atom(Y),
    simplify(X, XR),
    XR == 0.
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
  YR == 0.
subtract(X, Y, XR - YR) :-
  simplify(X, XR),
  simplify(Y, YR).


% DERIV
if_term_is_negative(N / X ^ Y) :-
  N < 0.

format_term(N / X ^ Y, NPositive / X ^ Y) :-
  NPositive is -N.

% power rule n*x^(n-1)
power_rule(X, N, R) :-
    simplify(N - 1, ReducedPower),
    simplify(X ^ ReducedPower, RaisedPower),
    simplify(N * RaisedPower, R).


format_result(N * X ^ Y, N / X ^ YPositive) :-
    YPositive is -Y.

% constant by itself
deriv(Constant, 0) :- integer(Constant).

% x
deriv(x, 1).

% constant divided by a power (ex. 2/x^3 = -6/x^4)
deriv(N / X ^ Y, RFormatted) :-
    YNegative is Y * -1,
  deriv(N * X ^ YNegative, R),
	format_result(R, RFormatted).

% constant divided by an atom x (ex. 1/x = x^-1)
deriv(N / X, RFormatted) :- 
   atom(X),
  deriv(N * X ^ -1, R),
    format_result(R, RFormatted).

% constant times atom x (ex. 5 * x)
deriv(N * X, N) :-
  atom(X).

% constant times a power (ex. 2*x^3)
deriv(X * Y ^ Z, Result) :-
  simplify(X * Z, MultipliedConstant),
  simplify(Z - 1, ReducedPower),
  simplify(Y ^ ReducedPower, RaisedPower),
  simplify(MultipliedConstant * RaisedPower, Result).

deriv(X ^ N, Result) :-
    power_rule(X, N, Result).

deriv(X * Y, Result) :-
    deriv(X, XR),
    deriv(Y, YR),
    simplify(XR * YR, Result).

deriv(X / Y, Result) :-
    deriv(X, XR),
    deriv(Y, YR),
    simplify(XR / YR, Result).

deriv(X - Y, Result) :-
    deriv(X, XR),
    deriv(Y, YR),
    if_term_is_negative(YR),
    format_term(YR, NewYR),
    simplify(XR + NewYR, Result).

deriv(X - Y, Result) :-
    deriv(X, XR),
    deriv(Y, YR),
    not(if_term_is_negative(YR)),
    simplify(XR - YR, Result).

deriv(X + Y, Result) :-
    deriv(X, XR),
    deriv(Y, YR),
    if_term_is_negative(YR),
    format_term(YR, NewYR),
    simplify(XR - NewYR, Result).

deriv(X + Y, Result) :-
    deriv(X, XR),
    deriv(Y, YR),
    not(if_term_is_negative(YR)),
    simplify(XR + YR, Result).



% handle 4-(-2*x)
