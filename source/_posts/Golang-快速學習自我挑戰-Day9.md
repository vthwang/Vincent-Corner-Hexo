---
title: Golang 快速學習自我挑戰 Day9
thumbnail:
  - /images/learning/golang/GolangDay09.jpg
date: 2021-08-13 12:28:43
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay09.jpg">

***
# 第五章：Slices 和 Internal
## 章節介紹
1. Slice 是動態的 Array。
2. 這個章節會學習到的內容。
    - Array 和 Slice 的差異。
    - 使用 append() 來增加 Slice。
    - Slicing - Slice 表達式 `[low:high]`。
    - Internals。
        - Backing Array。
        - Slice Header。
        - Capacity of Slice - cap()。
    - 完整的 Slice 表達式 `[low:high:cap]`。
    - Preallocation - make()。
    - 不使用 loop 來複製 Slices - copy()。
    - Multi-Dimensional Slices。
## 學習 Array 和 Slice 的差異
1. Array 不能增加或減少 elements，Slice 可以在 Runtime 的時候增加和減少 elements。
2. Array 不能在 在 Runtime 的時候增加或減少 elements，因為長度是 type 的一部分，比方說 `var nums [3]int` 的 type 就是 `[3]int`，它的長度屬於 compile-time，所以它的長度在 Runtime 的時候不能修改，也就是這樣，Array 不能增加或減少 elements。
3. Slice 可以在 Runtime 的時候增加和減少 elements，比方說 `var nums []int` 它在 compile-time 的時候並沒有固定長度，所以它的長度在 Runtime 的時候可以修改，它的長度屬於 Runtime。
4. 跟 Array 不同，未初始化的 Slice 的值是 nil，比方說 `var nums []int`，nums 就等於 nil。nil 不是裡面沒有值，而是值還沒有被初始化，雖然它的值是 nil，但是他還是有型別，它的型別是 int。它可以使用 `len(nums)`，這邊的長度值會等於 0。
5. Array 和 Slice 的差別。
    | Slice | Array |
    |:-:|:-:|
    | `var nums []int` | `var nums [3]int` |
    | 它的長度<u>不屬於</u>它型別的一部分。 | 它的長度屬於它型別的一部分。 |
    | 它可以增加或減少。 | 它不可以增加或減少。 |
    | 它的空值是 nil。 | 它的空值是 0 elements。 |
6. Array 和 Slice 的相同之處。
    | Slice & Array |
    |:-:|
    | 它們可以只能包含**相同類型**的 elements。 |
    | 你可以使用 index 表達式去取得值，例如：nums[0]、nums[1]。 |
    | 可以使用 len(nums)，因為它們的有相同的 index。 |
## Slice 跟另外一個 Slice 比較嗎？
1. Slice 只能跟 nil value 進行比較。
2. 如果 Slice 是 nil 的情況下，Go 不會執行 for loop。
3. 可以直接將一個 Slice assign 到另外一個 Slice，例如：`games = newGames`，也可以直接 assign nil，例如：`games = nil`
4. 千萬不要檢查 Slice 是否等於 nil，而要檢查 Slice 的長度，因為當你使用 `games = []string{}` 的時候，你會發現這個 Slice 不等於 nil。
5. 用 for loop 的方式進行比較。
    ```
    package main

    import "fmt"

    func main() {
      games := []string{"Pokemon", "sims"}
      newGames := []string{"pacman", "doom", "pong"}

      games = []string{}

      var ok string
      for i, game := range games {
        if game != newGames[i] {
          ok = "not "
          break
        }
      }

      if len(games) == 0 {
        ok = "not "
      }

      fmt.Printf("games and newGames are %sequal\n\n", ok)

      fmt.Printf("games		: %#v\n", games)
      fmt.Printf("newGames	: %#v\n", newGames)
      fmt.Printf("games		: %T\n", games)
      fmt.Printf("games' len	: %d\n", len(games))
      fmt.Printf("nil?		: %t\n", games == nil)
    }
    ====OUTPUT====
    games and newGames are not equal

    games           : []string{}
    newGames        : []string{"pacman", "doom", "pong"}
    games           : []string
    games' len      : 0
    nil?            : false
    ```
