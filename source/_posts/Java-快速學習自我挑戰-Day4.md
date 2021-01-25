---
title: Java 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/java/JavaDay04.jpg
date: 2020-05-11 09:50:37
categories: Study Note
tags: Java
toc: true
---
<img src="/images/learning/java/JavaDay04.jpg">

***
#### 題目練習
##### 題目五
Write a method areEqualByThreeDecimalPlaces with two parameters of type double.
The method should return boolean and it needs to return true if two double numbers are the same up to three decimal places. Otherwise, return false.

```
EXAMPLES OF INPUT/OUTPUT:
* areEqualByThreeDecimalPlaces(-3.1756, -3.175); → should return true since numbers are equal up to 3 decimal places.
* areEqualByThreeDecimalPlaces(3.175, 3.176); → should return false since numbers are not equal up to 3 decimal places
* areEqualByThreeDecimalPlaces(3.0, 3.0); → should return true since numbers are equal up to 3 decimal places.
* areEqualByThreeDecimalPlaces(-3.123, 3.123); → should return false since numbers are not equal up to 3 decimal places.
```

TIP: Use paper and pencil.
TIP: Use casting.
NOTE: The areEqualByThreeDecimalPlaces method  needs to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a  main method to solution code.
##### 題目五(答案)
```
public class DecimalComparator {
    public static boolean areEqualByThreeDecimalPlaces(double firstNumber, double secondNumber) {
        int transformedFirstNumber = (int) (firstNumber * 1000);
        int transformedSecondNumber = (int) (secondNumber * 1000);
        return transformedFirstNumber == transformedSecondNumber;
    }
}
```
```
public class Main {

    public static void main(String[] args) {

        boolean isIdentical = DecimalComparator.areEqualByThreeDecimalPlaces(-3.1756, -3.175);
        System.out.println(isIdentical);
        isIdentical = DecimalComparator.areEqualByThreeDecimalPlaces(3.175, 3.176);
        System.out.println(isIdentical);
        isIdentical = DecimalComparator.areEqualByThreeDecimalPlaces(3.0, 3.0);
        System.out.println(isIdentical);
        isIdentical = DecimalComparator.areEqualByThreeDecimalPlaces(-3.123, 3.123);
        System.out.println(isIdentical);

    }

}
```
##### 題目六
Write a method hasEqualSum with 3 parameters of type int.
The method should return boolean and it needs to return true if the sum of the first and second parameter is equal to the third parameter. Otherwise, return false.

```
EXAMPLES OF INPUT/OUTPUT:
* hasEqualSum(1, 1, 1);  should return false since 1 + 1 is not equal to 1
* hasEqualSum(1, 1, 2);  should return true since 1 + 1 is equal to 2
* hasEqualSum(1, -1, 0);  should return true since 1 + (-1) is 1 - 1 and is equal to 0
```

NOTE: The hasEqualSum method  needs to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a  main method to solution code.
##### 題目六(答案)
```
public class EqualSumChecker {
    public static boolean hasEqualSum(int firstNumber, int secondNumber, int thirdNumber) {
        return firstNumber + secondNumber == thirdNumber;
    }
}
```
```
public class Main {

    public static void main(String[] args) {

        boolean isEqual = EqualSumChecker.hasEqualSum(1, 1, 1);
        System.out.println(isEqual);
        isEqual = EqualSumChecker.hasEqualSum(1, 1, 2);
        System.out.println(isEqual);
        isEqual = EqualSumChecker.hasEqualSum(1, -1, 0);
        System.out.println(isEqual);

    }

}
```
##### 題目七
We'll say that a number is "teen" if it is in the range 13 -19 (inclusive).
Write a method named hasTeen with 3 parameters of type int.
The method should return boolean and it needs to return true if one of the parameters is in range 13(inclusive) - 19 (inclusive). Otherwise return false.

```
EXAMPLES OF INPUT/OUTPUT:
* hasTeen(9, 99, 19);  should return true since 19 is in range 13 - 19
* hasTeen(23, 15, 42);  should return true since 15 is in range 13 - 19
* hasTeen(22, 23, 34);  should return false since numbers 22, 23, 34 are not in range 13-19
```

