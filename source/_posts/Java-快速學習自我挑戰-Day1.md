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


