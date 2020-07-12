---
title: Java 快速學習自我挑戰 Day9
thumbnail:
  - /images/learning/java/JavaDay09.jpg
date: 2020-06-22 08:43:52
categories: Study Note
tags: Java
toc: true
---
<img src="/images/learning/java/JavaDay09.jpg">

***
### 物件導向程式設計 (OOP) - Classes, Constructors 和 Inheritance
#### 挑戰
##### 地毯花費計算器
1. 題目

The Carpet Company has asked you to write an application that calculates the price of carpeting for rectangular rooms. To calculate the price, you multiply the area of the floor (width times length) by the price per square meter of carpet. For example, the area of the floor that is 12 meters long and 10 meters wide is 120 square meters. To cover the floor with a carpet that costs <span>$</span>8 per square meter would cost $960.

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
##### 複數操作 (Complex Operation)
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
3. 新增 walk(), run()，但是用不同的方式呼叫 move，如果直接使用 move()，他會呼叫同個 Class 裡面的 move()，如果同個 Class 沒有 move()，就會去呼叫上層的 move()，而使用 super.move() 會直接呼叫上層的 move()。
```
public class Dog extends Animal {

    ...

    public void walk() {

        System.out.println("Dog.walk() called");
        super.move(5);
    }

    public void run() {

        System.out.println("Dog.run() called");
        move(10);
    }

    private void moveLegs(int speed) {
        System.out.println("Dog.moveLegs called");
    }
    @Override
    public void move(int speed) {
        System.out.println("Dog.move() called");
        moveLegs(speed);
        super.move(speed);
    }
}
```
4. 新增一個 Fish.java，再次練習繼承的概念。
```
public class Fish extends Animal{

    private int gills;
    private int eyes;
    private int fins;

    public Fish(String name, int brain, int body, int size, int weight, int gills, int eyes, int fins) {

        super(name, 1, 1, size, weight);
        this.gills = gills;
        this.eyes = eyes;
        this.fins = fins;
    }

    private void rest() {

    }

    private void moveMuscles() {

    }

    private void moveBackFin() {

    }

    private void swim(int speed) {

        moveMuscles();
        moveBackFin();
        super.move(speed);
    }
}
```
#### Reference vs Object vs Instance vs Class
1. 透過建房子來了解這些名詞的概念。
    - Class 就是藍圖，使用藍圖，我們可以根據這個計畫建立很多房子。
    - 每一個蓋的房子就是 Object，也稱為 Instance。
    - 每一棟房子都有實體地址，也就是說，你想要告訴別人你住在哪裡，你必須給他們地址(或許寫在一張紙上)，這就稱為 Reference。
    - 你可以複製 Reference 多少次都可以，但是你還是只有一棟房子，所以我們複製藍圖的時候，地址並不是現在要蓋的那一棟。
    - 我們將 References 當作 parameters 傳送到 Constructors 和 Methods。
