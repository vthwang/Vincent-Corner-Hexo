---
title: Java 快速學習自我挑戰 Day7
thumbnail:
  - /images/learning/java/JavaDay07.jpeg
date: 2020-05-27 23:30:04
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay07.jpeg">

***
### 控制流陳述句
#### 從 String 解析出值
1. 使用 Integer.parseInt 就可以將 String 轉換為 int。
```
public static void main(String[] args) {

    String numberAsSting = "2018";
    System.out.println("numberAsString = " + numberAsSting);

    int number = Integer.parseInt(numberAsSting);
    System.out.println("number = " + number);

    numberAsSting += 1;
    number += 1;

    System.out.println("numberAsString = " + numberAsSting);
    System.out.println("number = " + number);
}

-----
numberAsString = 2018
number = 2018
numberAsString = 20181
number = 2019
```
2. 同樣地，使用 Double.parseDouble 也可將 String 轉換為 double.
```
public static void main(String[] args) {

    String numberAsSting = "2018.125";
    System.out.println("numberAsString = " + numberAsSting);

    double number = Double.parseDouble(numberAsSting);
    System.out.println("number = " + number);

    numberAsSting += 1;
    number += 1;

    System.out.println("numberAsString = " + numberAsSting);
    System.out.println("number = " + number);
}

-----
numberAsString = 2018.125
number = 2018.125
numberAsString = 2018.1251
number = 2019.125
```
3. 如果 String 無法轉換成 int 就會出現 Exception 錯誤。
```
public static void main(String[] args) {

    String numberAsSting = "2018test";
    System.out.println("numberAsString = " + numberAsSting);

    int number = Integer.parseInt(numberAsSting);
    System.out.println("number = " + number);
}

-----
numberAsString = 2018test
Exception in thread "main" java.lang.NumberFormatException: For input string: "2018test"
	at java.base/java.lang.NumberFormatException.forInputString(NumberFormatException.java:65)
	at java.base/java.lang.Integer.parseInt(Integer.java:652)
	at java.base/java.lang.Integer.parseInt(Integer.java:770)
	at com.fishboneapps.Main.main(Main.java:10)
```
#### 題目一
Write a method named canPack with three parameters of type int named bigCount, smallCount, and goal. 
The parameter bigCount represents the count of big flour bags (5 kilos each).
The parameter smallCount represents the count of small flour bags (1 kilo each).
The parameter goal represents the goal amount of kilos of flour needed to assemble a package.
Therefore, the sum of the kilos of bigCount and smallCount must be at least equal to the value of goal. The method should return true if it is possible to make a package with goal kilos of flour.
If the sum is greater than goal, ensure that only full bags are used towards the goal amount. For example, if goal = 9, bigCount = 2, and smallCount = 0, the method should return false since each big bag is 5 kilos and cannot be divided. However, if goal = 9, bigCount = 1, and smallCount = 5, the method should return true because of 1 full bigCount bag and 4 full smallCount bags equal goal, and it's okay if there are additional bags left over.
If any of the parameters are negative, return false.

```
EXAMPLE INPUT/OUTPUT:
* canPack (1, 0, 4); should return false since bigCount is 1 (big bag of 5 kilos) and goal is 4 kilos.
* canPack (1, 0, 5); should return true since bigCount is 1 (big bag of 5 kilos) and goal is 5 kilos.
* canPack (0, 5, 4); should return true since smallCount is 5 (small bags of 1 kilo) and goal is 4 kilos, and we have 1 bag left which is ok as mentioned above.
* canPack (2, 2, 11); should return true since bigCount is 2 (big bags 5 kilos each) and smallCount is 2 (small bags of 1 kilo), makes in total 12 kilos and goal is 11 kilos. 
* canPack (-3, 2, 12); should return false since bigCount is negative.
```

NOTE: The method canPack should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目一(答案)
```
public class FlourPacker {
    public static boolean canPack(int bigCount, int smallCount, int goal) {

        if (bigCount < 0 || smallCount < 0 || goal < 0) {
            return false;
        }

        if (bigCount * 5 > goal) {
            return smallCount >= goal % 5;
        }

        return smallCount >= goal - (bigCount * 5);
    }
}
```
#### 題目二
Write a method named getLargestPrime with one parameter of type int named number. 
If the number is negative or does not have any prime numbers, the method should return -1 to indicate an invalid value.
The method should calculate the largest prime factor of a given number and return it.

