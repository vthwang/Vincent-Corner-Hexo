---
title: Java 快速學習自我挑戰 Day11
thumbnail:
  - /images/learning/java/JavaDay11.png
toc: true
date: 2021-01-24 11:07:31
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay11.png">

***
### 物件導向程式設計 (OOP) - Composition, Encapsulation 和 Polymorphism
#### Encapsulation
1. Encapsulation 是一個允許你對正在創建的 Objects 裡面的特定 Components 做限制存取的機制。
2. 它可以用來屏蔽其它 Class 的存取，保持內部工作正常，且可以讓你修改內容的時候避免損壞。
3. 用一個範例來了解 Encapsulation
    1. 新增 Player.java
    ```
    public class Player {

        public String name;
        public int health;
        public String weapon;

        public void loseHealth(int damage) {
            this.health = this.health - damage;
            if (this.health <= 0) {
                System.out.println("Player knocked out");
                // Reduce number of lives remaining for the player
            }
        }

        public int healthRemaining() {
            return this.health;
        }
    }
    ```
    2. 修改 Main.java
    ```
    Player player = new Player();
    player.name = "Vincent";
    player.health = 20;
    player.weapon = "Sword";

    int damage = 10;
    player.loseHealth(damage);
    System.out.println("Remaining health = " + player.healthRemaining());

    damage = 11;
    player.health = 200;
    player.loseHealth(damage);
    System.out.println("Remaining health = " + player.healthRemaining());
    ```
    3. 這時候，如果把 Player.java 裡面的 `public String name;` 改成 `public String fullName`，整個程式碼就會出錯。
    4. 新增一個 EnhancedPlayer.java
    ```
    public class EnhancedPlayer {

        private String name;
        private int health = 100;
        private String weapon;

        public EnhancedPlayer(String name, int health, String weapon) {
            this.name = name;
            if (health > 0 && health <= 100) {
                this.health = health;
            }
            this.weapon = weapon;
        }

        public void loseHealth(int damage) {
            this.health = this.health - damage;
            if (this.health <= 0) {
                System.out.println("Player knocked out");
                // Reduce number of lives remaining for the player
            }
        }

        public int getHealth() {
            return health;
        }
    }
    ```
    5. 修改 Main.java
    ```
    EnhancedPlayer player = new EnhancedPlayer("Vincent", 200, "Sword");
    System.out.println("Initial health is " + player.getHealth());
    ```
    6. 就算把 health 改成 hitPoints，運作仍然正常。
    ```
    public class EnhancedPlayer {

        private String name;
        private int hitPoints = 100;
        private String weapon;

        public EnhancedPlayer(String name, int health, String weapon) {
            this.name = name;
            if (health > 0 && health <= 100) {
                this.hitPoints = health;
            }
            this.weapon = weapon;
        }

        public void loseHealth(int damage) {
            this.hitPoints = this.hitPoints - damage;
            if (this.hitPoints <= 0) {
                System.out.println("Player knocked out");
                // Reduce number of lives remaining for the player
            }
        }

        public int getHealth() {
            return hitPoints;
        }
    }
    ```