2. 一開始創建物件，給予 blueHouse 藍色的 Reference，然後定義 anotherHouse 等於 blueHouse，這時候他們會共用一個 Object，所以當設定 anotherHouse 為黃色的時候，blueHouse 也會變成黃色，這時候再定義一個 greenHouse Reference 為 green，然後再次定義 anotherHouse 等於 greenHouse，這時候他們又會共用一個 Object，而 blueHouse 自己一個 Object，最後當 getColor() 的時候，blueHouse 就會等於黃色，而 greenHouse 和 anotherHouse 就等於綠色。
```
public class Main {

    public static void main(String[] args) {

        House blueHouse = new House("blue");
        House anotherHouse = bluehouse;

        System.out.println(blueHouse.getColor()); // blue
        System.out.println(anotherHouse.getColor()); // blue

        anotherHouse.setColor("yellow");
        System.out.println(blueHouse.getColor()); // yellow
        System.out.println(anotherHouse.getColor()); // yellow

        House greenHouse = new House("green");
        anotherHouse = greenHouse;
        
        System.out.println(blueHouse.getColor()); // yellow
        System.out.println(greenHouse.getColor()); // green
        System.out.println(anotherHouse.getColor()); //green
    }
}
```
#### this vs super
1. 關鍵字 **super** 是用來呼叫上層的 Class 成員(變數和方法)，而關鍵字 **this** 是用來呼叫同一層的 Class 成員(變數和方法)，但是當 Instance 有相同的變數名稱，this 就是必要的。
2. 注意：我們可以在 Class 裡面同時使用 this 和 super，但是 static 區域(靜態 Class 或靜態 Method)是不行的，如果想要在靜態區域做任何嘗試，都會導致編譯器錯誤。
3. 關鍵字 **this** 很常被使用在 **Constructors** 和 **Setters**，偶而也會在 Getters 裡使用(對使用者比較容易)，下面的例子中，**this** 被使用在 **Constructors** 和 **Setters**，因為有同樣的名稱所以一定要用 this，在 Getter 中，我們沒有任何相同的參數，所以關鍵字 **this** 是選擇性的。
```
Class House {

    private String color;

    public House(String color) {

        this.color = color;
    }

    public String getColor() {

        return color;
    }

    public void setColor(String color) {

        this.color = color;
    }
}
```
4. 關鍵字 **super** 很常跟 **method overriding** 一起使用，我們會使用 super 在當前 Class 呼叫上層 Class 同名的 Method，如果沒有使用 **super** 會導致 Recursive Call(遞歸呼叫)，意思就是他會無止盡的呼叫 Method，直到記憶體用盡，這就為什麼 **super** 是必要的。
5. 在 Java 中，我們有 **this()** 和 **super()** 的 Call，() 被稱為 Call，因為它很像一般的 Method Call。
6. 使用 **this()** 來呼叫一個 Constructor，這個 Constructor 是在同一個 Class 的其它 overloaded Constructor。
7. **this()** 只能被使用在 Constructor，而且它必須用在 Constructor 的第一行陳述句，而它被用來當作 Constructor chaining 的功用，當一個 Constructor 呼叫另外一個 Constructor 可以幫助減少程式碼。
8. 呼叫上層 Constructor 唯一的方式就是呼叫 super()，所以它也被稱為上層 Constructor
9. Java 編譯器會自動放一個 **super()** 作為預設的 Call，而且被編譯器插入的 super 都是沒有參數的。
10. **super()** 的 Call 一定要放在每一個 Constructor 的第一行陳述句。
11. 即使 Abstract Classes 有 Constructors，但是你不能使用新的關鍵字來實例化 Abstract Class。
12. Abstract Classes 仍然是一個 **super** Class，所以當有人建立一個 Concrete Class Instance，它的 Constructors 還是會執行的。
13. 注意：一個 Constructor 可以有 **super()** 和 **this()**，但是不能同時使用這兩個關鍵字。
14. 好的 Constructor 範例如下，第一個 Constructor 呼叫第二個，第二個 Constructor 呼叫第三個，而第三個初始化所有 Instance 變數。不管我們呼叫哪一個 Constructor，最後變數都會在第三個 Constructor 做初始化。這就是知名的 Construcor Chaining，第三個 Constructor 有責任來初始化所有變數。
```
class Rectangle {

    private int x;
    private int y;
    private int width;
    private int height;

    // 1st constructor
    public Rectangle() {

        thsi(0, 0); // calls 2nd constructor
    }

    // 2nd constructor
    public Rectangle(int width, int height) {

        this(0, 0, width, height); // calls 3rd constructor
    }

    // 3rd constructor
    public Rectangle(int x, int y, int width, int height) {

        // initialize variables
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}
```
15. 在範例中，我們有一個 Class Shape，它有 x 和 y 的變數，而 Class Rectangle 繼承 Class Shape 的變數並加上 width 和 height。在 Retangle 裡面，第一個 Constructor 呼叫第二個 Constructor，第二個 Constructor 呼叫了有變數 x 和 y 的上層 Constructor。上層的 Constructor 會初始化 x 和 y，而 Rectangle 的第二個 Constructor 會初始化 width 和 height 變數。在這邊我們同時有 **super()** 和 **this()** 的 Calls。
```
class Shape {

    private int x;
    private int y;

    public Shape(int x, int y) {

        this.x = x;
        this.y = y;
    }
}

class Rectangle extends Shape {

    private int width;
    private int height;

    // 1st constructor
    public Retangle(int x, int y) {

        this(x, y, 0, 0); // calss 2nd constructor
    }

    // 2nd constructor
    public Rectangle(int x, int y, int width, int height) {
        super(x, y); // calls constructor from parent (Shape)
        this.width = width;
        this.height = height;
    }
}
```
#### 方法過載(Method Overloading) vs 方法覆寫(Method Overriding) 回顧
1. 方法過載
    - 方法過載就是在同一個 Class 放入好幾個**相同名字**的方法，但是這些方法有**不同的變數**。
    - 這些方法回傳的值型態可以不一樣也可以一樣，這種方法可以讓我們**重複使用**相同的方法。
    - 方法過載**很好使用**，因為它減少了重複的程式碼，而且我們可以不用記住很多種方法的名稱。
    - **方法過載**跟**多態性(Polymorphism)** 無關，但是 Java 開發者常常把方法過載當作 Compile Time Polymorphism。
    - 換句話說，編譯器決定哪個方法被呼叫是根據方法名稱、回傳型態和參數列表。
    - 我們可以過載 **static** 和 **Instance** 方法。
    - 通常來說，**過載**只會發生在同一個 Class，但是在下層 Class 的同一種方法也可以被當作**過載**。
    - 這是因為**下層 Class 繼承**從上層 Class 的一個方法，並在下層 Class 使用這個方法來過載的另一個方法。
    - 如果以下兩個原則被達成，方法會被視為過載
        - 方法有兩個相同的名稱。
        - 方法有不同的變數。
    - 如果方法達到以上兩個原則，它們可能或可能不會
        - 有不同的變數回傳型態。
        - 有不同的存取修改器(Access Modifier)。
        - 回傳受檢查或未檢查過的異常(Exception)。
