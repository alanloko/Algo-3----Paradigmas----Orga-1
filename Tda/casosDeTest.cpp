#include <iostream>
#include <vector>
#include <string>
#include <ctime>
#include <cstdlib>
#include <fstream>
#include <cassert>
#include <algorithm>

using namespace std;

// Función para determinar si un caso tendría solución
bool verificarSolucion(int n, int m, const vector<vector<int> >& grilla) {
    // Si la longitud del camino es impar, no puede haber solución
    if ((n + m - 1) % 2 != 0) {
        return false;
    }

    // Analizar el balance de la matriz
    int totalPosibles = n + m - 1;  // Total de celdas en el camino mínimo
    int balanceInicial = grilla[0][0];
    int balanceFinal = grilla[n-1][m-1];

    // Si las celdas inicio y fin tienen el mismo signo (ambas frías o ambas calientes)
    if (balanceInicial == balanceFinal) {
        // El balance debe ser par para poder compensarse
        if (balanceInicial == 1) {
            // Necesitamos suficientes celdas frías para compensar
            int celdasFriasNecesarias = totalPosibles / 2;
            int celdasCalientesNecesarias = totalPosibles / 2 - 2;  // -2 por las celdas inicio y fin

            // Contamos cuántas celdas frías hay disponibles en la matriz
            int celdasFriasDisponibles = 0;
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    if (grilla[i][j] == -1) {
                        celdasFriasDisponibles++;
                    }
                }
            }

            // Verificamos si hay suficientes celdas frías
            return celdasFriasDisponibles >= celdasFriasNecesarias;
        } else {  // balanceInicial == -1
            // Necesitamos suficientes celdas calientes para compensar
            int celdasCalientesNecesarias = totalPosibles / 2;
            int celdasFriasNecesarias = totalPosibles / 2 - 2;  // -2 por las celdas inicio y fin

            // Contamos cuántas celdas calientes hay disponibles en la matriz
            int celdasCalientesDisponibles = 0;
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    if (grilla[i][j] == 1) {
                        celdasCalientesDisponibles++;
                    }
                }
            }

            // Verificamos si hay suficientes celdas calientes
            return celdasCalientesDisponibles >= celdasCalientesNecesarias;
        }
    } else {  // balanceInicial != balanceFinal
        // Las celdas inicio y fin tienen signos opuestos
        // Necesitamos que el camino tenga igual número de celdas frías y calientes
        int celdasFriasNecesarias = totalPosibles / 2;
        int celdasCalientesNecesarias = totalPosibles / 2;

        // Ya tenemos una celda fría y una caliente (inicio y fin)
        celdasFriasNecesarias--;
        celdasCalientesNecesarias--;

        // Contamos cuántas celdas de cada tipo hay disponibles
        int celdasFriasDisponibles = 0;
        int celdasCalientesDisponibles = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if ((i == 0 && j == 0) || (i == n-1 && j == m-1)) {
                    continue;  // Saltamos las celdas de inicio y fin
                }
                if (grilla[i][j] == -1) {
                    celdasFriasDisponibles++;
                } else {
                    celdasCalientesDisponibles++;
                }
            }
        }

        // Verificamos si hay suficientes celdas de cada tipo
        return celdasFriasDisponibles >= celdasFriasNecesarias &&
               celdasCalientesDisponibles >= celdasCalientesNecesarias;
    }
}

// Función para generar un caso con solución conocida
vector<vector<int> > generarCasoConSolucion(int n, int m, int seed) {
    srand(seed);

    if ((n + m - 1) % 2 != 0) {
        // No puede haber solución si el camino es de longitud impar
        vector<vector<int> > vacio;
        return vacio;
    }

    vector<vector<int> > grilla(n, vector<int>(m));

    // Primero, asignamos aleatoriamente las celdas
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            grilla[i][j] = rand() % 2 == 0 ? -1 : 1;
        }
    }

    // Definimos un camino mínimo desde (0,0) hasta (n-1,m-1)
    vector<pair<int, int> > camino;
    int i = 0, j = 0;

    // Construimos el camino mínimo
    while (i < n-1 || j < m-1) {
        pair<int, int> punto(i, j);
        camino.push_back(punto);

        // Decidimos si ir abajo o a la derecha
        if (i < n-1 && j < m-1) {
            if (rand() % 2 == 0) {
                i++;
            } else {
                j++;
            }
        } else if (i < n-1) {
            i++;
        } else {
            j++;
        }
    }
    pair<int, int> puntoFinal(n-1, m-1);
    camino.push_back(puntoFinal);  // Añadimos la celda final

    // Aseguramos que haya exactamente la misma cantidad de celdas frías y calientes en el camino
    int countNeg = 0, countPos = 0;
    for (size_t k = 0; k < camino.size(); k++) {
        int r = camino[k].first;
        int c = camino[k].second;
        if (grilla[r][c] == -1) {
            countNeg++;
        } else {
            countPos++;
        }
    }

    // Ajustamos el camino para que tenga igual cantidad de celdas frías y calientes
    int target = (n + m - 1) / 2;  // Cantidad deseada de cada tipo

    // Si hay demasiadas celdas frías, convertimos algunas en calientes
    while (countNeg > target) {
        int idx = rand() % camino.size();
        int r = camino[idx].first;
        int c = camino[idx].second;
        if (grilla[r][c] == -1) {
            grilla[r][c] = 1;
            countNeg--;
            countPos++;
        }
    }

    // Si hay demasiadas celdas calientes, convertimos algunas en frías
    while (countPos > target) {
        int idx = rand() % camino.size();
        int r = camino[idx].first;
        int c = camino[idx].second;
        if (grilla[r][c] == 1) {
            grilla[r][c] = -1;
            countPos--;
            countNeg++;
        }
    }

    // Verificamos una última vez
    assert(countNeg == countPos);

    return grilla;
}

