:- begin_tests(katamino_extended).
:- use_module(piezas).
:- [katamino].

test(test_1) :- sublista(0, 0, [], R), R = [].
test(test_2, [fail]) :- sublista(1, 2, [a], R).
test(test_3) :- sublista(1, 1, [x,y,z], R), R = [y].
test(test_4) :- sublista(2, 3, [a,b,c,d,e,f], R), R = [c,d,e].
test(test_5, [fail]) :- tablero(0, T).
test(test_6) :- tablero(1, T), length(T, F), maplist(length_list(1), T), F = 5.
test(test_7) :- tablero(5, T), nth0(0, T, Fila), length(Fila, 5).
% test(test_8) :- tamano([[_,_],[_,_]], F, C), F = C, C = 2.
% test(test_9) :- tamano([], F, C), F = 0, C = 0.
% test(test_10) :- tamano([[a,b,c]], F, C), F = 1, C = 3.
test(test_11) :- tablero(1, T), findall(IJ, coordenadas(T, IJ), L), length(L, N), N = 5.
test(test_12) :- tablero(2, T), coordenadas(T, (5,2)).
test(test_13, [fail]) :- tablero(2, T), coordenadas(T, (6,1)).
test(test_14, [fail]) :- tablero(2, T), coordenadas(T, (0,1)).
test(test_15) :- kPiezas(0, L), L = [].
test(test_16) :- kPiezas(1, [A]), nombrePiezas(P), member(A, P).
test(test_17) :- kPiezas(12, PS), sort(PS, PS), length(PS, 12).
test(test_18, [fail]) :- kPiezas(13, _).
test(test_19) :- tablero(3, T), seccionTablero(T, 1, 1, (1,1), [[_]]).
test(test_20) :- tablero(3, T), seccionTablero(T, 5, 3, (1,1), ST), tamano(ST, 5, 3).
test(test_21, [fail]) :- tablero(3, T), seccionTablero(T, 3, 3, (3,2), _).
test(test_22, [fail]) :- tablero(3, T), seccionTablero(T, 3, 2, (5,2), _).

:- end_tests(katamino_extended).

length_list(N, L) :- length(L, N).
