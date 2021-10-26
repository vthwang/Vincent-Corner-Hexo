---
title: C++ Learning Journey Day6
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay06.jpg
toc: true
date: 2021-10-23 16:40:55
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay06.jpg">

***
# Section11: Functions
## Introduction
1. return-Type Function-name(Parameter List).
2. Should not use cin and cout inside function.
3. Add function example.
    ```
    #include <iostream>

    using namespace std;

    int add (int x, int y) {
        int z;
        z = x + y;
        return z;
    }

    int main()
    {
        int a = 10, b= 15, c;

        c = add(a, b);

        cout << "sum is " << c << endl;

        return 0;
    }
    ====OUTPUT====
    sum is 25
    ```
## Function Overloading
1. Functions can be overloaded. If the functions with same name have different number of parameters and different types of parameters, they are the different functions.
    - int max(int, int)
    - float max(float, float)
    - int max(int, int, int)
    - float max(int, int) (X, this is the same function with the first one.)
2. Overloading example.
    ```
    #include <iostream>

    using namespace std;

    int add(int x, int y)
    {
        return x + y;
    }

    int add(int x, int y, int z)
    {
        return x + y + z;
    }

    float add(float x, float y)
    {
        return x + y;
    }

    int main()
    {
        int a = 10, b = 5, c, d;
        c = add(a, b);
        d = add(a, b, c);

        cout << c << endl;
        cout << d << endl;

        float i = 2.5f, j = 3.5f, k;
        k = add(i, j);

        cout << k << endl;

        return 0;
    }
    ====OUTPUT====
    15
    30
    6
    ```
## Function Template
1. Template is used for generic function. For example, we have two max functions with two types and the whole logic is identical. I can use template to combine them together.
    ```
    #include <iostream>

    using namespace std;

    template<class T>

    T Max(T x, T y)
    {
        return x > y ? x : y;
    }

    int main()
    {
        int c = Max(10, 5);
        float d = Max(10.5f, 6.9f);
        cout << c << endl;
        cout << d << endl;

        return 0;
    }
    ====OUTPUT====
    10
    10.5
    ```
## Default Arguments
1. You can assign a default value for function arguments. For example.
    ```
    #include <iostream>

    using namespace std;

    int sum(int a, int b, int c = 0)
    {
        return a + b + c;
    }

    int main()
    {
        cout << sum(10 ,5) << endl;
        cout << sum(12, 13, 14) << endl;

        return 0;
    }
    ```
2. The best practice is write the default argument from right to left parameters. Make sure you'll check every arguments.
    ```
    #include <iostream>

    using namespace std;

    int max(int a = 0, int b = 0, int c = 0)
    {
        return a > b && a > c ? a : (b > c ? b : c);
    }

    int main()
    {
        cout << max() << endl;
        cout << max(10) << endl;
        cout << max(10 ,13) << endl;
        cout << max(10 ,13, 15) << endl;

        return 0;
    }
    ====OUTPUT====
    0
    10
    13
    15
    ```
## Parameter Passing - Pass by Value
1. Parameter Passing Method.
    - Pass by value.
    - Pass by address.
    - Pass by reference.
2. Example. x and y won't be changed, because it just pass value into swap() function, and a and b would eliminate after the function is executed.
    ```
    #include <iostream>

    using namespace std;

    void swap(int a, int b)
    {
        cout << a << " " << b << endl;
        int temp;
        temp = a;
        a = b;
        b = temp;
        cout << a << " " << b << endl;
    }

    int main()
    {
        int x = 10, y = 20;
        swap(x, y);
        cout << x << " " << y << endl;

        return 0;
    }
    ====OUTPUT====
    10 20
    20 10
    10 20
    ```