Write another method named isTeen with 1 parameter of type int.
The method should return boolean and it needs to return true if the parameter is in range 13(inclusive) - 19 (inclusive). Otherwise return false.

```
EXAMPLES OF INPUT/OUTPUT:
* isTeen(9);  should return false since 9 is in not range 13 - 19
* isTeen(13);  should return true since 13 is in range 13 - 19
```

NOTE: All methods need to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a  main method to solution code.
##### 題目七(答案)
```
public class TeenNumberChecker {

    public static boolean hasTeen(int firstAge, int secondAge, int thirdAge) {
        return (firstAge >= 13 && firstAge <= 19) || (secondAge >= 13 && secondAge <= 19) || (thirdAge >= 13 && thirdAge <= 19);
    }

    public static boolean isTeen(int firstAge) {
        return (firstAge >= 13 && firstAge <= 19);
    }

}
```
```
public class Main {

    public static void main(String[] args) {

        boolean hasTeen =  TeenNumberChecker.hasTeen(9, 99, 19);
        System.out.println(hasTeen);
        hasTeen =  TeenNumberChecker.hasTeen(23, 15, 42);
        System.out.println(hasTeen);
        hasTeen =  TeenNumberChecker.hasTeen(22, 23, 34);
        System.out.println(hasTeen);
        boolean isTeen = TeenNumberChecker.isTeen(9);
        System.out.println(isTeen);
        isTeen = TeenNumberChecker.isTeen(13);
        System.out.println(isTeen);

    }

}
```
#### 方法多載(Method Overloading)
1. **方法多載**就是一個功能可以允許我們使用超過一種**同樣名稱**的方法，只要我們使用不同的**變數**。它就是一個功能可以創建很多同名的方法並有不同的應用。呼叫一個多載的方法可以運行該方法特別的應用。
2. 挑戰
Create a method called calcFeetAndInchesToCentimeters. It needs to have two parameters. Feet is the first parameter, inches is the second parameter．

You should validate that the first parameter feet is >= 0.
You should validate that the second parameter inches is >=0 and <= 12.
return -1 from the method if either of the above is not true.

If the parameters are valid, then calculate how many centimeters comprise the feet and inches passed to this method and return that value.

Create a second method of the same name but with only one parameter, inches is the parameter, validate that its >= 0, return -1 if it is not true.
But if its valid, then calculate how many feet are in the inches and then here is the tricky part
call the other overloaded method passing the correct feet and inches calculated so that it can calculate correctly.

hints: Use double for your number data types is probably a good idea.
1 inch = 2.54cm and 1 foot = 12 inches.
use the link I give you to confirm your code is calculating correctly.
calling another overloaded method just require you to use the right number of parameters.
3. 挑戰的答案
```
public static void main(String[] args) {
    calcFeetAndInchesToCentimeters(8, 4);
    calcFeetAndInchesToCentimeters(-10);
}

public static double calcFeetAndInchesToCentimeters(double feet, double inches) {

    if (feet < 0 || inches < 0 || inches > 12) {
        return -1;
    }

    double centimeters = (feet * 12 * 2.54) + (inches * 2.54);
    System.out.println(feet + " feet, " + inches + " inches = " + centimeters + " cm");
    return centimeters;
}

public static double calcFeetAndInchesToCentimeters(double inches) {

    if (inches < 0) {
        return -1;
    }

    int feet = (int) inches / 12;
    int remainingInches = (int) inches % 12;
    System.out.println(inches + " inches is equal to " + feet + " feet and " + remainingInches + " inches");
    return calcFeetAndInchesToCentimeters(feet, remainingInches);
}
```
4. 方法多載的好處
    - 它改善了程式碼的可讀性和重複使用性。
    - 記住一個名稱比起記住很多名稱更容易。
    - 保持命名方法的一致性，單一名稱的方法是很常被使用的。
    - 方法多載給予程式設計師彈性去呼叫一個有不同變數型態但相似的方法。
