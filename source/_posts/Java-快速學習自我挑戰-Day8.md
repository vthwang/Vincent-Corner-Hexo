---
title: Java 快速學習自我挑戰 Day8
thumbnail:
  - /images/learning/java/JavaDay08.png
date: 2020-06-19 01:35:23
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay08.png">

***
### 物件導向程式設計 (OOP) - Classes, Constructors 和 Inheritance
#### Classes
1. 真實世界的物件有兩種特徵，狀態(State)和行為(Behavior)，在物件導向程式裡面，同樣也有狀態和行為。Class 則是用來創建物件的模板，前面我們使用的都是原始資料型態(Primtive Data Type)，可以用的非常有限，而使用 Class 可以自定義資料型態，雖然在真實意義上這麼說，並不是很準確，但是我們可以知道 Class 能夠有強力的用戶自定義資料型態。
2. 在 src 目錄底下點選右鍵，New > Java Class 新增 Car。
```
public class Car {

    private int doors;
    private int wheels;
    private String model;
    private String engine;
    private String color;

    public void setModel(String model) {

        String validModel = model.toLowerCase();

        if (validModel.equals("carrera") || validModel.equals("commodore")) {

            this.model = model;
        } else {

            this.model = "Unknown";
        }

    }

    public String getModel() {

        return this.model;
    }
}
```
3. 在 Main 引入 class 並使用。
```
public class Main {

    public static void main(String[] args) {

        Car porsche = new Car();
        Car holden = new Car();

        porsche.setModel("Carrera");

        System.out.println("Model is " + porsche.getModel());

    }
}
```
