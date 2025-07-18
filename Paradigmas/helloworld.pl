% Ej 1:

padre(juan, carlos).
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
interseccion([X | Xs], Ys, [X | L]) :-  
    member(X, Ys), 
    interseccion(Xs, Ys, L), 
    not(member(X, L)).
interseccion([X | Xs], Ys, L) :- 
    not(member(X, Ys)), 
    interseccion(Xs, Ys, L).

% Partir(N, Xs, L1, L2)

% partir(0, Xs, [], Xs).
% partir(N, [X | Xs], [X | L1], L2) :-  partir(N1, Xs, L1 ,L2), N is N1 + 1. 
partir(N,L, L1,L2) :-
    length(L1, N),
    append(L1, L2, L).
    
iesimo(0, [X | _] , X).
iesimo(I, [_ | T], X) :- I \= 0, I1 is I - 1, iesimo(I1, T, X).

% Pares menores que X: 

pmq(X, Y) :- % Genero todos los numeros entre 0 y X, dsp me quedo con los que son pares.
    between(0, X, Y), % Instancio Y, sino no podria chequear que sea par
    0 =:= Y mod 2.  % Y ya instanciada, pido que sea par.
    % Si yo primero genero todos los numeros pares y despues veo cuales son menores a X, no termina nunca el programa
    % seria una generacion infinita primero, hay que tener cuidado con el orden.
% borrar(+ListaOriginal, +X, -ListaSinX)

borrar([],_,[]).
borrar([X | ListaOriginal], X, ListaSinX) :- borrar(ListaOriginal, X, ListaSinX).
borrar([H | ListaOriginal], X, [H | ListaSinX]) :- borrar(ListaOriginal, X, ListaSinX).

sacarDuplicados([],[]).
sacarDuplicados([X | L1], L2) :-
    member(X, L1),
    sacarDuplicados(L1,L2).
sacarDuplicados([X | L1], [X | L2]) :-
    not(member(X, L1)),
    sacarDuplicados(L1,L2).

permutacion(L1, L2) :-
    length(L1, N),
    permutacionAux(L1, N, L2).

permutacionAux([],_,_).
permutacionAux([X | L1], N, Res) :-
    length(Res, N),
    member(X, Res),
    permutacionAux(L1,N,Res).

reparto(L, N, LListas) :-
    length(LListas, N),
    aplanar(LListas, L).

% Ej 10:
% desde(X,X).
% desde(X,Y) :- N is X+1, desde(N,Y).

%desde(+X, -Y)
desde(X, X).
desde(X, Y) :- N is X+1, desde(N, Y).

%desdeReversible(+X, ?Y)
desdeReversible(X,Y) :- var(Y), desde(X,Y).
desdeReversible(X,Y) :- nonvar(Y), X =< Y.

% Ej 11:

intercalar([],L2,L2).
intercalar(L1,[],L1).
intercalar([X | L1], [Y | L2],[X | [Y | Res]]) :- intercalar(L1,L2,Res).

% Ej 12: Bin(i, r, d)

vacio(nil).

raiz(bin(_,R,_),R).

altura(nil,0).
altura(bin(Izq,_,Der), Altura) :- 
    altura(Izq, AlturaIzq),
    altura(Der, AlturaDer),
    Altura is max(AlturaIzq, AlturaDer) + 1.

max(A,B,A) :- A >= B.
max(A,B,B) :- B >= A.

cantNodos(nil, 0).
cantNodos(bin(Izq, _, Der), N) :- cantNodos(Izq, Nizq),cantNodos(Der, Nder), N is Nizq + Nder + 1.

inorder(nil,[]).
inorder(bin(Izq, R, Der), L) :- inorder(Izq, L1), inorder(Der,L2), append(L1, [R | L2], L).

arbolConInorder([], nil).
arbolConInorder(L, bin(Izq, R, Der)) :- 
    length(L, N),
    Mitad is N // 2,
    length(PrimeraMitad, Mitad),
    append(PrimeraMitad, [R | SegundaMitad],L),
    arbolConInorder(PrimeraMitad, Izq),
    arbolConInorder(SegundaMitad, Der).

aBB(AB) :- aBBAux(AB, -inf, +inf).

aBBAux(nil, _, _).
aBBAux(bin(Izq, R, Der), Min, Max) :- R >= Min, R =< Max, aBBAux(Izq, Min, R), aBBAux(Der, R, Max).


% aBBinsertar(X, nil, bin(nil,X,nil)).
% aBBinsertar(X, bin(Izq, R, Der), ABRes).



