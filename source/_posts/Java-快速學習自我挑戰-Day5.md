---
title: Java 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/java/JavaDay05.jpg
date: 2020-05-15 19:47:01
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay05.jpg">

***
### 控制流陳述句(Control Flow Statements)
#### Switch 陳述句
1. Switch 陳述句就是 if-else 的取代版本，如果條件很多的情況下，用 switch 會更簡潔，也可以同時定義很多 case 並執行一種命令。最重要的是，每個 case 最後面一定要加上 break，否則會繼續執行，最後一個可以不加，但是為了程式碼的完整性，會建議加上。
```
int switchValue = 1;
switch (switchValue) {
    case 1:
        System.out.println("Value was one");
        break;
    case 2:
        System.out.println("Value was two");
        break;
    case 3: case 4: case 5:
        System.out.println("was a 3, or a 4, or a 5");
        System.out.println("Actually, it was " + switchValue);
        break;
    default:
        System.out.println("Was not one or two");
        break;
}
```
2. 挑戰
Create a new switch statement using char instead of int
create a new char variable
create a switch statement testing for
A, B, C, D or E
display a message if any of these are found and then break
Add a default which displays a message saying not found
3. 挑戰(答案)
```
char charValue = 'A';
switch (charValue) {
    case 'A': case 'B': case 'C': case 'D': case 'E':
        System.out.println(charValue + " was found.");
        break;

    default:
        System.out.println("Could not found A, B, C, D or E");
        break;
}
```
#### 星期挑戰
1. 挑戰
    - Write a method with the name **printDayOfTheWeek** that has one parameter of type **int** and name it **day**.
    - The method should not return any value (hint: void)
    - Using a switch statement print "**Sunday**", "**Monday**", ..., "**Saturday**" if the **int** parameter "**day**" is **0, 1, ..., 6** respectively, otherwise it should print "**Invalid day**"
    - Bonus
      - Write a second solution using if then else, instead of using switch.
      - Create a new project in IntelliJ with the name "**DayOfTheWeekChallenge**"
2. 挑戰(答案)
```
public static void main(String[] args) {
    printDayOfTheWeek(-1);
    printDayOfTheWeek(0);
    printDayOfTheWeek(1);
    printDayOfTheWeek(2);
    printDayOfTheWeek(3);
    printDayOfTheWeek(4);
    printDayOfTheWeek(5);
    printDayOfTheWeek(6);

    printDayOfTheWeekIf(-1);
    printDayOfTheWeekIf(0);
    printDayOfTheWeekIf(1);
    printDayOfTheWeekIf(2);
    printDayOfTheWeekIf(3);
    printDayOfTheWeekIf(4);
    printDayOfTheWeekIf(5);
    printDayOfTheWeekIf(6);

}

private static void printDayOfTheWeek(int day) {
    switch (day) {
        case 0:
            System.out.println("Sunday");
            break;
        case 1:
            System.out.println("Monday");
            break;
        case 2:
            System.out.println("Tuesday");
            break;
        case 3:
            System.out.println("Wednesday");
            break;
        case 4:
            System.out.println("Thursday");
            break;
        case 5:
            System.out.println("Friday");
            break;
        case 6:
            System.out.println("Saturday");
            break;

        default:
            System.out.println("Invalid day");
            break;
    }
}

private static void printDayOfTheWeekIf(int day) {
    if (day == 0) {
        System.out.println("Sunday");
    } else if (day == 1) {
        System.out.println("Monday");
    } else if (day == 2) {
        System.out.println("Tuesday");
    } else if (day == 3) {
        System.out.println("Wednesday");
    } else if (day == 4) {
        System.out.println("Thursday");
    } else if (day == 5) {
        System.out.println("Friday");
    } else if (day == 6) {
        System.out.println("Saturday");
    } else {
        System.out.println("Invalid day");
    }
}
```
#### 挑戰
##### 題目一
Write a method called printNumberInWord. The method has one parameter number which is the whole number. The method needs to print "ZERO", "ONE", "TWO", ... "NINE", "OTHER" if the int parameter number is 0, 1, 2, .... 9 or other for any other number including negative numbers. You can use if-else statement or switch statement whatever is easier for you.

