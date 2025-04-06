#include <iostream>
#include <vector>
#include<cmath>

using namespace std;

float factorial(int n);

int main() {
  string mensaje;
  string recibo;
  cin >> mensaje;
  cin >> recibo;
  int positivos = 0;
  int negativos = 0;
  int desconocidos = 0;
  for(int i = 0; i < mensaje.size(); i++){
    if(mensaje[i] == '+'){
      positivos++;
    } else if(mensaje[i] == '-'){
      negativos++;
    }
    if(recibo[i] == '+'){
      positivos--;
    } else if(recibo[i] == '-'){
      negativos--;
    } else {
      desconocidos++;
    }
  }
  float prob;
  cout.precision(12);
  cout.setf(ios::fixed);
  if(positivos == 0 && negativos == 0){
    prob = 1.000000000000;
    cout << prob << endl;
  } else if (positivos < 0 or negativos < 0) {
    prob = 0.000000000000;
    cout << prob << endl;
  } else if ( positivos + negativos < desconocidos){
    prob = 0.000000000000;
    cout << prob << endl;
  } else {
    float combinatoria;
    combinatoria = (factorial(desconocidos) / ((factorial(positivos))*factorial(desconocidos - positivos)));
    prob = pow(0.5, desconocidos)*combinatoria;
    cout << prob << endl;
  }

return 0;
}

float factorial(int n) {
  float res = 1;
  for(int i = 1; i <= n; i++) {
    res *= i;
  }
  return res;
}