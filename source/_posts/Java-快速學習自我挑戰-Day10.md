---
title: Java 快速學習自我挑戰 Day10
thumbnail:
  - /images/learning/java/JavaDay10.jpg
toc: true
date: 2021-01-22 21:55:25
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay10.jpg">

***
### 物件導向程式設計 (OOP) - Classes, Constructors 和 Inheritance
#### 繼承(Inheritance) 挑戰
1. Class 會自動從 Object Class 繼承，所以下面的程式碼是本來應該有的樣子，為了簡便，所以省略了 extends Object
```
public class Main extends Object {

    public static void main(String[] args) {
	     
    }
}
```
2. 挑戰
Start with a base class of a Vehicle, then create a Car class that inherits from this base class.
Finally, crate another class, a specific type of Car that inherits from the Car class.
You should be able to hand steering, changing gears, and moving (speed in other words).
You will want to decide where to put the appropriate state and behaviours (fields and methods).
As mentioned above, changing gears, increasing/decreasing speed should be included.
For you specific type of vehicle you will want to add something specific for that type of car.
3. 新增 Vehicle.java
```
public class Vehicle {

    private String name;
    private String size;

    private int currentVelocity;
    private int currentDirection;

    public Vehicle(String name, String size) {
        this.name = name;
        this.size = size;

        this.currentVelocity = 0;
        this.currentDirection = 0;
    }

    public void steer(int direction) {
        this.currentDirection += direction;
        System.out.println("Vehicle.steer(): Steering at " + currentDirection + " degrees.");
    }

    public void move(int velocity, int direction) {
        currentVelocity = velocity;
        currentDirection = direction;
        System.out.println("Vehicle.move(): Moving at " + currentVelocity + " in direction " + currentDirection);
    }

    public String getName() {
        return name;
    }

    public String getSize() {
        return size;
    }

    public int getCurrentVelocity() {
        return currentVelocity;
    }

    public int getCurrentDirection() {
        return currentDirection;
    }

    public void stop() {
        this.currentVelocity = 0;
    }
}
```
4. 新增 Car.java
```
public class Car extends Vehicle {

    private int wheels;
    private int doors;
    private int gears;
    private boolean isManual;

    private int currentGear;

    public Car(String name, String size, int wheels, int doors, int gears, boolean isManual) {
        super(name, size);
        this.wheels = wheels;
        this.doors = doors;
        this.gears = gears;
        this.isManual = isManual;
        this.currentGear = 1;
    }

    public void changeGear(int currentGear) {
        this.currentGear = currentGear;
        System.out.println("Car.setCurrentGear(): Change to " + this.currentGear + " gear.");
    }

    public void changeVelocity(int speed, int direction) {
        move(speed, direction);
        System.out.println("Car.changeVelocity(): Velocity " + speed + " direction " + direction);
    }
}
```
5. 新增 Outlander.java
```
public class Outlander extends Car {

    private int roadServiceMonths;

    public Outlander(int roadServiceMonths) {
        super("Outlander", "4WD", 5, 5, 6, false);
        this.roadServiceMonths = roadServiceMonths;
    }

    public void accelerate(int rate) {

        int newVelocity = getCurrentVelocity() + rate;
        if (newVelocity == 0) {
            stop();
            changeGear(1);
        } else if (newVelocity > 0 && newVelocity <= 10) {
            changeGear(1);
        } else if (newVelocity > 10 && newVelocity <= 20) {
            changeGear(2);
        } else if (newVelocity > 20 && newVelocity <= 30) {
            changeGear(3);
        } else {
            changeGear(4);
        }

        if (newVelocity > 0) {
            changeVelocity(newVelocity, getCurrentDirection());
        }
    }
}
```
6. 修改 Main.java
```
public class Main {

    public static void main(String[] args) {

        Outlander outlander = new Outlander(36);
        outlander.steer(45);
        outlander.accelerate(30);
        outlander.accelerate(20);
        outlander.accelerate(-42);
    }
}
```
#### 練習：圓柱體
1. 題目
    1. Write a class with the name Circle. The class needs one field (instance variable) with name radius of type double.
    The class needs to have one constructor with parameter radius of type double and it needs to initialize the fields.
    In case the radius parameter is less than 0 it needs to set the radius field value to 0.
    Write the following methods (instance methods):
        * Method named getRadius without any parameters, it needs to return the value of radius field.
        * Method named getArea without any parameters, it needs to return the calculated area (radius * radius * PI). For PI use Math.PI constant.
    2. Write a class with the name Cylinder that extends Circle class. The class needs one field (instance variable) with name height of type double.
    The class needs to have one constructor with two parameters radius and height both of type double. It needs to call parent constructor and initialize a height field.
    In case the height parameter is less than 0 it needs to set the height field value to 0.
    Write the following methods (instance methods):
        * Method named getHeight without any parameters, it needs to return the value of height field.
        * Method named getVolume without any parameters, it needs to return the calculated volume. To calculate volume multiply the area with height.
    
    TEST EXAMPLE
    → TEST CODE:
    ```
    Circle circle = new Circle(3.75);
    System.out.println("circle.radius= " + circle.getRadius());
    System.out.println("circle.area= " + circle.getArea());
    Cylinder cylinder = new Cylinder(5.55, 7.25);
    System.out.println("cylinder.radius= " + cylinder.getRadius());
    System.out.println("cylinder.height= " + cylinder.getHeight());
    System.out.println("cylinder.area= " + cylinder.getArea());
    System.out.println("cylinder.volume= " + cylinder.getVolume());
    ```
    → OUTPUT
    ```
    circle.radius= 3.75
    circle.area= 44.178646691106465
    cylinder.radius= 5.55
    cylinder.height= 7.25
    cylinder.area= 96.76890771219959
    cylinder.volume= 701.574580913447
    ```
    NOTE: All methods should be defined as public NOT public static.
    NOTE: In total, you have to write 2 classes.
    NOTE: Do not add a main method to the solution code.
