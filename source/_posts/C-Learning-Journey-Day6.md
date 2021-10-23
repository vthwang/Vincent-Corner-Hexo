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

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.