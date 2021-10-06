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
# Section 8: Array
## Introduction
1. Array can be any type, such as int, float, char.
2. Declaration:
    ```
    int A[5] = {2, 4, 6, 8, 10};
    float B[5] = {1.1, 2.4, 3.7, 6.2, 9.5};
    char C[5] = {'A', 'B', 'C', 'D', 'E'};
    ```
3. You can initialize without assigning data, it will be 0. And you can initialize without length, it will give it a size automatically.
    ```
    int A[5] = {2, 4}; // A = {2, 4, 0, 0, 0};
    int B[] = {1, 2, 4, 6} // B = {1, 2, 4, 6};
    ```
## Array Declarations
1. Declare the array without initialization.
    ```
    int A[5];
    for (int i = 0; i < 5; i++)
        cout << A[i] << endl;
    ====OUTPUT====
    0
    0
    0
    0
    -487864256
    ```
2. If you assign more data than array length, it will have the compile error. For example, `int A[5] = {2, 4, 6, 8, 10, 12};`.
3. For each loop.
    ```
    int A[6] = {2, 4, 6, 8, 10, 12};
    for (int x : A)
        cout << x << endl;
    ```
4. You can use `auto` to specify the type automatically.
    ```
    float A[] = {2.5f, 5.6f, 9, 8, 7};
    for (auto x : A)
        cout << x << endl;
    ```
5. If you don't want to specify automatically, you can specify the type by yourself. For example, you can specify int to read char, it will show the ASCII code of char.
    ```
    char A[] = {'A', 66, 'C', 68};
    for (auto x : A)
        cout << x << endl;
    ====OUTPUT====
    A
    B
    C
    D
    ```
    ```
    char A[] = {'A', 66, 'C', 68};
    for (int x : A)
        cout << x << endl;
    ====OUTPUT====
    65
    66
    67
    68
    ```
## For Each loop
1. You can use pointer to change the original value in the array by for each loop.
    ```
    int A[] = {8, 6, 3, 9, 7, 4};
    for (auto &x : A)
        cout << ++x << endl;
    ```
## Nested Loops
1. If you want to working on matrixes, it will use nested loops. For example.
    ```
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            cout << i << j << endl;
        }
    }
    ```
## Multidimensional Array
1. Multidimensional array can initialize may ways. If you don't specify the value, it will be zero.
    ```
    int A[2][3] = { {2, 5, 9}, {6, 9, 15} };
    int A[2][3] = {2, 5, 9, 6, 9, 15};
    int A[2][3] = {2, 5}
    ```
2. print all value in the multidimensional array.
    ```
    int A[3][4] = { {2, 5, 9}, {6, 9, 15} };

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            cout << A[i][j] << " ";
        }
        cout << endl;
    }
    ```
3. Use for each to print out the multidimensional array.
    ```
    int A[2][3] = {2, 4, 6, 3, 5, 7};

    for (auto& x : A) {
        for (auto& y : x) {
            cout << y << " ";
        }
        cout << endl;
    }
    ```
4. Add two matrixes.
    ```
    int A[2][3] = { {2, 5, 9}, {7, 3, 6} };
    int B[2][3] = { {6, 3, 4}, {9, 5, 2} };
    int C[2][3];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            C[i][j] = A[i][j] + B[i][j];
        }
    }

    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            cout << C[i][j] << " ";
        }
        cout << endl;
    }
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.