#### Encapsulation 挑戰
1. 題目
Create a class and demonstrate proper encapsulation techniques
the class will be called Printer
It will simulate a real Computer Printer
It should have fields for the toner Level, number of pages printed, and
also whether its a duplex printer (capable of printing on both sides of the paper).
Add methods to fill up the toner (up to a maximum of 100%), another method to
simulate printing a page (which should increase the number of pages printed).
Decide on the scope, whether to use constructors, and anything lese you think is needed.
2. 答案
    1. 新增 Printer.java
    ```
    public class Printer {

        private int tonerLevel = -1;
        private int pagesPrinted = 0;
        private boolean duplex;

        public Printer(int tonerLevel, boolean duplex) {
            if (tonerLevel > -1 && tonerLevel <= 100) {
                this.tonerLevel = tonerLevel;
            }
            this.duplex = duplex;
        }

        public int addToner(int tonerAmount) {
            if (tonerAmount > 0 && tonerAmount <= 100) {
                if (tonerLevel + tonerAmount > 100) {
                    return -1;
                }
                return tonerLevel += tonerAmount;
            } else {
                return -1;
            }
        }

        public int printPages(int pages) {
            int pagesToPrint = pages;
            if (duplex) {
                System.out.println("Printing in duplex mode");
                pagesToPrint = (pages / 2) + (pages % 2);
            }
            pagesPrinted += pagesToPrint;
            return pagesToPrint;
        }

        public int getPagesPrinted() {
            return pagesPrinted;
        }
    }
    ```
    2. 修改 Main.java
    ```
    Printer printer = new Printer(50, true);
    System.out.println(printer.addToner(50));
    System.out.println("initial page count = " + printer.getPagesPrinted());
    int pagesPrinted = printer.printPages(4);
    System.out.println("Pages printed was " + pagesPrinted + " new total print count for printer = " + printer.getPagesPrinted());
    pagesPrinted = printer.printPages(2);
    System.out.println("Pages printed was " + pagesPrinted + " new total print count for printer = " + printer.getPagesPrinted());
    ```
### Polymorphism
1. 在 Main.java 新增很多 Class
```
class Movie {
    private String name;

    public Movie(String name) {
        this.name = name;
    }

    public String plot() {
        return "No plot here";
    }

    public String getName() {
        return name;
    }
}

class Jaws extends Movie {
    public Jaws() {
        super("Jaws");
    }

    public String plot() {
        return "A shark eats lots of people";
    }
}

class IndependenceDay extends Movie {
    public IndependenceDay() {
        super("Independence Day");
    }

    @Override
    public String plot() {
        return "Aliens attempt to take over planet earth";
    }
}

class MazeRunner extends Movie {

    public MazeRunner() {
        super("Maze Runner");
    }

    @Override
    public String plot() {
        return "Kids try and escape a maze.";
    }
}

class StarWars extends Movie {

    public StarWars() {
        super("Star Wars");
    }

    @Override
    public String plot() {
        return "Imperial Forces try to take over the universe";
    }
}

class Forgettable extends Movie {

    public Forgettable() {
        super("Forgettable");
    }

    // No plot method
}
```
2. 修改 Main.java 最主要的內容來展示 Polymorphism
```
public class Main {

    public static void main(String[] args) {
        for (int i = 1; i < 11; i++) {
            Movie movie = randomMovie();
            System.out.println("Movie #" + i + " : " + movie.getName() + "\n" + "Plot: " + movie.plot() + "\n");
        }
    }

    public static Movie randomMovie() {
        int randomNumber = (int) (Math.random() * 5) + 1;
        System.out.println("Random number generated was: " + randomNumber);
        switch (randomNumber) {
            case 1:
                return new Jaws();
            case 2:
                return new IndependenceDay();
            case 3:
                return new MazeRunner();
            case 4:
                return new StarWars();
            case 5:
                return new Forgettable();
        }

        return null;
    }
}
```
#### Polymorphism 挑戰
1. 題目
We are going to go back to the car analogy.
Crate a base class called Car
It should have a few fields that would be appropriate for a generic car class.
engine, cylinders, wheels, etc.
Constructor should initialize cylinders (number of) and name, and set wheels to 4
and engine to true. Cylinders and names would be passed parameters.
Create appropriate getters
Create some methods like startEngine, accelerate, and brake
show a message for each in the base class
Now create 3 sub classes for your favorite vehicles.
Override the appropriate methods to demonstrate polymorphism in use.
put all classes in the one java file (this one).