## Parameter Passing - Pass by Address
1. Example.
    ```
    #include <iostream>

    using namespace std;

    void swap(int *a, int *b)
    {
        int temp;
        temp = *a;
        *a = *b;
        *b = temp;
    }

    int main()
    {
        int x = 10, y = 20;
        swap(&x, &y);
        cout << x << " " << y << endl;

        return 0;
    }
    ====OUTPUT====
    20 10
    ```
## Parameter Passing - Pass by Reference
1. Example.
    ```
    #include <iostream>

    using namespace std;

    void swap(int &a, int &b)
    {
        int temp;
        temp = a;
        a = b;
        b = temp;
    }

    int main()
    {
        int x = 10, y = 20;
        swap(x, y);
        cout << x << " " << y << endl;

        return 0;
    }
    ====OUTPUT====
    20 10
    ```
## Return by Address
1. Return by address example.
    ```
    #include <iostream>

    using namespace std;

    int * fun()
    {
        int *p = new int[5];
        for (int i = 0; i < 5; i++)
        {
            p[i] = 5 * i;
        }
        cout << p << endl;
        return p;
    }

    int main()
    {
        int *q = fun();
        cout << q << endl;
        for (int i = 0; i < 5; i++)
        {
            cout << q[i] << endl;
        }

        return 0;
    }
    ====OUTPUT====
    0x7ff6a04059d0
    0x7ff6a04059d0
    0
    5
    10
    15
    20
    ```
## Return by Reference
1. Return by reference example. Because the fun() return the reference type a, we can assign value to it. `fun(a) = 25;` is as same as `a = 25;`.
    ```
    #include <iostream>

    using namespace std;

    int & fun(int &x)
    {
        return x;
    }

    int main()
    {
        int a = 10;
        fun(a) = 25;

        cout << a << endl;

        return 0;
    }
    ====OUTPUT====
    25
    ```
## Local and Global Variables
1. Example. The outside g is the global variable. The other variables are local variables, they would be vanished after the variables' block code is executed. Declare variable g repeatedly would shadow the global variable g, the related code block only treat the g as a local variable.
    ```
    #include <iostream>

    using namespace std;

    int g = 5;

    void fun()
    {
        int g = 10;
        {
            int g = 0;
            g++;
            cout << g << endl;
        }
        cout << g << endl;
    }

    int main()
    {
        cout << g << endl;
        fun();
        cout << g << endl;

        return 0;
    }
    ====OUTPUT====
    5
    1
    10
    5
    ```
## Scope Rule
1. Example. If we want to access the global variable, we can use `::x` to access it.
    ```
    #include <iostream>

    using namespace std;

    int x = 10;

    int main()
    {
        int x = 20;
        {
            int x = 30;
            cout << x << endl;
        }

        cout << x << endl;
        cout << ::x << endl;

        return 0;
    }
    ====OUTPUT====
    30
    20
    10
    ```
## Static Variables
1. If we want to create a global variable and limited it use in a function, we will use static. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    void fun()
    {
        static int s = 10;
        s++;
        cout << s << endl;
    }

    int main()
    {
        fun();
        fun();
        fun();

        return 0;
    }
    ====OUTPUT====
    11
    12
    13
    ```
## Recursive Functions
1. Example.
    ```
    #include <iostream>

    using namespace std;

    void fun(int n)
    {
        if (n > 0)
        {
            fun(n - 1);
            cout << n << endl;
        }
    }

    int main()
    {
        fun(5);

        return 0;
    }
    ====OUTPUT====
    1
    2
    3
    4
    5
    ```
## Function Pointer
1. Function pointer can point to different functions when they have same signature.
    ```
    #include <iostream>

    using namespace std;

    int max(int x, int y)
    {
        return x > y ? x : y;
    }

    int min(int x, int y)
    {
        return x < y ? x : y;
    }

    int main()
    {
        int (*fp) (int, int);
        fp = max;
        int a = (*fp)(10, 5);
        cout << a << endl;

        fp = min;
        int b = (*fp)(10, 5);
        cout << b << endl;

        return 0;
    }
    ====OUTPUT====
    10
    5
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.