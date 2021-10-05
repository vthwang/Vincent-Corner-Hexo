---
title: C++ Learning Journey Day3
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay03.jpg
toc: true
date: 2021-10-03 18:14:05
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay03.jpg">

***
# Section 7: Loops
## Loops - Iterative Statement
1. while
    ```
    while (<condition>) {
      process;
    }
    ```
2. do while
    ```
    do {
      process;
    } while (<condition>)
    ```
3. Print the numbers example.
    - while
    ```
    int n, i = 1;
    cout << "Enter n";
    cin >> n;
    while (i <= n) {
        cout << i << endl;
        i++;
    }
    ```
    - do while
    ```
    int n, i = 1;
    cout << "Enter n";
    cin >> n;
    do {
        cout << i << endl;
        i++;
    } while (i <= n);
    ```
## for loop
1. for
    ```
    for (initialization; condition; updation) {
      process;
    }
    ```
2. Print the numbers example
    ```
    int n, i;
    cout << "Enter n";
    cin >> n;
    for (i = 1; i <= n; i++) {
        cout << i << endl;
    }
    ```
3. for each
## Infinite loop
1. You can skip condition in the for and define the initialization and condition somewhere else.
    ```
    int i = 0;
    for (;;)
    {
        cout << i << " Hello\n";
        i++;
        if (i > 10)
            break;
    }
    ```
## Multiplication Table
1. Example.
    ```
    int n, i;
    cout << "Enter n";
    cin >> n;
    for (i = 1; i <= 10; i++) {
        cout << n << " x " << i << " = " << n * i << endl;
    }
    ```
## Find GDC of 2 numbers
1. Example.
    ```
    int m, n;
    cout << "Enter 2 numbers";
    cin >> m >> n;
    while (m != n) {
        if (m > n)
            m -= n;
        else
            n -= m;
    }
    cout << "GCD is " << m << endl;
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.