NOTE: Method printNumberInWord needs to be public static for now, we are only using static methods.
NOTE: Do not add main method to solution code.
##### 題目一(答案)
```
public class NumberInWord {
    public static void printNumberInWord(int number) {
        switch (number) {
            case 0:
                System.out.println("ZERO");
                break;
            case 1:
                System.out.println("ONE");
                break;
            case 2:
                System.out.println("TWO");
                break;
            case 3:
                System.out.println("THREE");
                break;
            case 4:
                System.out.println("FOUR");
                break;
            case 5:
                System.out.println("FIVE");
                break;
            case 6:
                System.out.println("SIX");
                break;
            case 7:
                System.out.println("SEVEN");
                break;
            case 8:
                System.out.println("EIGHT");
                break;
            case 9:
                System.out.println("NINE");
                break;

            default:
                System.out.println("OTHER");
                break;
        }
    }
}
```
#### 題目二
Write a method isLeapYear with a parameter of type int named year. 
The parameter needs to be greater than or equal to 1 and less than or equal to 9999.
If the parameter is not in that range return false. 
Otherwise, if it is in the valid range, calculate if the year is a leap year and return true if it is, otherwise return false. 
A year is a leap year if it is divisible by 4 but not by 100, or it is divisible by 400.

```
Examples of input/output:
* isLeapYear(-1600); →  should return false since the parameter is not in the range (1-9999)
* isLeapYear(1600); → should return true since 1600 is a leap year
* isLeapYear(2017); → should return false since 2017 is not a leap year
* isLeapYear(2000); → should return true because 2000 is a leap year 
```

​NOTE:  The solution to the Leap Year coding exercise earlier in the course created the isLeapYear method. You can use that solution if you wish.
Write another method getDaysInMonth with two parameters month and year.  ​Both of type int.
If parameter month is < 1 or > 12 return -1. ​
If parameter year is < 1 or > 9999 then return -1.
This method needs to return the number of days in the month. Be careful about leap years they have 29 days in month 2 (February).
You should check if the year is a leap year using the method isLeapYear described above.

```
Examples of input/output:
* getDaysInMonth(1, 2020); → should return 31 since January has 31 days.
* getDaysInMonth(2, 2020); → should return 29 since February has 29 days in a leap year and 2020 is a leap year.
* getDaysInMonth(2, 2018); → should return 28 since February has 28 days if it's not a leap year and 2018 is not a leap year.
* getDaysInMonth(-1, 2020); → should return -1 since the parameter month is invalid.
* getDaysInMonth(1, -2020); → should return -1 since the parameter year is outside the range of 1 to 9999.
```

HINT: Use the switch statement.
NOTE: Methods isLeapYear and getDaysInMonth need to be public static like we have been doing so far in the course.
NOTE: Do not add a main method to solution code.
#### 題目二(答案)
```
public class NumberOfDaysInMonth {
    public static boolean isLeapYear(int year) {

        if (year < 1 || year > 9999) {
            return false;
        }

        int yearDividedByFour = year % 4;
        int yearDividedByHundred = year % 100;
        int yearDividedByFourHundred = year % 400;

        return (yearDividedByFour == 0 && yearDividedByHundred == 0 && yearDividedByFourHundred == 0) || (yearDividedByFour == 0 && yearDividedByHundred != 0);
    }

    public static int getDaysInMonth(int month, int year) {

        if ((month < 1 || month > 12) || (year < 1 || year > 9999)) {
            return -1;
        }

        if (isLeapYear(year)) {
            switch (month) {
                case 1: case 3: case 5: case 7: case 8: case 10: case 12:
                    return 31;
                case 2:
                    return 29;
                case 4: case 6: case 9: case 11:
                    return 30;
            }
        }

        switch (month) {
            case 1: case 3: case 5: case 7: case 8: case 10: case 12:
                return 31;
            case 2:
                return 28;
            case 4: case 6: case 9: case 11:
                return 30;
        }
        
        return -1;
    }
}
```
#### For 陳述句
1. For 迴圈又被稱為迭代(iteration)，在 increment 的地方，會根據條件執行疊加，可以一次加 1，也可以加 5，在 conditon 的地方設定條件，如果條件為 false，這個回圈(Loop) 就不會繼續執行，在 init 的地方定義起始值。另外，分號是必要的，不能省略。
```
for (init; condition; increment) {
    execute line (code block)
}
```
2. 下面這個程式碼會不會回傳任何東西，因為 number 永遠符合條件，這種迴圈稱為無止盡迴圈(endless loop)，很多情況下，它可能會導致程式錯誤，或是用盡記憶體。
```
for (int number = 100; number > 0; number += 10) {
    System.out.println("number = " + number);
}
```
3. 使用 For 迴圈查詢某一範圍的數字是否為質數，回傳的結果可以用 String.format 來避免回傳過多位數。也可以使用 break 讓程式跳離 For 迴圈。
```
public static void main(String[] args) {

    for (int i=2; i<9; i++) {
        System.out.println("10000 at " + i + "% interest = " + String.format("%.2f", calculateInterest(10000.0, i)));
    }

    for (int i=8; i>1; i--) {
        System.out.println("10000 at " + i + "% interest = " + String.format("%.2f", calculateInterest(10000.0, i)));
    }

    int count = 0;

    for (int i=10; i<50; i++) {
        if (isPrime(i)) {
            count++;
            System.out.println("Number " + i + " is a prime number.");
        }

        if (count == 3) {
            System.out.println("Exiting for loop");
            break;
        }
    }
}

public static boolean isPrime(int n) {

    if (n == 1) {
        return false;
    }

    for (int i = 2; i <= n/2; i++) {
        if (n % i == 0) {
            return false;
        }
    }

    return true;
}
```
#### 3 和 5 之和挑戰
1. 挑戰
    - Create a for statement using a range of numbers from **1** to **1000** inclusive.
    - **Sum** all the numbers that can be divided with both **3** and also with **5**
    - For those numbers that met the above conditions, print out the number.
    - **break** out of the loop once you find **5** numbers that met the above condtions.
    - After breaking out of the loop print the **sum** of the numbers that met the above conditions.
    - Note: Type all code in main method
