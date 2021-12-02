---
title: C++ Learning Journey Day9
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay09.jpg
toc: true
date: 2021-11-27 19:51:58
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay09.jpg">

***
# Section 16: Polymorphism
## Function Overriding
1. Function overriding is you can redefined the parent function in the child class. You use the same function name of the parent class in child class.
2. Example.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        void display()
        {
            cout << "Display of Base" << endl;
        }
    };

    class Derived : public Base
    {
    public:
        void display()
        {
            cout << "Display of Derived" << endl;
        }
    };

    int main()
    {
        Derived d;
        d.display();

        return 0;
    }
    ====OUTPUT====
    Display of Derived
    ```
## Virtual Functions
1. If you don't use `virtual` in the base function. Pointer object will call the base class.
    ```
        ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        void fun()
        {
            cout << "fun of Base" << endl;
        }
    };

    class Derived : public Base
    {
    public:
        void fun()
        {
            cout << "fun of Derived" << endl;
        }
    };

    int main()
    {
        Derived d;
        Base *ptr = &d;
        ptr->fun();

        return 0;
    }
    ====OUTPUT====
    fun of Base
    ```
2. If you use `virtual` in the base function. Pointer object will call the derived class.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        virtual void fun()
        {
            cout << "fun of Base" << endl;
        }
    };

    class Derived : public Base
    {
    public:
        void fun()
        {
            cout << "fun of Derived" << endl;
        }
    };

    int main()
    {
        Derived d;
        Base *ptr = &d;
        ptr->fun();

        return 0;
    }
    ====OUTPUT====
    fun of Derived
    ```
## Runtime Polymorphism
1. We can defined functions in the base class equals to zero, and the sub-classes must implement those functions, this is called pure virtual functions.
2. Example.
    ```
    #include <iostream>

    using namespace std;

    class Car
    {
    public:
        virtual void start() { cout << "Car Started" << endl; }
    };

    class Innova : public Car
    {
    public:
        void start() { cout << "Innova Started" << endl; }
    };

    class Swift : public Car
    {
    public:
        void start() { cout << "Swift Started" << endl; }
    };

    int main()
    {
        Car *p = new Innova();
        p->start();
        p = new Swift();
        p->start();

        return 0;
    }
    ====OUTPUT====
    Innova Started
    Swift Started
    ```
## Abstract Classes
1. If a base class has all concrete functions, it means this class's purpose is to achieve reusability. And if a base class has some concrete functions and some pure virtual functions, it means this class's purpose is to achieve reusability and polymorphism.
2. If a base class has all pure virtual functions, it means this class's purpose is to achieve polymorphism. This is also called **interface**.
3. When you use pure virtual functions in the base class, they are the abstract class.
4. If you make a class as abstract class, you can't initialize it. For example, `Car c;` is not allowed.
5. If the sub-class didn't overwrite the virtual functions from the base class, the sbu-class will also become abstract class.

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.