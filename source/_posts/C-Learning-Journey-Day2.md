---
title: C++ Learning Journey Day2
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay02.jpg
toc: true
date: 2021-10-01 15:25:53
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay02.jpg">

***
# Section 5: C++ Basics
## Compound Assignment
1. +=, -=, *=, /=, %=.
2. &=, |=, <<=, >>=.
3. example
    ```
    int a = 10, b = 5, c = 15;
    int sum;
    sum = sum + a + b + c;
    // simplify
    sum += a + b + c;
    
    int prod = 1;
    prod = prod * a * b * c;
    // simplify
    prod *= a * b * c;
    ```
## Increment and Decrement Operators
1. pre increment ++x;
2. post increment x++;
3. pre decrement --x;
4. post decrement x--;
5. Pre increment add value to variable first, then execute the others. Post increment execute the assignment, then add value to variable.
    - pre increment.
    ```
    int x = 5, y;

    y = ++x;
    // x = 6
    cout << x;
    // y = 6
    cout << y;
    ```
    - post increment
    ```
    int x = 5, y;

    y = x++;
    // x = 6
    cout << x;
    // y = 5
    cout << y;
    ```
6. Complicated example.
    ```
    int x = 5, y = 10, z;

    // x = 5, y = 10, z = 50
    z = x++ * y;

    // x = 6, y = 10, z = 60
    z = ++x * y;
    ```
## Overflow
1. Overflow is if a value is more than the capacity, it will take the values from the beginning. For example, `char x = 127;`, `x++;`, then the x will become -128.
## Bitwise Operators
1. & and.
2. | or.
3. ^ X-OR.
4. ~ not.
5. << shift left.
6. \>\> shift right.
7. Example.
    ```
    int x = 11, y = 7, z;

    // 00001011 & 00000111 = 00000011 (3)
    z = x & y;
    cout << z << endl;

    // 00001011 | 00000111 = 00001111 (15)
    z = x | y;

    // 00001011 ^ 00000111 = 00001100 (12)
    z = x | y;
    cout << z << endl;
    ```
8. Shift example. If x shift i left `x << i`, the result is $x*2^i$. On the contrary, if x shift i right `x >> i`, the result is $\frac{x}{2^i}$.
    ```
    char x = 20, y;

    // 00010100 -> 00101000 (40)
    y = x << 1;
    cout << int(y) << endl;

    // 00010100 -> 00001010 (10)
    y = x >> 1;
    cout << int(y) << endl;
    ```
## Enum and Typedef
1. If you have a set of words, you want to use them efficiently. You can use enum to make these words as the constant numbers. You can even assign the number to the constant. If you don't assign the number, enum will add one from the previous one to the current word. Here is the example.
    ```
    enum day {mon = 1, tue = 7, wed, thu = 10, fri, sat, sun};
    enum dept {cs = 1, it, ec, mech};

    int main()
    {
        dept  dep = cs;

        cout << dep << endl;

        cout << mon << endl;
        cout << tue << endl;
        cout << wed << endl;
        cout << thu << endl;
        cout << fri << endl;
        cout << sat << endl;
        cout << sun << endl;

        return 0;
    }
    ====OUTPUT====
    1
    1
    7
    8
    10
    11
    12
    13
    ```
2. typedef is used for making variable readable. You can define the variables by yourself. For example, you can know m1 means marks and it is int type.
    ```
    typedef int marks;

    int main()
    {
        marks m1, m2;

        m1 = 50;
        m2 = 90;

        return 0;
    }
    ```





# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.