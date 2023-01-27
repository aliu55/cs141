// include libraries for memory allocation (malloc) and I/O (iostream)

#include <malloc.h>
#include <iostream>
#include <string>
using namespace std;

// define the types which we'll need in this program 
typedef double (*double_method_type)(void *);
typedef void (*void_method_type)(void *);

// VirtualTableEntry is a union storing the two data types we created above
typedef union {
    double_method_type double_method; 
    void_method_type void_method;
} VirtualTableEntry;

// VTableType is a pionter to a VirtualTableEntry
typedef VirtualTableEntry * VTableType; 

// indices of the virtual functions (in Shape, we have print(), draw(), and area())

#define PRINT_INDEX 0
#define DRAW_INDEX 1
#define AREA_INDEX 2

#define PI 3.14159

// SHAPE CLASS START ----- 

// Shape class type
struct Shape 
{
    // every class should have a pointer to a virtual table (vtable) 
    VTableType VPointer;
    std::string name;
};

// Shape functions
void Shape_print(Shape *_this)
{
    cout << " " << endl;
}

void Shape_draw(Shape *_this)
{
    cout << " " << endl;
}

double Shape_area(Shape *_this)
{
    return 0.0;
}

// define VTable for Shape that contains all virtual methods
// again, having a vtable allows for dynamic binding
VirtualTableEntry Shape_VTable [] = 
{
    {.void_method=(void_method_type)Shape_print},
    {.void_method=(void_method_type)Shape_draw},
    {.double_method=(double_method_type)Shape_area},
};

// Shape constructor
Shape * Shape_Shape(Shape * _this, std::string name)
{
    _this->VPointer = Shape_VTable;
    _this->name = name;
    return _this;
}

// SHAPE CLASS END ----- 

// CIRCLE CLASS START ----- 

// Circle class type
struct Circle 
{
    VTableType VPointer;
    std::string name; // inherited data member from Shape
    int radius;    // additional data member
};

// Circle class methods

void Circle_draw(Circle * _this)
{
    cout << "          *************************" << endl;
    cout << "        **                         **" << endl;
    cout << "     **                               **" << endl;
    cout << "   *                                     *" << endl;
    cout << " *                                        *" << endl;
    cout << " *                                         *" << endl;
    cout << " *                                         *" << endl;
    cout << " *                                         *" << endl;
    cout << " *                                         *" << endl;
    cout << "   *                                     *" << endl;
    cout << "     **                               **" << endl;
    cout << "        **                         **" << endl;
    cout << "          *************************" << endl;
}

double Circle_area(Circle * _this)
{
    return PI * _this->radius * _this->radius;
}

void Circle_print(Circle * _this)
{
    cout << _this->name + "(" << _this->radius << ") : " << Circle_area(_this) << endl;
}

// Circle VTable
VirtualTableEntry Circle_VTable [] = 
{
    {.void_method=(void_method_type)Circle_print},
    {.void_method=(void_method_type)Circle_draw},
    {.double_method=(double_method_type)Circle_area}
};

// Circle constructor
Circle * Circle_Circle(Circle * _this, std::string newName, int newRadius)
{
    Shape_Shape((Shape *)_this, newName); // similar to super() in Java
    _this->VPointer = Circle_VTable;
    _this->radius = newRadius;
    return _this;
}

// CIRCLE CLASS END ----

// SQAURE CLASS START ----

// Square class type
struct Square 
{
    VTableType VPointer;
    std::string name;
    int length;
};

// Square methods
double Square_area(Square * _this)
{
    return _this->length * _this->length;
}

void Square_print(Square * _this)
{
    cout << _this->name + "(" << _this->length << ") : " << Square_area(_this) << endl;
}

void Square_draw(Square * _this)
{
    cout << "**********" << endl;
    cout << "*        *" << endl;
    cout << "*        *" << endl;
    cout << "**********" << endl;
}

// Square VTable
VirtualTableEntry Square_VTable [] = 
{
    {.void_method=(void_method_type)Square_print},
    {.void_method=(void_method_type)Square_draw},
    {.double_method=(double_method_type)Square_area}
};

// Square constructor
Square * Square_Square(Square * _this, std::string newName, int newLength) 
{
    Shape_Shape((Shape *)_this, newName);
    _this->VPointer = Square_VTable;
    _this->length = newLength;
    return _this;
}

// SQUARE CLASS END ----

// TRIANGLE CLASS START ----

// Triangle data type
struct Triangle
{
    VTableType VPointer;
    std::string name;
    int base;
    int height;
};

// Triangle methods
void Triangle_draw(Triangle * _this) 
{
    cout << "       *" << endl;
    cout << "     *   *" << endl;
    cout << "    *     *" << endl;
    cout << "   *********" << endl;;
}

double Triangle_area(Triangle * _this) 
{
    return (double) _this->base * _this->height / 2;
}

void Triangle_print(Triangle * _this) 
{
 cout << _this->name + "(" << _this->base << ", " << _this->height << ") : " << Triangle_area(_this) << endl;
}

// Triangle VTable
VirtualTableEntry Triangle_VTable [] =
{
    {.void_method=(void_method_type)Triangle_print},
    {.void_method=(void_method_type)Triangle_draw},
    {.double_method=(double_method_type)Triangle_area}
};

