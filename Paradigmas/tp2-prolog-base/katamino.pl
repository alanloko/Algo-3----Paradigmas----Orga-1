:- use_module(piezas).

% Completar ...

% Ej 1 sublista(+Descartar, +Tomar, +L, -R):

sublista(Descartar, Tomar, L, Tomados) :- 
    length(Descartados, Descartar), % L1 tiene longitud M, es la lista de los M descartados
    length(Tomados, Tomar), % R va a tener longitud N, siendo la sublista que queremos
    append(Descartados, Tomados, Union), % Los unimos, y juntamos a los elementos restantes
    append(Union, _, L). % La union junto a los elementos restantes no elegidos tienen que ser igual a la lista inicial

% Ej 12: Queremos ver si sublista(-Descartar, +Tomar, +L, +R):
%   En el caso de que sea cierto que R/Tomados sea una Sublista, va a encontrar el tamaño de Descartar tal que se cumpla, pero luego de haberlos encontrado o que no existan desde un principio, este programa se va a colgar, dado que el length(Descartados, Descartar) crea una generacion infinta de listas porque al no estar instanciado Descartar, la lista Descartados puede tener diferntes longitudes, las cuales instancia a medida que avanza el programa infinitamente.
%   Con esto llegamos a la conclusion de que la funcion sublista(Descartar, Tomar, L, Tomados) no es reversible en el 1er y 4to argumento.
% El hecho de que Descartados y Descartar ambos no esten instanciados, hace que length(Descartados, Descartar) cree una generacion infinita.
% Ej 2 tablero(+K, -T):

tablero(K,Tablero) :-
    length(Tablero,5), % instanciamos las filas en 5
    maplist(fliplength(K),Tablero). % como length toma los parametros en orden inveritdo, generamos una funcion auxiliar que tome K como parametro inicial, para luego llamar a length(Fila,K), dado el comportamiento de maplist

fliplength(K, Fila) :-
    length(Fila,K).

% Ej 3 tamano(+M, -F, -C):

tamano([], 0, _). % Caso Base
tamano([Fila | M], F, C) :-
    length([Fila | M], F), % F = número de filas
    length(Fila, C).     % C = número de columnas
% Ej 4 coordenadas(+T, -IJ):

coordenadas(Tablero, (I,J)) :-
    tamano(Tablero, Filas, Columnas), % Instanciamos el tamaño del tablero
    between(1, Filas, I), % Pedimos que I esté en rango
    between(1, Columnas, J). % Pedimos que J esté en rango

% Ej 5 kPiezas(+K, -PS):

kPiezas(K, PS) :-
    nombrePiezas(P), % instanciamos las piezas
    sublistaDeKPiezas(K, P, PS). % instanciamos PS como una lista de K piezas que pertenecen a P

sublistaDeKPiezas(0, _, []). % K = 0, lista vacia
sublistaDeKPiezas(K, [Pieza|ColaPiezas], [Pieza|ColaPS]) :- % la cabeza de la lista de piezas (o sub-lista de piezas) tiene que ser igual a la cabeza del resultado.
    K > 0,
    K1 is K - 1, % instanciamos K1 = K - 1, representa el haber "agregado" un elemento a ColaPS
    length(ColaPiezas,N),
    N >= K1, % Chequeo que la cantidad de Piezas restantes sean mayores a la cantidad de piezas fatantes por elegir
    sublistaDeKPiezas(K1, ColaPiezas, ColaPS). % pedimos que la cola de la lista cumpla con el predicado
sublistaDeKPiezas(K, [_|ColaPiezas], PS) :- % Ignoramos el elemento en la cabeza de la lista de Piezas
    K > 0, % al no "agregar" un elemento, seguimos queriendo K elementos restantes
    length(ColaPiezas,N),
    N >= K1, % Chequeo que la cantidad de Piezas restantes sean mayores a la cantidad de piezas fatantes por elegir
    sublistaDeKPiezas(K, ColaPiezas, PS). % Buscamos que los argumetos cumplan con el predicado

% Ej 6 seccionTablero(+T,+ALTO, +ANCHO, +IJ, ?ST):

