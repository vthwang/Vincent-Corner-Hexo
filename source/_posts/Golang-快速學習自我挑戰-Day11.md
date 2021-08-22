---
title: Golang 快速學習自我挑戰 Day11
thumbnail:
  - /images/learning/golang/GolangDay11.jpg
date: 2021-08-18 17:57:38
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay11.jpg">

***
# 第五章：Slices 和 Internal
## 完整的 Slice 表達式：限制 Slice 的 capacity
1. `newSlice := sliceable[START:STOP:CAP]`，`CAP` 可以限制回傳的 Slice capacity。
2. stop position <= capacity position，停止的位置必定小於等於 capacity 的位置。
    ```
    sliceable := []byte{'f', 'u', 'l', 'l'}
    sliceable[0:3] - len: 3, cap: 4
    sliceable[0:3:3] - len: 3, cap: 3
    sliceable[0:2:2] - len: 2, cap: 2
    sliceable[0:1:1] - len: 1, cap: 1
    sliceable[1:3:3] - len: 2, cap: 2
    sliceable[2:3:3] - len: 1, cap: 1
    sliceable[2:3:4] - len: 1, cap: 2
    sliceable[4:4:4] - len: 0, cap: 0
    ```
3. 如果在 odds 設定 `nums[:2]` 然後 append 數字上去之後，本來的 Array 會被取代，因為共享同一個 backing Array，這時候限制 capacity 之後，它就會生成新的 Array。而 evens 因為 capacity slice 之後就只有 2 了，所以不需要定義 capacity 就一樣會生成新的 Array。 
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
    )

    func main() {
      s.PrintBacking = true

      nums := []int{1, 3, 2, 4}
      odds := append(nums[:2:2], 5, 7)
      evens := append(nums[2:4], 6, 8)

      s.Show("nums", nums)
      s.Show("odds", odds)
      s.Show("evens", evens)
    }
    ====OUTPUT====
    nums                (len:4  cap:4  ptr:3840)
    ╔═══╗╔═══╗╔═══╗╔═══╗
    ║ 1 ║║ 3 ║║ 2 ║║ 4 ║
    ╚═══╝╚═══╝╚═══╝╚═══╝
      0    1    2    3  
    odds                (len:4  cap:4  ptr:3872)
    ╔═══╗╔═══╗╔═══╗╔═══╗
    ║ 1 ║║ 3 ║║ 5 ║║ 7 ║
    ╚═══╝╚═══╝╚═══╝╚═══╝
      0    1    2    3  
    evens               (len:4  cap:4  ptr:3904)
    ╔═══╗╔═══╗╔═══╗╔═══╗
    ║ 2 ║║ 4 ║║ 6 ║║ 8 ║
    ╚═══╝╚═══╝╚═══╝╚═══╝
      0    1    2    3  
    ```
## make()：預分配位置給 backing Array
1. make 初始化並回傳一個指定長度和 capacity 的 Slice。如果使用一直使用 append 會非常耗能，所以如果提前知道大小，先指定好，會更有效率。
2. `make(type, length, capacity)`，最常使用的方式就是 `s := make([]int, 0, 5)`，直接指定一個變數給它，後面只需要直接 append()，`s = append(s, 42)`。
3. 這是沒有效率的方式，因為指定了好幾次不同的記憶體位置。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
      "strings"
    )

    func main() {
      s.PrintBacking = true
      s.MaxPerLine = 10

      tasks := []string{"jump", "run", "read"}

      var upTasks []string
      s.Show("upTasks", upTasks)

      for _, task := range tasks {
        upTasks = append(upTasks, strings.ToUpper(task))
        s.Show("upTasks", upTasks)
      }
    }
    ====OUTPUT====
    upTasks             (len:0  cap:0  ptr:0   )
    <nil slice>
    upTasks             (len:1  cap:1  ptr:5872)
    ╔══════╗
    ║ JUMP ║
    ╚══════╝
        0   
    upTasks             (len:2  cap:2  ptr:7424)
    ╔══════╗╔═════╗
    ║ JUMP ║║ RUN ║
    ╚══════╝╚═════╝
        0      1   
    upTasks             (len:3  cap:4  ptr:9136)
    ╔══════╗╔═════╗╔══════╗+--+
    ║ JUMP ║║ RUN ║║ READ ║|  |
    ╚══════╝╚═════╝╚══════╝+--+
        0      1       2     3 
    ```
