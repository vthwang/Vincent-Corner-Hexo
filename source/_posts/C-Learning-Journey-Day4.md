---
title: C++ Learning Journey Day4
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay04.jpg
toc: true
date: 2021-10-10 19:22:24
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay04.jpg">

***
# Section 9: Pointers
## Introduction
1. Two types of variables.
    - data variable. For example, `int x = 10;`.
    - address variable. For example, `int *p; p = &x;`
2. Example
    ```
    // x, value 10, address 200/201
    // p, value 10, address 300/301
    cout << x; // 10
    cout << &x; // 200
    cout << p; // 200
    cout &p; // 300
    cout << *p. // 10
    ```
3. Three things about pointer.
    - declaration `int *p;`.
    - initialization `p = &x;`.
    - dereferencing `cout << *p;`.
## Why pointers?
1. You can only access a file by pointer. Also, access network connection can only be done by pointer. The keyboard, monitor and printer are all needed it.
2. Java and most of programming languages without pointer can't access the hardware directly. For example, Java need to use JVM to access hardwares using C runtime.
## Heap Memory Allocation
1. When you initiate `int *p`, p will created in the stack of memory. Then, if you new array, the array will created in the heap of memory and p will point to the array in the heap.
    ```
    int A[5] = {1, 2, 3, 4, 5};
    int *p;
    p = new int[5];
    ```
2. When you want to delete a pointer variable p, you should not use `p = NULL;`. The p won't be deleted, p just point to null. You should use `delete []p;`. If you really want to make p point to nothing, you should use `p = nullptr;`.
3. You can access general array by using `A[2]`, you can also access pointer array by using `p[2]`. It's the benefit.
## Pointer Arithmetic
1. `p++;`, ++ means move to next location instead of add one. For example, if the pointer is float, it will move 4 bytes.
2. `p--;`, -- means move backward.
3. `p = p + 2;`, it will move forward by two elements.
4. `p = p - 2;`, it can move backward.
5. `d = q - p`, it can know the distance between two elements. For example, `p = 200`, `q = 206`, and the type of p and q is int. The d will be 3, because it will divide 6 by 2 bytes and you know the distance between the q and p is 3 elements. On the contrary, if you do `p - q`, it will get the -3. You can know q is farther than p.
6. Print values by many ways.
    ```
    int A[5]{2, 4, 6, 8, 10};
    int *p = A;

    for (int i = 0; i < 5; i++) {
        // cout << A[i] << endl;
        // cout << i[A] << endl;
        // cout << *(A + i) << endl;
        // cout << A + i << endl; // print the address
        // cout << p + i << endl; // print the address
        // cout << *(p + i) << endl;
        // cout << p[i] << endl;
        cout << *p << endl;
        p++;
    }
    ```
7. Print distance example.
    ```
    int A[5]{2, 4, 6, 8, 10};
    int *p = A, *q = &A[4];

    cout << p - q;
    ====OUTPUT====
    -4
    ```
## Problems using Pointers
1. Uninitialized pointer.
    - There are three ways to initialize the pointer.
    ```
    int x = 10;
    int *p;
    1) p = &x;
    2) p = (int *) 0x5638;
    3) p = new int[5];
    // Runtime error - Using uninitialized pointer
    cout << *p;
    ```
2. Memory leak.
    - If you don't want to use p anymore, and you don't delete the p by using `delete []p`. It will cause memory leak.
    ```
    int *p = new int[5];
    .
    .
    .
    p = NULL;
    ```
3. Dangling pointer
    ```
    void main() {
      int *p = new int[5];
      .
      .
      .
      fun(P);
      // cause the error, since p is deleted in the function.
      cout << *p;
    }

    void func(int *q) {
      .
      .
      .
      delete []q;
    }
    ```
## Reference
1. Reference doesn't consume any memory at all.
    ```
    main() {
      int x = 10;
      int &y = x; // reference, x is l-value of x
      // Error: cannot initialize without value.
      // int &y;

      x++;
      y++;
      cout << x; // 12
      cout << y; // 12

      int a;
      a = x; // x is r-value and the data of x.
      x = 25; // x is l-value and the address of x.
      // Error: y can't be referencing any other variable at all.
      // &y = a;
    }
    ```
2. Reference Example.
    ```
    int x = 10;
    int &y = x;
    
    cout << x << endl;
    y++;
    x++;
    cout << x << endl;
    cout << &x << " " << &y << endl;
    ====OUTPUT====
    10
    12
    0x7ffee33ae828 0x7ffee33ae828
    ```
# Section 10: String
## Introduction
1. There are two ways to represent the String.
    - Using char Array
    - class string