2. 答案

    1. 新增 Class 到 Main.java

    ```
    class Car {
        private boolean engine;
        private int cylinders;
        private String name;
        private int wheels;

        public Car(int cylinders, String name) {
            this.engine = true;
            this.cylinders = cylinders;
            this.name = name;
            this.wheels = 4;
        }

        public String startEngine() {
            return "Car -> startEngine()";
        }

        public String accelerate() {
            return "Car -> accelerate()";
        }

        public String brake() {
            return "Car -> brake()";
        }

        public int getCylinders() {
            return cylinders;
        }

        public String getName() {
            return name;
        }
    }

    class Mitsubishi extends Car {

        public Mitsubishi(int cylinders, String name) {
            super(cylinders, name);
        }

        @Override
        public String startEngine() {
            return "Mitsubishi -> startEngine()";
        }

        @Override
        public String accelerate() {
            return "Mitsubishi -> accelerate()";
        }

        @Override
        public String brake() {
            return "Mitsubishi -> brake()";
        }
    }

    class Holden extends Car {

        public Holden(int cylinders, String name) {
            super(cylinders, name);
        }

        @Override
        public String startEngine() {
            return "Holden -> startEngine()";
        }

        @Override
        public String accelerate() {
            return "Holden -> accelerate()";
        }

        @Override
        public String brake() {
            return "Holden -> brake()";
        }
    }

    class Ford extends Car {

        public Ford(int cylinders, String name) {
            super(cylinders, name);
        }

        @Override
        public String startEngine() {
            return "Ford -> startEngine()";
        }

        @Override
        public String accelerate() {
            return "Ford -> accelerate()";
        }

        @Override
        public String brake() {
            return "Ford -> brake()";
        }
    }
    ```
    2. 修改 Main.java 的主要內容
    ```
        public class Main {

        public static void main(String[] args) {
          Car car = new Car(8, "Base Car");
            System.out.println(car.startEngine());
            System.out.println(car.accelerate());
            System.out.println(car.brake());

            Mitsubishi mitsubishi = new Mitsubishi(6, "Outlander VRX 4WD");
            System.out.println(mitsubishi.startEngine());
            System.out.println(mitsubishi.accelerate());
            System.out.println(mitsubishi.brake());

            Ford ford = new Ford(6, "Ford Falcon");
            System.out.println(ford.startEngine());
            System.out.println(ford.accelerate());
            System.out.println(ford.brake());

            Holden holden = new Holden(6, "Holden Commodore");
            System.out.println(holden.startEngine());
            System.out.println(holden.accelerate());
            System.out.println(holden.brake());
        }
    }
    ```
    3. 可以使用內建語法 getClass().getSimpleName() 來取得 Class 的名稱
    ```
    class Mitsubishi extends Car {

        public Mitsubishi(int cylinders, String name) {
            super(cylinders, name);
        }

        @Override
        public String startEngine() {
            return getClass().getSimpleName() + " -> startEngine()";
        }

        @Override
        public String accelerate() {
            return getClass().getSimpleName() + " -> accelerate()";
        }

        @Override
        public String brake() {
            return getClass().getSimpleName() + " -> brake()";
        }
    }
    ```
