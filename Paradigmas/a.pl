natural(cero).
natural(suc(X)) :- natural(X).

mayorOIgual(X,X) :- natural(X).
mayorOIgual(suc(X),Y) :- mayorOIgual(X, Y).


nat(0).
nat(N) :- nat(N1), N is N1 + 1.

generarListas(L) :- nat(N), listasQueSuman(L,N).

listasQueSuman([], 0).
listasQueSuman([H | T], N) :- between(1, N, H), N1 is N - H,  listasQueSuman(T,N1). 

%pmq(+X, -Y)
pmq(X, Y) :- between(0, X, Y),  par(Y).
            % generamos los y, testeamos que cumplan

%par(+Y)
par(Y) :- 0 =:= Y mod 2.


%coprimos(-X, -Y)
coprimos(X, Y) :- generarPares(X,Y), X > 0, Y > 0, 1 =:= gcd(X,Y).

%generarPares(-X, -Y)
generarPares(X,Y) :- nat(N), paresQueSuman(N, X, Y).

%paresQueSuman(+N, -X, -Y)
paresQueSuman(N, X, Y) :- between(0, N, X), Y is N-X.

%triplasQueSuman(?P, -A, -B, -C)
triplasQueSuman(P, A, B, C) :- 
    nat(P), 
    between(1,P,A), between(1,P,B), 
    C is P - A - B,  
    C > 0.

sublista(_, []).
sublista(L, SL) :-
	append(_, SLYAlgoMas, L),
	append(SL, _, SLYAlgoMas).

insertar(X, L, LX) :-
	append(A, B, L),
	append(A, [X|B], LX).

permutacion([], []).
permutacion([H|T], P) :-
	permutacion(T, Q),
	 insertar(H, Q, P).	 


loElijoONo([],[]).
loElijoONo([H | T], [H | Res]) :- loElijoONo(T, Res).
loElijoONo([_ | T], Res) :- loElijoONo(T, Res).