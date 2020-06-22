---
title: Java 快速學習自我挑戰 Day9
thumbnail:
  - /images/learning/java/JavaDay09.jpg
date: 2020-06-22 08:43:52
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay09.jpg">

***
### 挑戰
#### 地毯花費計算器
1. 題目

The Carpet Company has asked you to write an application that calculates the price of carpeting for rectangular rooms. To calculate the price, you multiply the area of the floor (width times length) by the price per square meter of carpet. For example, the area of the floor that is 12 meters long and 10 meters wide is 120 square meters. To cover the floor with a carpet that costs $8 per square meter would cost $960.

1. Write a class with the name Floor. The class needs two fields (instance variables) with name width and length of type double.

The class needs to have one constructor with parameters width and length of type double and it needs to initialize the fields.
In case the width parameter is less than 0 it needs to set the width field value to 0, in case the length parameter is less than 0 it needs to set the length field value to 0.

Write the following methods (instance methods):

* Method named getArea without any parameters, it needs to return the calculated area (width * length).

2. Write a class with the name Carpet. The class needs one field (instance variable) with name cost of type double.

The class needs to have one constructor with parameter cost of type double and it needs to initialize the field.

In case the cost parameter is less than 0 it needs to set the cost field value to 0.

Write the following methods (instance methods):

* Method named getCost without any parameters, it needs to return the value of cost field

3. Write a class with the name Calculator. The class needs two fields (instance variables) with name floor of type Floor and carpet of type Carpet.

The class needs to have one constructor with parameters floor of type Floor and carpet of type Carpet and it needs to initialize the fields.

Write the following methods (instance methods):

* Method named getTotalCost without any parameters, it needs to return the calculated total cost to cover the floor with a carpet.

TEST EXAMPLE

```
→ TEST CODE:

Carpet carpet = new Carpet(3.5);
Floor floor = new Floor(2.75, 4.0);
Calculator calculator = new Calculator(floor, carpet);
System.out.println("total= " + calculator.getTotalCost());
carpet = new Carpet(1.5);
floor = new Floor(5.4, 4.5);
calculator = new Calculator(floor, carpet);
System.out.println("total= " + calculator.getTotalCost());

→ OUTPUT

total= 38.5
total= 36.45
```

NOTE: All methods should be defined as public NOT public static.
NOTE: In total, you have to write 3 classes.
NOTE: Do not add a main method to the solution code.
2. 答案
Floor.java
```
public class Floor {
    
    private double width;
    private double length;

    public Floor(double width, double length) {

        if (width < 0) {

            this.width = 0;
        } else {

            this.width = width;
        }

        if (length < 0) {

            this.length = 0;
        } else {

            this.length = length;
        }
    }

    public double getArea() {

        return this.width * this.length;
    }
}
```
Carpet.java
```
public class Carpet {
    
    private double cost;

    public Carpet(double cost) {

        if (cost < 0) {

            this.cost = 0;
        } else {

            this.cost = cost;
        }
    }

    public double getCost() {

        return this.cost;
    }
}
```
Calculator.java
```
public class Calculator {
    
    private Floor floor;
    private Carpet carpet;

    public Calculator(Floor floor, Carpet carpet) {

        this.floor = floor;
        this.carpet = carpet;
    }

    public double getTotalCost() {

        return floor.getArea() * carpet.getCost();
    }
}
```
#### 複數操作 (Complex Operation)
1. 題目
A complex number is a number that can be expressed in the form a + bi, where a and b are real numbers, and i is a solution of the equation x2 = −1. Because no real number satisfies this equation, i is called an imaginary number. For the complex number a + bi, a is called the real part, and b is called the imaginary part. To add or subtract two complex numbers, just add or subtract the corresponding real and imaginary parts. For instance, the sum of 5 + 3i and 4 + 2i is 9 + 5i. For another, the sum of 3 + i and –1 + 2i is 2 + 3i.

Write a class with the name ComplexNumber. The class needs two fields (instance variables) with name real and imaginary of type double. It represents the Complex Number.

The class needs to have one constructor. The constructor has parameters real and imaginary of type double and it needs to initialize the fields.

Write the following methods (instance methods):