## 新增唯一編號產生器
1. 使用 `append()` 新增 Slice 的 element。使用 `nums[:]` 可以將 Array 換成 Slice。
    ```
    package main

    import (
      "fmt"
      "math/rand"
      "os"
      "sort"
      "strconv"
      "time"
    )

    func main() {
      rand.Seed(time.Now().UnixNano())

      max, _ := strconv.Atoi(os.Args[1])

      var uniques []int

    loop:
      for len(uniques) < max {
        n := rand.Intn(max) + 1
        fmt.Print(n, " ")

        for _, u := range uniques {
          if u == n {
            continue loop
          }
        }

        uniques = append(uniques, n)
      }
      fmt.Println("\n\nuniques:", uniques)

      sort.Ints(uniques)
      fmt.Println("\nsorted:", uniques)

      nums := [5]int{5, 4, 3, 2, 1}
      sort.Ints(nums[:])
      fmt.Println("\nnums:", nums)
    }
    ====EXECUTE====
    go run main.go 10
    ====OUTPUT====
    5 3 4 1 5 7 6 4 3 8 4 10 3 10 6 9 6 10 7 9 10 5 4 5 7 1 5 10 2 

    uniques: [5 3 4 1 7 6 8 10 9 2]

    sorted: [1 2 3 4 5 6 7 8 9 10]

    nums: [1 2 3 4 5]
    ```
## Append：新增到 Slice
1. 用法：`append(slice, newElement)`，append() 可以到處使用，不需要引入任何 package。
2. 這邊下面的 nums 還是 []int{1, 2, 3}，因為 append() 不會改變傳入的 Slice，需要把 append 過後的結果傳到一個新的 Slice。
    ```
    nums := []int{1, 2, 3}
    append(nums, 4)
    ```
3. `nums = append(nums, 4)` 把 append() 過後的結果存回去本來的 Slice。
4. 可以 append 多個 elements，因為 append 是 variadic function，`nums = append(nums, 4, 9)`。
5. 可以使用 ellipsis 來 append 一個 Slice 到另外一個 Slice。
    ```
    nums := []int{1, 2, 3}
    tens := []int{12, 13}
    nums = append(nums, tens...)
    ```
6. 取得課程的 prettyslice `go get -u github.com/inancgumus/prettyslice`。
7. 使用 append() 的範例。
    ```
    package main

    import s "github.com/inancgumus/prettyslice"

    func main() {
      var todo []string

      todo = append(todo, "sing")
      todo = append(todo, "run", "code", "play")

      tomorrow := []string{"see mom", "learn go"}
      todo = append(todo, tomorrow...)

      s.Show("todo", todo)
    }
    ```
## Slicing：來減少 Slice 吧！
1. Sliceable：可以被 Slice 的任意值，比方說：Array, Slice 和 String 都是 Sliceable。
2. `newSlice := sliceable[START:STOP]`，START 就是從哪個 index 開始 slice，STOP 就是 slice 到哪個位置（範圍是 index + 1），最後回傳的會是一個新的 Slice。
3. `msg := []string{"h", "e", "l", "l", "o"}`，`msg[0:1]` 就是 `[]string{"h"}`，`msg[4:5]` 就是 `[]string{"o"}`。如果第一個是最前面的數字，最後面跟長度一樣，就可以省略，比方說 `msg[:]` 回傳 `[]string{"h", "e", "l", "l", "o"}`。如果用 `msg[:6]` 因為沒有這麼長，會出現 `RUNTIME ERROR: Slice bounds out of range`。
4. 可以在 slice 過後再 append element 上去，`append(msg[:4], "!")`，結果會是 `[]string{"h", "e", "l", "l", "!"}`，但是這邊原本的 Slice 也會變成 `[]string{"h", "e", "l", "l", "!"}`，後面會解釋為什麼有這樣奇怪的現象。
5. slicing 的範例。可以使用取得長度的方式來取得位置，更加容易閱讀。被 slice 過的 Slice 也可以再次 slice，這稱為 re-slicing。slice 之後會回傳 Slice，如果用 index 的方式則會取得 element 的內容，在下面的範例是 string。
    ```
    package main

    import (
      "fmt"
      s "github.com/inancgumus/prettyslice"
    )

    func main() {
      items := []string{
        "pacman", "mario", "tetris", "doom", "galaga", "frogger", "asteroids", "simcity", "metroid", "defender", "rayman", "tempest", "ultima",
      }

      s.MaxPerLine = 4
      s.Show("items", items)

      top3 := items[:3]
      s.Show("top 3 items", top3)

      l := len(items)

      last4 := items[l-4:]
      s.Show("last 4 items", last4)

      mid := last4[1:3]
      s.Show("mid items", mid)

      fmt.Printf("slicing: %T %[1]q\n", items[2:3])
      fmt.Printf("indexing: %T %[1]q\n", items[2])
    }
    ```
