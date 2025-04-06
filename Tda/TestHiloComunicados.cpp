#include <iostream>
#include <vector>
#include <cmath>
#include <string>
#include <iomanip>
#include <sstream>

using namespace std;

// Function to run the original algorithm
string runOriginalAlgorithm(const string& mensaje, const string& recibo) {
    int positivos = 0;
    int negativos = 0;
    int probabilidad = 0;
    
    for(int i = 0; i < mensaje.size(); i++) {
        if(mensaje[i] == '+') {
            positivos++;
        } else if(mensaje[i] == '-') {
            negativos++;
        }
        
        if(recibo[i] == '+') {
            positivos--;
        } else if(recibo[i] == '-') {
            negativos--;
        } else {
            probabilidad++;
        }
    }
    
    stringstream ss;
    ss << fixed << setprecision(12);
    
    if(positivos == 0 && negativos == 0) {
        ss << 1.0;
    } else if (positivos + negativos < probabilidad) {
        ss << 0.0;
    } else if (positivos < 0 || negativos < 0) {
        ss << 0.0;
    } else {
        ss << pow(0.5, probabilidad);
    }
    
    return ss.str();
}

// Function to run a test case
void runTest(const string& mensaje, const string& recibo, const string& expectedOutput) {
    string result = runOriginalAlgorithm(mensaje, recibo);
    cout << "Test Case:" << endl;
    cout << "Original message: \"" << mensaje << "\"" << endl;
    cout << "Received message: \"" << recibo << "\"" << endl;
    cout << "Expected output: " << expectedOutput << endl;
    cout << "Actual output:   " << result << endl;
    cout << "Result: " << (result == expectedOutput ? "PASSED" : "FAILED") << endl;
    cout << endl;
}

int main() {
    // Test case 1: Perfect communication - all instructions match
    runTest("++--", "++--", "1.000000000000");
    
    // Test case 2: One unknown instruction
    runTest("+", "?", "0.500000000000");
    
    // Test case 3: Multiple unknown instructions
    runTest("+++", "???", "0.125000000000");
    
    // Test case 4: Mixed instructions with some unknown
    runTest("+-+-", "+-?-", "0.500000000000");
    
    // Test case 5: Impossible scenario - opposites
    runTest("++", "--", "0.000000000000");
    
    // Test case 6: Known instructions but not enough unknowns to balance
    runTest("+++---", "++-???", "0.000000000000");
    
    // Test case 7: Exactly enough unknowns to balance
    runTest("+++", "+-?", "0.500000000000");
    
    // Test case 8: Empty strings edge case
    runTest("", "", "1.000000000000");
    
    // Test case 9: Maximum length with balanced unknowns
    runTest("+++++-----", "++?????---", "0.031250000000");
    
    // Test case 10: Maximum length with perfect match
    runTest("+-+-+-+-+-", "+-+-+-+-+-", "1.000000000000");
    
    // Test case 11: Test for negative counters
    runTest("+-", "--", "0.000000000000");
    
    // Test case 12: More positives received than sent
    runTest("+-", "++", "0.000000000000");
    
    // Test case 13: More negatives received than sent
    runTest("+-", "--", "0.000000000000");
    
    // Test case 14: Exact balance with question marks
    runTest("++--", "+??-", "0.250000000000");
    
    // Test case 15: All question marks
    runTest("+-+-", "????", "0.062500000000");
    
    return 0;
}