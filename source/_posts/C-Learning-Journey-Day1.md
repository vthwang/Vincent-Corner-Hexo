---
title: C++ Learning Journey Day1
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay01.jpg
toc: true
date: 2021-09-20 21:13:42
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay01.jpg">

***
# Section 2: Essential Fundamentals
## How computer works?
1. CPU have two parts, ALU(Arithmetic Logic Unit) and CU(Control Unit). A computer can perform arithmetic operations like +, -, *, / and logical operations like >, <, =, AND, OR, NOT. 
2. Hard Drive has program files and data files.
3. If you type data into computer, it will put into buffer, not directly use in the program; also the output has buffer, the data will put into output buffer before showing on the screen. So it's the communication point for the device and a programming running inside the memory.
## What is a program?
1. Natural Language -> Programming Language -> Machine Language.
2. When you transform Programming Language to Machine Language, you need Compiler or Interpreter.
## Low-Level v.s. High-Level Language
1. Low-Level Language is the Machine Language, it's the binary system. We can't understand it.
2. Assembly Language is easier than Machine Language, it can be learned, practiced and used for writing the program. However, it's still the Low-Level Language and it's very difficult for learning.
3. High-Level Language: C, C++, Java, Python, C#, VB, VC++....
## Compiler v.s. Interpreter
1. Both do these things.
    - Check Errors - syntax error
    - Convert into Machine Code
2. The third step: Execution. Compiler don't have the responsibility for execution, but Interpreter involved.
3. If we create the first.cpp file, you will get the first.exe file after you compile it. Then, you don't need Compiler anymore, you can execute first.exe as many time as you want.
4. The first difference between them is Interpreter won't create exe file.
5. The second difference between them is Compiler just translate it and it won't execute. However, Interpreter will translate as well as execute.
6. The third difference between them is after Compile compile the file, you can execute whenever you want. However, Interpreter need to translate every time they run. So if n times you are executing then n times translation will be done.
7. Compiling Programs are faster because they're independent as a separate program, but Interpreter Language is easy to write.
# Section 3: Program Development
## Programming paradigms/Methodologies
1. Programming Paradigm
    - Monolithic Programming: Write everything in only one file.
    - Modular / Procedural Programming: Remove the duplicated code and make function to reuse these code. One benefit is you can share the functions with other projects and other programmers. Second, team work can work, functions can be developed individually. Modular programming has data. In C language, you can group data using structure and process data in functions.
    - Object-oriented Programming: Put the data and functions related to these data together and defined as a class.
    - Aspect-oriented/Component Assembly Programming: Talk in the OOP section.
## What is an Algorithm
1. Algorithm: You can write the Pseudo-code to perform the algorithm.
2. Program: You need to follow the syntax to write the program.
3. Example: find average of list of elements.
    - Algorithm
    ```
    Algorithm Average(List, n)
    {
        sum <- o;
        for each element x in List
        Begin
            sum <- sum + x;
        End;
        avg <- sum / n;
        return avg;
    }
    ```
    - Program
    ```
    float Average(int L{}, int n)
    {
        float sum = 0.0;
        for (i = 0; i < n; i++)
        {
            sum = sum + L{i};
        }
        float avg = sum / n;
        return avg;
    }
    ```
## What is a FlowChart
1. FlowChart is used for showing the flow of control of a program.
## Steps for Program Development and Execution
1. Editing
2. Compiling
3. LKinking Library
4. Loading
5. Execution: Stack of memory is used for variable creation and code section of memory is used for program itself. Heap of memory is used for dynamic memory allocation.
# Section 4: Compiler and IDE Setup
## Practice C++ online Compiler
1. [Online compiler link](https://www.onlinegdb.com/online_c++_compiler).
2. You can use the following code to test.
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        int x, y, z;
        
        cout << "Enter 2 numbers";
        cin >> x >> y;
        z = x + y;
        cout << "Sum is " << z;

        return 0;
    }
    ```
## Setup Xcode
1. Install Xcode in the App Store.
2. New Project -> set name and start working. Left sidebar has a start button to run the code.
# Section 5
## Skeleton of C++ Program
1. iostream is a library. int is the main function return type. `cout` can print value on the screen. If you don't want to use `using namespace std;`, you need to add std in front of cout as `std::cout`.
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        cout << "Hello World";

        return 0;
    }
    ```
