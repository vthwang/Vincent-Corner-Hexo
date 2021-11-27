---
title: C++ Learning Journey Day8
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay08.jpg
toc: true
date: 2021-11-25 20:09:23
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay08.jpg">

***
# Section 13: Operator Overloading
## Operator Overloading
1. Operators: +, *, -, (), ++, new, delete...
2. These operators can be used for primary data types, such as int, float...
3. If we want to perform these operators to custom data types, we need to use operator overloading.
4. Example of complex number.
    ```
    #include <iostream>

    using namespace std;

    class Complex
    {
    private:
        int real;
        int img;
    public:
        Complex(int r = 0, int i = 0)
        {
            real = r;
            img = i;
        }

        Complex operator+(Complex x)
        {
            Complex temp;
            temp.real = real + x.real;
            temp.img = img + x.img;
            return temp;
        };
    };

    int main()
    {
        Complex C1(3, 7);
        Complex C2(5, 4);
        Complex C3;

        C3 = C1 + C2;

        return 0;
    }
    ```
## Friend Operator Overloading
1. Friend function can be used to Operator Overloading, when you need to use `friend` to access the private variable outside the class. Here is an example.
    ```
    class Complex
    {
    private:
        int real;
        int img;
    public:
        Complex(int r = 0, int i = 0)
        {
            real = r;
            img = i;
        }

        friend Complex operator+(Complex c1, Complex c2);
    };

    Complex operator+(Complex c1, Complex c2)
    {
        Complex t;
        t.real = c1.real + c2.real;
        t.img = c1.real + c2.img;
        return t;
    }
    ```
## Insertion Operator Overloading
1. Example
    ```
    class Complex
    {
    private:
        int real;
        int img;
    public:
        .
        .
        .
        friend ostream & operator<<(ostream &o, Complex &c1);
    };

    ostream & operator<<(ostream &o, Complex &c1)
    {
        o << c1.real << "+i" << c1.img;
        return o;
    }
    ```
# Section 14: Inheritance
## Introduction
1. The derived class can use everything in the base class. Here is an example.
    ```
    #include <iostream>

    using namespace std;

    class Base
    {
    public:
        int x;
        void show()
        {
            cout << x << endl;
        }
    };

    class Derived : public Base
    {
    public:
        int y;
        void display()
        {
            cout << x << " " << y << endl;
        }
    };


    int main()
    {
        Base b;
        b.x = 25;
        b.show(); // 25
        Derived d;
        d.x = 10;
        d.y = 15;
        d.show(); // 10
        d.display(); // 10 15

        return 0;
    }
    ====OUTPUT====
    25
    10
    10 15
    ```
## Inheritance Examples
1. Using Rectangle as the base class and extend the new class Cuboid.
    ```
    #include <iostream>

    using namespace std;

    class Rectangle
    {
    private:
        int length;
        int breadth;
    public:
        Rectangle(int r = 0, int b = 0)
        {
            length = r;
            breadth = b;
        }
        void setLength(int l)
        {
            if (l >= 0)
                length = l;
            else
                length = 0;
        }

        void setBreadth(int b)
        {
            if (b >= 0)
                breadth = b;
            else
                breadth = 0;
        }

        int getLength()
        {
            return length;
        }

        int getBreadth()
        {
            return breadth;
        }

        int area()
        {
            return length * breadth;
        }

        int perimeter()
        {
            return 2 * (length + breadth);
        }
    };

    class Cuboid : public Rectangle
    {
    private:
        int height;
    public:
        Cuboid(int l = 0, int b = 0, int h = 0)
        {
            height = h;
            setLength(l);
            setBreadth(b);
        }

        int getHeight()
        {
            return height;
        }

        void setHeight(int h)
        {
            height = h;
        }

        int volume()
        {
            return getLength() * getBreadth() * height;
        }
    };


    int main()
    {
        Cuboid c(10, 5, 3);
        cout << c.getLength() << endl;
        cout << c.volume() << endl;
        cout << c.area() << endl;

        return 0;
    }
    ====OUTPUT====
    10
    150
    50
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.