#### 秒和分的挑戰
1. 題目
    - Create a method called **getDurationString** with two parameters, first parameter **minutes** and second parameter **seconds**.
    - You should validate that teh **first parameter minutes is >= 0**.
    - You should validate that the **second parameter seconds is >=0 and <= 59**.
    - The method should **return "Invalid value"** in teh method if either of the above are not true.
    - If the **parameters are valid** then calculate how many hours minutes and seconds equal the minutes and seconds passed to this method and **return that value as string in format "XXh XXm ZZs"** where XX represents a number of hours, YY the minutes and ZZ the seconds.
    - Create a **second method of the same name but with only one parameter seconds**.
    - **Validate that it is >= 0, and retrun "Invalid value" if it is not true**.
    - If it is valid, then calculate how many minutes are in the seconds value and then call the other overloaded method passing the correct minutes and seconds calculated so that it can calculate correctly.
    - Call both methods to print values to the console.
    - Tips:
        - Use int or long for your number data types is probably a good idea.
        - 1 minute = 60 seconds and 1 hour = 60 minutes or 3600 seconds.
        - Methods should be static as we have used previously.
    - Bonus:
        - For the input 61 minutes output should be 01h 01m 00s, but it is ok it is 1h 1m 0s (Tip: use if-else)
        - Create a new console project and call it SecondsAndMinutesChallenge
2. 答案
```
public class Main {

    public static void main(String[] args) {
        System.out.println(getDurationString(3945));
    }

    private static String getDurationString(int minutes, int seconds) {

        // 驗證分鐘是否大於 0，且秒是否介於 0-59 之間
        if (minutes < 0 || (seconds < 0 || seconds > 59)) {
            return "Invalid Value";
        }

        int hours = minutes / 60;
        int remainingMinutes = minutes % 60;

        String hoursString = hours + "h";
        if (hours < 10) {
            hoursString = "0" + hoursString;
        }

        String minutesString = minutes + "m";
        if (minutes < 10) {
            minutesString = "0" + minutesString;
        }

        String secondsString = seconds + "s";
        if (seconds < 10) {
            secondsString = "0" + secondsString;
        }

        return hoursString + " " + minutesString + " " + secondsString;
    }

    private static String getDurationString(int seconds) {

        // 驗證秒是否大於 0
        if (seconds < 0) {
            return "Invalid Value";
        }

        int minutes = seconds / 60;
        int remainingSeconds = seconds % 60;

        return getDurationString(minutes, remainingSeconds);
    }
}
```
3. `final` 就是 constant 變數裡面的一個關鍵字，如果定義了，就不能改變它。可以將上面的程式碼改成下面這樣。
```
private static final String INVALID_VALUE_MESSAGE = "Invalid value";

...
if (minutes < 0 || (seconds < 0 || seconds > 59)) {
    return INVALID_VALUE_MESSAGE;
}
...
if (seconds < 0) {
    return INVALID_VALUE_MESSAGE;
}
```
#### 四個挑戰
##### 題目一
Write a method named area with one double parameter named radius.
The method needs to return a double value that represents the area of a circle.
If the parameter radius is negative then return -1.0 to represent an invalid value.
Write another overloaded method with 2 parameters x and y (both doubles), where x and y represent the sides of a rectangle.
The method needs to return an area of a rectangle.
If either or both parameters is/are a negative return -1.0 to indicate an invalid value.
For formulas and PI value please check the tips below.

```
Examples of input/output:
* area(5.0); should return 78.53975
* area(-1);  should return -1 since the parameter is negative
* area(5.0, 4.0); should return 20.0 (5 * 4 = 20)
* area(-1.0, 4.0);  should return -1 since first the parameter is negative
```

TIP: The formula for calculating the area of a rectangle is x * y.
TIP: The formula for calculating a circle area is radius * radius * PI.
TIP: For PI use a constant from Math class e.g. Math.PI
NOTE: All methods need to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to your solution code!
##### 題目一(答案)
```
public class AreaCalculator {
    public static double area(double radius) {

        if (radius < 0) {
            return -1;
        }

        // 計算圓面積
        return radius * radius * Math.PI;
    }

    public static double area(double x, double y) {

        if (x < 0 || y < 0) {
            return -1;
        }

        // 計算三角形面積
        return x * y;
    }
}
```
##### 題目二
Write a method printYearsAndDays with parameter of type long named minutes.
The method should not return anything (void) and it needs to calculate the years and days from the minutes parameter.
If the parameter is less than 0, print text "Invalid Value".
Otherwise, if the parameter is valid then it needs to print a message in the format "XX min = YY y and ZZ d".
XX represents the original value minutes.
YY represents the calculated years.
ZZ represents the calculated days.