## Writing My First Program
1. Every program has three elements: Input, Process, Output.
2. Add two number's program.
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        int a, b, c;
        cout << "Enter 2 numbers";
        cin >> a >> b;
        c = a + b;
        cout << "Sum is " << c;
        return 0;
    }
    ```
3. Get the name and give welcome message. Use `getline` to get the whole line stead of a word.
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        string name;

        cout << "May I know your name";
        getline(cin, name);

        cout << "Hello " << name;
        
        return 0;
    }
    ```
## Why Data Types
1. Data
    - Numeric
        - Integer
        - Floating
    - Character/Alphabetic
        - String
## Primitive Data Types
1. Data Types
    - Primitive
        - Integral
            - int
            - char
        - Bool
        - Floating Point
            - float
            - double
    - UserDefined
        - enum
        - structure
        - union
        - class
    - Derived
        - Array
        - Pointer
        - Reference
2. Data Type Size
    | Data Type | Size | Range |
    | :---: | :---: | :---: |
    | int | 2 or 4 | -32768 to 32676 |
    | float | 4 | $-3.4\times10^{-38}$ to $3.4\times10^{38}$ |
    | double | 8 | $-1.7\times10^{-308}$ to $1.7\times10^{308}$ |
    | char | 1 | -128 to 127 |
    | bool | undefined | true/false |
3. Modifier
    - unsigned
        - unsigned integer, range is 0-65535
        - unsigned char, range is 0-255
    - long
        - long int, 4 bytes / 8 bytes
        - long double, 10 bytes
## Variables
1. You must declare variable before you use it.
2. If you want to declare float, better to add f after the decimal number.
3. Allowed and not-allowed variables.
    - √ int x1;
    - x int 1x;
    - √ int rollno;
    - x int roll no;
    - √ int roll_no;
    - √ int rollNo;
    - √ int RollNo;
## Arithmetic Operators and Expressions
1. Arithmetic - +, -, *, /, %
    - % gets the remainder of two numbers.
    - We can't perform % on the float number.
    - We can perform % to **char**, using ASCII code do the calculation.
2. Relational - <, <=, >, >=, ==
3. Logical - &&, ||, !
4. Bitwise - &, |, ~, ^
5. Increment/Decrement - ++, --
6. Assignment - =
## Operator Precedence & Expressions
1. Highest precedence will calculate first.
    | Operator | Assumed Precedence |
    | :---: | :---: |
    | ( ) | 3 |
    | *, /, % | 2 |
    | +, - | 1 |
## Program using Expression
1. Calculate Triangle Area.
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        float b, h, a;
        cout << "Enter base & height";
        cin >> b >> h;

        a = (b * h) / 2;
        cout << "Area is " << a;
    }
    ```
## Practice Problem: Sum of First N Natural Numbers
1. Formula: n * (n + 1) / 2
    ```
    #include <iostream>

    using namespace std;

    int main()
    {
        int n, sum;
        cout << "Enter n";
        cin >> n;
        sum = n * (n + 1) / 2;
        cout << "Sum is " << sum;
        return 0;
    }
    ```
## Practice Problem: Roots of Quadratic Equations
1. Formula: 
    - $ax^2 + bx + c = 0$
    - $r = \frac{-b\pm\sqrt{b^2-4ac}}{2a}$
2. Program
    ```
    #include <iostream>
    #include <cmath>

    using namespace std;

    int main()
    {
        float a, b, c, r1, r2;
        cout << "Enter a, b, c";
        cin >> a >> b >> c;
        r1 = (-b + sqrt( b * b - 4 * a * c)) / (2 * a);
        r2 = (-b - sqrt( b * b - 4 * a * c)) / (2 * a);
        cout << "Roots are " << r1 << " " << r2;
        return 0;
    }
    ====EXECUTE====
    4 8 4
    ====OUTPUT====
    Roots are -1 -1
    ```
## Demo - Expression
1. Find the circle area.
    ```
    #include <iostream>
    #include <cmath>

    using namespace std;

    int main()
    {
        float r, area;
        cout << "Enter Radius";
        cin >> r;
        area = 3.1425f * r * r;
        cout << "Area is " << area << endl;
        
        return 0;
    }
    ```
2. Find the speed.
    ```
    #include <iostream>
    #include <cmath>

    using namespace std;

    int main()
    {
        int u, v, a;
        float speed;
        cout << "Enter 3 numbers";
        cin >> u >> v >> a;
        speed = (v * v - u * u) / (2 * a);
        cout << "Speed is " << speed << endl;

        return 0;
    }
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.