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


