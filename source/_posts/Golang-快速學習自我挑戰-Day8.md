---
title: Golang 快速學習自我挑戰 Day8
thumbnail:
  - /images/learning/golang/GolangDay08.jpg
date: 2021-08-11 22:09:35
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay08.jpg">

***
# 第三章
## 如何使用 Multi-dimensional Array？
1. 新增一個 Multi-dimensional Array，會是這樣的形式，最外層的 `[2]` 宣告裡面有 2 個 Array，而 `[3]int` 是裡面 Array 的長度和型別。
    ```
    [2][3]int{
      [3]int{5, 6, 1},
      [3]int{9, 8, 4},
    }
    ```
2. 要取得學生的平均分數，程式碼如下：
    ```
    student1 := [3]float64{5, 6, 1}
    student2 := [3]float64{9, 8, 4}
    
    var sum float64
    sum += student1[0] + student1[1] + student1[2]
    sum += student2[0] + student2[1] + student2[2]
    
    const N = float64(len(student1) * 2)
    fmt.Printf("Avg Grade: %g\n", sum/N)
    ```
3. 使用 Multi-dimensional Array。
    ```
    students := [2][3]float64{
      [3]float64{5, 6, 1},
      [3]float64{9, 8, 4},
    }
    
    var sum float64
    sum += students[0][0] + students[0][1] + students[0][2]
    sum += students[1][0] + students[1][1] + students[1][2]
    
    const N = float64(len(students) * len(students[0]))
    fmt.Printf("Avg Grade: %g\n", sum/N)
    ```
4. 優化程式碼，型別已經在外層宣告，所以不用再宣告一遍，長度也可以用 ellipse ([...]) 的方式處理，最後再用 for range 取得分數。
    ```
    students := [...][3]float64{
      {5, 6, 1},
      {9, 8, 4},
    }

    var sum float64
    for _, grades := range students {
      for _, grade := range grades {
        sum += grade
      }
    }

    const N = float64(len(students) * len(students[0]))
    fmt.Printf("Avg Grade: %g\n", sum/N)
    ```
## 小挑戰 2：Moodly
1. 使用 Multi-dimensional Array 改良 Moodly
    ```
    package main

    import (
      "fmt"
      "math/rand"
      "os"
      "time"
    )

    func main() {
      args := os.Args[1:]
      if len(args) != 2 {
        fmt.Println("[your name] [positive|negative]")
        return
      }

      name, mood := args[0], args[1]

      moods := [...][3]string{
        {"happy 😀", "good 👍", "awesome 😎"},
        {"sad 😔", "bad 👎", "terrible 😩"},
      }

      rand.Seed(time.Now().UnixNano())
      n := rand.Intn(len(moods[0]))

      var mi int

      if mood != "positive" {
        mi = 1
      }

      fmt.Printf("%s feels %s\n", name, moods[mi][n])
    }
    ```
## 學習 Go 很少被人知道的功能：The Keyed Elements
1. 可以直接在 element 前面加上 index 的數字，指定 element 的 key。
    ```
    rates := [3]float64{
      1: 2.5,
      0: 0.5,
      2: 1.5,
    }
    ```
2. 如果直接指定 key，就會指定 element 的位置，因為另外兩個 Element 沒有值，所以初始化為 0，下面這個 Array 的值等於 `[3]float64{0, 0, 1.5}`。
    ```
    rates := [3]float64{
      2: 1.5,
    }
    ```
3. 如果使用 ellipse，因為指定 key 為 5，它就會知道有 6 個 elements，所以下面這個 Array 的值等於 `[6]float64{0, 0, 0, 0, 0, 1.5}`。
    ```
    rates := [...]float64{
      5: 1.5,
    }
    ```
4. 如果有 element 是沒有 key 的，Go 會先把有 key 的 element 放到對應位置，最後再把沒有 key 的 element 加到最後面，所以下面這個 Array 的值等於 `[7]float64{0.5, 0, 0, 0, 0, 1.5, 2.5}`。
    ```
    rates := [...]float64{
      5: 1.5,
      2.5,
      0: 0.5,
    }
    ```
5. 在 Array 使用 const，這樣的程式碼更好閱讀。
    ```
    package main

    import (
      "fmt"
    )

    func main() {
      const(
        ETH = 9 - iota
        WAN
        ICX
      )

      rates := [...]float64{
        ETH: 25.5,
        WAN: 120.5,
        ICX: 20,
      }

      fmt.Printf("1 BTC is %g ETH\n", rates[ETH])
      fmt.Printf("1 BTC is %g WAN\n", rates[WAN])
      fmt.Printf("1 BTC is %g ICX\n", rates[ICX])
      fmt.Printf("%#v\n", rates)
    }
    ```
## 學習 composite 和 unnamed types 的關係



