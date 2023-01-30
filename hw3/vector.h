#ifndef VECTOR_H
#define VECTOR_H
#include <iostream>
#include <stdexcept>
#include <algorithm>
using namespace std;

 /* Commented by Safeeullah Saifuddin, Fall 2022 */

/** ADVISED ORDER OF IMPLEMENTATION
 * 1. Constructors
 * 2. Insertor (<<) -> allows you to print out and see what is in the vector throughout development
 * 3. Write test cases that use some of the constructors and print those vectors out
 * 4. Write a test case for a function
 * 5. Implement the function and test until you are confident on its correctness
 * 6. Repeat from 4 until all methods are implemented and tested
 * 7. Implement the destructor last; if there are still errors, then you know it is due to memory management
*/


template <typename T> // We will only be testing int and double
class Vector {
 private:
  /**
   * size_t sz   size of the vector i.e the amount of elements in the vector
  */
  size_t sz; 

  /**
   * T* buf  pointer to the base (first element) of a dynamically allocated array
   *    Be careful to manage its memory wisely (calling del[] when necessary)
  */
  T* buf;  

 public:
  /**
   * Constructs a vector of size sz
   *
   * ex: Vector v(10); -> constructs a 10 elem Vector
   * @param sz size of vector
  */
  // NOTE: default constructor

  Vector(size_t sz) : sz{sz}, buf{new T[sz]} {}


  /**
   * Constructs a vector from a list of elements
   *
   * ex: Vector v1{1, 2, 3}; -> creates a vector with values 1, 2, 3 and size 3
   * @param L a list of values to initialize our vector
   *   - L.size() gives the list's size
   *   - You can iterate through it using an iterator
  */
  // NOTE: argument constructor
  Vector(initializer_list<T> L) 
  {
    sz = L.size();
    buf = new T[sz];
    int i = 0;
    for (auto it = L.begin(); it != L.end(); ++it) 
    {
      buf[i] = *it;
      i++;
    }
  }


  /**
   * Destructs the object at the end of the object's lifecycle
   *  - Automatically called
   * Deallocate the array here.
   * Some versions of valgrind report 72704 bytes in one still-reachable block.  You can ignore that. 
  */
  // NOTE: destructor
  ~Vector() 
  {
    delete[] buf;
  }


  /**
   * Copy constructor; makes a new Vector by deep copying the vector passed to it
   * ex: Vector v2{v1};
  */
  // NOTE: copy constructor
  Vector(const Vector & v) 
  {
    sz = v.size();
    buf = new T[sz];

    for (int i = 0; i != sz; ++i)
    {
      buf[i] = v[i];
    }
  }


  /**
   * Returns the size of the vector
   * ex: Vector v1(10); v1.size(); -> will return 10
   * @return size of vector
  */
  // NOTE: size method
  size_t size() const 
  {
    return sz;
  }


  /**
  * Overloads the [] operator and returns a reference to the value at index i in the 
  * dynamically allocated array. This would be used to change the value at that index.
  * Throws an error when accessing index out of bounds
  * ex: v1[2] = 3;
  * @param i index of elem in buf that will be accessed
  */
  // NOTE: the index operator (return the index)
  T & operator [] (const int i) 
  {
    if (i < 0 || i >= sz)
    {
      throw out_of_range("Index out of bounds");
    }

    return buf[i];
  }


  /**
  * Overloads the [] operator and returns the value of the elem at index i in the 
  * dynamically allocated array. This would be used to access the value at that index
  * without modifying it.
  * Throws an error when accessing index out of bounds
  * ex: T elemAtInd3 = v1[3];
  * @param i index of elem in buf that will be accessed
  */
  // NOTE: the index operator (return the value)
  T operator [] (const int i) const 
  {
    if (i < 0 || i >= sz)
    {
        throw out_of_range("Index out of bounds");
    } 

    return buf[i];
  }
 

  /**
   * Dot products the current vector with the passed vector.
   * The dot product of two vectors is the sum of the products 
   * of the corresponding entries of two sequences of numbers.
   * 
   * ex: T x = V1 * V2; 
   * dot product: [1, 2] * [3, 4, 5] = 1 * 3 + 2 * 4 + 0 = 11
   * Assume an empty Vector will cause the product to be 0.
   * @param v Vector on the right to dot product with
   * @return a scalar value with type T (not a vector!) that is the dot product of the
   *    two vectors
  */
  // NOTE: the * operator (return the dot product of two vectors)
  T operator * (const Vector & v) const 
  {
    int smallerSize = min(sz, v.size());
    int dotProduct = 0;
    for (int i = 0; i < smallerSize; ++i)
    {
      dotProduct += buf[i] * v[i];
    }
    
    return dotProduct;
  }