// Función para generar un caso sin solución
vector<vector<int> > generarCasoSinSolucion(int n, int m, int seed) {
    srand(seed);

    // Si el camino es de longitud impar, cualquier matriz no tendrá solución
    if ((n + m - 1) % 2 != 0) {
        vector<vector<int> > grilla(n, vector<int>(m, 1));  // Todas calientes
        return grilla;
    }

    // Para caminos de longitud par, creamos una matriz donde sea imposible equilibrar
    vector<vector<int> > grilla(n, vector<int>(m, 1));  // Inicializamos con todas calientes

    // Hacemos que la celda inicial y final sean calientes (1)
    grilla[0][0] = 1;
    grilla[n-1][m-1] = 1;

    // Para que no haya solución, aseguramos que no haya suficientes celdas frías
    // Necesitamos al menos (n+m-1)/2 celdas frías en el camino

    // Dejamos solo unas pocas celdas frías, insuficientes para cualquier camino
    int maxFrias = (n + m - 1) / 2 - 1;  // Una menos de las necesarias

    // Colocamos aleatoriamente unas pocas celdas frías
    for (int i = 0; i < min(maxFrias, (n * m) / 4); i++) {
        int r = rand() % n;
        int c = rand() % m;
        grilla[r][c] = -1;
    }

    // Verificar que realmente no haya solución
    assert(!verificarSolucion(n, m, grilla));

    return grilla;
}

// Función para generar casos que causen muchas llamadas recursivas
vector<vector<int> > generarCasoPesado(int n, int m, int seed) {
    srand(seed);

    // Para maximizar la cantidad de llamadas recursivas, queremos que
    // haya muchos caminos posibles y que el árbol de búsqueda sea profundo

    // Creamos una matriz donde todas las celdas sean neutrales (permitan cualquier dirección)
    // Pero al final necesitamos equilibrar, así que alternamos frías y calientes
    vector<vector<int> > grilla(n, vector<int>(m));

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            // Alternamos celdas frías y calientes como un tablero de ajedrez
            grilla[i][j] = ((i + j) % 2 == 0) ? 1 : -1;
        }
    }

    // Aseguramos que sea posible equilibrar
    if ((n + m - 1) % 2 == 0) {
        int totalFrias = 0, totalCalientes = 0;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grilla[i][j] == -1) totalFrias++;
                else totalCalientes++;
            }
        }

        // Ajustamos si es necesario
        if (totalFrias != totalCalientes) {
            // Convertimos algunas celdas para equilibrar
            int diff = abs(totalFrias - totalCalientes);
            for (int i = 0; i < n && diff > 0; i++) {
                for (int j = 0; j < m && diff > 0; j++) {
                    if ((totalFrias > totalCalientes && grilla[i][j] == -1) ||
                        (totalCalientes > totalFrias && grilla[i][j] == 1)) {
                        grilla[i][j] *= -1;  // Invertimos el valor
                        diff--;
                    }
                }
            }
        }
    }

    return grilla;
}

