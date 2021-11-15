---
title: C++ Learning Journey Day7
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay07.jpg
toc: true
date: 2021-10-26 22:12:21
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay07.jpg">

***
# Section 12: Introduction to OOPS
## Principles of Object-Oriented Programming
1. Abstraction: We use class to abstract the object, and put data and function inside the class. We don't need to see content inside the class.
2. Encapsulation: We hide the data to prevent misbehaving.
    - Data Hiding
3. Inheritance
4. Polymorphism
## Class vs Objects
1. We initiate the class Human, you and my are the objects of this class. Also, we initiate the class Car, BMW and Camry are the objects of this class.
2. We can treat Class as the blueprint of Object.
3. Example
    ```
    class Rectangle
    {
        float length;
        float breath;

        float area()
        float perimeter()
        float diagonal()
    };

    // r1, r2, r3 are the objects
    int main()
    {
        Rectangle r1, r2, r3;
    }
    ```
## Writing a Class in C++
1. Example.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
    public:
        int length;
        int breadth;

        int area()
        {
            return length * breadth;
        }

        int perimeter()
        {
            return 2 * (length + breadth);
        }
    };

    int main()
    {
        Rectangle r1, r2;
        r1.length = 10;
        r1.breadth = 5;

        cout << "r1 Area is " << r1.area() << endl;
        cout << "r1 Perimeter is " << r1.perimeter() << endl;

        r2.length = 15;
        r2.breadth = 10;
        cout << "r2 Area is " << r2.area() << endl;
        cout << "r2 Perimeter is " << r2.perimeter() << endl;

        return 0;
    }
    ```
## Pointer to an Object in Heap
1. The first example create an object by stack, and the second example create an object by heap.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
    public:
        int length;
        int breadth;

        int area()
        {
            return length * breadth;
        }

        int perimeter()
        {
            return 2 * (length + breadth);
        }
    };

    int main()
    {
        // created by stack
        Rectangle r;
        Rectangle *p;

        p = &r;
        r.length = 10;
        p->length = 10;
        p->breadth = 5;
        cout << p->area() << endl;

        // created by heap
        Rectangle *q;
        q = new Rectangle;

        q->length = 15;
        q->breadth = 10;

        cout << q->area() << endl;

        return 0;
    }
    ```
## Philosophy Behind Data Hiding
1. Inside the class, we should not let variables as public. If the data is wrong, we should handle it inside the class.
## Data Hiding in C++ (Accessors and Mutator)
1. Getter(Accessor) and Setter(Mutator) in class.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
    private:
        int length;
        int breadth;
    public:
        void setLength(int l)
        {
            if (l >= 0)
                length = l;
            else
                length = 0;
        }

        void setBreath(int b)
        {
            if (b >= 0)
                breadth = b;
            else
                breadth = 0;
        }

        int getLength()
        {
            return length;
        }

        int getBreadth()
        {
            return breadth;
        }

        int area()
        {
            return length * breadth;
        }

        int perimeter()
        {
            return 2 * (length + breadth);
        }
    };

    int main()
    {
        Rectangle r;
        r.setLength(10);
        r.setBreath(-5);
        cout << r.area() << endl;
        cout << "Length is " << r.getLength() << endl;
        cout << "Breadth is " << r.getBreadth() << endl;

        return 0;
    }
    ====OUTPUT====
    0
    Length is 10
    Breadth is 0
    ```
## Philosophy Behind Constructors
1. Constructors are used for initializing the variables inside class. If we want to create an object with default variables, we should use constructors.
## Constructors
1. Default Constructor
2. Non-parameterized Constructor
3. Parameterized Constructor
4. Copy Constructor
5. Example
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
    private:
        int length;
        int breadth;
    public:
        Rectangle()
        {
            length = 0;
            breadth = 0;
        }

        Rectangle(int l, int b)
        {
            setLength(l);
            setBreath(b);
        }

        Rectangle(Rectangle &r)
        {
            length = r.length;
            breadth = r.breadth;
        }

        void setLength(int l)
        {
            if (l >= 0)
                length = l;
            else
                length = 0;
        }

        void setBreath(int b)
        {
            if (b >= 0)
                breadth = b;
            else
                breadth = 0;
        }

        int getLength()
        {
            return length;
        }

        int getBreadth()
        {
            return breadth;
        }

        int area()
        {
            return length * breadth;
        }

        int perimeter()
        {
            return 2 * (length + breadth);
        }
    };

    int main()
    {
        // Default Constructor
        // Non-parameterized Constructor
        Rectangle r;

        // Parameterized Constructor
        Rectangle r2(10, 5);

        // Copy Constructor
        Rectangle r3(r);

        return 0;
    }
    ```
6. We can set default value to Parameterized Constructor `Rectangle(int l, int b)`. And we can call `Rectangle(l, b)`, `Rectangle(l)` and `Rectangle()` just use one constructor.
    ```
    Rectangle(int l = 0, int b = 0)
    {
        setLength(l);
        setBreath(b);
    }
    ```
## Deep Copy Constructor
1. When we deal with the pointer in copy constructor, we need to assign the values carefully.
    ```
    #include <iostream>

    using namespace std;

    class Test
    {
        int a;
        int *p;
    public:
        Test(int x)
        {
            a = x;
            p = new int[a];
        }

        Test(Test &t)
        {
            a = t.a;
            // many people use p = t.p, it will point to same address location which is wrong.
            p = new int[a];
        }
    };

    int main()
    {
        Test t(5);
        Test t2(t);

        return 0;
    }
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.