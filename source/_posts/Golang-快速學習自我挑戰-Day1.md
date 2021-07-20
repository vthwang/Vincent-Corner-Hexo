---
title: Golang 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/golang/GolangDay01.jpg
date: 2021-07-19 18:47:56
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay01.jpg">

***
## 章節一
### 安裝 Go 環境
1. [安裝Go環境教學](https://www.youtube.com/watch?v=1MXIGYrMk80)
### 變數介紹
1. 你必須要先定義變數才能夠使用它，所以你不能直接給一個未定義的變數一個值，因為它不存在。
2. 在 Dynamic Programming 裡面，你可以在還沒定義變數之前，直接給它值，這樣很好用，但是對後面的程式碼維護並不容易。
3. `var speed int`
    - `var` 就是 variable 的簡稱，宣告變數一定要輸入這個 Keyword。
    - `speed` 就是變數的**名字**，又稱為「identifier」，這是一個獨一無二的名字，用來讓 Go 了解你在提到哪個變數。
        - 在電腦科學裡面，兩件事情是最困難的，cache invalidation 和 naming，以下說的命名原則可以適用到 function name, package name...等等。
        - Go 可以這樣命名，下面是命名範例，真實情境不一定會這樣使用。
            - `var speed int`
            - `var SpeeD int`
            - `var _speed int`
            - `var 速度 int` (unicode 是可以的)
        - Go 不能這樣命名，這些原則是為了避免模稜兩可的命名
            - 字首不能是數字 `var 3speed int`
            - 字首不能是標點符號 `var !speed int`
            - 變數不能包含標點符號，`var spe!ed int`，因為標點符號在 Go 裡面有特殊意義，它讓 Go 編譯器更容易辨識名字。
            - 變數不能包含 Go Keywords `var var int`，Go 不允許你覆寫他的 keywords。
    - `int` 是變數的類型，int 是 integer 的簡稱，在 Go 裡面，**所有的**變數和值都有**類型**，因為 Go 是強型別語言(Strongly Typed Programming Language)。它比較像 C, C#, Java，它幫助你在編譯的時候就找到問題。
        - 變數類型決定什麼樣的值可以儲存在這個變數，還有哪邊可以使用這個變數。
        - 一旦你指定了變數的類型，你就不能改變它，它是固定的。
4. 宣告變數的範例，在宣告變數的時候，如果是 integer 的話，初始值會是 0。
    ```
    package main
    import "fmt"

    func main() {
        var speed int

        fmt.Println(speed)
    }
    ====OUTPUT====
    0
    ```
### 範例：Path Separator
1. 你會學到三樣東西。
    - 使用 Go 標準套件(stdlib) - path
    - 學習如何賦值給表達式回傳的多個值
    - 拋棄其中一個值(blank-identifier)
2. **path** 套件提供實用的功能來處理 **url string** 路徑。
3. 範例
    ```
    import (
      "fmt"
      "path"
    )

    func main() {
      var dir, file string

      dir, file = path.Split("css/main.css")

      fmt.Println("dir: ", dir)
      fmt.Println("file: ", file)
    }
    ====OUTPUT====
    dir:  css/
    file:  main.css
    ```
4. 如果你想拋棄回傳回來的值，用 `_` 來賦空值
    ```
    import (
      "fmt"
      "path"
    )

    func main() {
      var file string

      _, file = path.Split("css/main.css")

      fmt.Println("file: ", file)
    }
    ====OUTPUT====
    file:  main.css
    ```
5. 你也可以使用 `:=` (short declaration) 直接將表達式回傳的值直接變成一個變數
    ```
    import (
      "fmt"
      "path"
    )

    func main() {
      _, file := path.Split("css/main.css")

      fmt.Println("file: ", file)
    }
    ====OUTPUT====
    file:  main.css
    ```
### 什麼時候使用 short declaration
1. 

