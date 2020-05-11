---
title: Java 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/java/JavaDay04.png
date: 2020-05-11 09:50:37
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay04.png">

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