2. 挑戰(答案)
```
public static void main(String[] args) {

    int count = 0;
    int sum = 0;

    for (int i = 1; i <= 1000; i++) {
        if (i % 3 == 0 && i % 5 == 0) {
            count++;
            sum += i;
            System.out.println("Found number = " + i);
        }

        if (count == 5) {
            break;
        }
    }

    System.out.println("Sum = " + sum);
}
```
#### 奇數之和挑戰
1. 挑戰
Write a method called isOdd with an int parameter and call it number. The method needs to return a boolean.
Check that number is > 0, if it is not return false.
If number is odd return true, otherwise  return false.
Write a second method called sumOdd that has 2 int parameters start and end, which represent a range of numbers.
The method should use a for loop to sum all odd numbers  in that range including the end and return the sum.
It should call the method isOdd to check if each number is odd.
The parameter end needs to be greater than or equal to start and both start and end parameters have to be greater than 0.
If those conditions are not satisfied return -1 from the method to indicate invalid input. 

```
Example input/output:
* sumOdd(1, 100); → should return 2500
* sumOdd(-1, 100); →  should return -1
* sumOdd(100, 100); → should return 0
* sumOdd(13, 13); → should return 13 (This set contains one number, 13, and it is odd)
* sumOdd(100, -100); → should return -1
* sumOdd(100, 1000); → should return 247500
```

TIP: use the remainder operator to check if the number is odd
NOTE: Both methods  needs to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a  main method to solution code.
2. 挑戰(答案)
```
public class SumOddRange {
    public static boolean isOdd(int number) {

        return number > 0 && number % 2 != 0;
    }

    public static int sumOdd(int start, int end) {

        if (start < 0 || end < 0 || end < start) {
            return -1;
        }

        int sum = 0;

        for (int i = start; i <= end; i ++) {
            if (isOdd(i)) {
                sum += i;
            }
        }

        return sum;
    }
}
```
#### while 和 do 陳述句
1. while 語法，{} 裡面定義迴圈程式碼區塊，condition 的部分加上條件。
```
while (condition) {

}
```
2. do-while 語法，最後的分號是必要的，{} 裡面定義迴圈程式碼區塊，do-while 至少會執行一次，然後才會檢查條件。
```
do {

} while (condition);
```
3. 使用 while 寫出跟 for 陳述句一樣語法，基本上邏輯都是一樣的，有 init 起始值、condition 條件以及 increment 增加值，
```
// while 語法
int count = 1;
while (count < 5) {
    System.out.println("count = " + count)
    count ++;
}

// for 語法
for (int i = 0; i < 5; i++) {
    System.out.println("i = " + i)
}
```
4. 在 while 迴圈裡面使用 **continue** 可以跳過後面的所有程式碼，使用 **break** 可以脫離迴圈。
5. **while** 迴圈在執行程式碼之前就會先檢查條件， **do-while** 迴圈至少會將程式碼區塊執行過一次，才檢查條件，所以要小心條件，**很容易** 會進入無止盡的迴圈或是沒有執行的迴圈。
6. **秘訣：總是檢查條件和表達式(condtions/expressions)**
7. 
Create a method called isEvenNumber that takes a parameter of type int.
Its purpose is to determine if the argument passed to the method is an even number or not.
return true if an even number, otherwise return false.

Make it record the total number of even numbers it has found and break once 5 found and at the end, display the total number of even numbers found.
8. 挑戰(答案)
```
public static void main(String[] args) {
    int number = 4;
    int finishNumber = 20;
    int evenNumbersFound = 0;

    while (number <= finishNumber) {
        number++;

        if (!isEvenNumber(number)) {
            continue;
        }

        System.out.println("Even number = " + number);

        evenNumbersFound++;
        if (evenNumbersFound == 5) {
            break;
        }
    }

    System.out.println("Total even numbers found = " + evenNumbersFound);
}

public static boolean isEvenNumber(int number) {
    return number % 2 == 0;
}
```