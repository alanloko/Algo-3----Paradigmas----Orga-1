#include <iostream>
#include <vector>
#include <map>
#include <fstream>
#include <string>

using namespace std;

bool hayCamino(int n, int m, vector<vector<int > > &grilla, int i, int j, int longitud, map<string, int> caminos, string& camino);
int op = 0;

int main(int argc, char* argv[])
{
    if (argc < 2) {
        cout << "Uso: ./tu_programa archivo_casos.txt" << endl;
        return 1;
    }

    ifstream fin(argv[1]);
    if (!fin) {
        cout << "Error al abrir el archivo de casos." << endl;
        return 1;
    }

    int casos;
    fin >> casos;
    cout << "Analizando " << casos << " casos:" << endl;

    int n, m;
    for (int z = 0; z < casos; z++)
    {
        fin >> n >> m;
        vector<vector<int > > grilla(n, vector<int>(m));
        map<string, int> caminos;
        string camino = "";
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < m; j++)
            {
                fin >> grilla[i][j];
            }
        }

        op = 0; // Reiniciar contador para cada caso
        cout << "Caso #" << z+1 << " (" << n << "x" << m << "): ";
        
        if ((n != 0 or m != 0) && (n + m - 1) % 2 == 0)
        {
            caminos[camino] = grilla[0][0];
            if (hayCamino(n, m, grilla, 0, 0, (n + m - 1), caminos, camino))
            {
                cout << "YES";
            }
            else
            {
                cout << "NO";
            }
        }
        else
        {
            cout << "NO";
        }
        cout << " (Operaciones: " << op << ")" << endl;
    }

    fin.close();
    return 0;
}

bool hayCamino(int n, int m, vector<vector<int > > &grilla, int i, int j, int longitud, map<string, int> caminos, string &camino)
{
    op++;
    string caminoaux = camino;
    if (i == n - 1 && j == m - 1)
    {
        return caminos[camino] == 0;
    }
    bool res = false;
    int balance = caminos[camino];
    if (abs(balance) > longitud)
        return false;

    // Voy hacia la derecha
    if (j < m - 1)
    {
        balance += grilla[i][j+1];
        caminoaux += "0";
        caminos[caminoaux] = balance;
        res = res | hayCamino(n, m, grilla, i, j + 1, longitud - 1, caminos, caminoaux);
        balance -= grilla[i][j+1];
        caminoaux = camino;
    }

    // Voy hacia abajo
    if (i < n - 1)
    {
        balance += grilla[i+1][j];
        caminoaux += "1";
        caminos[caminoaux] = balance;
        res = res | hayCamino(n, m, grilla, i + 1, j, longitud - 1, caminos, caminoaux);
    }
    return res;
}