%coprimos(-X, -Y)
coprimos(X, Y) :- generarPares(X,Y), X > 0, Y > 0, 1 =:= gcd(X,Y).

%generarPares(-X, -Y)
generarPares(X,Y) :- desde(0, N), paresQueSuman(N, X, Y).

%paresQueSuman(+N, -X, -Y)
paresQueSuman(N, X, Y) :- between(0, N, X), Y is N-X.

sumanN(0,[]).
sumanN(N,[H | T]) :- sumanN(N1, T), N is N1 + H.

generarMatriz(N, Matriz) :- length(Matriz, N), maplist(longitud(N), Matriz).
longitud(N, L) :- length(L,N).

dominio(_, []).
dominio(N,[X | Xs]) :- between(0,N,X), dominio(N,Xs).

cuadradoSemiMagico(N, [PrimeraFila | Matriz]) :-
  length([PrimeraFila | Matriz], N),
  % filas de longitud N
  maplist(length_(N), [PrimeraFila | Matriz]),
  % rango de valores 0..N
  maplist(maplist(dominio(N)), [PrimeraFila | Matriz]),
  % calculo de suma objetivo
  sumanN(S, PrimeraFila),
  % todas las filas suman S
  maplist(sumanN(S), Matriz).

length_(N, L) :- length(L, N).

arbol(nil).
arbol(bin(I, _, D)) :- arbol(I), arbol(D).

nodosEn(nil, _) :- !.
nodosEn(bin(I, R, D), L) :-  member(R, L), nodosEn(I, L), nodosEn(D,L).

% sinRepEn(nil, []) :- !.
% sinRepEn(bin(I, R, D), [H | T]) :- nodosEn(A, [H]), sinRepEn(A, T).
% a)

tieneMateriaAprobada(E, M) :-
    notas(XS),tAux(E,M,XS).

tAux(E,M,[(E,M,Nota) | _]) :- Nota >= 4.
tAux(E,M,[_ | T]) :- tAux(E,M,T).

% b)

elimAplazos([],[]).
elimAplazos([(E,M,Nota) | T],L) :- tAux(E,M, [(E,M,Nota) | T]), Nota < 4, elimAplazos(T,L).
elimAplazos([(E,M,Nota) | T],[(E,M,Nota) | L]) :- tAux(E,M, [(E,M,Nota) | T]), Nota >= 4 ,elimAplazos(T,L).
elimAplazos([(E,M,Nota) | T],[(E,M,Nota) | L]) :- not(tAux(E,M, [(E,M,Nota) | T])) ,elimAplazos(T,L).
% c)

promedio(A,P) :-
    notas(XS),
    notasDeA(A,XS,Res),
    calcularPromedio(Res,P).

notasDeA(_,[],[]).
notasDeA(A,[(A,_,Nota) | XS],[Nota | Res]) :- notasDeA(A,XS,Res).
notasDeA(A,[(B,_,_) | XS],Res) :- A \= B, notasDeA(A,XS,Res).

calcularPromedio(Res,P) :-
    sum_list(Res, Total),
    length(Res, N),
    P is Total / N.

mejorEstudiante(A) :- estudiante(A), promedio(A,P), not((estudiante(B), promedio(B,Q), Q > P)).

% Predicados base
estudiante(juan).
estudiante(maria).
estudiante(pedro).
estudiante(luis).

notas([
    (juan, plp, 3),
    (juan, plp, 9),
    (maria, tlen, 2),
    (maria, tlen, 5),
    (pedro, alg, 7),
    (pedro, alg, 8),
    (luis, fisica, 2),
    (luis, fisica, 3)
]).
% 9 8 7 6 5 4 1 2 3

% subsecuenciaCreciente(+L,-S)

subsecuenciaCreciente([],[]).
subsecuenciaCreciente([H | T],[H | S]) :-
    subsecuenciaCreciente(T, S),
    esCreciente([H | S]).
subsecuenciaCreciente([_ | T],S) :-
    subsecuenciaCreciente(T, S),
    esCreciente(S).

esCreciente([]).
esCreciente([H | T]) :- listaCreciente(H, T).

listaCreciente(_, []).
listaCreciente(Elem ,[H | T]) :- 
    Elem < H,
    listaCreciente(H,T).


% subsecuenciaCrecienteMasLarga(+L,-S) 

subsecuenciaCrecienteMasLarga(L,S) :-
    subsecuenciaCreciente(L, S),
    length(S,N),
    not((subsecuenciaCreciente(L, S1), length(S1,M), M > N)).

