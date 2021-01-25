---
title: Java 快速學習自我挑戰 Day12
thumbnail:
  - /images/learning/java/JavaDay12.jpg
toc: true
date: 2021-01-25 16:25:57
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay12.jpg">

***
### Arrays、Java 內建 List、Autoboxing 和 Unboxing
#### Arrays
1. 設置 Array，可以用以下兩種方式來進行設置
```
int[] myIntArray = new int[25];
int[] myIntArray = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
```
2. 賦予 Array 值
```
myIntArray[0] = 45;
myIntArray[1] = 476;
myIntArray[5] = 50;
```
3. 將 Array 列印出來，可以使用 .length 來取得 Array 的長度，避免錯誤發生
```
public static void main(String[] args) {
	    int[] myIntArray = new int[25];
        for (int i = 0; i < myIntArray.length; i++) {
            myIntArray[i] = i * 10;
        }
        printArray(myIntArray);
    }

    public static void printArray(int[] array) {
        for (int i = 0; i < array.length; i++) {
            System.out.println("Element " + i + ", value is " + array[i]);
        }
    }
```
4. 使用 Array 寫一個平均計算器
```
import java.util.Scanner;

public class Main {

    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        int[] myIntegers = getIntegers(5);
        for (int i = 0; i < myIntegers.length; i++) {
            System.out.println("Element " + i + ", typed value was " + myIntegers[i]);
        }
        System.out.println("The average is " + getAverage(myIntegers));
    }

    public static int[] getIntegers(int number) {
        System.out.println("Enter " + number + " integer values.\r");
        int[] values = new int[number];

        for (int i = 0; i < values.length; i++) {
            values[i] = scanner.nextInt();
        }

        return values;
    }

    public static double getAverage(int[] array) {
        int sum = 0;
        for (int i = 0; i < array.length; i++) {
            sum += array[i];
        }

        return (double) sum / (double) array.length;
    }
}
```
#### Array 挑戰
1. 題目
    Create a program using arrays that sorts a list of integers in descending order.
    Descending order is highest value to lowest.
    In other words if the array had the values in it [106, 26, 81, 5, 15] your program should ultimately have an array with [106, 81, 26, 15, 5] in it.
    Set up the program so that the numbers to sort are read in from the keyboard (Scanner).
    Implement the following methods: 
    getIntegers has one parameter of type int which is the size of the array. It returns an array of entered integers from the keyboard.=
    printArray accepts an array and prints out the contents of the array. It should be printed in the following format:
    Element 0 contents 106
    Element 1 contents 81
    Element 2 contents 26
    Element 3 contents 15
    Element 4 contents 5
    sortIntegers accepts the unsorted array. It should sort the array and return a new array containing the sorted numbers.
    The scenario is:

    1. getIntegers() is called.
    2. The returned array from getIntegers() is then used to call sortIntegers().
    3. The returned array from sortIntegers() is then printed to the console.
    [Do not try and implement this. It is to give you an idea of how the methods will be used]
    
    TIP: you will have to figure out how to copy the array elements from the passed array into a new array and sort them and return the new sorted array.
    TIP: Instantiate (create) the Scanner object inside the method.
    TIP: Be extremely careful about spaces in the printed message.
    NOTE: All methods should be defined as public static NOT public.
    NOTE: Do not add a main method to the solution code.
2. 答案
    1. 修改 Main.java
    ```
    import java.util.Scanner;

    public class Main {

        private static Scanner scanner = new Scanner(System.in);

        public static void main(String[] args) {
          int[] myIntegers = getIntegers(6);
          int[] sorted = sortIntegers(myIntegers);
            printArray(sorted);
        }

        public static int[] getIntegers(int capacity) {
            
            System.out.println("Enter " + capacity + " integer values:\r");
            int[] array = new int[capacity];

            for (int i = 0; i < array.length; i++) {
                array[i] = scanner.nextInt();
            }

            return array;
        }

        public static void printArray(int[] array) {
            for (int i = 0; i < array.length; i++) {
                System.out.println("Element " + i + " contents " + array[i]);
            }
        }

        public static int[] sortIntegers(int[] array) {
            int[] sortedArray = new int[array.length];
            for (int i = 0; i < array.length; i++) {
                sortedArray[i] = array[i];
            }

            boolean flag = true;
            int temp;
            while (flag) {
                flag = false;
                for (int i = 0; i < sortedArray.length - 1; i++) {
                    if (sortedArray[i] < sortedArray[i + 1]) {
                        temp = sortedArray[i];
                        sortedArray[i] = sortedArray[i + 1];
                        sortedArray[i + 1] = temp;
                        flag = true;
                    }
                }
            }

            return sortedArray;
        }
    }
    ```
    2. 以下程式碼可以進行優化
    ```
    int[] sortedArray = new int[array.length];
    for (int i = 0; i < array.length; i++) {
        sortedArray[i] = array[i];
    }
    // 可以用 Java 內建的語法優化
    int[] sortedArray = Arrays.copyOf(array, array.length);
    ```
3. 總結
    - Array 是一種數據結構可以讓你儲存多個同型態的值到一個變數中。
    - 默認的 Array 元素會設為 **0**。
    - Array 是從 **0** 開始索引的：Array 有 **n 個元素**的索引會**從 0 到 n-1**，例如：**10 個元素的索引是 0 到 9**。
    - 如果我們想要存取 Array 範圍外的索引，Java 會給我們 **ArrayIndexOutOfBoundsException** 的錯誤，這表示索引超出範圍。
    - 存取 Array 元素我們使用中括號 **[** 和 **]**，這就是 Array 存取運算符。
    - 例子 1
      - `int[] array = new int[5]`
      - 這個 Array 包含元素從 array[0] 到 array[4]。
      - 這 **5 個元素**的索引範圍是 **0** 到 **4**。
      - **new** 這個運算符或 Keyword 被用來創建 Array 或是初始化 Array 元素為它們的默認值。
      - 在這個例子，當 int Array 生成的時候，會初始化為 0。
      - 對於 **boolean** 的 Array 元素，會初始化為 **false**。
      - 對於 String 或是 Objects 會初始化為 **null**，後面課程會說更多關於 **null** 的內容。
    - 例子 2
      - `int[] myNumbers = {5, 4, 3, 2, 1};`
      - 我們可以使用初始化區塊 **{** 和 **}** 來初始化 array 為一行，我們定義的值必須要用逗號分開。
      - 這種初始化 Array 的方式稱為匿名 Array(Anonymous Array)。
      - 這 **5 個元素**的索引範圍是 **0** 到 **4**。
      - 在這個例子，Array 元素被分別初始化為 5, 4, 3, 2, 1。