  /**
   * Adds the current vector with the passed vector and returns a new vector.
   * ex: V3 = V1 + V2; 
   * addition: [1, 2, 3] + [4, 5, 6, 7] = [5, 7, 9, 7]
   * @param v Vector on the right to perform addition with
   * @return new vector where index i is the result of this[i] + v[i]
  */
  // NOTE: the + operator (return the sum of two vectors)
  Vector operator + (const Vector & v) const 
  {
    cout << "+ operator" << endl;
    int largerSize = max(sz, v.size());
    int smallerSize = min(sz, v.size());
    
    cout << largerSize << endl;
    Vector<T> newV(largerSize);
    
    // add sum from both arrays
    for (int i = 0; i < smallerSize; ++i) // range 0 through smallerSize
    {
      newV[i] = buf[i] + v[i];
    }

    // add remaining elements from the larger array
    if (v.size() == largerSize)
    {
      for (int i = smallerSize; i < largerSize; ++i) // range smallerSize through largerSize
      {
        newV[i] = v[i];
      }
    }
    else 
    {
      for (int i = smallerSize; i < largerSize; ++i) // range smallerSize through largerSize
      {
        newV[i] = buf[i];
      }
    }
    
    return newV;
  }


  /**
   * Destructs the current vector and deep copies the passed vector 
   * ex: V1 = V2; 
   * V1 could be an already existing vector, be sure to clean it up before the deep copy
   * @param v Vector on the right to deep copy
   * @return reference to the current object
  */
  // NOTE: the assignment operator and makes a deep copy
  const Vector & operator = (const Vector & v) 
  {
    delete[] buf; // destruct the current vector
    sz = v.size();
    buf = new T[sz];

    for (int i = 0; i != sz; ++i)
    {
      buf[i] = v[i];
    }

    return *this;
  }
  

  /**
   * Determines whether the current vector is equivalent to the passed vector
   * ex: bool isV1AndV2Same = V1 == V2; 
   * @param v Vector on the right to compare current with
   * @return true if both vectors are deeply equivalent (elem by elem comparison) and false otherwise
  */
  // NOTE: the equality operator 
  bool operator == (const Vector & v) const 
  {
    if (sz != v.size()) return false;

    for (int i = 0; i != sz; ++i)
    {
      if (v[i] != buf[i]) return false;
    }

    return true;
  }


  /**
   * Determines whether the current vector is not equivalent to the passed vector
   * ex: bool isV1AndV2Different = V1 != V2; 
   * @param v Vector on the right to compare current with
   * @return false if both vectors are deeply equivalent (elem by elem comparison) and true otherwise
  */
  // NOTE: the not equals operator
  bool operator != (const Vector & v) const 
  {
    if (sz != v.size()) return true;

    for (int i = 0; i != sz; ++i)
    {
      if (v[i] != buf[i]) return true;
    }

    return false;
  }


  /**
   * Multiplies each element in the current vector with the passed integer and returns a new vector.
   * ex: V1 = 20 * V2; it is important that 20 is on the left!
   * 20 * [1, 2, 3] = [20, 40, 60]
   * @param scale integer to multiple each element of vector v
   * @param v Vector on the right to perform multiplication on
   * @return new vector where index i is the result of v[i] * scale
  */
  inline friend Vector operator * (const int scale, const Vector & v) 
  {
    Vector<T> newV(v.size());
    for (int i = 0; i != v.size(); ++i) 
    {
      newV[i] = scale * v[i];
    }
    
    return newV;
  }


  /**
   * Adds each element in the current vector with the passed integer and returns a new vector.
   * ex: V1 = 20 + V2; it is important that 20 is on the left!
   * 20 + [1, 2, 3] = [21, 22, 23]
   * @param adder integer to add to each element of vector v
   * @param v Vector on the right to perform addition on
   * @return new vector where index i is the result of v[i] + adder
  */
  inline friend Vector operator + (const int adder, const Vector & v) 
  {
    Vector<T> newV(v.size());
    for (int i = 0; i != v.size(); ++i) 
    {
      newV[i] = adder + v[i];
    }
    
    return newV;
  }


  /**
   * Allows the << operator to correctly print out the vector.
   * ex: cout << V2; -> (v[0], v[1], v[2], ... v[sz-1])
   * @param o ostream to print the elems of the array, usage is o << thingToPrint;
   * @param v vector that will be printed out
   * @return the ostream passed in
  */
  // NOTE: inserter
  inline friend ostream& operator << (ostream & o, const Vector & v) 
  {
    int lastIndex = v.size() - 1;
    o << "(";
    for (int i = 0; i < lastIndex; ++i)
    {
      o << v[i] << ", ";
    }
    o << v[lastIndex] << ")";
    return o;
  }
  
};

#endif
