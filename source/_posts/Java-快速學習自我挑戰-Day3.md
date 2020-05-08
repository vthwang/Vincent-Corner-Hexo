---
title: Java 快速學習自我挑戰 Day3
thumbnail:
  - /images/learning/java/JavaDay03.jpg
date: 2020-05-07 16:51:10
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