## 如果使用 Slice 來新增分頁(Pagination)？
1. 分頁的範例。如果遇到錯誤，可以使用 `printf` 來進行除錯。`Sprintf` 和 `printf` 其實很像，差別在於 `Sprintf` 回傳格式化的 String 而不是列印出來。
    ```
    package main

    import (
      "fmt"
      s "github.com/inancgumus/prettyslice"
    )

    func main() {
      items := []string{
        "pacman", "mario", "tetris", "doom", "galaga", "frogger", "asteroids", "simcity", "metroid", "defender", "rayman", "tempest", "ultima",
      }

      const pageSize = 4

      l := len(items)
      for from := 0; from < l; from+=pageSize {
        to := from + pageSize
        if to > l {
          to = l
        }

        currentPage := items[from:to]

        head := fmt.Sprintf("Page #%d", (from/pageSize) + 1)
        s.Show(head, currentPage)
      }
    }
    ```
## 什麼是 backing Array？
1. Slice 背後有一個**隱藏的 Array**，也就是 backing Array 儲存在記憶體中，最後回傳的 Slice 會指向那個 Array，Slice 就是指向 backing Array 的一個窗戶。
2. 使用 Slice 表達式產生的 Slice 會跟原本的 Slice 共享相同的 Array。
3. indexing Slice 是非常快的，因為 Slice 的 backing Array 是連續的。
4. 非空值的 Slice 會總是新增新的 Backing Array。例如新增兩個 Slice `ages := []int{35, 15, 25}` 和 `grades := []int{70, 99}`，它們兩個的 backing Array 就是分開的，總結來說，新增不一樣的 Slice，backing Array 是分開的。
5. 後面修改 ages 也會影響到本來的 agesArray。
    ```
    agesArray := [3]int{35, 15, 25}
    ages := agesArray[0:3]
    ages[0] = 100
    ages[2] = 50
    ```
