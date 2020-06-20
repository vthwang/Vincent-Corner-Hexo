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
import java.util.Scanner;
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
#### 讀取用戶輸入挑戰
1. 挑戰
- Read **10** numbers from the console entered by the user and print the sum of those numbers.
- Create a **Scanner** like we did in the previous video.
- Use the **hasNextInt()** method from the scanner to check if the user has entered an **int** value.
- If **hasNextInt()** returns **false**, print the message "**Invalid Number**". Continue reading nutil you have read **10** numbers.
- Before the user enters each number, print the message "**Enter number #x:**" where **x** represents the count, i.e. **1, 2, 3, 4,** etc.
- For example, the first message printed to the user would be "**Enter number #1:**", the next "**Enter number #2:**", and so on.
- Hint:
    - Use a **while** loop.
    - Use a **counter** variable for counting valid nubmers.
    - Close the scanner after you don't need it anymore.
    - Create a project with the name **ReadingUserInputChallenge**.
2. 答案
```
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        int counter = 1;
        int sum = 0;
        while (counter <= 10) {

            System.out.println("Enter number #" + counter + ":");

            boolean isAnInt = scanner.hasNextInt();
            if (!isAnInt) {
                System.out.println("Invalid Value");
                // handle the enter character
                scanner.nextLine();
                continue;
            }

            sum += scanner.nextInt();
            System.out.println("The sum of numbers: " + sum);
            counter++;
        }

        scanner.close();
    }
}
```
#### 最小和最大挑戰
1. 挑戰
- Read the numbers from the console entered by the user and print the minimum and maximum number the user has entered.
- Befroe the user enters the number, print the message "**Enter number:**".
- If the user enters an invalid number, break out of the loop and print the minimum and maximum number.
- Hint:
    - Use an endless **while** loop.
- Bonus:
    - Create a project with the name **MinAndMaxInputChanllenge**.
2. 答案
```
import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        Scanner scanner = new Scanner(System.in);

        int Min = 0;
        int Max = 0;
        while (true) {

            System.out.println("Enter number:");

            boolean isAnInt = scanner.hasNextInt();
            if (!isAnInt) {
                System.out.println("Invalid Value");
                break;
            }

            int input = scanner.nextInt();
            if (Min == 0 && Max == 0) {
                Min = input;
                Max = input;
            } else if (input > Max) {
                Max = input;
            } else if (input < Min) {
                Min = input;
            }

            scanner.nextLine(); //handle input
        }

        System.out.println("The min value is " + Min + ", and the max value is " + Max);

        scanner.close();
    }
}
```
#### 輸入計算機
1. 挑戰
Write a method called inputThenPrintSumAndAverage that does not have any parameters.
The method should not return anything (void) and it needs to keep reading int numbers from the keyboard.
When the user enters something that is not an int then it needs to print a message in the format "SUM = XX AVG = YY".
XX represents the sum of all entered numbers of type int.
YY represents the calculated average of all numbers of type long.

```
EXAMPLES OF INPUT/OUTPUT:
EXAMPLE 1:
INPUT:
1
2
3
4
5
a
OUTPUT
SUM = 15 AVG = 3

EXAMPLE 2:
INPUT:
hello

OUTPUT:
SUM = 0 AVG = 0
```

TIP: Use Scanner to read an input from the user.
TIP: Use casting when calling the round method since it needs double as a parameter.

NOTE: Use the method Math.round to round the calculated average (double). The method round returns long.
NOTE: Be mindful of spaces in the printed message.
NOTE: Be mindful of users who may type an invalid input right away (see example above).
NOTE: The method inputThenPrintSumAndAverage should be defined as public static like we have been doing so far in the course.
NOTE: Do not add the main method to the solution code.
2. 答案
```
import java.util.Scanner;
 
public class InputCalculator {
    public static void inputThenPrintSumAndAverage() {

        Scanner scanner = new Scanner(System.in);

        int sum = 0;
        int average = 0;
        int count = 1;
        while (true) {
            // 監控輸入內容
            boolean isAnInt = scanner.hasNextInt();
            if (!isAnInt) {
                System.out.println("SUM = " + sum + " AVG = " + average);
                break;
            }

            sum += scanner.nextInt();
            average = Math.round((float) sum / (float) count);
            count++;
        }

        scanner.close();
    }
}
```
#### 畫畫的工作
1. 挑戰