seccionTablero(Tablero, Alto, Ancho, (I,J), ST) :-
    I0 is I - 1,
    J0 is J - 1,
    sublista(I0, Alto, Tablero, SubFilas), % instanciamos un SubFilas desde I con tamaño Alto
    maplist(sublista(J0, Ancho), Filas, ST). % dentro del SubFilas, achicamos desde j hasta Ancho elementos por cada fila



% Ej 7 ubicarPieza(+Tablero, +Identificador):

ubicarPieza(Tablero, Identificador) :-
    pieza(Identificador, Pieza), % Dado el identificador, instanciamos la pieza
    coordenadas(Tablero, (I,J)), % instanciamos un par IJ de coordenadas validas
    tamano(Pieza, Fila,Columna), % insntanciamos el tamaño de la pieza
    seccionTablero(Tablero, Fila, Columna, (I,J), Pieza). % Dado el IJ inicial, ubicamos la pieza en la seccion de su tamaño

% Ej 8 ubicarPiezas(+Tablero, +Poda, +Identificadores):
ubicarPiezas(_, _,[]).
ubicarPiezas(Tablero, Poda,[Identificador | Identificadores]) :-
    ubicarPieza(Tablero, Identificador), % Ubicamos la pieza actual dentro del tablero
    poda(Poda, Tablero), % en Caso de elegir podaMod5, esto no se cumple cuando el tablero no tenga una vecindad de variables libres que no sea multplo de 5
    ubicarPiezas(Tablero, Poda, Identificadores). % Luego de instanciar el tablero con la pieza ubicada, llamamos recursivamente al predicado para ubicar las piezas restantes
    
    

% Ej 9 llenarTablero(+Poda, +Columnas, -Tablero):

llenarTablero(Poda, Columnas, Tablero) :-
    tablero(Columnas, Tablero), % instanciamos al Tablero
    kPiezas(Columnas, Piezas), % instanciamos una lista de piezas posibles para ubicar de tamaño Columnas
    ubicarPiezas(Tablero, Poda, Piezas). % Ubicamos la lista de piezas instanciadas previamente

% Ej 10 cantSoluciones/3:   

cantSoluciones(Poda, Columnas, N) :- % Funcion proveniente de la consigna
    findall(T, llenarTablero(Poda, Columnas, T), TS),
    length(TS, N).

% ?- time(cantSoluciones(sinPoda, 3, N)).
% 25,849,472 inferences, 1.075 CPU in 1.079 seconds (100% CPU, 24055732 Lips)
% N = 28.

% ?- time(cantSoluciones(sinPoda, 4, N)).
% 989,676,164 inferences, 40.254 CPU in 40.355 seconds (100% CPU, 24586002 Lips)
% N = 200.


poda(sinPoda, _).
poda(podaMod5, T) :- 
    todosGruposLibresModulo5(T).% Poda tal que las vecindades de posiciones libres del tablero tienen que ser multiplo de 5, caso contrario sabemos que no existe posibilidad de llenar el tablero


% Ej 11 todosGruposLibresModulo5(+Tablero):

coordLibre(T,(I,J)) :-  
    coordenadas(T,(I,J)), % instanciamos la coordenada en caso de que no lo esté, o corroboramos que sea una coordenada valida
    seccionTablero(T, 1, 1, (I,J), R), % instanciamos el valor de la posicion de las coordenadas
    not(ground(R)). % corroboramos que sea una posicion libre

todosGruposLibresModulo5(T) :- 
    findall((I,J), coordLibre(T, (I,J)),L), % Encontramos todos las coordenadas libres
    agrupar(L,GruposLibres),  % Las agrupamos segun su vecindad
    todosMod5(GruposLibres). % Nos fijamos que todos cumplan la condicion

todosMod5(LugaresLibres) :- 
    maplist(esMod5,LugaresLibres). % Para todos los grupos de lugares libres tiene que cumplirse que sean multiplo de 5

esMod5(L) :- 
    length(L, N), % Instanciamos la longitud de L
    0 =:= N mod 5. % Corroboramos que sea multiplo de 5


% ?- time(cantSoluciones(podaMod5, 3, N)).
% 15,996,808 inferences, 0.768 CPU in 0.808 seconds (95% CPU, 20834223 Lips)
% N = 28.

% ?- time(cantSoluciones(podaMod5, 4, N)).
% 356,866,660 inferences, 17.283 CPU in 18.522 seconds (93% CPU, 20647881 Lips)
% N = 200.
