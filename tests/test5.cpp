#include <iostream>
using namespace std;

int main() {
    int n;
    long double factorial = 1.0;

   
    cin >> n;

    
        for(int i = 1; i <= n; ++i) {
            factorial *= i;
        }
        cout <<  factorial;    
    

    return 0;
}