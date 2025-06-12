#include <iostream>
#include <vector>
#include <unordered_set>

using namespace std;

bool hayCamino(int n, int m, vector<vector<int > > &grilla, int i, int j, int longitud, vector<vector<unordered_set<int > > >& dp);
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
        vector<vector<int > > grilla(n, vector<int>(m));
        vector<vector<unordered_set<int > > > dp(n, vector<unordered_set<int > >(m, unordered_set<int >()));
        for (int i = 0; i < n; i++)
        {
            for (int j = 0; j < m; j++)
            {
                cin >> grilla[i][j];
            }
        }
        if ((n != 0 or m != 0) && (n + m - 1) % 2 == 0)
        {
          dp[0][0].insert(grilla[0][0]);
            if (hayCamino(n, m, grilla, 0, 0, (n + m - 1), dp))
            {
                cout << "YES" << endl;
            }
            else
            {
                cout << "NO" << endl;
            }
        }
    }

    return 0;
}

bool hayCamino(int n, int m, vector<vector<int > > &grilla, int i, int j, int longitud, vector<vector<unordered_set<int > > >& dp)
{
  bool res = false;
    if (i == n - 1 && j == m - 1)
    {
        return dp[i][j].find(0)   != dp[i][j].end();
    }


    // Sumo el camino de arriba:
    if (i > 0)
    {
        // Alternative for neighbor processing
    if (i > 0) {
    unordered_set<int> temp = dp[i-1][j];
    int current_val = grilla[i][j];
    for (unordered_set<int>::const_iterator it = temp.begin(); it != temp.end(); ++it) {
        dp[i][j].insert(*it + current_val);
    }
}
    }
    if (j > 0)
    {
        unordered_set<int> temp = dp[i][j-1];
        int current_val = grilla[i][j];
        for (unordered_set<int>::const_iterator it = temp.begin(); it != temp.end(); ++it) {
            dp[i][j].insert(*it + current_val);
        }
    }
    if (!dp[i][j].empty())
    {
        res = res | hayCamino(n,m,grilla,i + 1,j,longitud - 1,dp);
        res = res | hayCamino(n,m,grilla,i,j + 1,longitud - 1,dp);
    }

    return res;
}