6. 這邊你會發現 grades 也被改變了，而且後面的 ptr 指向的是同一個 backing Array。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
      "sort"
    )

    func main() {
      grades := []float64{40, 10, 20, 50, 60, 70}

      front := grades[:3]

      sort.Float64s(front)

      s.PrintBacking = true
      s.MaxPerLine = 7
      s.Show("grades", grades[:])
      s.Show("front", front)
    }
    ====OUTPUT====
    grades              (len:6  cap:6  ptr:4544)
    ╔════╗╔════╗╔════╗╔════╗╔════╗╔════╗
    ║ 10 ║║ 20 ║║ 40 ║║ 50 ║║ 60 ║║ 70 ║
    ╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝
      0     1     2     3     4     5  
    front               (len:3  cap:6  ptr:4544)
    ╔════╗╔════╗╔════╗+----++----++----+
    ║ 10 ║║ 20 ║║ 40 ║| 50 || 60 || 70 |
    ╚════╝╚════╝╚════╝+----++----++----+
      0     1     2     3     4     5  
    ```
7. 這邊新增一個 newGrades 就會發現 ptr 和本來的 grades 不一樣，而 front 則跟 newGrades 共享同一個 backing Array。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
      "sort"
    )

    func main() {
      grades := []float64{40, 10, 20, 50, 60, 70}

      var newGrades []float64
      newGrades = append(newGrades, grades...)

      front := newGrades[:3]

      sort.Float64s(front)

      s.PrintBacking = true
      s.MaxPerLine = 7
      s.Show("grades", grades[:])
      s.Show("newGrades", newGrades)
      s.Show("front", front)
    }
    ====OUTPUT====
    grades              (len:6  cap:6  ptr:2896)
    ╔════╗╔════╗╔════╗╔════╗╔════╗╔════╗
    ║ 40 ║║ 10 ║║ 20 ║║ 50 ║║ 60 ║║ 70 ║
    ╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝
      0     1     2     3     4     5  
    newGrades           (len:6  cap:6  ptr:2944)
    ╔════╗╔════╗╔════╗╔════╗╔════╗╔════╗
    ║ 10 ║║ 20 ║║ 40 ║║ 50 ║║ 60 ║║ 70 ║
    ╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝
      0     1     2     3     4     5  
    front               (len:3  cap:6  ptr:2944)
    ╔════╗╔════╗╔════╗+----++----++----+
    ║ 10 ║║ 20 ║║ 40 ║| 50 || 60 || 70 |
    ╚════╝╚════╝╚════╝+----++----++----+
      0     1     2     3     4     5  
    ```
8. 可以在 append 的地方直接放入 nil 的 Slice，但是那邊一定要是 Slice，所以使用 `[]float64(nil)`。同時我們新增 front2, front3，看結果你會發現一樣都被排序了，因為它們共享相同的 backing Array。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
      "sort"
    )

    func main() {
      grades := []float64{40, 10, 20, 50, 60, 70}

      newGrades := append([]float64(nil), grades...)

      front := newGrades[:3]
      front2 := front[:3]
      front3 := front2

      sort.Float64s(front)

      s.PrintBacking = true
      s.MaxPerLine = 7
      s.Show("grades", grades[:])
      s.Show("newGrades", newGrades)
      s.Show("front", front)
      s.Show("front2", front2)
      s.Show("front3", front3)
    }
    ====OUTPUT====
     grades              (len:6  cap:6  ptr:4544)
    ╔════╗╔════╗╔════╗╔════╗╔════╗╔════╗
    ║ 40 ║║ 10 ║║ 20 ║║ 50 ║║ 60 ║║ 70 ║
    ╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝
      0     1     2     3     4     5  
    newGrades           (len:6  cap:6  ptr:4592)
    ╔════╗╔════╗╔════╗╔════╗╔════╗╔════╗
    ║ 10 ║║ 20 ║║ 40 ║║ 50 ║║ 60 ║║ 70 ║
    ╚════╝╚════╝╚════╝╚════╝╚════╝╚════╝
      0     1     2     3     4     5  
    front               (len:3  cap:6  ptr:4592)
    ╔════╗╔════╗╔════╗+----++----++----+
    ║ 10 ║║ 20 ║║ 40 ║| 50 || 60 || 70 |
    ╚════╝╚════╝╚════╝+----++----++----+
      0     1     2     3     4     5  
    front2              (len:3  cap:6  ptr:4592)
    ╔════╗╔════╗╔════╗+----++----++----+
    ║ 10 ║║ 20 ║║ 40 ║| 50 || 60 || 70 |
    ╚════╝╚════╝╚════╝+----++----++----+
      0     1     2     3     4     5  
    front3              (len:3  cap:6  ptr:4592)
    ╔════╗╔════╗╔════╗+----++----++----+
    ║ 10 ║║ 20 ║║ 40 ║| 50 || 60 || 70 |
    ╚════╝╚════╝╚════╝+----++----++----+
      0     1     2     3     4     5  
    ```