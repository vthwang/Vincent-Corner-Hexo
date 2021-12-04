---
title: C++ Learning Journey Day12
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay12.jpg
toc: true
date: 2021-12-04 15:43:26
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay12.jpg">

***
# Section 24: C++ 11
## Auto
1. `auto` can detect the data type, so you don't need to declare the data type by yourself. `decltype` can capture the data type and use it on the other variables.
    ```
    #include <iostream>

    using namespace std;

    float fun()
    {
        return 2.34f;
    }

    int main()
    {
        double d = 12.3;
        int i = 9;

        auto x = 2 * d + i;
        cout << x << endl;

        auto y = fun();
        cout << y << endl;

        float a = 90.5;

        decltype(a) b = 12.3;

        cout << typeid(b).name() << endl;

        return 0;
    }
    ====OUTPUT====
    33.6
    2.34
    f
    ```
## Final Keyword
1. If you use `final` keyword, it will restrict inheritance. Moreover, `final` function can't be inherited by the derived class.
## Lambda Expressions
1. Lambda is useful for defining unnamed function, so we can define the function wherever we like.
2. The format of lambda expression: `[capture_list](parameter_list)->returnType{ body };`
3. Example.
    ```
    #include <iostream>

    using namespace std;

    template<typename T>
    void fun(T p)
    {
        p();
    }

    int main()
    {
        [](){ cout << "Hello" << endl; }();

        [](int x, int y){ cout << "Sum is " << x + y << endl; }(10, 5);
        cout << ([](int x, int y){ return x + y; }(10, 5)) << endl;
        int a = [](int x, int y)->int{ return x + y; }(10, 5);
        cout << a << endl;

        auto f = [](){ cout << "Hello" << endl; };
        f();

        int x = 10;
        auto g = [&x](){ cout << x++ << endl; };
        g();
        x++;
        g();

        fun(g);
        fun(g);

        return 0;
    }
    ====OUTPUT====
    Hello
    Sum is 15
    15
    15
    Hello
    10
    12
    13
    14
    ```
## Smart Pointers
1. unique_ptr: Upon an object at a time only one pointer will be pointing.
2. shared_ptr: It can be used by more than one pointer can point on the same object. It has Ref_counter to record how many pointers point to an object and you can use `use_count()` to check it. If the Ref_counter becomes to zero, the object will be deleted.
3. weak_ptr: It doesn't have the Ref_counter. Suppose the pointers are holding the objects and requesting for other objects, then they may form a deadlock between the pointers. So to avoid a deadlock, weak pointers are useful. This is between unique and share, but it's not strict.
4. unique_prt example.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
        int length;
        int breadth;
    public:
        Rectangle(int l, int b)
        {
            length = l;
            breadth = b;
        }

        int area()
        {
            return length * breadth;
        }
    };

    int main()
    {
        unique_ptr<Rectangle> ptr(new Rectangle(10, 5));
        cout << ptr->area() << endl;
        // It's deleted, so you can't initialize another pointer to ptr.
        // unique_ptr<Rectangle> ptr2 = ptr;
        unique_ptr<Rectangle> ptr2;
        ptr2 = move(ptr);
        cout << ptr2->area() << endl;
        // shows nothing, because ptr is removed at this point.
        cout << ptr->area() << endl;

        return 0;
    }
    ====OUTPUT====
    50
    50
    ```
5. share_ptr example.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
        int length;
        int breadth;
    public:
        Rectangle(int l, int b)
        {
            length = l;
            breadth = b;
        }

        int area()
        {
            return length * breadth;
        }
    };

    int main()
    {
        shared_ptr<Rectangle> ptr(new Rectangle(10, 5));
        cout << ptr->area() << endl;
        
        shared_ptr<Rectangle> ptr2;
        ptr2 = ptr;
        cout << ptr2->area() << endl;
        cout << ptr->area() << endl;
        cout << ptr.use_count() << endl;

        return 0;
    }
    ====OUTPUT====
    50
    50
    50
    2
    ```
## InClass Initializer and Delegation of Constructor
1. One constructor can call another constructor in the same class. Here is an example.
    ```
    class Test
    {
        int x = 10;
        int y = 13;
    public:
        Test(int a, int b)
        {
            x = a;
            y = b;
        }
        Test():Test(1, 1) {}
    };
    ```
## Ellipsis
1. Ellipsis is used for taking variable number of arguments in a function. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    int sum(int n, ...)
    {
        va_list list;
        va_start(list, n);

        int x;
        int s = 0;
        for (int i = 0; i < n; i++) {
            x = va_arg(list, int);
            s += x;
        }

        va_end(list);

        return s;
    }

    int main()
    {
        cout << sum(3, 10, 20, 30) << endl;
        cout << sum(5, 1, 2, 3, 4, 5) << endl;

        return 0;
    }
    ====OUTPUT====
    60
    15
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.