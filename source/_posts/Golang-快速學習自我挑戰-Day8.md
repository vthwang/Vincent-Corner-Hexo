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
1. Composite types 都是 unnamed types。
2. `[3]int{6, 9, 3}` 就是一個 unnamed type，這個的底層型別(underlying type)是它自己，也就是 `[3]int`，這個不只是 Array 是這樣，所有的 composite types 都是這樣。
3. `type bookcase [3]int` 就是一個 named type，這個的底層型別(underlying type)也是 `[3]int`。
4. 這時候新增一個 `bookcase{6, 9, 3}`，它可以和 `[3]int{6, 9, 3}` 進行比較，在 unnamed type 和 named type 的情況下，它們的底層型別是一樣的，所以是可以比較的。
5. 新增一個 `type cabinet [3]int` 並定義 `cabinet{6, 9, 3}`，它和 `bookcase{6, 9, 3}` 就不能比較，因為在兩個都是 named type 的情況下，就算底層型別一樣，也是不能比較的。
6. 但是如果再轉換過後，`bookcase(cabinet{6, 9, 3})`，它們就可以進行比較了，因為它們有一樣的 type，這邊需要特別注意的地方是，轉換過後，底層型別一定要一樣，否則還是不能比較的。
7. 如果 type 不一樣，可以透過轉換的方式，就可以進行比較了。
    ```
    package main

    import "fmt"

    func main() {
      type (
        bookcase [5]int
        cabinet [5]int
      )

      blue := bookcase{6, 9, 3, 2, 1}
      red := cabinet{6, 9, 3, 2, 1}

      fmt.Printf("Are they equal?")

      if cabinet(blue) == red {
        fmt.Println("✅")
      } else {
        fmt.Println("❌")
      }

      fmt.Printf("blue: %#v\n", blue)
      fmt.Printf("red : %#v\n", red)
    }
    ====OUTPUT====
    Are they equal?✅
    blue: main.bookcase{6, 9, 3, 2, 1}
    red : main.cabinet{6, 9, 3, 2, 1}
    ```
8. 如果再新增一個 type 叫做 integer，`[5]integer{} == [5]int{}` 不成立，因為它們有不一樣的底層型別。而 `[5]integer{} == cabinet{}` 是可以比較的，因為 unnamed type 可以和 named type 進行比較。
    ```
    type (
      integer int

      bookcase [5]int
      cabinet [5]integer
    )

    // cannot compare
    //_ = [5]integer{} == [5]int{}
    // comparable
    _ = [5]integer{} == cabinet{}
    ```
## 回顧：Array
1. Array 就是一個 elements 的集合，它儲存同樣的型別、同樣的數量在相連的記憶體位置，所以非常高效。但是 Array 的長度和型別是固定的，你不能新增多的 element 或是修改 type。
2. Array 的 element 是 unnamed variables，所以你只能用 index expression 來讀取 Array 裡面的 element。
3. 定義 Array 的方式 `var name[length]elementType`，長度也是型別的一部分，你也可以用常數(constant)來定義長度。
4. Array Literal 會根據不同的型別，初始化沒有被定義的 element 為 0 或是空。
5. 可以使用 ellipse，Go 會自動根據 element 來設定 Array 的長度。
6. 可以使用 keyed element 來指定 Array element 的位置。
7. 可以使用 Multi-Dimensional Array，將 Array 儲存在一個 Array 裡面。
8. 如果新增一個 Array，Go 會自動複製一份新的 Array 到新的記憶體位置。
9. 不同長度和型別的 Array 是不能比較的也不能夠互相 assign 給對方。
10. 一個 unnamed composite type 的底層型別就是它自己，Array 就是一個 composite type。
11. 如果底層型別相同，named 和 unnamed type 是可以比較的。