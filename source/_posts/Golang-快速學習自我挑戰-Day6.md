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

      if guess < 0 {
        fmt.Println("Please pick a positive number.")
        return
      }

      for turn := 0; turn < maxTurns; turn++ {
        n := rand.Intn(guess + 1)

        if n == guess {
          fmt.Println("🎉 YOU WIN!")
          return
        }
      }
      fmt.Println("☠️ YOU LOST...Try again?")
    }
    ```







