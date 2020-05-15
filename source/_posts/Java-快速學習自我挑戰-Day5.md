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