```
EXAMPLE INPUT/OUTPUT:
* getLargestPrime (21); should return 7 since 7 is the largest prime (3 * 7 = 21)
* getLargestPrime (217); should return 31 since 31 is the largest prime (7 * 31 = 217)
* getLargestPrime (0); should return -1 since 0 does not have any prime numbers
* getLargestPrime (45); should return 5 since 5 is the largest prime (3 * 3 * 5 = 45)
* getLargestPrime (-1); should return -1 since the parameter is negative
```

HINT: Since the numbers 0 and 1 are not considered prime numbers, they cannot contain prime numbers.
NOTE: The method getLargestPrime should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目二(答案)
```
public class LargestPrime {
    public static int getLargestPrime(int number) {

        if (number < 2) {
            return -1;
        }

        int largestPrime = 2;
        while (largestPrime < number) {

            if (number % largestPrime != 0) {
                largestPrime++;
            } else {
                number /= largestPrime;
                largestPrime = 2;
            }
        }

        return largestPrime;
    }
}
```
#### 題目三
Write a method named printSquareStar with one parameter of type int named number. 
If number is < 5, the method should print "Invalid Value".
The method should print diagonals to generate a rectangular pattern composed of stars (*). This should be accomplished by using loops (see examples below).

```
EXAMPLE INPUT/OUTPUT:
EXAMPLE 1
printSquareStar(5); should print the following:

→ NOTE: For text in Code Blocks below, use code icon {...}  on Udemy

*****
** **
* * *
** **
*****

Explanation:

*****   5 stars
** **   2 stars space 2 stars
* * *   1 star space 1 star space 1 star
** **   2 stars space 2 stars
*****   5 stars

EXAMPLE 2

printSquareStar(8); should print the following:

********
**    **
* *  * *
*  **  *
*  **  *
* *  * *
**    **
********
```

The patterns above consist of a number of rows and columns (where number is the number of rows to print). For each row or column, stars are printed based on four conditions (Read them carefully):

* In the first or last row
* In the first or last column
* When the row number equals the column number
* When the column number equals rowCount - currentRow + 1 (where currentRow is current row number)

HINT: Use a nested loop (a loop inside of a loop).
HINT: To print on the same line, use the print method instead of println, e.g. System.out.print(" "); prints a space and does not "move" to another line.
HINT: To "move" to another line, you can use an empty println call, e.g. System.out.println(); .
NOTE: The method printSquareStar should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目三(答案)
```
public class DiagonalStar {
    public static void printSquareStar(int number) {

        if (number < 5) {
            System.out.println("Invalid Value");
            return;
        }

        for (int row = 1; row <= number; row++) {

            for (int column = 1; column <= number; column++) {

                if (row == 1 || row == number) {

                    System.out.print("*");
                } else if (column == 1 || column == number) {

                    System.out.print("*");
                } else if (row == column) {

                    System.out.print("*");
                } else if (column == (number - row + 1)) {

                    System.out.print("*");
                } else {

                    System.out.print(" ");
                }
            }

            System.out.println("");
        }
    }
}
```
#### 讀取用戶輸入
1. 我們用 Scanner 來讀取用戶的輸入，用 nextLine() 將輸入讀取出來，也可以使用 nextInt() 將輸入讀取成 int，需要注意的是，在數字後面會有換行字元問題，需要再加上 nextLine() 來解決問題。
```
public class Main {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter your year of birth: ");
        int YearOfBirth = scanner.nextInt();
        scanner.nextLine(); //handle next line character(enter key)

        System.out.println("Enter your name: ");
        String name = scanner.nextLine();
        int age = 2018 - YearOfBirth;

        System.out.println("Your name is " + name + ", and you are " + age + " years old.");

        scanner.close();
    }
}
```
#### 用戶輸入的問題和解決方案
1. 如果用戶輸入負數，可以直接計算年紀是不是在合理範圍內，如果不在就返回錯誤，另外針對用戶輸入字元的話，可以用 scanner.hasNextInt() 來確定是否為數字。

```
public class Main {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        System.out.println("Enter your year of birth: ");

        boolean hasNextInt = scanner.hasNextInt();

        if (hasNextInt) {

            int YearOfBirth = scanner.nextInt();
            scanner.nextLine(); //handle next line character(enter key)

            System.out.println("Enter your name: ");
            String name = scanner.nextLine();
            int age = 2018 - YearOfBirth;

            if (age >= 0 && age <= 100) {
                System.out.println("Your name is " + name + ", and you are " + age + " years old.");
            } else {
                System.out.println("Invalid year of birth.");
            }
        } else {
            System.out.println("Unable to parse year of birth.");
        }

        scanner.close();
    }
}
```