4. 使用 make() 改寫，就會指向同一個 backing Array 了。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
      "strings"
    )

    func main() {
      s.PrintBacking = true
      s.MaxPerLine = 10

      tasks := []string{"jump", "run", "read"}

      upTasks := make([]string, 0, len(tasks))
      s.Show("upTasks", upTasks)

      for _, task := range tasks {
        upTasks = append(upTasks, strings.ToUpper(task))
        s.Show("upTasks", upTasks)
      }
    }
    ```
## copy()：在 Slices 之間複製 elements
1. `copy(destination Slice, source Slice)`，來源 Slice 和目標 Slice 的型別必須相同，而複製 elements 是基於長度最小的 Slice 來複製，而最後 copy() 回傳的是幾個 element 被複製了。
2. 如果你用比較少的 element copy 到目標 Slice，它就只會複製少的那一個，比方說，把 99 和 100 複製到本來的 data，只有前面兩個有改變，如果來源 element 比較多，那就只會複製目標有的 element 數量，比方說，把 10, 5, 15, 0, 20 複製到只有 4 個 element 的 data，就只有四個會改變，而不會增加長度。如果需要增加長度要用 append 的方式，也可以用 make() 之後再 copy() 來新增 Slice，但是用 append() 更好一些，因為看起來比較精簡。
    ```
    package main

    import (
      "fmt"
      s "github.com/inancgumus/prettyslice"
    )

    func main() {
      data := []float64{10, 25, 30, 50}

      copy(data, []float64{99, 100})

      //saved := make([]float64, len(data))
      //copy(saved, data)
      saved := append([]float64(nil), data...)

      n := copy(data, []float64{10, 5, 15, 0, 20})
      fmt.Printf("%d probabilities copied.\n", n)

      s.Show("Probabilities (saved)", saved)
      s.Show("Probabilities (data)", data)
      fmt.Printf("Is it gonna rain? %.f%% chance.\n",
        (data[0]+data[1]+data[2]+data[3])/float64(len(data)))
    }
    ====OUTPUT====
    4 probabilities copied.
    Probabilities (saved)  (len:4  cap:4  ptr:912 )
    ╔════╗╔═════╗╔════╗╔════╗
    ║ 99 ║║ 100 ║║ 30 ║║ 50 ║
    ╚════╝╚═════╝╚════╝╚════╝
      0     1      2     3  
    Probabilities (data)  (len:4  cap:4  ptr:880 )
    ╔════╗╔═══╗╔════╗╔═══╗
    ║ 10 ║║ 5 ║║ 15 ║║ 0 ║
    ╚════╝╚═══╝╚════╝╚═══╝
      0    1     2    3  
    Is it gonna rain? 8% chance.
    ```
## 如何使用 multi-dimensional Slice？
1. 基本上就跟 multi-dimensional Array 一樣，這邊實現計算每天的花費總和。
    ```
    package main

    import (
      "fmt"
      "strconv"
      "strings"
    )

    func main() {
      spendings := fetch()

      for i, daily := range spendings {
        var total int

        for _, spending := range daily {
          total += spending
        }
        fmt.Printf("Day %d: %d\n", i+1, total)
      }
    }

    func fetch() [][]int {
      content := `200 100
    25 10 45 60
    5 15 35
    95 10
    50 25`

      lines := strings.Split(content, "\n")

      spendings := make([][]int, len(lines))

      for i, line := range lines {
        fields := strings.Fields(line)

        spendings[i] = make([]int, len(fields))

        for j, field := range fields {
          spending, _ := strconv.Atoi(field)

          spendings[i][j] = spending
        }
      }

      return spendings
    }
    ```
# 第十章：Maps 和 Internal
## 創建一個英文和土耳其語的 dictionary
1. Maps 允許我們**更快**使用 unique key 去存取資料。
2. 先使用一般的方式來做查詢，裡面就會有 O(n) 的演算法，在資料越來越多的情況下，速度就會大幅下降。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      args := os.Args[1:]
      if len(args) != 1 {
        fmt.Println("[english word] -> [turkish word]")
        return
      }
      query := args[0]

      english := []string{"good", "great", "perfect"}
      turkish := []string{"iyi", "harika", "mükemmel"}

      for i, w := range english {
        if query == w {
          fmt.Printf("%q means %q\n", w, turkish[i])
          return
        }
      }
      fmt.Printf("%q not found\n", query)
    }
    ```
