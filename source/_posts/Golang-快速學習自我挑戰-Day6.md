---
title: Golang 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/golang/GolangDay06.jpg
date: 2021-07-26 08:46:56
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay06.jpg">

***
## 章節二
### Go 和 Randomization
1. 這邊會實作一個 Lucky number 的專案，使用者會輸入數字，然後系統會隨機產生一個數字，當使用者猜到跟系統隨機產生的數字相同，使用者勝利。
2. 這邊會用到 [rand 的套件包](https://pkg.go.dev/math/rand)，Go 的隨機是使用假隨機(pseudo-random)，在每次執行的時候，Go 會產生一連串的已定好的數列(deterministic sequence)。
3. `func Intn(n)` 會產生 [0, n) 之間的亂數，但是不包含 n。所以如果要取得 0-10 的變數，要使用 `Intn(11)`。
4. Lucky Number 的範例，你會發現你每次的結果都一樣，因為 Go 使用了假隨機。
    ```
    package main

    import (
      "fmt"
      "math/rand"
    )

    func main() {
      guess := 10

      for n := 0; n != guess; {
        n = rand.Intn(guess + 1)
        fmt.Printf("%d ", n)
      }
      fmt.Println()
    }
    ====OUTPUT====
    6 8 1 0 2 4 6 0 10 
    ```
5. 為了要讓每次產生的數字都不一樣，要使用 `func Seed(int64)`，在裡面放不同的數字，它就會產生不同的隨機值，也就是說如果 Seed 放 10，每次產生的隨機值就會都一樣，所以我們要在 Seed 裡面放不同的數字來讓每次產生不同的數字。
    ```
    package main

    import (
      "fmt"
      "math/rand"
    )

    func main() {
      rand.Seed(100)
      guess := 10

      for n := 0; n != guess; {
        n = rand.Intn(guess + 1)
        fmt.Printf("%d ", n)
      }
      fmt.Println()
    }
    ```
### 用時間 Seed 隨機數字
1. [查看現在的 Unix Time](https://time.is/Unix_time_now)。
2. Time 套件的 `func Unix` 回傳的是 int，可以拿來 Seed，這邊還有一個 `func UnixNano` 可以產生 Nanoseconds，更精準所以更適合拿來 Seed。
3. 用時間 Seed 隨機數字，這樣就可以每次產生不同的數字了。
    ```
    package main

    import (
      "fmt"
      "math/rand"
      "time"
    )

    func main() {
      rand.Seed(time.Now().UnixNano())
      guess := 10

      for n := 0; n != guess; {
        n = rand.Intn(guess + 1)
        fmt.Printf("%d ", n)
      }
      fmt.Println()
    }
    ====OUTPUT====
    7 8 0 7 0 8 10 
    5 3 4 4 6 0 2 10 
    ```
### 寫一個 Game Logic
1. 範例。
    ```
    package main

    import (
      "fmt"
      "math/rand"
      "os"
      "strconv"
      "time"
    )

    const (
      maxTurns = 5
      usage = `Welcome to the Luck Number Game! 🍀

    The program will pick %d random numbers.
    Your mission is to guess one those numbers.

    The greater your numbers is, the harder it gets.

    Wanna play?
    `
    )

    func main() {
      rand.Seed(time.Now().UnixNano())

      args := os.Args[1:]
      if len(args) != 1 {
        fmt.Printf(usage, maxTurns)
        return
      }

      guess, err := strconv.Atoi(args[0])
      if err != nil {
        fmt.Println("Not a number.")
        return
      }

      if guess <= 0 {
        fmt.Println("Please pick a positive number.")
        return
      }

      for turn := 1; turn < maxTurns; turn++ {
        n := rand.Intn(guess + 1)

        if n == guess {
          fmt.Println("🎉 YOU WIN!")
          return
        }
      }
      fmt.Println("☠️ YOU LOST...Try again?")
    }
    ```
### 建立文字查找器
1. 建立一個簡單的文字查找器。
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    const corpus = "lazy cat jumps again and again and again"

    func main() {
      words := strings.Fields(corpus)
      query := os.Args[1:]

      for _, q := range query {
        for i, w := range words {
          if q == w {
            fmt.Printf("#%-2d: %q\n", i + 1, w)
            break
          }
        }
      }
    }
    ```
### Label Statement
1. 使用 labeled statement，可以讓 nested loop 的 parent loop 直接被 break。
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    const corpus = "lazy cat jumps again and again and again"

    func main() {
      words := strings.Fields(corpus)
      query := os.Args[1:]

    queries:
      for _, q := range query {
        for i, w := range words {
          if q == w {
            fmt.Printf("#%-2d: %q\n", i + 1, w)
            break queries
          }
        }
      }
    }
    ```
2. 在 label 上面新增一樣名字的變數，也不會出錯，因為變數和 label 是不一樣的東西。正常來說，在同一個 block 不能宣告同樣的名字，所以 label 和變數還有常數並沒有共享同一個 block。
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    const corpus = "lazy cat jumps again and again and again"

    func main() {
      words := strings.Fields(corpus)
      query := os.Args[1:]

      var queries string
	    _ = queries

    queries:
      for _, q := range query {
        for i, w := range words {
          if q == w {
            fmt.Printf("#%-2d: %q\n", i + 1, w)
            break queries
          }
        }
      }
    }
    ```
3. 同樣地，也可以從 parent loop 直接 continue。
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    const corpus = "lazy cat jumps again and again and again"

    func main() {
      words := strings.Fields(corpus)
      query := os.Args[1:]

    queries:
      for _, q := range query {
        for i, w := range words {
          if q == w {
            fmt.Printf("#%-2d: %q\n", i + 1, w)
            continue queries
          }
        }
      }
    }
    ```
### 使用 label 來中斷 switch
1. 如果直接在 switch 裡面 break，就只會 break switch statement，下面還會繼續執行，用 label 的方式就可以讓 parent loop 直接中斷。
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    const corpus = "lazy cat jumps again and again and again"

    func main() {
      words := strings.Fields(corpus)
      query := os.Args[1:]

    queries:
      for _, q := range query {
        search:
        for i, w := range words {
          switch q {
          case "and", "or", "the":
            break search
          }
          if q == w {
            fmt.Printf("#%-2d: %q\n", i + 1, w)
            break queries
          }
        }
      }
    }
    ```
### Go 的 goto statement
1. `goto` 語法很少使用，正常來說使用 for，break 和 continue 更好，所以只有在 `goto` 能讓程式碼變簡單才選用它。
    ```
    package main

    import "fmt"

    func main() {
      var i int

    loop:
      if i < 3 {
        fmt.Println("looping")
        i++
        goto loop
      }
      fmt.Println("done")
    }
    ```
2. 不能在 label 裡面有定義的變數之前使用 `goto`。
    ```
    // Can't Work
    goto loop
    var i int
    ```