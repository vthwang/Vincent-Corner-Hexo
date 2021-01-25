---
title: Java 快速學習自我挑戰 Day8
thumbnail:
  - /images/learning/java/JavaDay08.jpg
date: 2020-06-19 01:35:23
categories: Study Note
tags: Java
toc: true
---
<img src="/images/learning/java/JavaDay08.jpg">

***
### 物件導向程式設計 (OOP) - Classes, Constructors 和 Inheritance
#### Classes
1. 真實世界的物件有兩種特徵，狀態(State)和行為(Behavior)，在物件導向程式裡面，同樣也有狀態和行為。Class 則是用來創建物件的模板，前面我們使用的都是原始資料型態(Primtive Data Type)，可以用的非常有限，而使用 Class 可以自定義資料型態，雖然在真實意義上這麼說，並不是很準確，但是我們可以知道 Class 能夠有強力的用戶自定義資料型態。
2. 在 src 目錄底下點選右鍵，New > Java Class 新增 Car。
```
public class Car {

    private int doors;
    private int wheels;
    private String model;
    private String engine;
    private String color;

    public void setModel(String model) {

        String validModel = model.toLowerCase();

        if (validModel.equals("carrera") || validModel.equals("commodore")) {

            this.model = model;
        } else {

            this.model = "Unknown";
        }

    }

    public String getModel() {

        return this.model;
    }
}
```
3. 在 Main 引入 class 並使用。
```
public class Main {

    public static void main(String[] args) {

        Car porsche = new Car();
        Car holden = new Car();

        porsche.setModel("Carrera");

        System.out.println("Model is " + porsche.getModel());

    }
}
```
#### 加總計算機
1. 挑戰
Write a class with the name SimpleCalculator. The class needs two fields (instance variables) with names firstNumber and secondNumber both of type double.

Write the following methods (instance methods):
* Method named getFirstNumber without any parameters, it needs to return the value of firstNumber field.
* Method named getSecondNumber without any parameters, it needs to return the value of secondNumber field.
* Method named setFirstNumber with one parameter of type double, it needs to set the value of the firstNumber field.
* Method named setSecondNumber with one parameter of type double, it needs to set the value of the secondNumberfield.
* Method named getAdditionResult without any parameters, it needs to return the result of adding the field values of firstNumber and secondNumber.
* Method named getSubtractionResult without any parameters, it needs to return the result of subtracting the field values of secondNumber from the firstNumber.
* Method named getMultiplicationResult without any parameters, it needs to return the result of multiplying the field values of firstNumber and secondNumber.
* Method named getDivisionResult without any parameters it needs to return the result of dividing the field values of firstNumber by the secondNumber. In case the value of secondNumber is 0 then return 0.

TEST EXAMPLE
```
TEST CODE:

SimpleCalculator calculator = new SimpleCalculator();
calculator.setFirstNumber(5.0);
calculator.setSecondNumber(4);
System.out.println("add= " + calculator.getAdditionResult());
System.out.println("subtract= " + calculator.getSubtractionResult());
calculator.setFirstNumber(5.25);
calculator.setSecondNumber(0);
System.out.println("multiply= " + calculator.getMultiplicationResult());
System.out.println("divide= " + calculator.getDivisionResult());

OUTPUT

add= 9.0
subtract= 1.0
multiply= 0.0
divide= 0.0
```

TIPS:
* add= 9.0 is printed because 5.0 + 4 is 9.0
* subtract= 1.0 is printed because 5.0 - 4 is 1.0
* multiply= 0.0 is printed because 5.25 * 0 is 0.0
* divide= 0.0 is printed because secondNumber is set to 0

NOTE: All methods should be defined as public NOT public static.
NOTE: In total, you have to write 8 methods.
NOTE: Do not add the main method to the solution code.
2. 答案
```
public class SimpleCalculator {
    private double firstNumber;
    private double secondNumber;

    public double getFirstNumber() {

        return this.firstNumber;
    }

    public double getSecondNumber() {

        return this.secondNumber;
    }

    public void setFirstNumber(double firstNumber) {

        this.firstNumber = firstNumber;
    }

    public void setSecondNumber(double secondNumber) {

        this.secondNumber = secondNumber;
    }

    public double getAdditionResult() {

        return this.firstNumber + this.secondNumber;
    }

    public double getSubtractionResult() {

        return this.firstNumber - this.secondNumber;
    }

    public double getMultiplicationResult() {

        return this.firstNumber * this.secondNumber;
    }

    public double getDivisionResult() {

        if (this.secondNumber == 0) {

            return 0;
        }

        return this.firstNumber / this.secondNumber;
    }
}
```
#### Person
1. 挑戰
Write a class with the name Person. The class needs three fields (instance variables) with the names firstName, lastName of type String and age of type int. 