#### OOP 終極挑戰
1. 題目
The purpose of this application is to help a company called Bill's Burgers manage the process of selling their hamburgers. And in order to match Bill's menu, you will need to create three(3) classes, Hamburger, DeluxeBurger, and HealthyBurger. 
For the base Hamburger class, there will need to be four variables to represent the four basic ingredients of the hamburger, name, meat, price, and breadRollType. The price variable should be of type double, while the other three are of type String. A constructor will be needed to accept these four values as parameters when creating a new hamburger.
There will also need to be separate variables for four(4) possible additions to the hamburger. Those should be declared with these names: addition1Name, addition1Price, addition2Name, addition2Price, addition3Name, addition3Price, addition4Name, and addition4Price. The name variables should be of type String and the price variables should be of type double.
Five(5) methods are also needed inside the Hamburger class. Four(4) for adding up to four additions to the hamburger and one(1) for printing out an itemized listing of the final hamburger with addons, if any, and the total price. Remember that a name and price must be accepted as parameters in the first four methods so that the price of the hamburger is adjusted accordingly. These methods should be named addHamburgerAddition1, addHamburgerAddition2, addHamburgerAddition3, addHamburgerAddition4, and itemizeHamburger. The first four methods do not return values, but the last method does return the total price of the hamburger of type double, which includes the base price of the hamburger plus any additional items. 
For the second class, DeluxeBurger, there are no additional member variables, and the constructor accepts no parameters. Instead, the constructor creates a deluxe burger with all the fixings and chips and a drink for a base price of $19.10. The constructor can be configured in any way, as long as chips and drink are added for the total price just mentioned. In this class, the four(4) methods defined in the Hamburger class for including additional toppings must each be overridden so that a message is printed stating that no additional items can be added to a deluxe burger.
And for the third class, HealthyBurger, there will be four(4) additional member variables called healthyExtra1Name, healthyExtra1Price, healthyExtra2Name, and healthyExtra2Price. The names are type String and the prices are type double. The constructor for this class accepts two(2) parameters for meat and price. Those are set in the constructor along with an appropriate name for the type of burger. 
Two methods, addHealthyAddition1 and addHealthyAddition2 should be created that each accept a name and price for the addition, allowing for up to two(2) addons to the basic healthy burger. And finally the itemizeHamburger method created in the Hamburger class should be overridden to generate a message appropriate to the type of burger along with any addons. The method also returns the total price of the healthy burger of type double.
    Example input:
    ```
    Hamburger hamburger = new Hamburger("Basic", "Sausage", 3.56, "White");
    hamburger.addHamburgerAddition1("Tomato", 0.27);
    hamburger.addHamburgerAddition2("Lettuce", 0.75);
    hamburger.addHamburgerAddition3("Cheese", 1.13);
    System.out.println("Total Burger price is " + hamburger.itemizeHamburger());

    HealthyBurger healthyBurger = new HealthyBurger("Bacon", 5.67);
    healthyBurger.addHamburgerAddition1("Egg", 5.43);
    healthyBurger.addHealthyAddition1("Lentils", 3.41);
    System.out.println("Total Healthy Burger price is  " + healthyBurger.itemizeHamburger());

    DeluxeBurger db = new DeluxeBurger();
    db.addHamburgerAddition3("Should not do this", 50.53);
    System.out.println("Total Deluxe Burger price is " + db.itemizeHamburger());
    ```
    Example output:
    ```
    Basic hamburger on a White roll with Sausage, price is 3.56
    Added Tomato for an extra 0.27
    Added Lettuce for an extra 0.75
    Added Cheese for an extra 1.13
    Total Burger price is 5.71
    Healthy hamburger on a Brown rye roll with Bacon, price is 5.67
    Added Egg for an extra 5.43
    Added Lentils for an extra 3.41
    Total Healthy Burger price is  14.51
    Cannot not add additional items to a deluxe burger
    Deluxe hamburger on a White roll with Sausage & Bacon, price is 14.54
    Added Chips for an extra 2.75
    Added Drink for an extra 1.81
    Total Deluxe Burger price is 19.10
    ```
