---
title: C++ Learning Journey Day5
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay04.jpg
toc: true
date: 2021-10-19 18:41:00
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay04.jpg">

***
# Section 10: String
## Class String
1. You need to include string library to use string. Also, you can use getline to get the string from the user input.
    ```
    #include <iostream>
    #include <string>

    using namespace std;

    int main()
    {
        string str = "Hello";

        cout << "Enter a string ";
        getline(cin, str);

        cout << str << endl;

        return 0;
    }
    ```
2. You can use `cin` to get the string directly and it won't get the line break. For example, output1 typed "Hi" and then enter to type "World", it will show two separate strings respectively. Also, output 2 types "Hello World", it will print Hello World separately. Not like char, you need to use `cin.ignore()` to ignore the line break.
    ```
    string str;
    cout << "Enter a string ";
    cin >> str;
    cout << str << endl;

    cin >> str;
    cout << str << endl;
    ====OUTPUT====
    Enter a string `Hi`
    Hi
    `World`
    World
    ====OUTPUT====
    Enter a string `Hello World`
    Hello
    World
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.