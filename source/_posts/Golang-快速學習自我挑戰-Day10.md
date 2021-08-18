---
title: Golang 快速學習自我挑戰 Day10
thumbnail:
  - /images/learning/golang/GolangDay10.jpg
date: 2021-08-15 14:16:49
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay10.jpg">

***
# 第五章
## 什麼是 Slice header？
1. 如果一個 Slice 沒有儲存任何 elements，那它裡面包含什麼？Slice 裡面包含記憶體位置用來指向 backing Array。
2. Slice header 裡面包含三個內容，Pointer(記憶體位置)、Length(長度) 和 Capacity(空間大小，儲存記憶體實際佔用的大小，你可以使用 `cap()` 來取得 Capacity 的值)。
3. Slice 就等同於 Slice Header，它是小型的資料結構，裡面包含它的 backing Array。
4. `ages := []int{35, 15, 25}` 它的 Slice Header 就包含 Pointer = 48、Length = 3 和 Capacity = 3。
5. 如果使用 `ages[0:1]` 減少 Slice 之後，它的 Pointer 還是 48，Length 會變成 1，而 Capacity 還是 3 。
6. 如果使用 `ages[1:3]` 減少 Slice 之後，它的 Pointer 會是 56，Length 會變成 2，而 Capacity 會變成 2，因為 Slice 不能往回看，所以 Pointer 和 Capacity 都會改變 。
7. nil Slice 沒有 backing Array，但是它還是有 Slice Header，它的 Slice Header 會是 Pointer = 0、Length = 0 和 Capacity = 0，如果你不知道 Slice 有沒有任何 elements，先 declare 它為一個 nil Slice。
## Slice Header 在 Go 的 runtime 程式碼看起來是怎麼樣的？
1. 你會發現本來的 data 沒有被改變，因為使用 func 會把變數複製過去，看到 output 的位址是兩個不同的位置，所以它們兩個是不同的 Array。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
    )

    type collection [4]string

    func main() {
      s.PrintElementAddr = true

      data := collection{"slices", "are", "awesome", "period"}
      change(data)
      s.Show("main's data", data)
    }

    func change(data collection) {
      data[2] = "brilliant!"
      s.Show("change's data", data)
    }
    ====OUTPUT====
    change's data                               
    ╔════════════════════════════════╗
    ║ [slices are brilliant! period] ║
    ╚════════════════════════════════╝
                    0                
                  8192               
    main's data                                 
    ╔═════════════════════════════╗
    ║ [slices are awesome period] ║
    ╚═════════════════════════════╝
                  0               
                8960 
    ```
2. 如果將 Array 改成 Slice 就會發現 data 的結果是一樣的，因為 Slice 被複製之後，backing Array 的資料仍然是一樣的，可以使用 `&data` 取得 Slice 的位置，會發現 Slice 位置不一樣，因為這邊有兩個 Slice 但是都是同一個 backing Array。
    ```
    package main

    import (
      "fmt"
      s "github.com/inancgumus/prettyslice"
    )

    type collection []string

    func main() {
      s.PrintElementAddr = true

      data := collection{"slices", "are", "awesome", "period"}
      change(data)
      s.Show("main's data", data)
      fmt.Printf("main's data slice address: %p\n", &data)
    }

    func change(data collection) {
      data[2] = "brilliant!"
      s.Show("change's data", data)
      fmt.Printf("changes's data slice address: %p\n", &data)
    }
    ====OUTPUT====
     change's data       (len:4  cap:4  ptr:1392)
    ╔════════╗╔═════╗╔════════════╗╔════════╗
    ║ slices ║║ are ║║ brilliant! ║║ period ║
    ╚════════╝╚═════╝╚════════════╝╚════════╝
        0       1          2           3    
      1392    1408       1424        1440   
    changes's data slice address: 0xc00011e018
    main's data         (len:4  cap:4  ptr:1392)
    ╔════════╗╔═════╗╔════════════╗╔════════╗
    ║ slices ║║ are ║║ brilliant! ║║ period ║
    ╚════════╝╚═════╝╚════════════╝╚════════╝
        0       1          2           3    
      1392    1408       1424        1440   
    main's data slice address: 0xc00011e000
    ```
3. 這邊你會看到 Slice 的長度都是固定的，因為它裡面只有 Slice Header，而 Array 則直接儲存資料，大小和 element 的多寡相關。
    ```
    package main

    import (
      "fmt"
      "unsafe"
    )

    type collection []string

    func main() {
      data := collection{"slices", "are", "awesome", "period"}
      array := [...]string{"slices", "are", "awesome", "period"}
      fmt.Printf("array's size: %d bytes\n", unsafe.Sizeof(array))
      fmt.Printf("slice's size: %d bytes\n", unsafe.Sizeof(data))

      data2 := collection{"slices", "are", "awesome", "period", "!"}
      array2 := [...]string{"slices", "are", "awesome", "period", "!"}
      fmt.Printf("array's size: %d bytes\n", unsafe.Sizeof(array2))
      fmt.Printf("slice's size: %d bytes\n", unsafe.Sizeof(data2))
    }
    ====OUTPUT====
    array's size: 64 bytes
    slice's size: 24 bytes
    array's size: 80 bytes
    slice's size: 24 bytes
    ```
4. Slice 總結：
    - Slice 非常高效且便宜。
    - Slicing：會新增一個新的 Slice Header。
    - Assign 一個 Slice 到另一個 Slice，或是將 Slice 傳到一個 function：只會複製 Slice Header。
    - Slice Header 有固定 Size，就算你有上百萬個 elements，它也不會改變。
    - 所以 Array 非常昂貴，assign 或是 pass Array 到 function 會複製所有的 elements。
## 什麼是 Slice 的 capacity？
1. nil Slice 沒有任何 backing Array，所以它的 capacity 是 0。
2. `ages := []int{35, 15, 25}`，這個 Slice Literal 有 3 個 elements，所以它會創建有 3 個 elements 的 Array。
3. capacity 就是關於 backing Array 的長度和 Slice 從哪裡開始。
4. 由 Slice Literal 創建的 Slice 會有相同的 len 和 cap。
5. `ages[0:0]`，空的 Slice 的長度是 0，但是它的 backing Array 有 3 個 elements，所以它的 capacity 是 3。如果 capacity 不是 0 的情況下，可以再使用 `ages[0:3]` 來 extend 並取得本來的 Slice，也可以使用 `ages[0, cap(ages)]`，會得到一樣的東西。在這邊要注意的是，不能使用 `ages[0:cap(ages) + 1]`，因為你不能 extend 一個超過它自己 capacity 的 Slice。
6. Capacity 就是 backing Array slice 之後的第一個 item 的長度。例如：`ages[1:3]` 的 capacity 就是 2。
7. `ages[3:3]` 是空的 Slice 但是它有 backing Array，長度為 0。這邊有意思的地方是，它的 Pointer 的位置是完整 Slice 的第一個位置，就算它知道 Slice 的位置，Go 也不能夠透過 `ages[0:3]` 來取得完整的 Slice，因為 capacity 等於 0。
8. 如果你失去了原本的 Slice Header，你就不能 extend 回來了。
## 使用 capacity 來 Extend Slice
1. 如果定義一個 nil 的 Slice，那麼它的地址就是 0。如果你定義空的 Slice，不管你定義了幾個，在同一個 runtime 都會指向同一個地址，而且使用相同的 Array。`part[:0]` 會得空的 Slice，使用 `part[:cap(part)]` 就可以完整還原 Slice 了。覆寫 part 會和原來的 part 共享相同的 backing Array，for 迴圈這一段就是一直縮減到沒有為止，就可以觀察到他們是相同的 backing Array。如果不修改 games 的話，後面 games 還是會有值，因為更改 part 不會更改到 games，這就是 Slice 強大的地方，使用 `games = games[len(games):]` 就會讓 games 和 part 一樣是空的 Slice，如此一來，games 和 part 再也不能夠 extend 回來本來的 Slice，這也是為什麼在前面同時定義了 games 和 part 了。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
    )

    type collection []string

    func main() {
      s.PrintBacking = true

      var games []string
      s.Show("games", games)

      games = []string{}
      s.Show("games", games)
      s.Show("another empty", []int{})

      games = []string{"pacman", "mario", "tetris", "doom"}
      s.Show("games", games)

      part := games
      s.Show("part", part)

      part = games[:0]
      s.Show("part[:0]", part)
      s.Show("part[:cap]", part[:cap(part)])

      for cap(part) != 0 {
        part = part[1:cap(part)]
        s.Show("part", part)
      }

      games = games[len(games):]

      s.Show("games", games)
      s.Show("part", part)
    }
    ====OUTPUT====
    games               (len:0  cap:0  ptr:0   )
    <nil slice>
    games               (len:0  cap:0  ptr:4976)
    <empty slice>
    another empty       (len:0  cap:0  ptr:4976)
    <empty slice>
    games               (len:4  cap:4  ptr:9136)
    ╔════════╗╔═══════╗╔════════╗╔══════╗
    ║ pacman ║║ mario ║║ tetris ║║ doom ║
    ╚════════╝╚═══════╝╚════════╝╚══════╝
        0        1         2        3   
    part                (len:4  cap:4  ptr:9136)
    ╔════════╗╔═══════╗╔════════╗╔══════╗
    ║ pacman ║║ mario ║║ tetris ║║ doom ║
    ╚════════╝╚═══════╝╚════════╝╚══════╝
        0        1         2        3   
    part[:0]            (len:0  cap:4  ptr:9136)
    <empty slice>
    +--------++-------++--------++------+
    | pacman || mario || tetris || doom |
    +--------++-------++--------++------+
        0        1         2        3   
    part[:cap]          (len:4  cap:4  ptr:9136)
    ╔════════╗╔═══════╗╔════════╗╔══════╗
    ║ pacman ║║ mario ║║ tetris ║║ doom ║
    ╚════════╝╚═══════╝╚════════╝╚══════╝
        0        1         2        3   
    part                (len:3  cap:3  ptr:9152)
    ╔═══════╗╔════════╗╔══════╗
    ║ mario ║║ tetris ║║ doom ║
    ╚═══════╝╚════════╝╚══════╝
        0         1        2   
    part                (len:2  cap:2  ptr:9168)
    ╔════════╗╔══════╗
    ║ tetris ║║ doom ║
    ╚════════╝╚══════╝
        0        1   
    part                (len:1  cap:1  ptr:9184)
    ╔══════╗
    ║ doom ║
    ╚══════╝
        0   
    part                (len:0  cap:0  ptr:9184)
    <empty slice>
    games               (len:0  cap:0  ptr:9136)
    <empty slice>
    part                (len:0  cap:0  ptr:9184)
    <empty slice>
    ```
