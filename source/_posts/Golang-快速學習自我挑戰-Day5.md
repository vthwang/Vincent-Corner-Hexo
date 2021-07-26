---
title: Golang 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/golang/GolangDay05.jpg
date: 2021-07-24 22:44:22
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay05.jpg">

***
## 章節一
### 在 Go 只有一種迴圈
1. 在 Go 只有 for 迴圈，沒有 while 和 until 迴圈。
2. for 迴圈就是重複**一段**程式碼**當**條件是 **true**。
3. `i := 1` 是 init statement。`i <= 5` 是 condition statement，它是 bool expression，當它等於 false 的時候，迴圈結束。`i++` 是 post statement。
    ```
    for i := 1; i <= 5; i++ {
      sum += i
    }
    ```
### 如何 break 一個 for 迴圈？
1. 使用 `break` 就可以 break for 迴圈，for 的 init statement 可以在前面定義，post statement 可以放到 for 回圈的最後面，condition statement 也可以放到 for 裡面，如果不使用 `break`，那麼這個 for 迴圈就會變成無限迴圈，只能用戶手動停止。
    ```
    package main

    import "fmt"

    func main() {
      var (
        sum int
        i = 1
      )

      for {
        if i > 5 {
          break
        }
        sum += i
        fmt.Println(i, "-->", sum)
        i++
      }

      fmt.Println(sum)
    }
    ```
### 如何 continue 一個 for 迴圈？
1. `continue` 可以離開當前的步驟，並繼續下一次的迴圈。
    ```
    package main

    import "fmt"

    func main() {
      var (
        sum int
        i = 1
      )

      for {
        if i > 10 {
          break
        }

        if i % 2 != 0 {
          i++
          continue
        }
        sum += i
        fmt.Println(i, "-->", sum)
        i++
      }

      fmt.Println(sum)
    }
    ====OUTPUT====
    2 --> 2
    4 --> 6
    6 --> 12
    8 --> 20
    10 --> 30
    30
    ```
### 如何建立一個乘法表？
1. 這裡會使用巢狀迴圈(nested loop)，把迴圈放在迴圈裡。乘法表範例如下。
    ```
    package main

    import "fmt"

    const max = 5

    func main() {
      fmt.Printf("%5s", "X")
      for i := 0; i <= max; i++ {
        fmt.Printf("%5d", i)
      }

      fmt.Println()

      for i := 0; i <= max; i++ {
        fmt.Printf("%5d", i)

        for j := 0; j <= max; j++ {
          fmt.Printf("%5d", i*j)
        }
        fmt.Println()
      }
    }
    ====OUTPUT====
        X    0    1    2    3    4    5
        0    0    0    0    0    0    0
        1    0    1    2    3    4    5
        2    0    2    4    6    8   10
        3    0    3    6    9   12   15
        4    0    4    8   12   16   20
        5    0    5   10   15   20   25
    ```
### 如何用迴圈把 slice 跑一遍？
1. 把 slice 用 for 迴圈跑一遍。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      for i := 1; i < len(os.Args); i++ {
        fmt.Printf("%q\n", os.Args[i])
      }
    }
    ====EXECUTE====
    go run main.go hi hello hey
    ====OUTPUT====
    "hi"
    "hello"
    "hey"
    ```
2. `strings.Fields` 可以把 string 用空格區隔並輸出成 slice，變成 slice 之後就沒有名字，你只能透過 `words[index]` 來取得值。`%-2d` 可以用來調整位置，`%-2d` 就是靠左排列，會顯示 `d  `，如果是 `%2d` 就會靠右排列，會顯示 `  d`。
    ```
    package main

    import (
      "fmt"
      "strings"
    )

    func main() {
      words := strings.Fields("lazy cat jumps again and again and again")

      for j := 0; j < len(words); j++ {
        fmt.Printf("#%-2d: %q\n", j+1, words[j])
      }
    }
    ```
### For Range
1. For Range 用來對 slice 跑迴圈是最簡單的方式，但是它不只能用在 slice，還可以用在 array, string, map 和 channel，後面會說到。這邊有用到一個進階的方法，`os.Args[1:]`，這個方法會建立一個新的 slice，然後省略掉第一個值。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      for _, v := range os.Args[1:] {
        fmt.Printf("%q\n", v)
      }
    }
    ```
2. 用 for range 跟 for 相比，更方便把變數提到外面，即使在迴圈之外，也可以使用這些變數。
    ```
    package main

    import (
      "fmt"
      "strings"
    )

    func main() {
      words := strings.Fields("lazy cat jumps again and again and again")

      var (
        i int
        v string
      )

      for i, v = range words {
        fmt.Printf("#%-2d: %q\n", i+1, v)
      }

      fmt.Printf("Last value of i is %d q = %q\n", i, v)
    }
    ```