// Triangle constructor
Triangle * Triangle_Triangle(Triangle * _this, std::string newName, int newBase, int newHeight)
{
    Shape_Shape((Shape *)_this, newName);
    _this->VPointer = Triangle_VTable;
    _this->base = newBase;
    _this->height = newHeight;
    return _this;
}

// TRIANGLE CLASS END ----

// RECTANGLE CLASS START ----

// Rectangle data type
struct Rectangle 
{
    VTableType VPointer;
    std::string name;
    int width;
    int length;
};

// Rectangle methods
void Rectangle_draw(Rectangle * _this)
{
    cout << "*********" << endl; 
    cout << "*       *" << endl; 
    cout << "*       *" << endl; 
    cout << "*       *" << endl; 
    cout << "*********" << endl;
}

double Rectangle_area(Rectangle * _this)
{
    return _this->length * _this->width;
}

void Rectangle_print(Rectangle * _this)
{
    cout << _this->name + "(" << _this->width << ", " << _this->length << ") : " << Rectangle_area(_this) << endl;
}

// Rectangle VTable
VirtualTableEntry Rectangle_VTable [] = 
{
    {.void_method=(void_method_type)Rectangle_print},
    {.void_method=(void_method_type)Rectangle_draw},
    {.double_method=(double_method_type)Rectangle_area}
};

// Rectangle constructor
Rectangle * Rectangle_Rectangle(Rectangle * _this, std::string newName, int newLength, int newWidth) 
{
    Square_Square((Square *)_this, newName, newWidth);
    _this->VPointer = Rectangle_VTable;
    _this->length = newLength;
    return _this;
}

// MAIN
void printAll(Shape** a, int aSize) 
{
    for (int i = 0; i < aSize; i++)
    {
        (a[i]->VPointer[PRINT_INDEX]).void_method(a[i]);
    }
}

void drawAll(Shape** a, int aSize) 
{
    for (int i = 0; i < aSize; i++)
    {
        (a[i]->VPointer[DRAW_INDEX]).void_method(a[i]);
    }
}

double totalArea(Shape** a, int aSize) 
{
    double total = 0;
    for (int i = 0; i < aSize; i++)
    {
        total += (a[i]->VPointer[AREA_INDEX]).double_method(a[i]);
    }
    return total;
}

int main(int argc, char * argv[]) 
{
    if (argc != 2)
    {
        cout << "Expecting two arguments" << endl;
    }

    int firstX = atoi(argv[1]);
    int firstY = atoi(argv[2]);
    int secondX = firstX - 1;
    int secondY = firstY - 1;
    int aSize = 8;

    // Shape_Shape((Shape *)malloc(sizeof(Shape)), "Shape"),
    
    Shape* a[] = {
        (Shape *)Circle_Circle((Circle *)malloc(sizeof(Circle)), "FirstCircle", firstX),
        (Shape *)Circle_Circle((Circle *)malloc(sizeof(Circle)), "SecondCircle", secondX),
        (Shape *)Square_Square((Square *)malloc(sizeof(Square)), "FirstSquare", firstX),
        (Shape *)Square_Square((Square *)malloc(sizeof(Square)), "SecondSquare", secondX),
        (Shape *)Triangle_Triangle((Triangle *)malloc(sizeof(Triangle)), "FirstTriangle", firstX, firstY),
        (Shape *)Triangle_Triangle((Triangle *)malloc(sizeof(Triangle)), "SecondTriangle", secondX, secondY),
        (Shape *)Rectangle_Rectangle((Rectangle *)malloc(sizeof(Rectangle)), "FirstRectangle", firstX, firstY),
        (Shape *)Rectangle_Rectangle((Rectangle *)malloc(sizeof(Rectangle)), "SecondRectangle", secondX, secondY)
    };

    drawAll(a, aSize);
    printAll(a, aSize);
    cout << "Total : " << totalArea(a, aSize) << endl;;

    return 0;
}

// RECTANGLE CLASS END ----

// TYPEDEF ---
// typedef with a function pointer (declaring a function data type)

// similar to function declaration in C++

// format: return_type function_name(arguments)

// so typedef double (*double_method_type)(void *);

// the * in front of the double_method_type is to indicate that we are creating
// a function pointer to store the memory address of this function 

// the (void *) is saying that this function that we are defining
// does not taking in any argument. hence a pointer to a void value...not exact
// sure why it's a pointer though

// the double at the very front is specifying the return type of this function 

// now we can use the alias double_method_type as a function declaration 
// for methods where we need to return a double type and take in a void argument

// https://stackoverflow.com/questions/4295432/typedef-function-pointer
// UNION ---
// union is a data type used to store different data types in the same memory location

// NOTES
// how does _this->radius know to refer to Shape's radius? 

// remember that the order in which you write the 
// data members in the derived class must follow the order in which the base class defined them (aka put anything related
// to the base class first)

// why is it Shape**? (i lowkey forgot)

// COMMAND LINE ARGUMENTS IN C
// argc is the number of arguments
// argv[] is the pointer array that points to the array of args (start at index 1 just like in Java)