// #include "vector.h"
// int main() // Here is a start:
// {
// 	Vector<int> intVec{1,3,5,7,9};
// 	Vector<double> doubleVec{1.5,2.5,3.5,4.5};
// 	Vector<int> iv{intVec};
// 	Vector<double> dv{doubleVec};
// 	cout << "intVec" << intVec << endl; 
// // "intVec(1, 3, 5, 7, 9)" 
// 	cout << "iv" << iv << endl; 
// // "iv(1, 3, 5, 7, 9)"
// 	cout << "doubleVec" << doubleVec << endl; 
// // "doubleVec(1.5, 2.5, 3.5, 4.5)" 
// cout << "dv" << dv << endl; 

// // "dv(1.5, 2.5, 3.5, 4.5)" 

// 	// add at least one test case for each method defined in Vector
// return 0;
// }


#include <iostream>
#include "vector.h"

using namespace std;

int main() 
{
  Vector<int> v1(3);
  Vector<int> v2{2,4,6};
  Vector<int> v3{1,3,5,7,9};
  
  Vector<int> v4{2,4,6};
  Vector<int> v5{2,4,6};

  cout << v4.remove(0) << endl;

  // assignment operator
  // Vector<int> v6(10);
  // v6 = v3;
  // v3[0] = 100;
  // cout << v6 << endl;
  // cout << v3 << endl;


  // copy constructor
  // Vector v6{v4};
  // v4[0] = 100;
  // v6[2] = 1000;
  // cout << v6 << endl;
  // cout << v4 << endl;

  // friend + and *
  // cout << 5 + v4 << endl;
  // cout << 5 * v4 << endl;

  // == and !=
  // bool compare1 = v2 == v3; // false = 0
  // bool compare2 = v4 == v5; // true = 1
  
  // bool compare3 = v2 != v3; // true = 1
  // bool compare4 = v4 != v5; // false = 0

  // cout << compare3 << endl;
  // cout << compare4 << endl;

  // * and +
  // cout << v2 * v3 << endl;
  // cout << v2 + v3 << endl;

  // cout << v2 << endl;
  // v2[0] = 100;
  // cout << v2 << endl;
  
  // the following test cases should throw an error
  // cout << v2[7] << endl;
  // cout << v2[-2] << endl;

  return 0;
}