Write the following methods (instance methods):
* Method named getFirstName without any parameters, it needs to return the value of the firstName field.
* Method named getLastName without any parameters, it needs to return the value of the lastName field.
* Method named getAge without any parameters, it needs to return the value of the age field.
* Method named setFirstName with one parameter of type String, it needs to set the value of the firstName field.
* Method named setLastName with one parameter of type String, it needs to set the value of the lastName field.
* Method named setAge with one parameter of type int, it needs to set the value of the age field. If the parameter is less than 0 or greater than 100, it needs to set the age field value to 0.
* Method named isTeen without any parameters, it needs to return true if the value of the age field is greater than 12 and less than 20, otherwise, return false.
* Method named getFullName without any parameters, it needs to return the full name of the person.
    * In case both firstName and lastName fields are empty, Strings return an empty String.
    * In case lastName is an empty String, return firstName.
    * In case firstName is an empty String, return lastName.
    
To check if s String is empty, use the method isEmpty from the String class. For example, firstName.isEmpty() returns true if the String is empty or in other words, when the String does not contain any characters.

TEST EXAMPLE
```
TEST CODE:

Person person = new Person();
person.setFirstName("");   // firstName is set to empty string
person.setLastName("");    // lastName is set to empty string
person.setAge(10);
System.out.println("fullName= " + person.getFullName());
System.out.println("teen= " + person.isTeen());
person.setFirstName("John");    // firstName is set to John
person.setAge(18);
System.out.println("fullName= " + person.getFullName());
System.out.println("teen= " + person.isTeen());
person.setLastName("Smith");    // lastName is set to Smith
System.out.println("fullName= " + person.getFullName());

OUTPUT

fullName=
teen= false
fullName= John
teen= true
fullName= John Smith
```

NOTE: All methods should be defined as public NOT public static.
NOTE: In total, you have to write 8 methods.
NOTE: Do not add the main method to the solution code.
2. 答案
```
public class Person {
    private String firstName;
    private String lastName;
    private int age;

    public String getFirstName() {

        return this.firstName;
    }

    public String getLastName() {

        return this.lastName;
    }

    public int getAge() {

        return this.age;
    }

    public void setFirstName(String firstName) {

        this.firstName = firstName;
    }

    public void setLastName(String lastName) {

        this.lastName = lastName;
    }

    public void setAge(int age) {

        if (age < 0 || age > 100) {

            this.age = 0;
        } else {

            this.age = age;
        }
    }

    public boolean isTeen() {

        return this.age > 12 && this.age < 20;
    }

    public String getFullName() {

        if (this.firstName.isEmpty() && this.lastName.isEmpty()) {

            return "";
        } else if (this.lastName.isEmpty()) {

            return this.firstName;
        } else if (this.firstName.isEmpty()) {

            return this.lastName;
        } else {

            return this.firstName + " " + this.lastName;
        }
    }
}
```
#### Constructors
1. 挑戰
Create a new class for a bank account.
Create fields for the account number, balance, customer name, email and phone number.

Create getters and setters for each field
Create two additional methods
    1. To allow the customer to deposit funds (this should increment the balance field).
    2. To allow the customer to withdraw funds. This should deduct from the balance field, but not allow the withdrawal to complete if their are insufficient funds.