* Method named getReal without any parameters, it needs to return the value of real field.
* Method named getImaginary without any parameters, it needs to return the value of imaginary field.
* Method named add with two parameters real and imaginary of type double, it needs to add parameters to fields. In other words, it needs to do a complex number add operation as described above.
* Method named add with one parameter of type ComplexNumber. It needs to add the ComplexNumber parameter to the corresponding instance variables.
* Method named subtract with two parameters real and imaginary of type double, it needs to subtract parameters from fields, in other words, it needs to do a complex number subtract operation as described above.
* Method named subtract with one parameter other of type ComplexNumber. It needs to subtract the other parameter from this complex number.

TEST EXAMPLE

```
→ TEST CODE:

ComplexNumber one = new ComplexNumber(1.0, 1.0);
ComplexNumber number = new ComplexNumber(2.5, -1.5);
one.add(1,1);
System.out.println("one.real= " + one.getReal());
System.out.println("one.imaginary= " + one.getImaginary());
one.subtract(number);
System.out.println("one.real= " + one.getReal());
System.out.println("one.imaginary= " + one.getImaginary());
number.subtract(one);
System.out.println("number.real= " + number.getReal());
System.out.println("number.imaginary= " + number.getImaginary());

→ OUTPUT

one.real= 2.0
one.imaginary= 2.0
one.real= -0.5
one.imaginary= 3.5
number.real= 3.0
number.imaginary= -5.0
```

NOTE: Try to avoid duplicated code.
NOTE: All methods should be defined as public NOT public static.
NOTE: In total, you have to write 6 methods.
NOTE: Do not add a main method to the solution code.
2. 答案
```
public class ComplexNumber {
    
    private double real;
    private double imaginary;

    public ComplexNumber(double real, double imaginary) {

        this.real = real;
        this.imaginary = imaginary;
    }

    public double getReal() {

        return real;
    }

    public double getImaginary() {

        return imaginary;
    }

    public void add(double real, double imaginary) {

        this.real += real;
        this.imaginary += imaginary;
    }

    public void add(ComplexNumber complex) {

        this.real += complex.getReal();
        this.imaginary += complex.getImaginary();
    }

    public void subtract(double real, double imaginary) {

        this.real -= real;
        this.imaginary -= imaginary;
    }

    public void subtract(ComplexNumber complex) {

        this.real -= complex.getReal();
        this.imaginary -= complex.getImaginary();
    }
}
```
#### 繼承(Inheritance)
1. 繼承會用動物的概念來去解釋，比方說要寫一個動物的 Class，動物會有共同的東西，比方大腦，身體，腿，眼睛，但是蛇沒有腿，有些蜘蛛也沒有眼睛，所以有些東西會是共用的，共用的部分，可以使用繼承的方式來實現。首先，新增一個 Animal 的 Class。
```
public class Animal {

    private String name;
    private int brain;
    private int body;
    private int size;
    private int weight;

    public Animal(String name, int brain, int body, int size, int weight) {

        this.name = name;
        this.brain = brain;
        this.body = body;
        this.size = size;
        this.weight = weight;
    }

    public void eat() {

        System.out.println("Animal.eat() called");
    }

    public void move() {

    }

    public String getName() {

        return name;
    }

    public int getBrain() {

        return brain;
    }

    public int getBody() {

        return body;
    }

    public int getSize() {

        return size;
    }

    public int getWeight() {

        return weight;
    }
}
```
2. 再新增一個 Dog 的 Class，並使用 extends 去繼承，我們可以在繼承的 Class 新增一些新的類別，比方說，牙齒、尾巴等等，使用 super() 語法繼承上面一層的 Class，如果想覆寫(Overiding)方法，可以使用 @Override。
```
public class Dog extends Animal {

    private int eyes;
    private int legs;
    private int tail;
    private int teeth;
    private String coat;

    public Dog(String name, int size, int weight, int eyes, int legs, int tail, int teeth, String coat) {

        super(name, 1, 1, size, weight);
        this.eyes = eyes;
        this.legs = legs;
        this.tail = tail;
        this.teeth = teeth;
        this.coat = coat;
    }

    private void chew() {

        System.out.println("Dog.chew() called");
    }

    @Override
    public void eat() {

        System.out.println("Dog.eat() called");
        chew();
        super.eat();
    }
}
```