fib(X) :-  
    desde(2, N),
    fibonacci(N, X).

fibonacci(0, 0).
fibonacci(1, 1).
fibonacci(N, Fibo) :-
    N >= 2,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci(N1, F1),
    fibonacci(N2, F2),
    Fibo is F1 + F2.

from(X, X).
from(X, Y) :- N is X + 1, from(N, Y).

esCapicua(L) :- reverse(L,L).


tokenizar(_,[],[]).
tokenizar(Diccionario, Letras, [Palabra | Palabras]) :-
    member(Palabra,Diccionario),
    append(Palabra, RestoDeLetras, Letras),
    tokenizar(Diccionario, RestoDeLetras, Palabras).

mayorCantPalbras(D,T,F) :-
    tokenizar(D,T,F),
    length(F,N),
    not((tokenizar(D,T,F2), length(F2,M), M > N)).


sublistaDePrimos(Lista,Primos) :-
    sublista2(Primos,Lista),
    todosPrimos(Primos).

todosPrimos([]).
todosPrimos([Primo | Lista]) :- esPrimo(Primo), todosPrimos(Lista).

listaDePrimosMasLarga(Lista,Primos) :-
    sublistaDePrimos(Lista,Primos),
    length(Primos,N),
    not((sublistaDePrimos(Lista,OtrosPrimos), length(OtrosPrimos, M), M > N)).

esPrimo(N) :-
    integer(N),
    N > 1,
    \+ tiene_divisor(N, 2).

% tiene_divisor(+N, +D)
% Verdadero si D*D =< N y D divide a N, o bien existe un divisor ≥D.
tiene_divisor(N, D) :-
    D*D =< N,
    (  N mod D =:= 0
    ;  D2 is D + 1,
       tiene_divisor(N, D2)
    ).

simbolo(a).
simbolo(b).

clausura([]).
clausura([S | L]) :-
    clausura(L),
    simbolo(S).


objeto(1,50,10).
objeto(2,75,15).
objeto(3,60,5).
objeto(4,10,1).

mochila(C,L) :- mochilaAux(C,L), sort(L,L).

mochilaAux(_, []).
mochilaAux(C, [Id | L]) :-
    objeto(Id,Peso, _),
    Peso =< C,
    C1 is C - Peso,
    mochilaAux(C1, L),
    not(member(Id,L)).

mejorMochila(C,L) :-
    mochila(C, L),
    sumaValores(L,Suma),
    not((mochila(C,L2), sumaValores(L2, SumaMenor), SumaMenor > Suma)).

sumaValores([],0).
sumaValores([Id | L], Suma) :-
    sumaValores(L,S2),
    objeto(Id, _, Valor),
    Suma is S2 + Valor.

nat(1).
nat(X) :- nat(Y), X is Y + 1.

esCamino((X,Y), [(X,Y) | Camino]) :- nat(N), length(Camino, N), generarCaminos((X,Y), Camino).

generarCaminos((_,_),[]).
generarCaminos((X,Y), [(Z, Y) | Camino]) :-
    Z is X + 1,
    generarCaminos((X,Y), Camino).
generarCaminos((X,Y), [(Z, Y) | Camino]) :-
    Z is X - 1,
    generarCaminos((X,Y), Camino).
generarCaminos((X,Y), [(X, Z) | Camino]) :-
    Z is Y + 1,
    generarCaminos((X,Y), Camino).
generarCaminos((X,Y), [(X, Z) | Camino]) :-
    Z is Y - 1,
    generarCaminos((X,Y), Camino).



corteMasParejo(L, L1, L2) :- 
    append(L1,L2,L), 
    sumlist(L1, N), 
    sumlist(L2, M), 
    Resul is abs(N - M), 
    not(
        (append(L3,L4,L), 
        sumlist(L3, N1), 
        sumlist(L4, M1), 
        Resul1 is abs(N1 - M1),
        Resul1 < Resul) 
    ).

proximoPrimo(N, P) :- P is N + 1, esPrimo(P).
proximoPrimo(N, P) :- N1 is N + 1, not(esPrimo(N1)), proximoPrimo(N1, P).

todosLosPrimos(P) :- nat(N), proximoPrimo(N, P).



generarCapicuas(L) :- nat(N), sumaListas(L,N), esCapicua(L).

sumaListas([], 0).
sumaListas([H | T], N) :- between(1, N, H) , N1 is N - H, sumaListas(T, N1).

