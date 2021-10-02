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
# Section 5
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


# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.