// Función principal para generar casos de prueba
void generarCasosDePrueba() {
    ofstream outFile("casos_prueba.txt");
    int totalAulas = 0;
    const int MAX_AULAS = 1000000;
    vector<pair<int, int> > sizes;
    vector<vector<vector<int> > > casosGrilla;

    // Casos básicos para verificar lógica general
    {
        // Caso 1x1
        pair<int, int> size1(1, 1);
        sizes.push_back(size1);

        vector<vector<int> > grid1;
        vector<int> row1;
        row1.push_back(1);
        grid1.push_back(row1);
        casosGrilla.push_back(grid1);
        totalAulas += 1;

        // Caso 2x1
        pair<int, int> size2(2, 1);
        sizes.push_back(size2);

        vector<vector<int> > grid2;
        vector<int> row2_1;
        row2_1.push_back(1);
        vector<int> row2_2;
        row2_2.push_back(-1);
        grid2.push_back(row2_1);
        grid2.push_back(row2_2);
        casosGrilla.push_back(grid2);
        totalAulas += 2;

        // Caso 1x2
        pair<int, int> size3(1, 2);
        sizes.push_back(size3);

        vector<vector<int> > grid3;
        vector<int> row3;
        row3.push_back(1);
        row3.push_back(-1);
        grid3.push_back(row3);
        casosGrilla.push_back(grid3);
        totalAulas += 2;

        // Caso 2x2 con solución
        pair<int, int> size4(2, 2);
        sizes.push_back(size4);

        vector<vector<int> > grid4;
        vector<int> row4_1;
        row4_1.push_back(1);
        row4_1.push_back(-1);
        vector<int> row4_2;
        row4_2.push_back(-1);
        row4_2.push_back(1);
        grid4.push_back(row4_1);
        grid4.push_back(row4_2);
        casosGrilla.push_back(grid4);
        totalAulas += 4;

        // Caso 2x2 sin solución
        pair<int, int> size5(2, 2);
        sizes.push_back(size5);

        vector<vector<int> > grid5;
        vector<int> row5_1;
        row5_1.push_back(1);
        row5_1.push_back(1);
        vector<int> row5_2;
        row5_2.push_back(1);
        row5_2.push_back(1);
        grid5.push_back(row5_1);
        grid5.push_back(row5_2);
        casosGrilla.push_back(grid5);
        totalAulas += 4;

        // Caso 3x1 (camino impar, sin solución)
        pair<int, int> size6(3, 1);
        sizes.push_back(size6);

        vector<vector<int> > grid6;
        vector<int> row6_1;
        row6_1.push_back(1);
        vector<int> row6_2;
        row6_2.push_back(1);
        vector<int> row6_3;
        row6_3.push_back(1);
        grid6.push_back(row6_1);
        grid6.push_back(row6_2);
        grid6.push_back(row6_3);
        casosGrilla.push_back(grid6);
        totalAulas += 3;

        // Caso 1x3 (camino impar, sin solución)
        pair<int, int> size7(1, 3);
        sizes.push_back(size7);

        vector<vector<int> > grid7;
        vector<int> row7;
        row7.push_back(1);
        row7.push_back(1);
        row7.push_back(1);
        grid7.push_back(row7);
        casosGrilla.push_back(grid7);
        totalAulas += 3;
    }

    // Casos medianos con y sin solución
    {
        // Caso 3x3 (camino impar, sin solución)
        pair<int, int> size8(3, 3);
        sizes.push_back(size8);
        casosGrilla.push_back(generarCasoSinSolucion(3, 3, 101));
        totalAulas += 9;

        // Caso 4x3 con solución
        pair<int, int> size9(4, 3);
        sizes.push_back(size9);
        casosGrilla.push_back(generarCasoConSolucion(4, 3, 102));
        totalAulas += 12;

        // Caso 3x4 con solución
        pair<int, int> size10(3, 4);
        sizes.push_back(size10);
        casosGrilla.push_back(generarCasoConSolucion(3, 4, 103));
        totalAulas += 12;

        // Caso 4x4 sin solución (a propósito)
        pair<int, int> size11(4, 4);
        sizes.push_back(size11);
        casosGrilla.push_back(generarCasoSinSolucion(4, 4, 104));
        totalAulas += 16;
    }

    // Casos que provocan muchas llamadas recursivas
    {
        // Caso 5x5 con patrón de ajedrez
        pair<int, int> size12(5, 5);
        sizes.push_back(size12);
        casosGrilla.push_back(generarCasoPesado(5, 5, 201));
        totalAulas += 25;

        // Caso 6x6 con patrón de ajedrez
        pair<int, int> size13(6, 6);
        sizes.push_back(size13);
        casosGrilla.push_back(generarCasoPesado(6, 6, 202));
        totalAulas += 36;

        // Caso 7x7 (camino impar)
        pair<int, int> size14(7, 7);
        sizes.push_back(size14);
        casosGrilla.push_back(generarCasoSinSolucion(7, 7, 203));
        totalAulas += 49;

        // Caso 8x8 con patrón de ajedrez
        pair<int, int> size15(8, 8);
        sizes.push_back(size15);
        casosGrilla.push_back(generarCasoPesado(8, 8, 204));
        totalAulas += 64;
    }

    // Casos extremos y grandes
    vector<pair<int, int> > grandesDimensiones;
    {
        pair<int, int> dim1(10, 10);
        grandesDimensiones.push_back(dim1);
        pair<int, int> dim2(20, 20);
        grandesDimensiones.push_back(dim2);
        pair<int, int> dim3(50, 50);
        grandesDimensiones.push_back(dim3);
        pair<int, int> dim4(100, 100);
        grandesDimensiones.push_back(dim4);
        pair<int, int> dim5(1, 1000);
        grandesDimensiones.push_back(dim5);
        pair<int, int> dim6(1000, 1);
        grandesDimensiones.push_back(dim6);
        pair<int, int> dim7(500, 2);
        grandesDimensiones.push_back(dim7);
        pair<int, int> dim8(2, 500);
        grandesDimensiones.push_back(dim8);
    }

    for (size_t i = 0; i < grandesDimensiones.size(); i++) {
        int n = grandesDimensiones[i].first;
        int m = grandesDimensiones[i].second;

        if (totalAulas + n * m > MAX_AULAS) continue;

        // Caso con solución
        if ((n + m - 1) % 2 == 0) {
            sizes.push_back(grandesDimensiones[i]);
            casosGrilla.push_back(generarCasoConSolucion(n, m, n * 1000 + m));
            totalAulas += n * m;
        }

        // Caso sin solución (si aún cabe en nuestro límite)
        if (totalAulas + n * m <= MAX_AULAS) {
            sizes.push_back(grandesDimensiones[i]);
            casosGrilla.push_back(generarCasoSinSolucion(n, m, n * 2000 + m));
            totalAulas += n * m;
        }
    }

    // Caso especial: matriz grande que causa muchas recursiones
    int maxN = min(20, (int)sqrt((double)(MAX_AULAS - totalAulas)));
    if (maxN >= 10) {
        pair<int, int> sizeMax(maxN, maxN);
        sizes.push_back(sizeMax);
        casosGrilla.push_back(generarCasoPesado(maxN, maxN, 999));
        totalAulas += maxN * maxN;
    }

    // Escribir número de casos
    outFile << casosGrilla.size() << endl;

    // Escribir cada caso
    for (size_t i = 0; i < casosGrilla.size(); i++) {
        int n = sizes[i].first;
        int m = sizes[i].second;

        outFile << n << " " << m << endl;
        for (int r = 0; r < n; r++) {
            for (int c = 0; c < m; c++) {
                outFile << casosGrilla[i][r][c];
                if (c < m - 1) outFile << " ";
            }
            outFile << endl;
        }
    }

    outFile.close();

    cout << "Generados " << casosGrilla.size() << " casos con un total de " << totalAulas << " aulas." << endl;
}