## append function 什麼時候會新增一個新的 backing Array？
1. 當 Slice 的 capacity 滿了，append() 就會分配一個新的而且更大的 Array，會回傳新的 Slice Header 而且指向更新的 Array。為什麼 Array 會新增一個更大的 Array，就是為了麼節省未來新分配的數量，複製之前的 Array 到新的 Array 會消耗 CPU 和記憶體的資源，所以當新增更大的 Array 會分配 0 的值到 backing Array 未初始化的 element。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
    )

    type collection []string

    func main() {
      s.PrintBacking = true

      var nums []int
      s.Show("no backing array", nums)

      nums = append(nums, 1, 3)
      s.Show("allocates", nums)

      nums = append(nums, 2)
      s.Show("free capacity", nums)

      nums = append(nums, 4)
      s.Show("no allocation", nums)

      nums = append(nums, nums[2:]...)
      s.Show("nums <- nums[2:]", nums)

      nums = append(nums[:2], 7, 9)
      s.Show("nums[:2] <- 7, 9", nums)

      nums = nums[:6]
      s.Show("nums: extend", nums)
    }
    ====OUTPUT====
    no backing array    (len:0  cap:0  ptr:0   )
    <nil slice>
    allocates           (len:2  cap:2  ptr:5760)
    ╔═══╗╔═══╗
    ║ 1 ║║ 3 ║
    ╚═══╝╚═══╝
      0    1  
    free capacity       (len:3  cap:4  ptr:3936)
    ╔═══╗╔═══╗╔═══╗+---+
    ║ 1 ║║ 3 ║║ 2 ║| 0 |
    ╚═══╝╚═══╝╚═══╝+---+
      0    1    2    3  
    no allocation       (len:4  cap:4  ptr:3936)
    ╔═══╗╔═══╗╔═══╗╔═══╗
    ║ 1 ║║ 3 ║║ 2 ║║ 4 ║
    ╚═══╝╚═══╝╚═══╝╚═══╝
      0    1    2    3  
    nums <- nums[2:]    (len:6  cap:8  ptr:2800)
    ╔═══╗╔═══╗╔═══╗╔═══╗╔═══╗
    ║ 1 ║║ 3 ║║ 2 ║║ 4 ║║ 2 ║
    ╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝
      0    1    2    3    4  
    ╔═══╗+---++---+
    ║ 4 ║| 0 || 0 |
    ╚═══╝+---++---+
      5    6    7  
    nums[:2] <- 7, 9    (len:4  cap:8  ptr:2800)
    ╔═══╗╔═══╗╔═══╗╔═══╗+---+
    ║ 1 ║║ 3 ║║ 7 ║║ 9 ║| 2 |
    ╚═══╝╚═══╝╚═══╝╚═══╝+---+
      0    1    2    3    4  
    +---++---++---+
    | 4 || 0 || 0 |
    +---++---++---+
      5    6    7  
    nums: extend        (len:6  cap:8  ptr:2800)
    ╔═══╗╔═══╗╔═══╗╔═══╗╔═══╗
    ║ 1 ║║ 3 ║║ 7 ║║ 9 ║║ 2 ║
    ╚═══╝╚═══╝╚═══╝╚═══╝╚═══╝
      0    1    2    3    4  
    ╔═══╗+---++---+
    ║ 4 ║| 0 || 0 |
    ╚═══╝+---++---+
      5    6    7  
    ```
## 什麼時候 Slice 的 backing Array 會增加？
1. 每當 Array 不夠的時候，Slice 就會新增更大的 Array 讓你在未來可以直接使用，不需要額外複製 Array。
    ```
    package main

    import (
      s "github.com/inancgumus/prettyslice"
      "github.com/inancgumus/screen"
      "math/rand"
      "time"
    )

    type collection []string

    func main() {
      s.PrintBacking = true
      s. MaxPerLine = 20
      s.Width = 150

      var nums []int

      screen.Clear()
      for cap(nums) <= 128 {
        screen.MoveTopLeft()

        s.Show("nums", nums)
        nums = append(nums, rand.Intn(9) + 1)

        time.Sleep(time.Second / 4)
      }
    }
    ```
2. `5e5` 代表 500000，而 `5e4` 代表 50000，以此類推。當新增 Array 到一個量級的時候，它的增長速度就會變慢，因為你可能後面不需要那麼多 elements 了，而且大量的 elements 是非常耗資源的，所以 Go 已經把 Slice 優化好了，不需要做額外的優化。
    ```
    package main

    import (
      "fmt"
    )

    type collection []string

    func main() {

      ages, oldCap := []int{1}, 1.

      for len(ages) < 5e5 {
        ages = append(ages, 1)

        c := float64(cap(ages))
        if c != oldCap {
          fmt.Printf("len:%-10d cap:%-10g growth:%.2f\n",
            len(ages), c, c/oldCap)
        }
        oldCap = c
      }
    }
    ====OUTPUT====
    len:2          cap:2          growth:2.00
    len:3          cap:4          growth:2.00
    len:5          cap:8          growth:2.00
    len:9          cap:16         growth:2.00
    len:17         cap:32         growth:2.00
    len:33         cap:64         growth:2.00
    len:65         cap:128        growth:2.00
    len:129        cap:256        growth:2.00
    len:257        cap:512        growth:2.00
    len:513        cap:1024       growth:2.00
    len:1025       cap:1280       growth:1.25
    len:1281       cap:1696       growth:1.32
    len:1697       cap:2304       growth:1.36
    len:2305       cap:3072       growth:1.33
    len:3073       cap:4096       growth:1.33
    len:4097       cap:5120       growth:1.25
    len:5121       cap:7168       growth:1.40
    len:7169       cap:9216       growth:1.29
    len:9217       cap:12288      growth:1.33
    len:12289      cap:15360      growth:1.25
    len:15361      cap:19456      growth:1.27
    len:19457      cap:24576      growth:1.26
    len:24577      cap:30720      growth:1.25
    len:30721      cap:38912      growth:1.27
    len:38913      cap:49152      growth:1.26
    len:49153      cap:61440      growth:1.25
    len:61441      cap:76800      growth:1.25
    len:76801      cap:96256      growth:1.25
    len:96257      cap:120832     growth:1.26
    len:120833     cap:151552     growth:1.25
    len:151553     cap:189440     growth:1.25
    len:189441     cap:237568     growth:1.25
    len:237569     cap:296960     growth:1.25
    len:296961     cap:371712     growth:1.25
    len:371713     cap:464896     growth:1.25
    len:464897     cap:581632     growth:1.25
    ```