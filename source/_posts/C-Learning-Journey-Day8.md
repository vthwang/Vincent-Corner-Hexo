---
title: C++ Learning Journey Day8
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay08.jpg
toc: true
date: 2021-11-25 20:09:23
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay08.jpg">

***
# Section 13: Operator Overloading
## Operator Overloading
1. Operators: +, *, -, (), ++, new, delete...
2. These operators can be used for primary data types, such as int, float...
3. If we want to perform these operators to custom data types, we need to use operator overloading.
4. Example of complex number.
    ```
    #include <iostream>

    using namespace std;

    class Complex
    {
    private:
        int real;
        int img;
    public:
        Complex(int r = 0, int i = 0)
        {
            real = r;
            img = i;
        }

        Complex operator+(Complex x)
        {
            Complex temp;
            temp.real = real + x.real;
            temp.img = img + x.img;
            return temp;
        };
    };

    int main()
    {
        Complex C1(3, 7);
        Complex C2(5, 4);
        Complex C3;

        C3 = C1 + C2;

        return 0;
    }
    ```
## Friend Operator Overloading
1. Friend function can be used to Operator Overloading, when you need to use `friend` to access the private variable outside the class. Here is an example.
    ```
    class Complex
    {
    private:
        int real;
        int img;
    public:
        Complex(int r = 0, int i = 0)
        {
            real = r;
            img = i;
        }

        friend Complex operator+(Complex c1, Complex c2);
    };

    Complex operator+(Complex c1, Complex c2)
    {
        Complex t;
        t.real = c1.real + c2.real;
        t.img = c1.real + c2.img;
        return t;
    }
    ```
## Insertion Operator Overloading
1. Example
    ```
    class Complex
    {
    private:
        int real;
        int img;
    public:
        .
        .
        .
        friend ostream & operator<<(ostream &o, Complex &c1);
    };

    ostream & operator<<(ostream &o, Complex &c1)
    {
        o << c1.real << "+i" << c1.img;
        return o;
    }
    ```
# Section 14: Inheritance
## Introduction
1. The derived class can use everything in the base class. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        int x;
        void show()
        {
            cout << x << endl;
        }
    };

    class Derived : public Base
    {
    public:
        int y;
        void display()
        {
            cout << x << " " << y << endl;
        }
    };


    int main()
    {
        Base b;
        b.x = 25;
        b.show(); // 25
        Derived d;
        d.x = 10;
        d.y = 15;
        d.show(); // 10
        d.display(); // 10 15

        return 0;
    }
    ====OUTPUT====
    25
    10
    10 15
    ```
## Inheritance Examples
1. Using Rectangle as the base class and extend the new class Cuboid.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
    private:
        int length;
        int breadth;
    public:
        Rectangle(int r = 0, int b = 0)
        {
            length = r;
            breadth = b;
        }
        void setLength(int l)
        {
            if (l >= 0)
                length = l;
            else
                length = 0;
        }

        void setBreadth(int b)
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

    class Cuboid : public Rectangle
    {
    private:
        int height;
    public:
        Cuboid(int l = 0, int b = 0, int h = 0)
        {
            height = h;
            setLength(l);
            setBreadth(b);
        }

        int getHeight()
        {
            return height;
        }

        void setHeight(int h)
        {
            height = h;
        }

        int volume()
        {
            return getLength() * getBreadth() * height;
        }
    };


    int main()
    {
        Cuboid c(10, 5, 3);
        cout << c.getLength() << endl;
        cout << c.volume() << endl;
        cout << c.area() << endl;

        return 0;
    }
    ====OUTPUT====
    10
    150
    50
    ```
## Constructors in Inheritance
1. When you call a derived class, it will call the default constructor of the base class first and then call  the constructor of the derived class.
2. Example.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        Base() { cout << "Non-param Base" << endl; }
        Base(int x) { cout << "Param of Base " << x << endl; }
    };

    class Derived : public Base
    {
    public:
        Derived() { cout << "Non-param Derived" << endl; }
        Derived(int y) { cout << "Param of Derived " << y << endl; }
        Derived(int x, int y) : Base(x)
        {
            cout << "Param of Derived " << y << endl;
        }
    };

    int main()
    {
        Derived d;
        Derived d2(10);
        Derived d3(5, 10);

        return 0;
    }
    ====OUTPUT====
    Non-param Base
    Non-param Derived
    Non-param Base
    Param of Derived 10
    Param of Base 5
    Param of Derived 10
    ```
## isA and hasA
1. There are two ways for a class: A class can be derived(isA). Object of a class can be used(hasA).
## Access Specifiers
1. When you create an object of a class, you cannot access all members except public members.
2. When you want to call the variables of the base class in the derived class, you can only access the protected and public members.
## Types of Inheritance
1. Simple/Single: Cuboid inheritance from Rectangle.
2. Hierarchical: Rectangle, Circle and Quadrilateral inheritance from Shape.
3. Multilevel: Cylinder inheritance from Circle, Circle inheritance from Point.
4. Multiple: Smart Phone inheritance from Phone and Camera.
5. Hybrid: mix hierarchical and multilevel or multiple. D inheritance from B and C, B and C inheritance from A.
    ```
    class A
    {
      ...
    };
    class B : virtual public A
    {
      ...
    };
    class C : virtual public A
    {
      ...
    };
    class D : public B, public C
    {
      ...
    };
    ```
## Ways of Inheritance
1. If you inheritance publicly, you can access all the members except the private member. If you inheritance protected class, the public and protected members become protected in child class.
2. If you inheritance privately, the public and protected members become private in child class. Thus, you can access those members in the child class, but you can't access them in the grandchild members since they are private in the child class.
## Generalization and Specialization
1. Something is existing, then you are deriving something from that one and defining a new class. It's specialization.
2. The child classes are existing, then you are defining a base class for them. It's Generalization.

# Section 15: Base Class Pointer Derived Class Object
## Base Class Pointer Derived Class Object
1. You can only call the base class functions when you initiate the pointer with base class.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        void fun1();
        void fun2();
        void fun3();
    };

    class Derived : public Base
    {
    public:
        void fun4();
        void fun5();
    };

    int main()
    {
        Base *p;
        p = new Derived();
        p->fun1();
        p->fun2();
        p->fun3();
        // p->fun4(); // Can't Work
        // p->fun5(); // Can't Work
        
        return 0;
    }
    ```
2. Example: you can only create a pointer of a base class to point to the child class. If we define the base class is Rectangle and derived class is cuboid, you want to initialize `Cuboid *ptr = &r;` which would get the error message. Because you can't say Rectangle is Cuboid which fits the real world rule.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        void fun1()
        {
            cout << "fun1 of Base" << endl;
        }
    };

    class Derived : public Base
    {
    public:
        void fun2()
        {
            cout << "fun2 of Derived" << endl;
        }
    };

    int main()
    {
        Derived d;
        Base *ptr = & d;
        ptr->fun1();
        
        // Can't work
        // Base b;
        // Derived *ptr = &b;

        return 0;
    }
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.