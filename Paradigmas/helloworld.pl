% Ej 1:

adre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis, pablo).
padre(luis, manuel).
padre(luis, ramiro).

padre(daniel,alan).

abuelo(X,Y) :- padre(X,Z), padre(Z,Y).

hermano(X,Y) :- padre(Z, X), padre(Z, Y), X \= Y.
hijo(X,Y) :- padre(Y,X).


descendiente(X,Y) :- padre(Y,X).
descendiente(X,Y) :- padre(Z,X), descendiente(Z,Y), X \= Y.

nieto(X,Y) :- abuelo(Y,X).

ancestro(X, X).
ancestro(X, Y) :- ancestro(Z, Y), padre(X, Z).

% Ej 3:

natural(0).
natural(suc(X)) :- natural(X).

menorOIgual(X,X) :- natural(X).
menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).


% EJ 4:
% append ::
% append [] ys = ys
% append (x:xs) ys = x : append xs ys

juntar([], L, L).
% lo pensé asi:
juntar([H1 | L1],L2,[H3 | L3]) :- H1 = H3, juntar(L1, L2, L3).
% forma equivalente: 
% juntar([X | L1], L2, [X, L3]) :- juntar(L1, L2, L3).

% Ej 5:

% Asi lo pense:
% ultimo([H | []], H).
% ultimo([_ | T], U) :- ultimo(T, U).
% Solucion con append:

ultimo(L, U) :- append(_, [U], L).


long([], 0).
long([_ | T], N) :- long(T, N1), N is N1 + 1.

reverse([H | []], [H]).
reverse([H | T], R) :- reverse(T,Z), append(Z,[H],R).

prefijo(P, L) :- append(P, _, L).

sufijo(S, L) :- append(_, S, L).

sublista2(S, L) :- prefijo(P,L), append(P,S,X), sufijo(Y,L), append(X, Y, L).


% asi lo pensé:
% pertenece(X, L) :- prefijo(P,L), sufijo(S,L), append(P,[X],Y), append(Y,S,L).

% solucion tryhard:
pertenece(X, L) :- append(_, [X | _], L).

aplanar([],[]).
aplanar(X, [X]) :-
    X \= [],            
    X \= [_|_]. 
aplanar([X | Xs], Ys) :- 
    aplanar(Xs, Zs), 
    aplanar(X, Y),
    append(Y , Zs, Ys).

interseccion([],_,[]).
interseccion([X | Xs], Ys, [X | L]) :-  member(X, Ys), interseccion(Xs, Ys, L), not(member(X, L)).
interseccion([X | Xs], Ys, L) :- not(member(X, Ys)), interseccion(Xs, Ys, L).

% Partir(N, Xs, L1, L2)

partir(0, Xs, [], Xs).
partir(N, [X | Xs], [X | L1], L2) :-  partir(N1, Xs, L1 ,L2), N is N1 + 1. 