You will want to create various code in the Main class (the one created bu IntelliJ) to confirm your code is working.
Add some System.out.println's in the two methods above as well.
2. 答案
- 新增一個 Account 的 Java Class，然後新增變數
```
public class Account {

    private String number;
    private double balance;
    private String customerName;
    private String customerEmailAddress;
    private String customerPhoneNumber;
}
```
- 然後使用 IntelliJ 自動生成 getter 和 setter，點選選單 Code > Generate > 選擇所有變數，就會自動產生 getter 和 setter，最後再將 deposit 和 withdrawal 的功能加上去就完成了
```
public class Account {

    private String number;
    private double balance;
    private String customerName;
    private String customerEmailAddress;
    private String customerPhoneNumber;

    public void deposit(double depositAmount) {

        this.balance += depositAmount;
        System.out.println("Deposit of " + depositAmount + " made. New balance is " + this.balance);
    }

    public void withdrawal(double withdrawalAmount) {

        if (this.balance - withdrawalAmount < 0) {

            System.out.println("Only " + this.balance + " available. Withdrawal not processed.");
        } else {

            this.balance -= withdrawalAmount;
            System.out.println("Withdrawal of " + withdrawalAmount + " processed. Remaining = " + this.balance);
        }
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmailAddress() {
        return customerEmailAddress;
    }

    public void setCustomerEmailAddress(String customerEmailAddress) {
        this.customerEmailAddress = customerEmailAddress;
    }

    public String getCustomerPhoneNumber() {
        return customerPhoneNumber;
    }

    public void setCustomerPhoneNumber(String customerPhoneNumber) {
        this.customerPhoneNumber = customerPhoneNumber;
    }
}
```
- 在 Main Java Class 進行測試
```
public class Main {

    public static void main(String[] args) {

        Account bobsAccount = new Account();
        bobsAccount.withdrawal(100.0);

        bobsAccount.deposit(50.0);
        bobsAccount.withdrawal(100.0);
        bobsAccount.deposit(51.0);
        bobsAccount.withdrawal(100.0);
    }
}
```
3. 在上面，我們並沒有定義預設值，我們可以在 Class 裡面使用 Constructor 定義預設值。
```
public Account(String number, double balance, String customerName, String customerEmailAddress, String customerPhoneNumber) {

    System.out.println("Account with constructor parameters called.");
    this.number = number;
    this.balance = balance;
    this.customerName = customerName;
    this.customerEmailAddress = customerEmailAddress;
    this.customerPhoneNumber = customerPhoneNumber;
}
```
4. 定義完成之後，我們可以在 Main 的地方，在創建物件的時候就呼叫 Constructor。
```
Account bobsAccount = new Account("12345", 0.00, "Bob Brown", "myemail@bob.com", "(087) 123-4567");
```
5. Constructor 可以 overloaded，可以在空的 Constructor 裡面呼叫別的 Constructor。然後這個 this 的呼叫動作一定要在第一行，否則無法執行。
```
public Account() {

      // 一定要在第一行
      this("56789", 2.50, "Default name", "Default address", "Default phone");
      System.out.println("Empty constructor called");
  }
```
6. 千萬不要在 Constructor 裡面呼叫 setter，因為這樣可以確保值是被初始化的。
7. 假設我們需要設定一個 Constructor，有兩個預設值，其他的要根據傳入的值去設定，我們會選擇重複使用主要的 Constructor。
```
public Account(String customerName, String customerEmailAddress, String customerPhoneNumber) {

    this("9999", 100.55, customerName, customerEmailAddress, customerPhoneNumber);
}
```
8. 挑戰
Create a new class VipCustomer.
It should have 3 fields name, credit limit, and email address.
Create 3 constructors.
1st constructor empty should call the constructor with 3 parameters with default values.
2nd constructor should pass on the 2 values it receives and add a default value for the 3rd.
3rd constructor should save all fields.
Create getters only for this using code generation of Intellij as setters won't be needed test and confirm it works.
9. 答案
- 新增一個 VipCustomer 的 Class
```
public class VipCustomer {

    private String name;
    private double creditLimit;
    private String emailAddress;

    public VipCustomer() {

        this("Default Name", 300.0, "default@email.com");
    }

    public VipCustomer(String name, double creditLimit) {

        this(name, creditLimit, "unknown@email.com");
    }

    public VipCustomer(String name, double creditLimit, String emailAddress) {

        this.name = name;
        this.creditLimit = creditLimit;
        this.emailAddress = emailAddress;
    }

    public String getName() {

        return name;
    }

    public double getCreditLimit() {

        return creditLimit;
    }

    public String getEmailAddress() {

        return emailAddress;
    }
}
```
- 在 Main 確定是否確實執行 Constructor
```
VipCustomer person1 = new VipCustomer();
System.out.println(person1.getName());

VipCustomer person2 = new VipCustomer("Bob", 2500.0);
System.out.println(person2.getName());

VipCustomer person3 = new VipCustomer("Tim", 100.0, "tim@email.com");
System.out.println(person3.getName());
System.out.println(person3.getEmailAddress());

===== OUTPUT =====
Default Name
Bob
Tim
tim@email.com
```
#### 挑戰
##### 牆壁面積
1. 題目
Write a class with the name Wall. The class needs two fields (instance variables) with name width and height of type double.

The class needs to have two constructors. The first constructor does not have any parameters (no-arg constructor). The second constructor has parameters width and height of type double and it needs to initialize the fields. In case the width is less than 0 it needs to set the width field value to 0, in case the height parameter is less than 0 it needs to set the height field value to 0.