2. 答案
    1. 新增 Circle.java
    ```
    public class Circle {
        private double radius;

        public Circle(double radius) {
            this.radius = (radius < 0) ? 0 : radius;
        }

        public double getRadius() {
            return radius;
        }

        public double getArea() {
            return radius * radius * Math.PI;
        }
    }
    ```
    2. 新增 Cylinder.java
    ```
    public class Cylinder extends Circle {
        private double height;

        public Cylinder(double radius, double height) {
            super(radius);
            this.height = (height < 0) ? 0 : height;
        }

        public double getHeight() {
            return height;
        }

        public double getVolume() {
            return getArea() * height;
        }
    }
    ```
#### 練習：游泳池面積
1. 題目
    The Swimming Company has asked you to write an application that calculates the volume of cuboid shaped pools.
    1. Write a class with the name Rectangle. The class needs two fields (instance variable) with name width and length both of type double.
    The class needs to have one constructor with parameters width and length both of type double and it needs to initialize the fields.
    In case the width parameter is less than 0 it needs to set the width field value to 0.
    In case the length parameter is less than 0 it needs to set the length field value to 0.
    Write the following methods (instance methods):
        * Method named getWidth without any parameters, it needs to return the value of width field.
        * Method named getLength without any parameters, it needs to return the value of length field.
        * Method named getArea without any parameters, it needs to return the calculated area (width * length).
    2. Write a class with the name Cuboid that extends Rectangle class. The class needs one field (instance variable) with name height of type double.
    The class needs to have one constructor with three parameters width, length, and height all of type double. It needs to call parent constructor and initialize a height field.
    In case the height parameter is less than 0 it needs to set the height field value to 0.
    Write the following methods (instance methods):
        * Method named getHeight without any parameters, it needs to return the value of height field.
        * Method named getVolume without any parameters, it needs to return the calculated volume. To calculate volume multiply the area with height.
    TEST EXAMPLE
    → TEST CODE:
    ```
    Rectangle rectangle = new Rectangle(5, 10);
    System.out.println("rectangle.width= " + rectangle.getWidth());
    System.out.println("rectangle.length= " + rectangle.getLength());
    System.out.println("rectangle.area= " + rectangle.getArea());
    Cuboid cuboid = new Cuboid(5,10,5);
    System.out.println("cuboid.width= " + cuboid.getWidth());
    System.out.println("cuboid.length= " + cuboid.getLength());
    System.out.println("cuboid.area= " + cuboid.getArea());
    System.out.println("cuboid.height= " + cuboid.getHeight());
    System.out.println("cuboid.volume= " + cuboid.getVolume());
    ```
    → OUTPUT
    ```
    rectangle.width= 5.0
    rectangle.length= 10.0
    rectangle.area= 50.0
    cuboid.width= 5.0
    cuboid.length= 10.0
    cuboid.area= 50.0
    cuboid.height= 5.0
    cuboid.volume= 250.0
    ```
    NOTE: All methods should be defined as public NOT public static.
    NOTE: In total, you have to write 2 classes.
    NOTE: Do not add a main method to the solution code.
2. 答案
    1. 新增 Rectangle.java
    ```
    public class Rectangle {
        private double width;
        private double length;

        public Rectangle(double width, double length) {
            this.width = (width < 0) ? 0 : width;
            this.length = (length < 0) ? 0 : length;
        }

        public double getWidth() {
            return width;
        }

        public double getLength() {
            return length;
        }

        public double getArea() {
            return width * length;
        }
    }
    ```
    2. 新增 Cuboid.java
    ```
    public class Cuboid extends Rectangle {
        private double height;

        public Cuboid(double width, double length, double height) {
            super(width, length);
            this.height = (height < 0) ? 0 : height;
        }

        public double getHeight() {
            return height;
        }

        public double getVolume() {
            return getArea() * height;
        }
    }
    ```
### 物件導向程式設計 (OOP) - Composition, Encapsulation 和 Polymorphism

