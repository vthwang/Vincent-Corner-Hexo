---
title: C++ Learning Journey Day10
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay10.jpg
toc: true
date: 2021-12-03 00:21:07
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay10.jpg">

***
# Section 19: Template Functions and Classes
## Template Functions and Classes
1. Template is used for multiple data types. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    template<class T>
    class Stack
    {
    private:
        T *stk;
        int top;
        int size;
    public:
        Stack(int sz)
        {
            size = sz;
            top = -1;
            stk = new T[size];
        }

        void push(T x);
        T pop();
    };

    template<class T>
    void Stack<T>::push(T x)
    {
        if (top == size - 1)
            cout << "Stack is Full" << endl;
        else
        {
            top++;
            stk[top] = x;
        }
    }

    template<class T>
    T Stack<T>::pop()
    {
        T x = 0;
        if (top == -1)
            cout << "Stack is Empty" << endl;
        else
        {
            x = stk[top];
            size--;
        }
        return x;
    }

    int main()
    {
        Stack<float> s(10);
        s.push(10);
        s.push(23);
        s.push(33);

        return 0;
    }
    ```
# Section 20: Constants, Preprocessor Directives and Namespaces
## Constant Qualifier
1. Constant qualifier can't be modified in the program. If you tried to modify it, you will get the error. Here is an example.
    ```
    cont int x = 10;
    // get the error
    // x++;
    ```
2. Pointer to constant integer, can't modify the x.
    ```
    int x = 10;
    const int *ptr = &x;
    // get the error
    // ++*ptr;
    ```
3. Also pointer to constant integer(same as 2), you can't modify the data, but you can point to any data.
    ```
    int x = 10;
    int const *ptr = &x;
    int y = 20;
    ptr = &y;
    ```
4. Constant pointer to integer, pointer can't be modified to point to other data.
    ```
    int x = 10;
    int *const ptr = &x;
    int y = 20;
    // get the error
    // ptr = &y;
    ++(*ptr)
    ```
5. Constant pointer to constant integer, both pointer and data can't be modified.
    ```
    int x = 10;
    const int *const ptr = &x;
    int y = 20;
    // get the error
    // ptr = &y;
    // get the error
    // ++(*ptr)
    ```
6. Constant in functions. You can add const after functions and you can't modify the data in the function.
    ```
    class Demo
    {
    public:
        int x = 10;
        int y = 20;
        void Display() const
        {
            // get the error
            // x++;
            cout << x << " " << y << endl;
        }
    };
    ```
7. Call by reference will modify the data. You can use `const` to prevent someone modify data in the function.
    ```
    #include <iostream>

    using namespace std;

    void fun(const int &x, int &y)
    {
        // get the error
        // x++;
        cout << x << " " << y;
    }

    int main()
    {
        int a = 10, b = 20;
        fun(a, b);
        
        return 0;
    }
    ```
## Preprocessor
1. Preprocessor Directives / Macros, here is an example.
    ```
    #include <iostream>

    using namespace std;

    #define PI 3.1425
    #define c cout

    int main()
    {
        cout << PI;
        c << 10;
    }
    ```
2. Preprocessor can replace contents before the compilation process start. `#` can convert the variable into string. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    #define max(x ,y) (x > y ? x : y)
    #define SQR(x) ( x * x )
    #define MSG(x) #x

    int main()
    {
        cout << max(10, 12) << endl;
        cout << SQR(5) << endl;
        cout << MSG(Hello) << endl;

        return 0;
    }
    ====OUTPUT====
    12
    25
    Hello
    ```
3. `ifndef` means if not defined.
    ```
    #define PI 3.1425
    #ifndef PI
        #define PI 3
    #endif
    ```
## Namespaces
1. You can use namespace to define the same function name without error. Also, you can use `using namespace First` to declare the default namespace. The best practice is using namespace in front of function all the time.
    ```
    #include <iostream>

    using namespace std;

    namespace First
    {
        void fun()
        {
            cout << "First" << endl;
        }
    }

    namespace Second
    {
        void fun()
        {
            cout << "Second" << endl;
        }
    }

    using namespace First;

    int main()
    {
        fun();
        Second::fun();

        return 0;
    }
    ====OUTPUT====
    First
    Second
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.