2. 答案
    1. 新增 Hamburger.java
    ```
    public class Hamburger {
        private String name;
        private String meat;
        private double price;
        private String breadRollType;

        private String addition1Name;
        private double addition1Price;

        private String addition2Name;
        private double addition2Price;

        private String addition3Name;
        private double addition3Price;

        private String addition4Name;
        private double addition4Price;

        public Hamburger(String name, String meat, double price, String breadRollType) {
            this.name = name;
            this.meat = meat;
            this.price = price;
            this.breadRollType = breadRollType;
        }

        public void addHamburgerAddition1(String name, double price) {
            this.addition1Name = name;
            this.addition1Price = price;
        }

        public void addHamburgerAddition2(String name, double price) {
            this.addition2Name = name;
            this.addition2Price = price;
        }

        public void addHamburgerAddition3(String name, double price) {
            this.addition3Name = name;
            this.addition3Price = price;
        }

        public void addHamburgerAddition4(String name, double price) {
            this.addition4Name = name;
            this.addition4Price = price;
        }

        public double itemizeHamburger() {
            double hamburgerPrice = this.price;
            System.out.println(this.name + " hamburger on a " + this.breadRollType + " roll with " + this.meat + ", price is " + this.price);
            if (this.addition1Name != null) {
                hamburgerPrice += this.addition1Price;
                System.out.println("Added " + this.addition1Name + " for an extra " + this.addition1Price);
            }
            if (this.addition2Name != null) {
                hamburgerPrice += this.addition2Price;
                System.out.println("Added " + this.addition2Name + " for an extra " + this.addition2Price);
            }
            if (this.addition3Name != null) {
                hamburgerPrice += this.addition3Price;
                System.out.println("Added " + this.addition3Name + " for an extra " + this.addition3Price);
            }
            if (this.addition4Name != null) {
                hamburgerPrice += this.addition4Price;
                System.out.println("Added " + this.addition4Name + " for an extra " + this.addition4Price);
            }

            return hamburgerPrice;
        }
    }
    ```
    2. 新增 DeluxeBurger.java
    ```
    public class DeluxeBurger extends Hamburger {
        public DeluxeBurger() {
            super("Deluxe", "Sausage & Bacon", 14.54, "White");
            super.addHamburgerAddition1("Chips", 2.75);
            super.addHamburgerAddition2("Drink", 1.81);
        }

        @Override
        public void addHamburgerAddition1(String addition1Name, double addition1Price) {
            System.out.println("Cannot not add additional items to a deluxe burger");
        }

        @Override
        public void addHamburgerAddition2(String addition2Name, double addition2Price) {
            System.out.println("Cannot not add additional items to a deluxe burger");
        }

        @Override
        public void addHamburgerAddition3(String addition3Name, double addition3Price) {
            System.out.println("Cannot not add additional items to a deluxe burger");
        }

        @Override
        public void addHamburgerAddition4(String addition4Name, double addition4Price) {
            System.out.println("Cannot not add additional items to a deluxe burger");
        }
    }
    ```
    3. 新增 HealthyBurger.java
    ```
    public class HealthyBurger extends Hamburger {
        private String healthyExtra1Name;
        private double healthyExtra1Price;

        private String healthyExtra2Name;
        private double healthyExtra2Price;

        public HealthyBurger(String meat, double price) {
            super("Healthy", meat, price, "Brown rye");
        }

        public void addHealthyAddition1(String name, double price) {
            this.healthyExtra1Name = name;
            this.healthyExtra1Price = price;
        }

        public void addHealthyAddition2(String name, double price) {
            this.healthyExtra2Name = name;
            this.healthyExtra2Price = price;
        }

        @Override
        public double itemizeHamburger() {
            double hamburgerPrice = super.itemizeHamburger();
            if (this.healthyExtra1Name != null) {
                hamburgerPrice += this.healthyExtra1Price;
                System.out.println("Added " + this.healthyExtra1Name + " for an extra " + this.healthyExtra1Price);
            }
            if (this.healthyExtra2Name != null) {
                hamburgerPrice += this.healthyExtra2Price;
                System.out.println("Added " + this.healthyExtra2Name + " for an extra " + this.healthyExtra2Price);
            }

            return hamburgerPrice;
        }
    }
    ```
    4. 修改 Main.java
    ```
    public class Main {

        public static void main(String[] args) {
            Hamburger hamburger = new Hamburger("Basic", "Sausage", 3.56, "White");
            hamburger.addHamburgerAddition1("Tomato", 0.27);
            hamburger.addHamburgerAddition2("Lettuce", 0.75);
            hamburger.addHamburgerAddition3("Cheese", 1.13);
            System.out.println("Total Burger price is " + hamburger.itemizeHamburger());

            HealthyBurger healthyBurger = new HealthyBurger("Bacon", 5.67);
            healthyBurger.addHamburgerAddition1("Egg", 5.43);
            healthyBurger.addHealthyAddition1("Lentils", 3.41);
            System.out.println("Total Healthy Burger price is  " + healthyBurger.itemizeHamburger());

            DeluxeBurger db = new DeluxeBurger();
            db.addHamburgerAddition3("Should not do this", 50.53);
            System.out.println("Total Deluxe Burger price is " + db.itemizeHamburger());
        }
    }
    ```