2. 方法覆寫
    - 方法覆寫就是有一個在下層 Class 的方法已經存在上層有相同方法(相同名稱、相同參數)的 Class。
    - 透過擴展(Extending)上層 Class，下層 Class 會取得上層 Class 所有的方法(這些方法又被稱為衍生方法(Derived Method))。
    - 方法覆寫又被稱為 **運行多態(Runtime Polymorphism)** 或**動態方法分配(Dynamic Method Dispatch)**，因為在運行時是透過 JVM 來決定哪個方法被呼叫。
    - 當我們**覆寫**方法時，會建議放 **@override** 在方法前面，這是一個註解，當編譯器看到註解發現我們沒有跟隨覆寫的規則時，就會顯示錯誤給我們。
    - 我們不能**覆寫 static**，**只能**覆寫 **Instance** 方法。
    - 如果以下原則被達成，方法會被視為覆寫
        - 它有相同名字和相同參數。
        - 下層的回傳型態要和上層回傳型態相同。
        - 它不同有較低層級的存取修改器(Access Modifier)。
        - 例如：上層方法是 protected，下層方法使用 private 是不允許的，但是使用 public 是允許的。
    - 關於方法覆寫還有一些**很重要的點**
        - **只有繼承的方法才可以被覆寫**，換句話說，方法只能在下層被覆寫。
        - **Constructors 和 private 方法不能被覆寫**。
        - 方法是 final 也不能被覆寫。
        - 下層 Class 使用 **super.methodName()** 來呼叫上層要被覆寫的方法。
3. 回顧

