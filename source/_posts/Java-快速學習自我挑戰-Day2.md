---
title: Java 快速學習自我挑戰 Day2
thumbnail:
  - /images/learning/java/JavaDay02.jpg
date: 2020-05-06 12:48:45
categories: Study Note
tags: Java
toc: true
---
<img src="/images/learning/java/JavaDay02.jpg">

***
### 第一步 - PartII
#### Java 型態轉換(Java Casting)
1. Casting 就是將數字從一個型態轉為另一個型態，我們將我們想要的型態放到 () 裡面，像這樣：`(byte) (myMinByteValue / 2)`
2. 其它語言也有型態轉換，這不是 Java 獨有的功能。
3. 如果不指定型態，Java 會默認為 Integer。
#### 原始型態挑戰
1. 挑戰：創建一個 **byte** 變數並設為有效的 **byte** 數字，再創建一個 **short** 和 **int**，也同樣設為有效的 **short** 和 **int** 數字，最後，再創建一個 **long** 的變數等於 50000 + 10 * (byte 值 + short 值 + integer 值)。
2. 整體來說，Integer 是最好的原始型態，就算你使用 Long，你會看到 Java 為你解決了很多複雜的問題，你不需要對 Long 做型態轉換，因為 Long 會接受 Integer (最大的 Integer 一定可以放進去 Long 裡面)，
```
public class Main {

    public static void main(String[] args) {

        byte byteValue = 10;
        short shortValue = 20;
        int intValue = 50;
        long longTotal = 50000L + 10L * (byteValue + shortValue + intValue);
        System.out.println(longTotal);

        short shortTotal = (short) (1000 + 10 * (byteValue + shortValue + intValue));
        System.out.println(shortTotal);
    }
}
```
#### 原始型態的浮點數和倍精度浮點數(float & double)
1. 不像整數，浮點數有小數點，**3.14159** 就是一個浮點數。
2. 浮點數又稱為實數(real number)，當我們在計算需要精度更高的時候，我們就會用浮點數。
3. 精度 (precision) 指的是被型態佔用的格式和數量，單精度佔用 32 位元(也就是寬度 32)，雙精度佔用 64 位元(也就是寬度 64)。
4. **浮點數** 的範圍是 **1.4E-45** 到 **3.4028235E+38**，而**雙精度**更精確，範圍是 **4.9E-324** 到 **1.7976931348623157E+308**。透過以下程式碼可以驗證原始型態的範圍。
```
float myMinFloatValue = Float.MIN_VALUE;
float myMaxFloatValue = Float.MAX_VALUE;
System.out.println("Float minimum value = " + myMinFloatValue);
System.out.println("Float maximum value = " + myMaxFloatValue);

double myMinDoubleValue = Double.MIN_VALUE;
double myMaxDoubleValue = Double.MAX_VALUE;
System.out.println("Double minimum value = " + myMinDoubleValue);
System.out.println("Double maximum value = " + myMaxDoubleValue);
```
5. 我們定義三個變數，發現如果新增一個 float 的變數，會出現錯誤，是因為在浮點數，默認為 double，所以在後面加一個 f 宣告為 float 就不會出現錯誤。
```
int myIntValue = 5;
float myFloatValue = 5.25f;
double myDoubleValue = 5.25;
```
6. 挑戰：前面用 type casting 將 **byte** 和 **short** 轉換為 **int**，你想想要怎麼對 **float** 做轉換來消除錯誤呢？
直接在前面加上 (float) 做型態轉換。
`float myFloatValue = (float) 5.25;`
7. 現在不推薦使用 float，double 浮點數才是首選的浮點數型態，而且不推薦使用 type casting，直接在後面加上 f 是更簡單的做法。
#### 浮點數精度和一個挑戰
1. 直接將這些變數打印出來，會發現 float 和 double 打印出來的都是 5.0，因為是浮點數。
```
int myIntValue = 5;
float myFloatValue = 5f;
double myDoubleValue = 5d;
System.out.println("MyIntValue = " + myIntValue);
System.out.println("myFloatValue = " + myFloatValue);
System.out.println("myDoubleValue = " + myDoubleValue);
```
2. 對這些變數做運算，int 會出現 2，因為它是整數，剩下的打印出 2.5，因為浮點數可以計算小數點，所以會得到比較精準的答案。
```
int myIntValue = 5 / 2;
float myFloatValue = 5f / 2f;
double myDoubleValue = 5d / 2d;
System.out.println("MyIntValue = " + myIntValue);
System.out.println("myFloatValue = " + myFloatValue);
System.out.println("myDoubleValue = " + myDoubleValue);

------
MyIntValue = 2
myFloatValue = 2.5
myDoubleValue = 2.5
```
3. 這時候再改除以 3，在這邊就可以看到 double 比 float 還要更精準。
```
int myIntValue = 5 / 3;
float myFloatValue = 5f / 3f;
double myDoubleValue = 5d / 3d;
System.out.println("MyIntValue = " + myIntValue);
System.out.println("myFloatValue = " + myFloatValue);
System.out.println("myDoubleValue = " + myDoubleValue);

------
MyIntValue = 1
myFloatValue = 1.6666666
myDoubleValue = 1.6666666666666667
```
4. 也可以不用 d，直接在數字後面加上 .00 對 Java 來說就會是 double 的浮點數。
`double myDoubleValue = 5.00 / 3.00;`
5. 為什麼使用 double?
    - 在現代的電腦，相同的 double 數值比 float 數值還要快。
    - Java 庫裡面，特定的數學函式時常用有一種特定寫法來處理 double 而不是 float，而且結果都是回傳 double 的。
    - 它更精確，而且可以處理更大量的數字。
    - 在現實世界中，很多庫都用 double，也正因為如此，如果你不指定資料型態為 d 或 f，Java 會默認 double 是浮點數的資料型態。
