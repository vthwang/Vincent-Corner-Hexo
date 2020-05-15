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