// Función para medir el rendimiento de casos específicos
void testearRendimiento() {
    // Caso que debería causar muchas llamadas recursivas
    vector<vector<int> > grillaPesada = generarCasoPesado(10, 10, 12345);

    // Escribir a un archivo para pruebas manuales
    ofstream outFile("caso_pesado.txt");
    outFile << "1" << endl;  // 1 caso de prueba
    outFile << "10 10" << endl;
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10; j++) {
            outFile << grillaPesada[i][j];
            if (j < 9) outFile << " ";
        }
        outFile << endl;
    }
    outFile.close();

    cout << "Generado caso pesado para pruebas de rendimiento." << endl;
}

// Función para generar un archivo de caso límite
void generarCasoLimite() {
    ofstream outFile("caso_limite.txt");

    // Un solo caso con el máximo permitido de celdas
    int n = 1000, m = 1000;  // 1 millón de celdas en total

    outFile << "1" << endl;  // 1 caso de prueba
    outFile << n << " " << m << endl;

    // Generamos un tablero alternando 1 y -1
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < m; j++) {
            outFile << ((i + j) % 2 == 0 ? 1 : -1);
            if (j < m - 1) outFile << " ";
        }
        outFile << endl;
    }

    outFile.close();

    cout << "Generado caso límite con " << n * m << " aulas." << endl;
}

int main() {
    cout << "Generando casos de prueba..." << endl;
    generarCasosDePrueba();

    cout << "Generando caso pesado para pruebas de rendimiento..." << endl;
    testearRendimiento();

    cout << "Generando caso límite (1 millón de celdas)..." << endl;
    generarCasoLimite();

    return 0;
}