3. Key 和 Value 的型別不需要相同，他們可以不同。一個 Map key 必須要是可以比較的型別，比方說：`map[int]bool` int 就是可以比較的型別，而如果 `map[[]float64]bool` []float64 就是不能比較的型別，Slice、Map 和 function values 都是不能比較的型別。另外不要使用 float 型別當作 Map key，因為結果會不準確。如果新增 Map 的話，Map 裡面有重複的 key 就會覆蓋，如果沒有重複的 key 就會新增。在取得 Map 的時候，可以增加第二個參數，來確定 Map 裡面是否有資料，如果有資料就會回傳 true。另外 Map 是用來快速查找的，不要用 loop 來取得資料，如果想要用 loop，Slice 會是更好的選項。從 Go 1.12 版本之後，Map 會自動排序，所以 Map 可以進行比較。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      args := os.Args[1:]
      if len(args) != 1 {
        fmt.Println("[english word] -> [turkish word]")
        return
      }
      query := args[0]

      dict := map[string]string{
        "good": "kötü",
        "great": "harika",
        "perfect": "mükemmel",
      }
      dict["good"] = "iyi"
      dict["up"] = "yukarı"
      dict["down"] = "aşağı"
      dict["mistake"] = ""

      copied := map[string]string{"down":"aşağı", "good":"iyi", "great":"harika", "mistake":"", "perfect":"mükemmel", "up":"yukarı"}

      first := fmt.Sprintf("%s", dict)
      second := fmt.Sprintf("%s", copied)

      if first == second {
        fmt.Println("Maps are equal.")
      }

      if value, ok := dict[query]; ok {
        fmt.Printf("%q means %#v\n", query, value)
        return
      }
      fmt.Printf("%q not found\n", query)

      fmt.Printf("# of keys: %d\n", len(dict))
    }
    ```
## Map Internal：Map 實際在後面是如何運作的？
1. Map Header 跟 Slice 一樣，你新增之後，它會一樣指向同一個記憶體位置，所以如果改了其中一個的 value，兩個都會改。跟 Slice 不同的地方是，Map 只有包含記憶體的位址，然後會指向一個 Map Header，這個 Header 裡面包含了很多複雜且可以移動部分的資料類型。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      args := os.Args[1:]
      if len(args) != 1 {
        fmt.Println("[english word] -> [turkish word]")
        return
      }
      query := args[0]

      dict := map[string]string{
        "good": "iyi",
        "great": "harika",
        "perfect": "mükemmel",
      }

      turkish := dict
      turkish["good"] = "güzel"
      dict["great"] = "kusursuz"
      fmt.Printf("english: %q\nturkish: %q\n", dict, turkish)

      if value, ok := dict[query]; ok {
        fmt.Printf("%q means %#v\n", query, value)
        return
      }
      fmt.Printf("%q not found\n", query)

      fmt.Printf("# of keys: %d\n", len(dict))
    }
    ====OUTPUT====
    english: map["good":"güzel" "great":"kusursuz" "perfect":"mükemmel"]
    turkish: map["good":"güzel" "great":"kusursuz" "perfect":"mükemmel"]
    "perfect" means "mükemmel"
    ```
2. 使用 make() 複製 Map，第二個參數指定的 length 就是個指示，讓 Go 知道什麼時候去增加 Map 更合適，但是實際的 Map 長度會是 0。delete(mapValue, key) 可以刪除指定 Map 的 key，而且你可以重複一直使用 delete() 不管 key 存在與否。如果使用 `dict = nil` 來刪除 Map 裡面所有的 key，看起來是刪除了，事實上他只是指向別的位置，Map 並沒有真正消失，要用 for loop 來刪除才能真正刪除。下面的範例，將土耳其語再翻譯回去英文，用 make() 來實現。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      args := os.Args[1:]
      if len(args) != 1 {
        fmt.Println("[english word] -> [turkish word]")
        return
      }
      query := args[0]

      dict := map[string]string{
        "good": "iyi",
        "great": "harika",
        "perfect": "mükemmel",
        "awesome": "mükemmel",
      }
      
      // delete all
      // for k := range dict {
      // 	delete(dict, k)
      // }

      turkish := make(map[string]string, len(dict))
      for k, v := range dict {
        turkish[v] = k
      }

      if value, ok := turkish[query]; ok {
        fmt.Printf("%q means %#v\n", query, value)
        return
      }

      if value, ok := dict[query]; ok {
        fmt.Printf("%q means %#v\n", query, value)
        return
      }
      fmt.Printf("%q not found\n", query)

      fmt.Printf("# of keys: %d\n", len(dict))
    }
    ```