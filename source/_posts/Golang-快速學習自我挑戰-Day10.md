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