6. 挑戰：將磅轉換為公斤
    - 步驟一：創建一個適合的變數儲存磅，並讓它轉換為公斤。
    - 步驟二：計算結果。例如：公斤數根據磅的變數來計算，再創建一個適合的變數儲存公斤。
    - 步驟三：打印出結果。
    - 提示：**1** 磅等於 **0.45359237** 公斤。
```
double numberOfPounds = 200d;
double convertedKilograms = numberOfPounds * 0.45359237d;
System.out.println("Converted kilograms = " + convertedKilograms);
```
7. double 一樣也可以用 _ 來分隔，讓閱讀更容易。
`double anotherNumber = 3_000_000.4_567_890d;`
8. 重點整理
    - 整理來說，**float** 和 **double** 對一般浮點數操作都是很棒的，但是兩者對需要精確計算的地方並不好，這是因為浮點數儲存的限制，並不是 Java 的問題。
    - Java 有一個 class 叫做 **BigDecimal** 可以克服這個的問題，我們後面會講到，但是要記得像是貨幣的計算，需要精度非常準確的計算，浮點數是不能使用的。
#### 原始型態 Char 和 Boolean
1. char 只能儲存一個字元(character)，什麼情況下會用到這種原始型態，像是遊戲裡面會記錄使用者最後打入的按鍵。
2. 一個 **char** 佔用 2 位元組，也就是 16 位元，因此他的寬度為 16，它不是**1 位元組**的原因是它允許儲存一個 Unicode 字母。
3. **Unicode** 是一種國際編碼標準，用在不同語言和腳本中，每一個字母、數字和符號都有獨一無二的數值可以用在不同的平台和程式。
4. 在英文字母中，只有 A-Z 26 個字母，也就是說只要 26 個字元就能表示整個英文字母，但是其它語言需要更多字元，通常是多很多。
5. **Unicode** 允許我們使用 **2 位元組**來表示這些語言，**char** 在記憶體中可以表示 **65535** 個不同型態字元中的其中一個。
6. 可以去 [Unicode Table](https://unicode-table.com/) 查看 Unicode 的表，可以用 \u 表示 Unicode。
```
char myChar = 'D';
char myUnicodeChar = '\u0044';
System.out.println(myChar);
System.out.println(myUnicodeChar);
```
7. 也可以測試將著作權的符號打印出來。
```
char myCopyrightChar = '\u00A9';
System.out.println(myCopyrightChar);
```
8. 布林(Boolean)原始型態：布林值允許兩種選擇，**True** 或 **False**，**Yes** 或 **No**，**1** 或 **0**，在 Java 裡，**boolean** 原始型態只能設定成兩種值，**true** 和 **false**，它們非常有用，而且會常常在寫程式的時候用到。
9. 我們可以用 boolean 定義變數為布林，如果要知道顧客年紀是否超過 21 歲，可以將變數命名為 isCustomerOverTwentyOne，這很直覺也很好追蹤，後面會說到更多命名變數，類和方法。
```
boolean myTrueBooleanValue = true;
boolean myFalseBooleanValue = false;

boolean isCustomerOverTwentyOne = true;
```
#### 原始型態回顧和字串(String)原始型態
1. 八個原始型態的回顧
    - 全部：byte、short、int、long、float、double、char、boolean
    - 最常用：int、double、boolean
2. String
    - **String** 是 Java 的一種資料型態，它不是**原始型態**，它其實是一個類(Class)，但是它在 Java 有點被偏愛，所以它比一般類更好使用，你可以用跟一般類不一樣的方式對待它。
    - **String** 是一串字元，上面講到 **Char** 只能放一個字元(或是 Unicode 字元)，而 **String** 可以放入一連串的字元，技術上來說，它的 **MAX_VALUE** 可以放入 **21.4 億**的 **int**，這是很大量的字元。
3. String 可以對自己加上內容，然後打印出來，Unicode 也是可以的。
```
String myString = "This is a string";
System.out.println("My string is equal to " + myString);
myString = myString + ", and this is more.";
System.out.println("My string is equal to " + myString);
myString = myString + " \u00A9 2020";
System.out.println("My string is equal to " + myString);

------
My string is equal to This is a string
My string is equal to This is a string, and this is more.
My string is equal to This is a string, and this is more. © 2020
```
4. String 裡面的數字會被當成文字處理，並沒有辦法做數學的計算。
```
String numberString = "250.55";
numberString = numberString + "49.95";
System.out.println(numberString);

------
250.5549.95
```
5. 就算在 String 後面加上數字型態的數字，最後還是會當作文字處理。
```
String lastString = "10";
int myInt = 50;
lastString = lastString + myInt;
System.out.println("My last string is " + lastString);

------
My last string is 1050
```
6. 就算用 double，還是一樣會當文字處理。
```
double doubleNumber = 120.47d;
lastString = lastString + doubleNumber;
System.out.println("My last string is " + lastString);

------
My last string is 1050120.47
```
7. Java 的 String 是不可變的(Immutable)
    - 當我說可以刪除 **String**，嚴格上來說是不正確的，因為 Java 的 **String** 是不可變的，所以說，你在創建 String 之後是不能改變 **String** 的，取而代之的，新的 **String** 是再次創建的。
    - 所以在上面這個例子，lastSting 不是附加上 **120.47** 這個值，而是新 **String** 被創建了，這個新 **String** 包含之前的 **lastString** 加上用文字表示的 double 值 **120.47**。
    - 結果是一樣的，**lastString** 有正確的值，然而，新的 **String** 被創建，而舊的被拋棄。
    - 不要擔心覺得這個不合理，後面會細說，在這邊，我想特別強調 **String** 是 Immutable (不可變的)。
8. 我們用的程式碼再創建 String 是沒有效率的
    - 最後一個新的 **String** 被創建，像這樣的方式是沒有效率的，而且不推薦的。後面會用 **StringBuffer**，這個就可以讓 **String** 被改變了。
    - 在我們處理 **StringBuffer**，我們需要了解類(class)，而且，後面你會遇到用這種風格(String + Value)寫的程式碼，所以用 **StringBuffer** 對你很有用。
#### 運算符(Operators)、運算數(Operands)、表達式(Expressions)
1. 什麼是運算符(Operator)？
Java 的 **運算符(Operator)** 是特殊符號，用來對一個、兩個、或三個運算數執行特定的操作，最後返回結果。例如：我們用 + 運算符來相加兩個數的值。
2. 什麼是運算數(Operand)？
    - **運算數(Operand)**是一個專有名詞，用來描述被**運算符**操作的任何物件。
    - 如果我們看這個陳述句(statement)：`int myVar = 15 + 12`，**+** 是**運算符**，而 **15** 和 **12** 是**運算數**，用文字表示的變數也是**運算數**。
    - `double mySalary = hoursWorked * hourlyRate`，在這邊，**hoursWorked** 和 **hourlyRate** 都是**運算數**，而且 **\*** 是 **運算符**。
3. 什麼是表達式(Expression)？
    - 一個表達式是由變數、文字、回傳值的方法(還沒講到)和運算符所組成。
    - `int myVar = 15 + 12`，**15 + 12** 就是表達式，最後會回傳 **27**。
    - `double mySalary = hoursWorked * hourlyRate`，**hoursWorked * hourlyRate** 是表達式，所以如果 **hoursWorked** 是 **10.00**，**hourlyRate** 是 **20.00**，最後這個表達式會回傳 **200.00**。
4. 什麼是註解(Comment)？
    - **註解**會被電腦忽略，被加到程式碼裡面是為了幫助描述某件事，**註解**是為了人而存在的。
    - 我們用 **//** 在任何程式碼前面，或是在空白的一行，任何在 **//** 後面的內容到這一行的結尾都會被忽略。
    - 除了可以用來描述一個程式碼的內容，**註解**也被用來暫時性地禁用程式碼。
5. 這邊可以看到，在第三行的時候指定了 result 給 previousResult，後面 previousResult 並沒有被改變，所以就算後面 result 改變了，previousResult 在最後也不會改變。另外展示運算符 (+, -, *, /, %)。
```
int result = 1 + 2; // 1 + 2 = 3
System.out.println("1 + 2 = " + result);
int previousResult = result;
System.out.println("previousResult = " + previousResult);
result = result - 1; // 3 - 1 = 2;
System.out.println("3 - 1 = " + result);
System.out.println("previousResult = " + previousResult);

result = result * 10; // 2 * 10 = 20;
System.out.println("2 * 10 = " + result);

result = result / 5; // 20 / 5 = 4
System.out.println("20 / 5 = " + result);

result = result % 3; // the remainder of (4 % 3) = 1;
System.out.println("4 % 3 = " + result);
------
1 + 2 = 3
previousResult = 3
3 - 1 = 2
previousResult = 3
2 * 10 = 20
20 / 5 = 4
4 % 3 = 1
```
#### 縮寫運算符
1. 可以用 ++, --, +=, -=, *=, /= 來進行運算的縮寫。
```
int result = 1;
// result = result + 1;
result++; // 1 + 1 = 2;
System.out.println("1 + 1 = " + result);

result--; // 2 - 1 = 1;
System.out.println("2 - 1 = " + result);

// result = result + 2;
result += 2; // 1 + 2 = 3
System.out.println("1 + 2 = " + result);

// result = result * 10;
result *= 10; // 3 * 10 = 30
System.out.println("3 * 10 = " + result);

// result = result / 3;
result /= 3; // 30 / 3 = 10
System.out.println("30 / 3 = " + result);

// result = result - 2;
result -= 2; // 10 - 2 = 8;
System.out.println("10 - 2 = " + result);
```
#### if-then 陳述句(statement)
1. **if-then** 是最基本的控制流陳述句，當特定值為 **true** 時，它告訴程式應該執行哪個區塊。
2. 條件式邏輯(Conditonal Logic)在 Java 使用特定陳述句，讓我們當條件是 **false** 或 **true** 的時候，檢查一個條件或執行特定程式碼。
3. 在 if 條件下，如果沒有程式碼區塊(code block)，它只會判斷後執行第一行，第二行會當成正常的程式碼運行。所以我們應該要使用程式碼區塊，程式碼區塊可以讓不只一行的程式碼運行。
```
boolean isAlien = false;
if (isAlien == true)
    System.out.println("It is not an alien!");
    System.out.println("And I am scared of aliens");

------
And I am scared of aliens
```
4. 使用程式碼區塊可以讓 if 陳述句更清楚，而且可執行超過一行。
```
boolean isAlien = false;
if (isAlien == false) {
    System.out.println("It is not an alien!");
    System.out.println("And I am scared of aliens");
}

------
It is not an alien!
And I am scared of aliens
```
#### 邏輯 AND 運算符
1. \>, <, >=, <= 分別對應數學上的大於、小於、大於等於、小於等於，&& 雙連字號(double ampersands) 就是邏輯 AND 的意思，後面會細說單連字號(bitwise AND)和雙連字號的差別，雙連字號用在左右兩邊的表達式都是 true 的時候，該條件才成立。
```
int topScore = 80;
if (topScore >= 100) {
    System.out.println("You got the high school!");
}

int secondTopScore = 60;
if (topScore > secondTopScore && topScore < 100) {
    System.out.println("Greater than second top score and less than 100");
}
```
2. 可以讓在 && 的旁邊兩個表達式加上 ()，可以更清楚要判斷的條件，而且輸出結果也不會改變。
```
if ((topScore > secondTopScore) && (topScore < 100)) {
    System.out.println("Greater than second top score and less than 100");
}
```
#### 邏輯 OR 運算符
1. OR 運算符，只要左右其中一個表達式為 true，則結果為 true，基本用法和 AND 一致。
```
if ((topScore > 90) || (secondTopScore <= 90)) {
    System.out.println("Either or both of conditions are true");
}
```
2. 邏輯 AND 和邏輯 OR
    - **AND** 運算符在 Java 中有兩種形式，**OR** 也是。
    - **&&** 是邏輯 AND，用來執行 boolean 運算數的運算 - 檢查條件是否為 **true** 或 **false**。
    - **&** 是一個位元運算符(bitwise operator)，用在位元等級的運算。
    - 同樣地，**||** 是邏輯 OR，用來執行 boolean 運算數的運算 - 檢查條件是否為 **true** 或 **false**。
    - 同樣地，**|** 是一個位元運算符(bitwise operator)，用在位元等級的運算。
#### 分配運算符和相等運算符
1. 第一行我們宣告了 **newValue int**，它使用了分配運算符(=)去分配 **50** 給 **newValue**。不要在 **if-then** 陳述句裡面使用**分配運算符**，而要使用相等運算符(==)。
```
int newValue = 50;
if (newValue = 50) {
    System.out.println("This is an error");
}
if (newValue == 50) {
    System.out.println("This is true");
}
```
2. 這邊在 if 後面使用 isCar = true 是指定 isCar 變數為 true，最後會返回 true，這個 if 條件句的內容就會被執行。
```
boolean isCar = false;
if (isCar = true) {
    System.out.println("This is not supposed to happen");
}

------
This is not supposed to happen
```
3. 縮寫運算符。
```
if (isCar == true)
if (isCar)
```
```
if (isCar == false)
if (!isCar)
```
4. NOT 運算符
    - ! 或 NOT 被稱為邏輯補運算符 (Logical Complement Operator)
    - 用來與 **boolean** 測試它的替代值，我們看到上面 **(isCar)** 是 **true**，再變數之前加上 **!**，就可以檢查相反的值 **false**。
    - 推薦使用縮寫運算符 (isCar) 或 (!isCar)，第一，可以避免使用分配運算符的錯誤，第二，程式碼更為簡潔。
#### 三元運算符 (ternary operator)
1. 三元運算符是一個捷徑，透過給予的條件，去分配兩個值中的其中一個給一個變數。它是 **if-then-else** 陳述句的快捷版。
```
isCar = true;
boolean wasCar = isCar ? true : false;
if (wasCar) {
    System.out.println("wasCar is true;");
}
```
2. 三元運算符的使用
    - 第一個運算數 **ageOfClient == 20**：我們要檢查的條件，它必須回傳 **true** 或 **false**。
    - 第二個運算數 **true**：**true** 是我們分配給 **isEighteenOrOver** 的值，如果前面的條件為 **true**，則為 **true**。
    - 第三個運算數 **false**: **false** 是我們分配給 **isEighteenOrOver** 的值，如果前面的條件為 **false**，則為 **false**。
    - 最後會回傳 true，因為 ageOfClient == 20 是 true。
    - 最好使用 () 會更容易閱讀。可以改寫成 `boolean isEighteenOrOver = (ageOfClient == 20) ? true : false;`
```
int ageOfClient = 20;
boolean isEighteenOrOver = ageOfClient == 20 ? true : false;
```
#### 運算符優先級和運算符挑戰
1. [運算符的總表](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/opsummary.html)
2. [運算符的優先級](http://www.cs.bilkent.edu.tr/~guvenir/courses/CS101/op_precedence.html)
3. 挑戰：測試你學到的**運算符**
    - 創建一個 **double** 變數，值為 **20.00**。
    - 創建第二個 **double** 變數，值為 **80.00**。
    - 相加以上兩個變數，並乘以 **100.00**。
    - 使用**餘數**運算符，將第三步驟取得的值用 **40.00** 取得餘數，我們在這堂課用係數(modulus)或餘數運算符在**整數**上，但是我們也可以把餘數用在 **double**。
    - 創建一個 **boolean** 變數，如果**步驟四**的餘數為 **0**，則為 **true**，如果**不是 0**，則為 **false**。
    - 輸出這個 **boolean** 值。
    - 寫一個 **if-then** 陳述句，如果步驟五的 boolean 值不為 true，回傳 "Got some remainder"。
4. 答案
```
double myFirstValue = 20.00d;
double mySecondValue = 80.00d;
double myValuesTotal = (myFirstValue + mySecondValue) * 100.00d;
System.out.println("myValuesTotal = " + myValuesTotal);
double theRemainder = myValuesTotal % 40.00d;
System.out.println("theRemainder = " + theRemainder);
boolean isNoRemainder = (theRemainder == 0) ? true : false;
System.out.println("isNoRemainder = " + isNoRemainder);
if (!isNoRemainder) {
    System.out.println("Got some remainder");
}
```