Write the following methods (instance methods):
* Method named getWidth without any parameters, it needs to return the value of width field.
* Method named getHeight without any parameters, it needs to return the value of height field.
* Method named setWidth with one parameter of type double, it needs to set the value of the width field. If the parameter is less than 0 it needs to set the width field value to 0.
* Method named setHeight with one parameter of type double, it needs to set the value of the height field. If the parameter is less than 0 it needs to set the height field value to 0.
* Method named getArea without any parameters, it needs to return the area of the wall.

TEST EXAMPLE

```
→ TEST CODE:

1 Wall wall = new Wall(5,4);
2 System.out.println("area= " + wall.getArea());
3 
4 wall.setHeight(-1.5);
5 System.out.println("width= " + wall.getWidth());
6 System.out.println("height= " + wall.getHeight());
7 System.out.println("area= " + wall.getArea());

→ OUTPUT:

area= 20.0
width= 5.0
height= 0.0
area= 0.0
```

NOTE: All methods should be defined as public NOT public static.
NOTE: In total, you have to write 5 methods and 2 constructors.
NOTE: Do not add a main method to the solution code.
2. 答案
```
public class Wall {
    
    private double width;
    private double height;

    public Wall() {

        this(0.0, 0.0);
    }

    public Wall(double width, double height) {

        if (width < 0) {

            this.width = 0;
        } else {

            this.width = width;
        }

        if (height < 0) {

            this.height = 0;
        } else {

            this.height = height;
        }
    }

    public double getWidth() {

        return width;
    }

    public double getHeight() {

        return height;
    }

    public void setWidth(double width) {

        if (width < 0) {

            this.width = 0;
        } else {

            this.width = width;
        }
    }

    public void setHeight(double height) {

        if (height < 0) {

            this.height = 0;
        } else {

            this.height = height;
        }
    }

    public double getArea() {

        return this.width * this.height;
    }
}
```
##### 點
1. 題目
You have to represent a point in 2D space. Write a class with the name Point. The class needs two fields (instance variables) with name x and y of type int.

The class needs to have two constructors. The first constructor does not have any parameters (no-arg constructor). The second constructor has parameters x and y of type int and it needs to initialize the fields.

Write the following methods (instance methods):
* Method named getX without any parameters, it needs to return the value of x field.
* Method named getY without any parameters, it needs to return the value of y field.
* Method named setX with one parameter of type int, it needs to set the value of the x field.
* Method named setY with one parameter of type int, it needs to set the value of the y field.
* Method named distance without any parameters, it needs to return the distance between this Point and Point 0,0 as double.
* Method named distance with two parameters x, y both of type int, it needs to return the distance between this Point and Point x,y as double.
* Method named distance with parameter another of type Point, it needs to return the distance between this Point and another Point as double.

How to find the distance between two points?To find a distance between points A(xA,yA) and B(xB,yB), we use the formula:
d(A,B)=√ (xB − xA) * (xB - xA) + (yB − yA) * (yB - yA)
Where √ represents square root.

TEST EXAMPLE
```
→ TEST CODE:

Point first = new Point(6, 5);
Point second = new Point(3, 1);
System.out.println("distance(0,0)= " + first.distance());
System.out.println("distance(second)= " + first.distance(second));
System.out.println("distance(2,2)= " + first.distance(2, 2));
Point point = new Point();
System.out.println("distance()= " + point.distance());

OUTPUT

distance(0,0)= 7.810249675906654
distance(second)= 5.0
distance(2,2)= 5.0
distance()= 0.0
```

NOTE: Use Math.sqrt to calculate the square root √.
NOTE: Try to avoid duplicated code.
NOTE: All methods should be defined as public NOT public static.
NOTE: In total, you have to write 7 methods.
NOTE: Do not add a main method to the solution code.
2. 答案
```
public class Point {
    private int x;
    private int y;

    public Point() {

        this(0, 0);
    }

    public Point(int x, int y) {

        this.x = x;
        this.y = y;
    }

    public int getX() {

        return x;
    }

    public int getY() {

        return y;
    }

    public void setX(int x) {

        this.x = x;
    }

    public void setY(int y) {

        this.y = y;
    }

    public double distance() {

        return distance(0, 0);
    }

    public double distance(int xB, int yB) {

        return Math.sqrt((double) ((xB - this.x) * (xB - this.x) + (yB - this.y) * (yB - this.y)));
    }

    public double distance(Point z) {

        return distance(z.x, z.y);
    }
}
```