Bob is a wall painter and he needs your help. You have to write a program that helps Bob calculate how many buckets of paint he needs to buy before going to work. Bob might also have some extra buckets at home. He also knows the area that he can cover with one bucket of paint.

1. Write a method named getBucketCount with 4 parameters. The first parameter should be named width of type double. This parameter represents the width of the wall.

The second parameter should be named height of type double. This parameter represents the height of the wall.
The third parameter should be named areaPerBucket. This parameter represents the area that can be covered with one bucket of paint.
The fourth parameter should be named extraBuckets. This parameter represents the bucket count that Bob has at home.
The method needs to return a value of type int that represents the number of buckets that Bob needs to buy before going to work. To calculate the bucket count, refer to the notes below.
If one of the parameters width, height or areaPerBucket is less or equal to 0 or if extraBuckets is less than 0, the method needs to return -1 to indicate an invalid value.
If all parameters are valid, the method needs to calculate the number of buckets and return it.

```
Examples of input/output:
*getBucketCount(-3.4, 2.1, 1.5, 2); → should return -1 since the width parameter is invalid
*getBucketCount(3.4, 2.1, 1.5, 2); → should return 3 since the wall area is 7.14, a single bucket can cover an area of 1.5 and Bob has 2 extra buckets home.
*getBucketCount(2.75, 3.25, 2.5, 1); → should return 3 since the wall area is 8.9375, a single bucket can cover an area of 2.5 and Bob has 1 extra bucket at home.
```

2. Bob does not like to enter 0 for the extraBuckets parameter so he needs another method.

Write another overloaded method named getBucketCount with 3 parameters namely width, height, and areaPerBucket (all of type double).
This method needs to return a value of type int that represents the number of buckets that Bob needs to buy before going to work. To calculate the bucket count, refer to the notes below.
If one of the parameters width, height or areaPerBucket is less or equal to 0, the method needs to return -1 to indicate an invalid value.
If all parameters are valid, the method needs to calculate the number of buckets and return it.

```
Examples of input/output:
*getBucketCount(-3.4, 2.1, 1.5); → should return -1 since the width parameter is invalid
*getBucketCount(3.4, 2.1, 1.5); → should return 5 since the wall area is 7.14, and a single bucket can cover an area of 1.5.
*getBucketCount(7.25, 4.3, 2.35); → should return 14 since the wall area is 31.175, and a single bucket can cover an area of 2.35.
```

3. In some cases, Bob does not know the width and height of the wall but he knows the area of a wall. He needs you to write another method.

Write another overloaded method named getBucketCount with 2 parameters namely, area and areaPerBucket (both of type double).
The method needs to return a value of type int that represents the number of buckets that Bob needs to buy before going to work. To calculate the bucket count, refer to the notes below.
If one of the parameters area or areaPerBucket is less or equal to 0, the method needs to return -1to indicate an invalid value.
If all parameters are valid, the method needs to calculate the number of buckets and return it.

```
Examples of input/output:
*getBucketCount(3.4, 1.5); → should return 3 since the area is 3.4 and a single bucket can cover an area of 1.5
*getBucketCount(6.26, 2.2); → should return 3 since the wall area is 6.26 and a single bucket can cover an area of 2.2.
*getBucketCount(3.26, 0.75); → should return 5 since the wall area is 3.26, and a single bucket can cover an area of 0.75 .
```

Do your best to help Bob.
NOTE: Use the method Math.ceil to round the number of calculated buckets (double) then convert it into an int before returning the value from the methods.
NOTE: All methods should be defined as public static like we have been doing so far in the course.
NOTE: Do not add the main method to the solution code.

2. 答案
```
public class PaintJob {
    public static int getBucketCount(double width, double height, double areaPerBucket, int extraBuckets) {

        if (width <= 0 || height <= 0 || areaPerBucket <= 0 || extraBuckets < 0) {

            return -1;
        }

        double area = width * height;
        double leftArea = area - (areaPerBucket * extraBuckets);

        return (int) Math.ceil(leftArea / areaPerBucket);
    }

    public static int getBucketCount(double width, double height, double areaPerBucket) {

        if (width <= 0 || height <= 0 || areaPerBucket <= 0) {

            return -1;
        }

        double area = width * height;

        return (int) Math.ceil(area / areaPerBucket);
    }

    public static int getBucketCount(double area, double areaPerBucket) {

        if (area <= 0 || areaPerBucket <= 0) {

            return -1;
        }

        return (int) Math.ceil(area / areaPerBucket);
    }
}
```