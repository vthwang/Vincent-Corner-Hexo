---
title: Java 快速學習自我挑戰 Day3
thumbnail:
  - /images/learning/java/JavaDay03.jpg
date: 2020-05-08 16:51:10
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay03.jpg">

***
### Java 教學 - 表達式(Expressions)、陳述句(Statements)、程式碼區塊(Code Blocks)、方法(Methods)...等等
#### 關鍵字(Keywords)和表達式(Expressions)
1. [Java Keyword 列表](https://en.wikipedia.org/wiki/List_of_Java_keywords)
2. `int int = 5;`，這樣的語法會出現錯誤，關鍵字是被保留的，所以在命名變數的時候，不能使用跟關鍵字同名的變數。
3. 裡面的 `kilometers = (100 * 1.609344);`、`highScore = 50;`、`highScore == 50`、`"This is an expression."` 都是表達式，`double kilometers = (100 * 1.609344);`、`int highScore = 50;` 則是陳述句(statement)，而 `System.out.println("This is an expression.");` 則是一個方法(method)
```
double kilometers = (100 * 1.609344);
int highScore = 50;

if (highScore == 50) {
    System.out.println("This is an expression.");
}
```
#### 陳述句(Statements)、空白(Whitespace)、縮排(Indentation)
1. 一行陳述句的結尾要有分號，中間不管放多少空白，Java 都可以讀取。
2. 寫程式碼一定要有縮排，沒有縮排不會影響功能，但是會影響閱讀。
#### 程式碼區塊(Code Blocks)和 If-then-else 控制陳述句(Control Statement)
1. if-else if-else 的範例。
```
boolean gameOver = true;
int score = 800;
int levelCompleted = 5;
int bonus = 100;

if (score < 5000 && score > 1000) {
    System.out.println("Your score was less than 5000 but greater than 1000");
} else if (score < 1000) {
    System.out.println("Your score was less than 1000");
} else {
    System.out.println("Got here.");
}
```
2. 在最後一行會發生錯誤，因為在 if 的程式碼區塊裡面，完成之後，就會將 finalScore 刪除。
```
if (gameOver) {
    int finalScore = score + (levelCompleted * bonus);
    System.out.println("Your final score was " + finalScore);
}

int savedFinalScore = finalscore; //error
```
3. 程式碼區塊裡面的內容，叫做 scope，後面會細說。
4. 挑戰：將 score 設定為 10000，levelCompleted 設定為 8，bonus 設定為 200，然後確定上面的程式碼一樣被執行。
5. 可以將變數重複利用，不需要在前面在定義變數原始型態，直接給變數名稱數值。
```
score = 10000;
levelCompleted = 8;
bonus = 200;

if (gameOver) {
    int finalScore = score + (levelCompleted * bonus);
    System.out.println("Your final score was " + finalScore);
}
```
#### if-then-else 回顧
1. **if** 陳述句根據表達式的值來判別要執行哪個陳述句或是程式碼區塊內容，換句話說，就是根據特定條件。
2. 程式碼區塊會用 **{** **}** 來定義，在裡面可以執行一到多行的陳述句。
3. 我們可以在 **if** 陳述句後面使用 **else**，當條件是錯誤的時候，else 的區塊程式碼會被執行。
4. 我們還可以使用 **else if** 去驗證多條件。
5. 基本的 if-else 陳述句架構如下：
```
if (condition) {
    if statement (block)
} else {
    else statement (block)
}
```
#### Java 裡的方法(Methods)
1. 方法是用來讓重複功能寫在一起，只要呼叫方法就可以，不需要重複寫一樣的程式碼。
2. `public static` 就是方法，void 就是不回傳值，如果需回傳值，就要像 calculateScore 在前面加上想要回傳的值的原始型態。
```
public static void main(String[] args) {
    calculateScore(true, 800, 5, 100);
    calculateScore(true, 10000, 8, 200);
}

public static int calculateScore(boolean gameOver, int score, int levelCompleted, int bonus) {

    if (gameOver) {
        int finalScore = score + (levelCompleted * bonus);
        System.out.println("Your final score was " + finalScore);
        return finalScore;
    }

    return -1;
}
```
3. 為什麼回傳 -1？找不到值、或是錯誤就會回傳 -1。
#### 更多方法(Methods)和挑戰
1. 挑戰：創建一個方法叫做 displayHighScorePosition，有兩個參數分別是 playerName 和 highScorePosition，要顯示訊息 playerName + "manage to get that position " + highScorePosition + " on the high score table"。再創建一個方法叫做 calculateHighScorePosition，只有一個參數 playerScore，要回傳 int，當分數 > 1000 回傳 1，分數 > 500 且 < 1000 回傳 2，分數 > 100 且 < 500 回傳 3，其餘回傳 4，最後分別顯示以下分數的結果 1500, 900, 400, 50。
```
public static void main(String[] args) {
    int highScorePosition = calculateHighScorePosition(1500);
    displayHighScorePosition("Tim", highScorePosition);
    highScorePosition = calculateHighScorePosition(900);
    displayHighScorePosition("Bob", highScorePosition);
    highScorePosition = calculateHighScorePosition(400);
    displayHighScorePosition("Percy", highScorePosition);
    highScorePosition = calculateHighScorePosition(50);
    displayHighScorePosition("Gilbert", highScorePosition);
}

public static void displayHighScorePosition(String playerName, int highScorePosition) {
    System.out.println(playerName + " managed to get into position "
            + highScorePosition + " on the high school table");
}

public static int calculateHighScorePosition(int playerScore) {
    if (playerScore >= 1000) {
        return 1;
    } else if (playerScore >= 500) {
        return 2;
    } else if (playerScore >= 100) {
        return 3;
    }
    
    return 4;
}   
```
2. calculateHighScorePosition 的程式碼也可以改寫如下
```
public static int calculateHighScorePosition(int playerScore) {

    int position = 4; // assuming position 4 will be returned

    if (playerScore >= 1000) {
        position = 1;
    } else if (playerScore >= 500) {
        position = 2;
    } else if (playerScore >= 100) {
        position = 3;
    }

    return position;
}
```
#### DiffMerge 工具
1. DiffMerge 是一個程式在任何作業系統下都可以幫助你視覺地比較和合併檔案。
2. 用 DiffMerge 可以視覺地比較一個檔案或整個資料夾的程式碼。
3. [DiffMerge 下載頁面](https://sourcegear.com/diffmerge/downloads.php)
#### 題目練習
##### 題目一
1. Write a method called toMilesPerHour that has 1 parameter of type double with the name kilometersPerHour. This method needs to return the rounded value of the calculation of type long.

If the parameter kilometersPerHour is less than 0, the method toMilesPerHour needs to return -1 to indicate an invalid value.
Otherwise, if it is positive, calculate the value of miles per hour, round it and return it. For conversion and rounding, check the notes in the text below.
```
Examples of input/output:
* toMilesPerHour(1.5); → should return value 1
* toMilesPerHour(10.25); → should return value 6
* toMilesPerHour(-5.6); → should return value -1
* toMilesPerHour(25.42); → should return value 16
* toMilesPerHour(75.114); → should return value 47
```

2. Write another method called printConversion with 1 parameter of type double with the name kilometersPerHour.

This method should not return anything (void) and it needs to calculate milesPerHour from the kilometersPerHour parameter.
Then it needs to print a message in the format "XX km/h = YY mi/h".
XX represents the original value kilometersPerHour.
YY represents the rounded milesPerHour from the kilometersPerHour parameter.
If the parameter kilometersPerHour is < 0 then print the text "Invalid Value".
```
Examples of input/output:
* printConversion(1.5); → should print the following text (into the console - System.out): 1.5 km/h = 1 mi/h
* printConversion(10.25); → should print the following text (into the console - System.out): 10.25 km/h = 6 mi/h
* printConversion(-5.6); → should print the following text (into the console - System.out): Invalid Value
* printConversion(25.42); → should print the following text (into the console - System.out): 25.42 km/h = 16 mi/h
* printConversion(75.114); → should print the following text (into the console - System.out): 75.114 km/h = 47 mi/h
```
Use method Math.round to round the number of calculated miles per hour(double). The method round returns long.

3. How to use the method round and how it works?

The Math.round() is a built-in math method which returns the closest long to the argument. The result is rounded to an integer by adding 1/2, taking the floor of the result after adding 1/2, and typecasting the result to type long. The method returns the value of the argument rounded to the nearest int value.

USAGE EXAMPLE:
```
double number = 1.5;
long rounded = Math.round(number);
System.out.println("rounded= " + rounded);
System.out.println("with 3.9= " + Math.round(3.9));
System.out.println("with 4.5= " + Math.round(4.5));
int sum = 45;
int count = 10;
// typecasting so result is double e.g. double / int -> double
double average = (double) sum / count;
long roundedAverage = Math.round(average);
System.out.println("average= " + average);
System.out.println("roundedAverage= " + roundedAverage);
```

OUTPUT:
```
rounded= 2
with 3.9= 4
with 4.5= 5
average= 4.5
roundedAverage= 5
```

TIP: In the method printConversion, call the method toMilesPerHour instead of duplicating the code.
NOTE: All methods should be defined as public static like we have been doing so far in the course.
NOTE: 1 mile per hour is 1.609 kilometers per hour
NOTE: Do not add a main method to the solution code.
##### 題目一(解答)
```
public class SpeedConverter {
    public static long toMilesPerHour(double kilometersPerHour) {

        if (kilometersPerHour < 0) {
            return -1;
        }

        long milesPerHour = Math.round(0.621371192 * kilometersPerHour);
        return milesPerHour;

    }

    public static void printConversion(double kilometersPerHour) {

        if (kilometersPerHour < 0) {
            System.out.println("Invalid Value");
        } else {
            long milesPerHour = toMilesPerHour(kilometersPerHour);
            System.out.println(kilometersPerHour + " km/h = " + milesPerHour + " mi/h");
        }

    }
}
```
```
public class Main {

    public static void main(String[] args) {

        SpeedConverter.printConversion(1.5);
        SpeedConverter.printConversion(10.25);
        SpeedConverter.printConversion(-5.6);
        SpeedConverter.printConversion(25.42);
        SpeedConverter.printConversion(75.114);

    }

}
```
##### 題目二
Write a method called printMegaBytesAndKiloBytes that has 1 parameter of type int with the name kiloBytes.

The method should not return anything (void) and it needs to calculate the megabytes and remaining kilobytes from the kilobytes parameter.

Then it needs to print a message in the format "XX KB = YY MB and ZZ KB".

XX represents the original value kiloBytes.
YY represents the calculated megabytes.
ZZ represents the calculated remaining kilobytes.

For example, when the parameter kiloBytes is 2500 it needs to print "2500 KB = 2 MB and 452 KB"

If the parameter kiloBytes is less than 0 then print the text "Invalid Value".

```
EXAMPLE INPUT/OUTPUT
* printMegaBytesAndKiloBytes(2500); → should print the following text: "2500 KB = 2 MB and 452 KB"
* printMegaBytesAndKiloBytes(-1024); → should print the following text: "Invalid Value" because parameter is less than 0.
* printMegaBytesAndKiloBytes(5000); → should print the following text: "5000 KB = 4 MB and 904 KB"
```

TIP: Be extremely careful about spaces in the printed message. 
TIP: Use the remainder operator
TIP: 1 MB = 1024 KB
NOTE: Do not set kilobytes parameter value inside your method. 
NOTE: The solution will not be accepted if there are extra spaces.
NOTE: The printMegaBytesAndKiloBytes method  needs to be defined as public static like we have been doing so far in the course.NOTE: Do not add a  main method to solution code.
##### 題目二(解答)
```
public static void printMegaBytesAndKiloBytes(int kiloBytes) {

    if (kiloBytes < 0) {
        System.out.println("Invalid Value");
    } else {
        int megaBytes = (int) Math.floor( kiloBytes / 1024d );
        int extraKiloBytes = kiloBytes - (megaBytes * 1024);
        System.out.println(kiloBytes + " KB = " + megaBytes + " MB and " + extraKiloBytes + " KB");
    }
}
```
```
public class Main {

    public static void main(String[] args) {

        MegaBytesConverter.printConversion(2500);
        MegaBytesConverter.printConversion(-1024);
        MegaBytesConverter.printConversion(5000);

    }

}
```
##### 題目三
We have a dog that likes to bark.  We need to wake up if the dog is barking at night!
Write a method shouldWakeUp that has 2 parameters.
1st parameter should be of type boolean and be named barking it represents if our dog is currently barking.
2nd parameter represents the hour of the day and is of type int with the name hourOfDay and has a valid range of 0-23.
We have to wake up if the dog is barking before 8 or after 22 hours so in that case return true.
In all other cases return false.
If the hourOfDay parameter is less than 0 or greater than 23 return false.

```
Examples of input/output:
* shouldWakeUp (true, 1); → should return true
* shouldWakeUp (false, 2); → should return false since the dog is not barking.
* shouldWakeUp (true, 8); → should return false, since it's not before 8.
* shouldWakeUp (true, -1); → should return false since the hourOfDay parameter needs to be in a range 0-23.
```

TIP: Use the if else statement with multiple conditions.
NOTE: The shouldWakeUp method  needs to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to solution code.
##### 題目三(解答)
```
public static boolean shouldWakeUp(boolean isBarking, int hourOfDay) {

    // 驗證 hourOfDay 是否是 0-23
    if (hourOfDay > 23 || hourOfDay < 0) {
        return false;
    }

    // 如果 isBarking true，且 hourOfDay 小於 8 或大於 23，會傳 true
    if (isBarking == true) {
        if (hourOfDay < 8 || hourOfDay > 22) {
            return true;
        }
    }

    return false;
}
```
```
public class Main {

    public static void main(String[] args) {

        boolean shouldWakeUp = BarkingDog.shouldWakeUp(true, 1);
        System.out.println(shouldWakeUp);
        shouldWakeUp = BarkingDog.shouldWakeUp(false, 2);
        System.out.println(shouldWakeUp);
        shouldWakeUp = BarkingDog.shouldWakeUp(true, 8);
        System.out.println(shouldWakeUp);
        shouldWakeUp = BarkingDog.shouldWakeUp(true, -1);
        System.out.println(shouldWakeUp);

    }

}
```
##### 題目四
Write a method isLeapYear with a parameter of type int named year.
The parameter needs to be greater than or equal to 1 and less than or equal to 9999.
If the parameter is not in that range return false.
Otherwise, if it is in the valid range, calculate if the year is a leap year and return true if it is a leap year, otherwise return false.

To determine whether a year is a leap year, follow these steps:
1. If the year is evenly divisible by 4, go to step
2. Otherwise, go to step 5.2. If the year is evenly divisible by 100, go to step
3. Otherwise, go to step 4.3. If the year is evenly divisible by 400, go to step
4. Otherwise, go to step 5.4. The year is a leap year (it has 366 days). The method isLeapYear needs to return true.
5. The year is not a leap year (it has 365 days). The method isLeapYear needs to return false.

The following years are not leap years:
1700, 1800, 1900, 2100, 2200, 2300, 2500, 2600
This is because they are evenly divisible by 100 but not by 400.

The following years are leap years:
1600, 2000, 2400
This is because they are evenly divisible by both 100 and 400.

```
Examples of input/output:
* isLeapYear(-1600); → should return false since the parameter is not in range (1-9999)
* isLeapYear(1600); → should return true since 1600 is a leap year
* isLeapYear(2017); → should return false since 2017 is not a leap year
* isLeapYear(2000);  → should return true because 2000 is a leap year 
```

NOTE: The method isLeapYear needs to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a  main method to solution code.
##### 題目四(答案)
```
public static boolean isLeapYear(int year) {

    // year 必須要大於等於 1，且要小於等於 9999
    if (year < 1 || year > 9999) {
        return false;
    }

    // 1. 如果年可以被 4 除，就往下，其餘的不是閏年
    // 2. 如果年可以被 100 除，就往下，其餘的是閏年
    // 3. 如果年可以被 400 除，就往下，其餘不是閏年
    int dividedByFour = year % 4;
    int dividedByHundred = year % 100;
    int dividedByFourHundreds = year % 400;

    return (dividedByFour == 0 && dividedByHundred == 0 && dividedByFourHundreds == 0) || (dividedByFour == 0 && dividedByHundred != 0);
    
}
```
```
public class Main {

    public static void main(String[] args) {

        boolean isLeapYear = LeapYear.isLeapYear(-1600);
        System.out.println(isLeapYear);
        isLeapYear = LeapYear.isLeapYear(1600);
        System.out.println(isLeapYear);
        isLeapYear = LeapYear.isLeapYear(2017);
        System.out.println(isLeapYear);
        isLeapYear = LeapYear.isLeapYear(2000);
        System.out.println(isLeapYear);

    }

}
```