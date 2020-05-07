---
title: Java 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/java/JavaDay01.png
date: 2020-05-02 10:13:36
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay01.png">

***
### 課前準備
1. 問問題的技巧
    - 盡可能地精準的問問題：貼上程式碼，加一些畫面截圖。
    - 問別人沒問過的問題：在問問題之前，先找找看別人有沒有問過。
2. 成為工程師的四個階段
    - Unconcious Incompetence (無意識的無能)：在剛開始起步的時候，你不知道你不會什麼，所以不要做長期規劃，應該要專注在基礎上面。
    - Concious Incompetence (有意識的無能)：你做一些調查，有一些基礎，知道你不會什麼，所以你意識到你需要學這些不會的技能，同時，你也意識到獲得這些技能的價值。
    - Concious Competence (有意識的有能力)：在這個階段，你需要不斷讓自己沈浸在在練習之中，否則有些東西會開始遺忘，最重要的事，你學習的東西開始有意義。
    - Unconcious competence (無意識的有能力)：寫程式對你來說變成第二個本能，你會覺得寫程式很簡單，你寫程式的時候不需要總是過度專注，當你在寫程式的時候，你就會知道要使用哪種算法，他是自然而來的，因為你已經瞭解它了。
3. 總結：堅持下去，許下承諾會堅持你的訓練和練習，並且定期練習和學習。
### 環境部署
1. 為什麼安裝 JDK 11？
現行版本已經到 JDK 14，但是 JDK 11 是 LTS 版本，安全性更新會持續到 2026 年，目前大公司都持續使用這個版本，下個 LTS 版本為 JDK 17，預計 2021 年 9 月發佈。
2. 如何選擇正確的 JDK Vendor 和 JVM (Java Virtual Machine)？
    - Hotspot JVM 是最常用來部署的 JVM，OpenJ9 是 JVM 另外一個替代方案，OpenJ9 是開源的，佔用記憶體較少，而且比很多典型的應用還要更快。
    - Amazon Corretto 有免費技術支援，專注在 LTS 版本，還大量被使用在 Amazon 的生產環境服務器，而且 Amazon 把他們開發的程式碼在貢獻回去給 OpenJDK。
    - 對學生來說，哪個版本更好？[AdoptJDK](https://adoptopenjdk.net/) 是一個不錯的選擇，因為它安裝很容易；[Amazon Corretto](https://aws.amazon.com/corretto/) 是另外一個不錯的選擇。
#### 安裝 JDK (Java Development Kit)
1. 下載 [Amazon Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html)。
2. 安裝完成之後，在命令行執行 `java -version`，就會跳出 Java 的版本。
3. 安裝的路徑會在 /Library/Java/JavaVirtualMachines。
#### 安裝 IntelliJ IDEA
1. 下載 [IntelliJ IDEA](https://www.jetbrains.com/idea/download/#section=mac)。
2. 直接雙擊進行安裝，所有設定都用預設的。
#### 設定 IntelliJ IDEA
1. 進去編輯器之前，點擊右下角的 Configure -> Structure for New Projects，選擇 Project Settings -> Project -> Project JDK -> 選擇 Corretto JDK。
2. 選擇左邊列的 Platform Settings -> SDKs，將原本的 11 修改為 Corretto-11，以後有多種版本的 SDK 做切換時，名稱不會搞混，點選確認後回到選擇專案視窗。
3. 再次點擊右下角的 Configure -> Preferences -> Editor -> General -> Auto Import，將以下兩個選項打勾
    - Add unambiguous imports on the fly
    - Optimize imports on the fly (for current project)
4. 選擇 Preferences -> Editor -> General -> Code Folding，將以下四個選項取消勾選
    - General -> Imports
    - Java -> One-line methods
    - Java -> "Closures" (anonymous classes implementing one method, before Java 8)
    - Java -> Generic constructor and method parameters
### 第一步
#### 介紹
1. 這個部分會做一個 Hello World 專案，並介紹 Java 關鍵字、變數、資料型態、主方法、表達式、運算符、原始型別、字符串。
#### Hello World 專案
1. 選擇 Create New Project，選擇 Java，不勾選任何東西，選擇下一步，不使用任何 Template，選擇下一步，創建資料夾名稱 HelloWorld，最後選擇完成。
2. 在 src 的資料夾按右鍵，選擇 New -> Java Class，輸入 Hello 來新增 Class。
```
public class Hello { 
}
```
3. Java Class 的觀念
    - Java 的程式有關鍵字 (Keywords)，每一個都有個別的意義，而且有時候需要在特定順序下使用。
    - 藉由使用一些特定規則、使用關鍵字組合來撰寫 Java 程式，這些組合在一起就是一個 Java 程式。
    - 關鍵字是字母大小敏感的，public、Public 和 PUBLIC 是不一樣的。
    - **public** 和 **class** 是兩個 Java 關鍵字，它們有不同的意思。
    - **public** 關鍵字是存取修改器 (access modifier)，存取修改器可以讓我們定義範圍，或是哪些其它地方的程式碼或甚至其他人的程式碼可以存取這個程式碼。
    - 現在我們使用 public 來提供完整的存取權限。
    - 定義一個 class，**class** 關鍵字用來定義接下來的關鍵字 - Hello，Hello 在這個例子中用 {} 來定義 class 區塊。
    - 所以，定義一個 class 需要有可選擇的存取修改器，接著 class，後面再接著 {}。
    - {} 用來定義 class 的內容，任何內容在 {} 之間的都是 class 的一部分。
#### 定義主方法
1. 什麼是方法(method)？
方法是一個或多個展現功能的陳述句集合，我們會使用主方法(main method)讓 Java 在運行程式的時候會去尋找它，它是任何 Java 程式碼的入口處。
2. 你可以創建自己的方法，但是我們先創建主方法。
```
public class Hello {
    public static void main(String[] args) {
    }
}
```
3. 主方法觀念
    - **public** 是一個存取修改器，在定義 class 的時候就說過了。
    - **static** 是一個需要瞭解其他概念才能解釋的 Java 關鍵字，現在，只要知道我們需要一個 static 讓 Java 找到我們這個方法，並運行我們即將添加的程式碼。
    - **void** 是另外一個 Java 關鍵字，用來表示這個方法不會回傳任何東西，後面會說更多關於 void 的事情。
    - 方法宣告裡的 () 是一個強制、而且可選擇放入一個或多個變數，這些變數會傳進去方法裡面，後面一樣會說更多。
4. 可以在編輯器裡面嘗試運行主方法，選擇「Run 'Hello.main()'」

<img src="/images/learning/java/JavaDay01-Image01.png">

5. 程式碼區塊 (code block)
程式碼區塊是用來定義一個程式碼區塊，在一個方法宣告裡面，它是必要的，我們會在裡面新增一些陳述句來執行一些任務。
6. 在主方法裡面新增打印 Hello World
```
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}
```
7. 陳述句 (statement)
陳述句是一個完整可被執行的命令，而且可以包含一個或多個表達式(expression)，後面都會細說。
#### Hello World 挑戰和常見錯誤
1. 挑戰如何將你的名字打印出來？
```
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Vincent");
    }
}
```
2. 常見錯誤
    - ';' expected，沒有加分號
    - ')' expected，沒有加括號
    - Illegal line end in string literal，字符串文字沒有對應結尾
    - 如果執行之後出現錯誤，雙擊錯誤訊息可以直接跳到錯誤的那一行
#### 變數
1. 什麼是變數？
    - 變數是一種儲存資料在你的電腦中的一種方式，變數可以透過我們給予變數的名稱來被存取，而電腦會處理這些變數要儲存在記憶體的哪個地方。
    - 變數，就像名稱一樣，他的內容是可變的。
    - 我們要做的就是告知電腦我們想用變數儲存什麼類型的資料，然後給予這個變數一個名稱。
    - 我們可以為變數定義很多資料型態，這些被稱為資料型態(data types)，我們也可以猜到，資料型態在 Java 中也是一種關鍵字。
    - 所以，讓我們從定義 **int** 開始，**int** 是整數(integer)的縮寫，整數就是沒有任何小數點的數字。
    - 要定義一個變數，我們必須要指定資料型態，然後給予變數名稱，我們有時候使用一個表達式來初始化帶有值的變數。
2. 在主方法裡面定義一個 myFirstNumber
`int myFirstNumber = 5;`
3. 上面這一行就是一個宣告陳述句(declaration statement)
    - 宣告陳述句透過指出資料型態、名字、有時候設定變數的值來定義一個變數。
    - 在上面的宣告陳述句，我們定義一個 **int**，名字叫做 **myFirstNumber**，而且值被分派或是初始化為 **5**，所以我們在宣告一個變數為 **int** 型態、名字為 **myFirstNumber**，而且分派值為 **5**。
4. 什麼是表達式(expression)？
表達式是評估一個值的構造，我們在後面會討論更多。
5. 挑戰：查看第一個 **System.out.println** 陳述句，想想看如何在下面打印出 myFirstNumber 這個變數。
```
int myFirstNumber = 5;
System.out.println(myFirstNumber);
```
6. 在 Java 中，任何被兩個雙引號放在中間的內容，都會被當作字串符文字，他的值不像變數，是不能被改變。
`System.out.println("MyFirstNumber");`
7. 也可以對變數做運算。
```
int myFirstNumber = (10 + 5) + (2 * 10);
System.out.println(myFirstNumber);
```
8. Java 運算符(operators)
    - **Java 運算符**就是利用運算符號對一個變數或值進行操作，**+, -, \*, \/** 對應加減乘除。
    - 還有更多運算符，後面會做講解。
#### 開始使用表達式 (expression)
1. 挑戰：創建額外的變數，新增 **mySecondNumber**，它是 **int** 型態且指定數值為 **12**，另外新增 **myThirdNumber**，它是 **int** 型態且指定數值為 **6**。
2. 將這些變數相加後，打印出來。
```
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Vincent");

        int myFirstNumber = (10 + 5) + (2 * 10);
        int mySecondNumber = 12;
        int myThirdNumber = 6;
        int myTotal = myFirstNumber + mySecondNumber + myThirdNumber;

        System.out.println(myTotal);
    }
}
```
3. 也可以將在變數裡做其它變數的運算
```
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Vincent");

        int myFirstNumber = (10 + 5) + (2 * 10);
        int mySecondNumber = 12;
        int myThirdNumber = myFirstNumber * 2;
        int myTotal = myFirstNumber + mySecondNumber + myThirdNumber;

        System.out.println(myTotal);
    }
}
```
4. 挑戰：新增一個變數 **myLastOne**，它是 **int** 型態，且希望它的值是 **1000 減掉** myTotal 當前值，最後並打印出 **myLastOne**。
```
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, Vincent");

        int myFirstNumber = (10 + 5) + (2 * 10);
        int mySecondNumber = 12;
        int myThirdNumber = myFirstNumber * 2;
        int myTotal = myFirstNumber + mySecondNumber + myThirdNumber;

        System.out.println(myTotal);

        int myLastOne = 1000 - myTotal;
        System.out.println(myLastOne);
    }
}
```
#### 原始型態
1. Java 原始型態是最基本的資料型態，**int** 就是八個原始型態中的一個。
2. 八個原始型態分別是，**boolean，byte，char，short，int，long，float 和 double**，這些就是資料操作的基本組件。
3. Java 套包(Java Package)是用來組織你的 Java 專案的，要把這個當成是資料夾路徑，舉例來說 **com.company**，就是 **com** 底下有一個子目錄叫做 **company**，就是公司網域反過來寫。所以 company.com 會變成 com.company，後面會說到更多 Package 的東西。
4. 創建一個新的專案，這次在第二步驟的時候，把 Create project from template 打勾，專案名稱為 ByteShortIntLong，並將 base package 改為 com.company。
5. 包裝類(Wrapper Classes)，Java 使用包裝類的概念到八種原始型態，在 **int** 的案例中，我們可以使用 **Integer** 來向 int 執行操作。在這個例子中，我們使用 **MIN_VALUE** 和 **MAX_VALUE** 讓 Java 告訴我們 Integer 可以儲存的最大和最小的範圍。
```
int myMinIntValue = Integer.MIN_VALUE;
int myMaxIntValue = Integer.MAX_VALUE;
System.out.println("Integer Minimum Value = " + myMinIntValue);
System.out.println("Integer Maximum Value = " + myMaxIntValue);
```
6. 我們在 myMaxIntValue 加 1，會發現打印出來是負數，這個就稱為溢位(overflow)，反過來也是一樣，但是反過來的狀況叫做不足位(underflow)，這些狀況電腦會直接跳回最小數或最大數，這通常不是我們想要的，所以要注意。
```
System.out.println("Busted Max Value = " + (myMaxIntValue + 1));
System.out.println("Busted Min Value = " + (myMinIntValue - 1));
```
7. 後面會提到其它種類型的資料型態可以儲存更多資料，所以程式設計師要知道在哪種狀況下要使用哪種資料型態。
8. 在 Java7 版本之後，如果數字比較難以閱讀的話，可以用底線分隔開，系統一樣可以讀出來。例如：`int myMaxIntText = 2_147_483_647`
#### Byte，Short，Long 和寬度
1. 使用和剛剛一樣的方式把 Byte 最大和最小值打印出來，通常來說，在現在電腦非常資源非常充足的情況下，使用 byte 的情況會比較少，如果考慮效能問題，這個可能是其中一個原因，它比較節省空間，速度也比較快。
```
byte myMinByteValue = Byte.MIN_VALUE;
byte myMaxByteValue = Byte.MAX_VALUE;
System.out.println("Byte Minimum Value = " + myMinByteValue);
System.out.println("Byte Maximum Value = " + myMaxByteValue);
```
2. 繼續用剛剛的方法，將 Short 的最大和最小值打印出來，最大值為 32767，最小值為 -32768，所以 Byte 和 Short 有相同的溢位和不足位的問題，但是它們有不同的範圍。
```
short myMinShortValue = Short.MIN_VALUE;
short myMaxShortValue = Short.MAX_VALUE;
System.out.println("Short Minimum Value = " + myMinShortValue);
System.out.println("Short Maximum Value = " + myMaxShortValue);
```
3. 原始型態的大小和寬度
    - 一個 **Byte** 佔用 8 位元(bit)，一個位元並不是原始型態，我們有 **boolean**，但是它跟 Byte 完全不是同一件事情，後面會細說，所以一個 **Byte** 佔用 **8 位元**，我們可以說 **byte** 的寬度為 **8**。
    - **short** 可以儲存大量數字，佔用 **16** 位元，所以寬度為 **16**。
    - **int** 可以儲存更大量數字，佔用 **32** 位元，所以寬度為 **32**。
    - 不同的原始型態佔用不同的記憶體大小，我們可以知道 **int** 跟 **byte** 比起來，佔用了 4 倍的記憶體。
    - 這些數字對對你來說並不是特別相關，但是面試作為題目的時候，知道特定資料類型佔用不同的空間是有用的。
4. Long 佔用 64 位元，是 Int 的 2 倍，在宣告 Long 的時候，如果值比 Integer 的最大值還要大的時候，需要在值後面加上 L，否則會出現錯誤，因為 Java 會把數字當成 Integer 來處理。
```
long bigLongLiteralValue = 2_147_483_647_123L;
System.out.println(bigLongLiteralValue);  
```