:- use_module(piezas).

% Completar ...

% Ej 1:

sublista(Descartar, Tomar, L, R) :- 
    length(L1, Descartar), % L1 tiene longitud M, es la lista de los M descartados
    length(R, Tomar), % R va a tener longitud N, siendo la sublista que queremos
    append(L1, R, L3), % Los uno, y junto a los elementos restantes
    append(L3, _, L). % tienen que ser igual a la lista inicial

% Ej 2:

tablero(K, [F1, F2, F3, F4, F5]) :- % Siempre son 5 Filas
    length(F1, K), % Por cada fila tienen que haber K elementos
    length(F2, K),
    length(F3, K),
    length(F4, K),
    length(F5, K).

% Ej 3:
tamano([], 0, _). % Caso Base
tamano([Fila | M], F, C) :-
    tamano(M, F1, C), % llamamos recursivamente a la funcion
    F is F1 + 1, % Declaramos F1 = F - 1
    length(Fila, C). % Corroboramos que la cantidad de columnas sea correcta para todo F

% Ej 4:

coordenadas(T, (I,J)) :-
    tamano(T, F, C), % Instanciamos el tamaño del tablero
    between(1, F, I), % Pedimos que I esté en rango
    between(1, C, J). % Pedimos que J esté en rango

kPiezas(K, PS) :-
    nombrePiezas(P),
    subKPieza(K, P, PS).

subKPieza(0, _, []).
subKPieza(K, [H|T], [H|R]) :-
    K > 0,
    K1 is K - 1,
    subKPieza(K1, T, R).
subKPieza(K, [_|T], R) :-
    K > 0,
    subKPieza(K, T, R).

% Ej 6:

seccionTablero(T, Alto, Ancho, (I,J), ST) :-
    I0 is I - 1,
    J0 is J - 1,
    sublista(I0, Alto, T, R),
    seccionFila(R,J0, Ancho, ST).


seccionFila([], _, _, []).
seccionFila([F | T], J, Ancho, [R | Cola]) :- sublista(J, Ancho, F, R), seccionFila(T, J, Ancho, Cola).

% Ej 7:

ubicarPieza(Tablero, Identificador) :-
    pieza(Identificador, E),
    coordenadas(Tablero, (I,J)),
    tamano(E, F,C),
    seccionTablero(Tablero, F, C, (I,J), E). 

% Ej 8:
ubicarPiezas(_, _,[]).
ubicarPiezas(Tablero, Poda,[Identificador | Identificadores]) :-
    poda(Poda, Tablero),
    ubicarPieza(Tablero, Identificador),
    ubicarPiezas(Tablero, Poda, Identificadores).

% Ej 9:

llenarTablero(Poda, Columnas, Tablero) :-
    tablero(Columnas, Tablero),
    kPiezas(Columnas, Piezas),
    ubicarPiezas(Tablero, Poda, Piezas).

% Ej 10:   

cantSoluciones(Poda, Columnas, N) :-
    findall(T, llenarTablero(Poda, Columnas, T), TS),
    length(TS, N).


poda(sinPoda, _).
poda(podaMod5, T) :- todosGruposLibresModulo5(T).

coordLibre(T,(I,J)) :-  coordenadas(T,(I,J)), seccionTablero(T, 1, 1, (I,J), R), not(ground(R)).

todosGruposLibresModulo5(T) :- findall((I,J), coordLibre(T, (I,J)),L), agrupar(L,Res), todosMod5(Res).

todosMod5([]).
todosMod5(LugaresLibres) :- maplist(esMod5,LugaresLibres).

esMod5(L) :- length(L, N), 0 =:= N mod 5.