2. Declaring and Initializing String
    - `char x = 'A';`
    - `char S[10] = "Hello";`
    - `char S[] = {'H', 'e', 'l', 'l', 'o', '\0'};`
    - `char S[] = {65, 66, 67, 68, '\n'};`
    - `char * S = "Hello";`
3. If you put the letters after `\0`, those letters won't show.
    ```
    char H[] = {'H', 'e', 'l', 'l', 'o', '\0', 'p', 'p', 'p'};
    cout << H << endl;
    char S[] = {65, 66, 67, 68, 69, 0, 70, 71};
    cout << S << endl;
    ====OUTPUT====
    Hello
    ABCDE
    ```
## Reading and Writing String
1. You can use `cin.get()` and `cin.getline()` to write a string.
2. If you try to get two string using `cin.getline()`, remember to use `cin.ignore()` to avoid the second cin get extra content from the first cin.
    ```
    char s[100];
    char s2[100];

    cout << "Enter your Name ";
    cin.get(s, 100);

    cout << "Welcome " << s << endl;

    cin.ignore();

    cout << "Enter your Name Again ";
    cin.get(s2, 100);

    cout << "Welcome " << s2 << endl;
    ```
## String Functions - Length, Concatenate and Copy
1. `strlen(str1);` to get the length of string.
    ```
    #include <iostream>
    #include <cstring>

    using namespace std;

    int main()
    {
        char *s;

        cout << "Enter a String ";
        cin.getline(s, 100);

        cout << "Length " << strlen(s) << endl;

        return 0;
    }
    ====OUTPUT====
    Enter a String Hello World
    Length 11
    ```
2. `strcat(destination, source);` concatenates two words.
    ```
    char S1[20] = "Good";
    char S2[10] = "Mourning";

    strcat(S1, S2);

    cout << S1 << endl;
    ====OUTPUT====
    GoodMourning
    ```
3. `strncat(destination, source, length);` concatenates two words with certain length.
    ```
    char S1[20] = "Good";
    char S2[10] = "Mourning";

    strncat(S1, S2, 3);

    cout << S1 << endl;
    ====OUTPUT====
    GoodMou
    ```
4. `strcpy(destination, source);` copies source string to destination string.
    ```
    char S1[20] = "Good";
    char S2[10] = "";

    strcpy(S2, S1);

    cout << S2 << endl;
    ====OUTPUT====
    Good
    ```
5. `strncpy(destination, source, length);` copies source string to destination string with certain length.
    ```
    char S1[20] = "Good";
    char S2[10] = "";

    strncpy(S2, S1, 2);

    cout << S2 << endl;
    ====OUTPUT====
    Go
    ```
## String Function - Substring and Compare
1. `strstr(main, sub);` can substring with certain string, it returns the string from sub to the rest of main string.
    ```
    char S1[20] = "Programming";
    char S2[10] = "gram";

    cout << strstr(S1, S2) << endl;
    ====OUTPUT====
    gramming
    ```
2. If you use `strstr` in the sub string which is not in the main string, it returns null.
    ```
    char S1[20] = "Programming";
    char S2[10] = "k";

    if (strstr(S1, S2) != NULL)
        cout << strstr(S1, S2) << endl;
    else
        cout << "Not Found" << endl;
    ====OUTPUT====
    Not Found
    ```
3. The function of `strchr(main, char);` is as same as `strstr`, the only difference is the second parameter is char type.
4. `strrchr(main, char);` can return the string count from the right hand side.
    ```
    char S1[20] = "Programming";

    cout << strchr(S1, 'g') << endl;
    cout << strrchr(S1, 'g') << endl;
    ====OUTPUT====
    gramming
    g
    ```
5. `strcmp(str1, str2)` will return 0 when the two strings are the same. It will return positive number if str1 is greater than str2, and vice versa.
    ```
    char s1[20] = "minor";
    char s2[20] = "elder";

    cout << strcmp(s1, s2) << endl;
    ====OUTPUT====
    8
    ```
## String Functions - Tokenizer and To Integer
1. `strtol(str1, NULL, base)` means string to long. `strtof(str1, NULL)` means string to float.
    ```
    char s1[10] = "235";
    char s2[10] = "54.78";

    long int x = strtol(s1, NULL, 10);
    float y= strtof(s2, NULL);

    cout << x + 10 << endl << y - 5 << endl;
    ====OUTPUT====
    245
    49.78
    ```
2. `strtok(str1, "=;")` tokenize a string base on the symbols.
    ```
    char s1[20] = "x=10;y=20;z=35";

    char *token = strtok(s1, "=;");

    while (token != NULL)
    {
        cout << token << endl;
        token = strtok(NULL, "=;");
    }
    ====OUTPUT====
    x
    10
    y
    20
    z
    35
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.