```
EXAMPLES OF INPUT/OUTPUT:
* printYearsAndDays(525600);  → should print "525600 min = 1 y and 0 d"
* printYearsAndDays(1051200); → should print "1051200 min = 2 y and 0 d"
* printYearsAndDays(561600);  → should print "561600 min = 1 y and 25 d"
```

TIPS:
- Be extra careful about spaces in the printed message.
- Use the remainder operator
- 1 hour = 60 minutes
- 1 day = 24 hours
- 1 year = 365 days

NOTES
- The printYearsAndDays method needs to be defined as public static like we have been doing so far in the course.
- Do not add main method to solution code.
- The solution will not be accepted if there are extra spaces
##### 題目二(答案)
```
public class MinutesToYearsDaysCalculator {
    public static void printYearsAndDays(long minutes) {

        if (minutes < 0) {
            System.out.println("Invalid Value");
        } else {
            // 將分鐘轉換成年和天
            long days = minutes / 60 / 24;
            long years = days / 365;
            long remainingDays = days % 365;

            System.out.println(minutes + " min = " + years + " y and " + remainingDays + " d");
        }
    }
}
```
##### 題目三
Write a method printEqual with 3 parameters of type int. The method should not return anything (void).
If one of the parameters is less than 0, print text "Invalid Value".
If all numbers are equal print text "All numbers are equal"
If all numbers are different print text "All numbers are different".
Otherwise, print "Neither all are equal or different".

```
EXAMPLES OF INPUT/OUTPUT:
* printEqual(1, 1, 1); should print text All numbers are equal
* printEqual(1, 1, 2); should print text Neither all are equal or different
* printEqual(-1, -1, -1); should print text Invalid Value
* printEqual(1, 2, 3); should print text All numbers are different
```

TIP: Be extremely careful about spaces in the printed message. 

NOTES
- The solution will not be accepted if there are extra spaces.
- The method printEqual needs to be defined as public static like we have been doing so far in the course.
- Do not add main method to solution code.
##### 題目三(答案)
```
public class IntEqualityPrinter {
    public static void printEqual(int first, int second, int third) {

        if (first < 0 || second < 0 || third < 0) {
            System.out.println("Invalid Value");
        } else if (first == second && second == third) {
            System.out.println("All numbers are equal");
        } else if (first != second && second != third && third != first) {
            System.out.println("All numbers are different");
        } else {
            System.out.println("Neither all are equal or different");
        }
    }
}
```
##### 題目四
The cats spend most of the day playing. In particular, they play if the temperature is between 25 and 35 (inclusive). Unless it is summer, then the upper limit is 45 (inclusive) instead of 35.
Write a method isCatPlaying that has 2 parameters. Method needs to return true if the cat is playing, otherwise return false
1st parameter should be of type boolean and be named summer it represents if it is summer.
2nd parameter represents the temperature and is of type int with the name temperature.

```
EXAMPLES OF INPUT/OUTPUT:
* isCatPlaying(true, 10); should return false since temperature is not in range 25 - 45 
* isCatPlaying(false, 36); should return false since temperature is not in range 25 - 35 (summer parameter is false)
* isCatPlaying(false, 35); should return true since temperature is in range 25 - 35 
```

NOTES
- The isCatPlaying method needs to be defined as public static like we have been doing so far in the course.
- Do not add the main method to the solution code.
##### 題目四(答案)
```
public class PlayingCat {
    
    public static boolean isCatPlaying(boolean summer, int temperature) {

        if (!summer) {
            return temperature >= 25 && temperature <= 35;
        } else {
            return temperature >= 25 && temperature <= 45;
        }
    }
}
```