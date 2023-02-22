% MY_LENGTH

my_length([], 0).
my_length([_|T], R) :-
  my_length(T, NewLength),
  R is NewLength + 1.

% MY_MEMBER

my_member(X, [X|T]).
my_member(X, [H|T]) :-
  X \== H,
  my_member(X, T).

% MY_APPEND

my_append([],L,L).
my_append([H|Tail_1], List_2, [H|NewTail]) :-
  my_append(Tail_1, List_2, NewTail).

% MY_REVERSE

my_reverse([],[]).
my_reverse([Head|T], Result) :-
  my_reverse(T, SubResult),
  my_append(SubResult, [Head], Result).

% MY_NTH

my_nth([], N, []).
my_nth(List, 1, List).
my_nth([_|T], N, R) :-
  NewN is N-1,
  my_nth(T, NewN, R).

% MY_REMOVE

my_remove(X, [], []).
my_remove(X, [H|T], Result) :-
  X == H,
  my_remove(X, T, Result).
my_remove(X, [H|T], [H|Result]) :-
  H \== X,
  my_remove(X, T, Result).

% MY_SUBST

my_subst(X, Y, [], []).
my_subst(X, Y, [X|T], [Y|Result]) :-
  my_subst(X, Y, T, Result).
my_subst(X, Y, [H|T], [H|Result]) :-
  X \== H,
  my_subst(X, Y, T, Result).

% MY_SUBSET

my_subset(Relation, [], []).
my_subset(Relation, [H|T], Result) :-
  not(call(Relation, H)),
  my_subset(Relation, T, Result).
my_subset(Relation, [H|T], [H|Result]) :-
  call(Relation, H),
  my_subset(Relation, T, Result).

% MY_MERGE

my_merge([], [], []). % both L1 and L2 are empty
my_merge([], L2, L2). % L2 is still a list, L1 is empty
my_merge(L1, [], L1). % L1 is still a list, L2 is empty

% put the L1 head in the result and recurse on the remaining L1 and the whole L2
my_merge([H1|T1], [H2|T2], [H1|Result]) :-
  H1 < H2, 
  my_merge(T1, [H2|T2], Result).

% put the L2 head in the result and recurse on the remaining L2 and the whole L1
my_merge([H1|T1], [H2|T2], [H2|Result]) :-
  H1 >= H2, 
  my_merge([H1|T1], T2, Result).


% MY_ADD

my_add(N1, N2, FinalResult) :-
  my_add_helper(N1, N2, 0, FinalResult).


my_add_helper([], [], 1, [1]). % if both N1 and N2 are empty and has carry

my_add_helper([], [H2|T2], 1, Result) :- % if N1 is empty but N2 still has elements and has carry -> add carry to H2 (ex. [] + [9], 1)
  Digit is ((H2 + 1) mod 10),
  my_add_helper([], T2, 1, SubResult),
  my_append([Digit], SubResult, Result).

my_add_helper([H1|T1], [], 1, Result) :- % if N2 is empty but N1 still has elements and has carry
  Digit is ((H1 + 1) mod 10),
  my_add_helper(T1, [], 1, SubResult),
  my_append([Digit], SubResult, Result).


my_add_helper([], N2, 0, N2). % if N1 is empty but N2 still has elements but no carry -> N2

my_add_helper(N1, [], 0, N1). % if N2 is empty but N1 still has elements but no carry -> N1

my_add_helper([H1|T1], [H2|T2], Carry, Result) :- % if sum exceeds 10, recurse on the remaining digits with 1 as the carry
  Sum is H1 + H2 + Carry,
  Sum > 9,
  Digit is (Sum mod 10),
  my_add_helper(T1, T2, 1, SubResult),
  my_append([Digit], SubResult, Result).


my_add_helper([H1|T1], [H2|T2], Carry, Result) :- % if sum does not exceed 10, recurse on the remaining digits with 0 as the carry
  Digit is H1 + H2,
  Digit =< 9,
  my_add_helper(T1, T2, 0, SubResult),
  my_append([Digit], SubResult, Result).



% MY_SUBLIST

my_sublist([A], [A]). % both L1 and L2 have only one element
my_sublist([],_). % all elements in L1 have been matched
my_sublist([First1,Second1|T1], [First2,Second2|T2]) :-
  First1 == First2,
  Second1 == Second2,
  my_sublist(T1, T2).

my_sublist(L1, [_|T2]) :-
  my_sublist(L1, T2).

% MY_ASSOC

my_assoc(A, [A,Value|T], Value).
my_assoc(A, [_,_|T], R) :-
  my_assoc(A, T, R).


% MY_REPLACE

my_replace(ALIST, [], []).

my_replace(ALIST, [H|T], [Value|Result]):-
  my_assoc(H, ALIST, Value),
  my_replace(ALIST, T, Result). % use the value if key-value pair found

my_replace(ALIST, [H|T], [H|Result]):-
  my_replace(ALIST, T, Result). % use the original element if no key-value pair found
