#include <iostream>
#include <vector>

using namespace std;

bool hayCamino(int n, int m, vector<vector<int>> grilla, int i, int j, int longitud, int balance);
int op = 0;
int main()
{
    int casos;
    cout << "Cantidad de casos:";
    cin >> casos;
    int n, m;

    for (int z = 0; z < casos; z++)
    {
        cin >> n;
        cin >> m;
        vector<vector<int>> grilla(n, vector<int>(m));

        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < m; j++)
            {
                cin >> grilla[i][j];
            }
        }
        if ((n != 0 or m != 0) && (n + m - 1) % 2 == 0)
        {
            if (hayCamino(n, m, grilla, 0, 0, (n + m - 1), grilla[0][0]))
            {
                cout << "YES" << endl;
            }
            else
            {
                cout << "NO" << endl;
            }
        }
        cout << op << endl;
    }

    return 0;
}

bool hayCamino(int n, int m, vector<vector<int>> grilla, int i, int j, int longitud, int balance)
{
    op++;
    if (i == n - 1 && j == m - 1)
    {
        return balance == 0;
    }
    bool res = false;
    if (abs(balance) > longitud)
        return false;
    // Voy hacia la derecha
    if (j < m - 1)
    {
        balance += grilla[i][j + 1];
        res = res | hayCamino(n, m, grilla, i, j + 1, longitud - 1, balance);
        balance -= grilla[i][j + 1];
    }

    // Voy hacia abajo
    if (i < n - 1)
    {
        balance += grilla[i + 1][j];
        res = res | hayCamino(n, m, grilla, i + 1, j, longitud - 1, balance);
        balance -= grilla[i + 1][j];
    }
    return res;
}