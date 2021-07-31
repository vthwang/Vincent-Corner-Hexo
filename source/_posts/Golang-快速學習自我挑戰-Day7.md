---
title: Golang 快速學習自我挑戰 Day7
thumbnail:
  - /images/learning/golang/GolangDay07.jpg
date: 2021-07-27 23:57:30
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay07.jpg">

***
# 第三章
## 複合型別(Composite Type)
1. 複合型別的類型
    - Arrays：有 index、固定長度。
    - Slices：有 index、動態長度。
    - Sting Internals：ByteSlices, ASCII & Unicode, Encoding & Decoding。
    - Maps：有 index，key-value pair。
    - Structs：一組不同型別的變數。
2. 這邊會學習到什麼？
    - 什麼是 Array?
    - Getting and Setting Array Elements
    - Array Literals - 建立 Array 最簡單的方式
    - Comparing Array
    - Assigning Array
    - Multi-Dimensional Arrays
    - Keyed Elements
    - Named vs Unnamed Types
3. 為什麼需要 Array？因為**很多時候**我們要一起使用多個變數，這只是其中一個原因，後面會講到用 Array 的更多好處。
    ```
    // No Array
    a := 54
    b := 143
    .. := ..
    oneThousand := 1000
    sum := a + b + .. + oneThousand

    // Using Array
    nums := [...]int{54, 143, .., 1000}
    var sum int
    for _, num := range nums {
      sum += num
    }
    ```
## 在 Go 裡面，Array 是什麼？
1. Go 會將 Array 的資料儲存在**相鄰的**位置，這可以讓效率提升很多，因為資料儲存在旁邊。CPU 就可以部分快取，速度也會變快。
2. Array 的 **size** 就等於 Array 的 **Element size 的總和**。
3. `var age [2]byte`，這邊的 2 就是 Array 的長度，也就是說，Array 最多只能儲存這個長度的內容。
4. `var age [1 + 1]byte`，在長度的地方，可以使用 constant values 或是 constant expressions。
5. 當你設置了 Array 的長度，它就是固定的，之後你就不能更改他的長度了，但是如果你需要更大的 Array，你可以重新 declare 一個新的。
6. 你不能設置 Array 長度為 -1，因為這樣做是沒有意義的。
7. `var age [2]byte`，這邊的 byte 就是 element type，意思是這個 Array 只能儲存這個型別的值。如果你一開始沒有定義值的話，Array 會自動給予初始值，如果是 byte 的話，初始值為 0。
8. 你可以使用任何類型的 type，比方說：`var tags [2]string`，初始值為 `""`
9. 在定義好型別的 Array，不能在 Array 放其它種型別的值。
10. 每一個 Array 的值都是未命名的變數(Unnamed Variables)，所以你不能像變數一樣地使用它。默認的情況下，Go 不允許你直接存取任意記憶體的位置，所以 Go 使用 index expression 來存取 Array 的內容。
11. `var age [2]byte`，要取得 Array 的內容，直接用 `age[0]` 就可以取得了，但是 `age[2]` 是不允許的，因為不可以超過 Array 的長度，`age[-1]` 也是不允許的，因為 Go index 從 0 開始。
12. 你可以使用 assignment operators 來設定 element。
    ```
    var ages [2]int
    ages[0] = 6
    ages[1] -= 3
    // result
    ages[0] = 6
    ages[1] = -3
    ```
## 開始創建一個 Array
1. 










