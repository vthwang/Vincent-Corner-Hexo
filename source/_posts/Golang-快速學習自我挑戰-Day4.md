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
1. 







