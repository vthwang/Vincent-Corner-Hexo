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
# Section 17: Friend and Static Members / Inner Classes
## Friend Function and Classes
1. Friend function is a global function outside function which can access all the members of a class.
2. When you declare the friend function, you need to add the class name before calling the class as friend.
3. Example.
    ```
    #include <iostream>

    using namespace std;

    class Your;
    class My
    {
    private: int a;
    protected: int b;
    public: int c;
        friend Your;
    };

    class Your
    {
    public:
        My m;
        void fun()
        {
            m.a = 10;
            m.b = 10;
            m.c = 10;
        }
    };
    ```
## Static Members
1. Static variables are static data members of a class belongs to a class that doesn't belong to an object, and all the objects can share it.
2. When you declare a static members inside the class, that data member must also be declared outside the class using scope resolution.
3. You can access the static members by object or class.
4. Static member functions can access only static data members of a class.
5. Example:
    ```
    #include <iostream>

    using namespace std;

    class Test
    {
    public:
        int a;
        static int count;

        Test()
        {
            a = 10;
            count ++;
        }

        static int getCount()
        {
            // a++; // invalid
            return count;
        }
    };

    int Test::count = 0;

    int main()
    {
        Test t1, t2;
        cout << t1.count << endl;
        cout << t2.count << endl;
        t1.count = 25;
        cout << t2.count << endl;
        cout << Test::count << endl;

        cout << Test::getCount() << endl;
        cout << t1.getCount() << endl;

        return 0;
    }
    ====OUTPUT====
    2
    2
    25
    25
    25
    25
    ```
## Inner / Nested Class
1. Inner Class can access the members of the outer class if they are static.
2. Outer Class can access all the members of the inner class and create a object of the inner class.
3. Example.
    ```
    class Outer
    {
    public:
        void fun()
        {
            i.display();
        }

        class Inner
        {
        public:
            void display()
            {
                cout << "Display of Inner" << endl;
            }
        };
        Inner i;
    };
    ```
# Section 18: Exception Handling
## Exception Handling
1. Error types and solutions.
    - Syntax Error - Compiler
    - Logical Error - Debugger
    - Runtime Error -  Caused by (1) bad input (2) problem with resources, using Exception to solve.
## Exception Handling Construct
1. Example.
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        int a = 10, b = 0, c;

        try
        {
            if (b == 0)
                throw 20;
            c = a / b;
            cout << c;
        }
        catch (int e)
        {
            cout << "Divided by zero " << "error code " << e << endl;
        }

        cout << "Bye" << endl;

        return 0;
    }
    ====OUTPUT====
    Divided by zero error code 20
    Bye
    ```
## Throw and Catch Between Functions
1. Error can also be implemented by if else, but the most powerful thing in try catch function is that you can throw the error from other functions.
2. Example.
    ```
    #include <iostream>

    using namespace std;

    int division(int x, int y)
    {
        if (y == 0)
            throw 1;
        else
            return x / y;
    }

    int main()
    {
        int a = 10, b = 0, c;

        try
        {
            c = division(a, b);
            cout << c << endl;
        }
        catch (int e)
        {
            cout << "Divided by zero " << "error code " << e << endl;
        }

        cout << "Bye" << endl;

        return 0;
    }
    ====OUTPUT====
    Divided by zero error code 20
    Bye
    ```
## All About Throw
1. You can throw anything, such as int, float, string, etc.
2. You can define your own Exception class. Example.
    ```
    class MyException : exception
    {
    };
    ```
2. Using `throw` after the function to declare the throw type.
    ```
    int division(int x, int y) throw (int)
    {
        if (y == 0)
            throw 10;
        return x / y;
    }
    ```
## All About Catch
1. You can have multiple catch blocks. `...` means catch all, but it can only use in the last block. If you use `...` in the first catch block, it will catch all of errors in the first block.
    ```
    try
    {
      ... int
      ... float
      ... myException
    }
    catch(int e)
    {

    }
    catch(myException e)
    {

    }
    catch(...)
    {

    }
    ```
2. Try catch can do nesting.
    ```
    try
    {
        try
        {
            
        }
        catch (int e)
        {
            
        }
    }
    catch (int e)
    {
        
    }
    ```
3. If you write your own Exception class, the child class must put before the base class. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    class MyException1
    {
        
    };

    class MyException2 : public MyException1
    {
        
    };

    int main()
    {
        try
        {
            
        }
        catch (MyException2 e)
        {
            
        }
        catch (MyException1 e)
        {

        }

        return 0;
    }
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.