---
title: Golang 快速學習自我挑戰 Day4
thumbnail:
  - /images/learning/golang/GolangDay04.jpg
date: 2021-07-23 22:59:50
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay04.jpg">

***
## 章節一
### Switch Statement
1. switch statement 和 if statement 很像，但是有不同的語法。
2. `city` 是 condition expression，它非常重要因為它控制了 case 語法的 condition。如果 city 等於 case 裡面的內容（等同於 if city == "Paris"），就會執行 case 裡面的 block。
    ```
    switch city {
      case "Paris":
        fmt.Println("France")
    }
    ```
3. 在 Go 裡面，Switch 背後的機制其實就是 if else。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      city := os.Args[1]

      switch city {
      case "Paris":
        fmt.Println("France")
      case "Tokyo":
        fmt.Println("Japan")
      }

      if city == "Paris" {
        fmt.Println("France")
      } else if city == "Tokyo" {
        fmt.Println("Japan")
      }
    }
    ```
4. 使用 switch statement 有兩個原則。
    - case 不能重複。
    - switch 的變數和 case 裡面的值必須要是可以比較的，也就是說型別要相同。
5. 如果你先學了其它的語言，你會發現為什麼不用 `break`，事實上，Go 有 `break` 這個語法，但是不是必要的。
6. 如果在 case block 裡面新增的變數，在外面是不能使用的。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      city := os.Args[1]

      switch city {
      case "Paris":
        fmt.Println("France")
        vip := true
        // It's working
        fmt.Println("VIP trip?", vip)
      case "Tokyo":
        fmt.Println("Japan")
        // can't work
        fmt.Println("VIP trip?", vip)
      }
      // can't work, either
      fmt.Println("VIP trip?", vip)
    }
    ```
### 什麼是 default clause
1. 如果 switch statement 找不到相符資料的時候，就會跑 default 的地方，跟 case clause 一樣，default 也只能有一個。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      city := os.Args[1]

      switch city {
      case "Paris":
        fmt.Println("France")
      case "Tokyo":
        fmt.Println("Japan")
      default:
        fmt.Println("Where?")
      }
    }
    ```
2. default 的位置可以隨便擺放，結果會是一樣的。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      city := os.Args[1]

      switch city {
      default:
        fmt.Println("Where?")
      case "Paris":
        fmt.Println("France")
      case "Tokyo":
        fmt.Println("Japan")
      }
    }
    ====EXECUTE====
    go run main.go Paris
    ====OUTPUT====
    France
    ```
### 使用很多值在一個 case condition
1. 如果要在一個 case condition 添加很多值，只要加上 `,` 和想要的值就可以了，這個背後使用的概念就是 `if city == "Paris || city == "Lyon"`。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      city := os.Args[1]

      switch city {
      case "Paris", "Lyon":
        fmt.Println("France")
      case "Tokyo":
        fmt.Println("Japan")
      default:
        fmt.Println("Where?")
      }
    }
    ```
### 在 case condition 使用 bool expression
1. 這邊的 `i > 0` 的結果是 bool，所以可以跟 switch 的 true 放在一起。
    ```
    switch true {
    case i > 0:
      fmt.Println("positive")
    case i < 0:
      fmt.Println("negative")
    default:
      fmt.Println("zero")
    }
    ```
2. switch 後面默認就是 true，所以可以簡化成以下內容，結果會是一樣的。
    ```
    switch {
    case i > 0:
      fmt.Println("positive")
    case i < 0:
      fmt.Println("negative")
    default:
      fmt.Println("zero")
    }
    ```
### fallthrough statement 是如何運作的？
1. fallthrough statement 就是直接跳過 condition 檢查，直接進去下一個 case block 裡面。事實上，真實情境很少使用到 fallthrough，但是有些情況下他卻很好用。
    ```
    package main

    import "fmt"

    func main() {
      i := 142

      switch {
      case i > 100:
        fmt.Print("big ")
        fallthrough
      case i > 0:
        fmt.Print("positive ")
        fallthrough
      default:
        fmt.Print("number\n")
      }
    }
    ====OUTPUT====
    big positive number
    ```
### 什麼是 short switch?
1. short switch 和 short if 很像。把剛剛上面的程式碼，縮減成下面的程式碼。`i := 10` 稱為 simple statement，裡面可以放置各種 simple statement，例如：`i = 10`, `i++`, `i--`，甚至可以放 func `func call()` 等等。
    ```
    switch i := 10; true {
    case i > 0:
      fmt.Println("positive")
    case i < 0:
      fmt.Println("negative")
    default:
      fmt.Println("zero")
    }
    ```
2. 在 simple statement，true 一樣可以省略掉。
    ```
    switch i := 10; {
    case i > 0:
      fmt.Println("positive")
    case i < 0:
      fmt.Println("negative")
    default:
      fmt.Println("zero")
    }
    ```
### 小挑戰：Parts of a Day
1. 題目
    ```
    如果系統時間是早上，要顯示『Good morning』。
    如果系統時間是下午，要顯示『Good afternoon』。
    如果系統時間是傍晚，要顯示『Good evening』。
    如果系統時間是晚上，要顯示『Good night』。
    要使用 time package。
    ```
2. 答案
    ```
    package main

    import (
      "fmt"
      "time"
    )

    func main() {
      switch h := time.Now().Hour(); {
      case h >= 18:
        fmt.Println("Good evening")
      case h >= 12:
        fmt.Println("Good afternoon")
      case h >= 6:
        fmt.Println("Good morning")
      default:
        fmt.Println("Good night")
      }
    }
    ```
### if vs switch，要用哪一個？
1. 如果你有像範例一樣很難閱讀的 if statement，就要改用 switch statement。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      if len(os.Args) != 2 {
        fmt.Println("Gimme a month name")
      }

      m := os.Args[1]

      if m == "Dec" || m == "Jan" || m == "Feb" {
        fmt.Println("Winter")
      } else if m == "Mar" || m == "Apr" || m == "May" {
        fmt.Println("Spring")
      } else if m == "Jun" || m == "Jul" || m == "Aug" {
        fmt.Println("Summer")
      } else if m == "Sep" || m == "Oct" || m == "Nov" {
        fmt.Println("Fall")
      } else {
        fmt.Printf("%q is not the month.\n", m)
      }
    }
    ```
2. 改用 switch statement。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      if len(os.Args) != 2 {
        fmt.Println("Gimme a month name")
      }

      m := os.Args[1]

      switch m {
      case "Dec", "Jan", "Feb":
        fmt.Println("Winter")
      case "Mar", "Apr", "May":
        fmt.Println("Spring")
      case "Jun", "Jul", "Aug":
        fmt.Println("Summer")
      case "Sep", "Oct", "Nov":
        fmt.Println("Fall")
      default:
        fmt.Printf("%q is not the month.\n", m)
      }
    }
    ```