| **方法過載** | **方法覆寫** |
| :--- | :--- |
| 提供重新使用一個有同名字的方法。 | 用來覆寫一個從上層繼層的 Class 的行為。 |
| 通常都在同一個 Class，但是有時侯也可以在下層 Class。 | **一定要在兩個**有上層-下層或 IS-A 關係的 Classes 裡面。|
| **一定要有**不同參數。 | **一定要有**相同參數和相同名稱。 |
| 可以有不同的回傳型態。 | 一定要有相同的回傳型態或是協變(covariant)的回傳型態(下層)。 |
| 可以有不同的存取修改器(private, protected, public)。 | **一定不能**有低權限的存取修改器，但是可以較高權限的存取修改器。|
| 可以回傳不同異常。 | **一定不能**回傳一個新的或是更廣泛的受檢異常(Checked Exception)。 |
#### static vs Instance 方法
1. 靜態方法(Static Method)
    - **靜態方法** 用 **static** 修改器來表示。
    - **靜態方法**不能直接存取 Instance 方法或是 Instance 變數。
    - 它們通常被用在不需要 Instance 的任何資料(從 this 來的資料)的操作。
    - 關鍵字 this 就是當前 Class 的 Instance。
    - 在**靜態方法**，我們不能使用 **this** 關鍵字。
    - 當你看到一個方法**不需要使用 Instance 變數**，那個變數就應該被定義為**靜態方法**。
    - 例如：main 就是一個靜態方法，它在 JVM 啟動程式的時候就會被呼叫。
2. Instance 方法
    - Instance 方法屬於 Class 的 Instance。
    - 要使用 Instance 方法，我們首先必須要使用關鍵字 **new** 初始化 Class。
    - **Instance 方法**可以直接存取 Instance 方法和 Instance 變數。
    - **Instance 方法**也可以直接存取靜態方法和靜態變數。
3. 要使用 Instance 還是 static 方法？
    - 它需要任何欄位(Instance 變數)或 Instance 方法嗎？
        - Yes: 它可能是 <span style="color:red">**Instance 方法**</span>。
        - No: 它可能是 <span style="color:red">**靜態方法**</span>。
#### static vs Instance 變數
1. 靜態變數
    - 使用關鍵字 **static** 來宣告變數。
    - **靜態變數**又被稱為 **static member variables**。
    - 那個 Class 的每一個 Instance 共享相同的靜態變數。
    - 如果那個變數被改變了，所有的 Instance 都會看到那個改變。
    - **靜態變數**並不常常被使用，但是有時候非常有用。
    - 例如：我們使用 **Scanner** 讀取用戶輸入，我們可以宣告 scanner 為靜態變數。
    - 如此一來，所有的靜態方法就都可以直接讀取靜態變數。
2. 在範例中，我們第一次定義 name 為 rex，第二次定義 name 為 fluffy，最後兩次輸出都會是 fluffy，因為靜態變數一旦被改變，會全域進行改變，所以在正常的情境下，使用 Instance 會比較合理。
```
class Dog {

    private static String name;

    public Dog(String name) {

        Dog.name = name;
    }

    public void printName() {

        System.out.println("name= " + name);
    }
}

public class Main {

    public static void main(String[] args) {

        Dog rex = new Dog("rex"); // Create Instance (rex)
        Dog fluffy = new Dog("fluffy"); // Create Instance (fluffy)
        rex.printName(); // print fluffy
        fluffy.printName(); // print fluffy
    }
}
```
3. Instance 變數
    - 它們不使用關鍵字 **static**。
    - Instance 變數又被稱為 fields 或 member variables。
    - Instance 變數屬於一個 Class 的特定 Instance。
    - 每一個 Instance 都會有一個 Instance 變數的備份。
    - 每一個 Instance 都會有不同的值或狀態(state)。
    - Instance 變數代表 Instance 的 state。
4. 在範例中我們用 Instance，所以會兩次會輸出不同的結果，每個 Instance 有自己的值和狀態，
```
class Dog {

    private String name;

    public Dog(String name) {

        Dog.name = name;
    }

    public void printName() {

        System.out.println("name= " + name);
    }
}

public class Main {

    public static void main(String[] args) {

        Dog rex = new Dog("rex"); // Create Instance (rex)
        Dog fluffy = new Dog("fluffy"); // Create Instance (fluffy)
        rex.printName(); // print rex
        fluffy.printName(); // print fluffy
    }
}
```
