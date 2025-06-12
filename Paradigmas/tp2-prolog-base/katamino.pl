:- use_module(piezas).

% Completar ...

% Ej 1:

sublista(M, N, L, R) :- 
    length(L1, M), % L1 tiene longitud M, es la lista de los M descartados
    length(R, N), % R va a tener longitud N, siendo la sublista que queremos
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


% kPiezas(0, []).
% kPiezas(K, [Pieza | PS]) :-
%     K > 0,
%     %%%%%%
%     length(PS, K1),
%     %%%%%%
%     nombrePiezas(P),
%     member(Pieza, P),
%     %%%%%
%     kPiezas(K1, PS),
%     not(member(Pieza,PS)),
%     K is K1 + 1.
%     %%%%%%%%

% Ej 6:

% seccionTablero(_,0, _, _, []).
% seccionTablero([F | T], Alto, Ancho, (I,J), [R | ST]) :-
%     sublista(I, Alto, T, R1)
%     seccionTablero(T, Alto1, Ancho, (I,J), ST),
%     Alto is Alto1 + 1,
%     sublista(J, Ancho, F, R).

seccionTablero(T, Alto, Ancho, (I,J), ST) :-
    I0 is I - 1,
    J0 is J - 1,
    sublista(I0, Alto, T, R),
    seccionFila(R,J0, Ancho, ST).


seccionFila([], _, _, []).
seccionFila([F | T], J, Ancho, [R | Cola]) :- sublista(J, Ancho, F, R), seccionFila(T, J, Ancho, Cola).