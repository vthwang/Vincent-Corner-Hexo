---
title: Golang 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/golang/GolangDay01.jpg
date: 2021-07-19 18:47:56
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay01.jpg">

***
# 章節一
## 安裝 Go 環境
1. [安裝Go環境教學](https://www.youtube.com/watch?v=1MXIGYrMk80)
## 變數介紹
1. 你必須要先定義變數才能夠使用它，所以你不能直接給一個未定義的變數一個值，因為它不存在。
2. 在 Dynamic Programming 裡面，你可以在還沒定義變數之前，直接給它值，這樣很好用，但是對後面的程式碼維護並不容易。
3. `var speed int`
    - `var` 就是 variable 的簡稱，宣告變數一定要輸入這個 Keyword。
    - `speed` 就是變數的**名字**，又稱為「identifier」，這是一個獨一無二的名字，用來讓 Go 了解你在提到哪個變數。
        - 在電腦科學裡面，兩件事情是最困難的，cache invalidation 和 naming，以下說的命名原則可以適用到 function name, package name...等等。
        - Go 可以這樣命名，下面是命名範例，真實情境不一定會這樣使用。
            - `var speed int`
            - `var SpeeD int`
            - `var _speed int`
            - `var 速度 int` (unicode 是可以的)
        - Go 不能這樣命名，這些原則是為了避免模稜兩可的命名
            - 字首不能是數字 `var 3speed int`
            - 字首不能是標點符號 `var !speed int`
            - 變數不能包含標點符號，`var spe!ed int`，因為標點符號在 Go 裡面有特殊意義，它讓 Go 編譯器更容易辨識名字。
            - 變數不能包含 Go Keywords `var var int`，Go 不允許你覆寫他的 keywords。
    - `int` 是變數的類型，int 是 integer 的簡稱，在 Go 裡面，**所有的**變數和值都有**類型**，因為 Go 是強型別語言(Strongly Typed Programming Language)。它比較像 C, C#, Java，它幫助你在編譯的時候就找到問題。
        - 變數類型決定什麼樣的值可以儲存在這個變數，還有哪邊可以使用這個變數。
        - 一旦你指定了變數的類型，你就不能改變它，它是固定的。
4. 宣告變數的範例，在宣告變數的時候，如果是 integer 的話，初始值會是 0。
    ```
    package main

    import "fmt"

    func main() {
        var speed int

        fmt.Println(speed)
    }
    ====OUTPUT====
    0
    ```
## 範例：Path Separator
1. 你會學到三樣東西。
    - 使用 Go 標準套件(stdlib) - path
    - 學習如何賦值給表達式回傳的多個值
    - 拋棄其中一個值(blank-identifier)
2. **path** 套件提供實用的功能來處理 **url string** 路徑。
3. 範例
    ```
    package main

    import (
      "fmt"
      "path"
    )

    func main() {
      var dir, file string

      dir, file = path.Split("css/main.css")

      fmt.Println("dir: ", dir)
      fmt.Println("file: ", file)
    }
    ====OUTPUT====
    dir:  css/
    file:  main.css
    ```
4. 如果你想拋棄回傳回來的值，用 `_` 來賦空值。
    ```
    package main

    import (
      "fmt"
      "path"
    )

    func main() {
      var file string

      _, file = path.Split("css/main.css")

      fmt.Println("file: ", file)
    }
    ====OUTPUT====
    file:  main.css
    ```
5. 你也可以使用 `:=` (short declaration) 直接將表達式回傳的值直接變成一個變數。
    ```
    package main

    import (
      "fmt"
      "path"
    )

    func main() {
      _, file := path.Split("css/main.css")

      fmt.Println("file: ", file)
    }
    ====OUTPUT====
    file:  main.css
    ```
## 什麼時候使用 short declaration
1. 什麼時候使用 normal declaration?
    - 如果你不知道**初始值**，你就用 normal declaration，這是 Go 社群的傳統，建議你跟隨這個傳統，這樣大家就可以輕鬆地了解你的程式碼。
        ```
        package main

        func main() {
          score := 0 // DON'T!
          var score int // already score = 0
        }
        ```
    - 當你需要 **package scoped** 變數。
        ```
        package main
        
        version := 0  // DON'T!
        var version string // Good
        ```
    - 當你想要將**變數組合**在一起增強**可讀性**。
        ```
        package main

        func main() {
          var (
            // related:
            video string

            // closely related:
            duration int
            current int
          )
        }
        ```
2. 什麼時候使用 short declaration，我們最常使用 short declaration，因為 Go 喜歡精簡的語法。
    - 如果你知道**初始值**，就用 short declaration。
        ```
        package main

        func main() {
          var width, height = 100, 50 // DON'T
          width, height := 100, 50 // Good
        }
        ```
    - 讓程式碼保持精簡
    - 為了 redeclaration，redeclaration 是禮物也是詛咒，會 shadowing 已經 declaration 的變數(後面會說到)。
        ```
        package main

        func main() {
          // DON'T
          width = 50 // assigns 50 to width
          color := "red" // new variable: color

          width, color := 50, "red" // Good, same as above
        }
        ```
## 轉換值
1. 型別轉換：用**另外一個型態**改變一個**值**的**型態**。
2. 轉換型別可能形成破壞性的操作，2.5 轉換成 int 之後，會變成 2。
    ```
    package main

    import "fmt"

    func main() {
      speed := 100 // speed is int
      force := 2.5 // force is float64

      speed = speed * int(force)

      fmt.Println(speed)
    }
    ====OUTPUT====
    200
    ```
3. 以下範例操作型別轉換之後就會是正確的，因為 speed 轉換成 100.0，然後乘以 2.5 會等於 250.0，最後 250.0 轉換成 int 之後，就會得到 250，而且它正是 int，所以可以正確輸出。
    ```
    package main

    import "fmt"

    func main() {
      speed := 100 // speed is int
      force := 2.5 // force is float64

      speed = int( float64(speed) * force )

      fmt.Println(speed)
    }
    ====OUTPUT====
    250
    ```
## 取得命令列的輸入
1. 要從命令列取得輸入，要用名為 os 的 Go 套件。
2. os 套件裡面的 **Args**，當你運行 go 的時候，Go 會自動將輸入的 Arguments 變成變數。
3. `var Args []string`，這邊要講到 slice 的概念，但是這邊的 slice 只是簡單的說，後面會有一個詳細的章節。
    - `[]string` Args 的類型是『slice of strings』，意思是 Args 可以儲存一連串的 string 在裡面。變數只能儲存單一值，slice 可以儲存很多值，但是 slice 它自己本質上是單一值。
    - 在 slice 的每一個值都是未命名的變數，所以要如何在 slice 取得沒有名字的變數呢？要用 index expression 來取得變數。
        - `go main.go hi yo`，用空格來區別 arguments，這邊的 hi 和 yo 是兩個 arguments。
        - Args[0]，儲存程式的**路徑**，它是一個暫時的路徑，ex: .../exe/main
        - Args[1]，第一個 argument，所以就是 hi
        - Args[2]，第二個 argument，所以就是 yo
## 學習 os.Args 的基礎
1. 執行範例，了解 os.Args 和 len 的用法。
    ```
    package main

    import (
      "fmt"
      "os"
    )

    func main() {
      fmt.Printf("%#v\n", os.Args)

      fmt.Println("Path", os.Args[0])
      fmt.Println("1st Argument:", os.Args[1])
      fmt.Println("2nd Argument:", os.Args[2])
      fmt.Println("3rd Argument:", os.Args[3])

      fmt.Println("Number of items inside os.Args", len(os.Args))
    }
    ====EXECUTE====
    go run go.main
    ====OUTPUT====
    []string{"/var/folders/3n/qn9m57sn0jq8h3pxfb11wq_m0000gn/T/go-build3944444413/b001/exe/main", "hi", "hello", "hey"}
    Path: /var/folders/3n/qn9m57sn0jq8h3pxfb11wq_m0000gn/T/go-build3944444413/b001/exe/main
    1st Argument: hi
    2nd Argument: hello
    3rd Argument: hey
    Number of items inside os.Args: 4
    ```
2. 封裝上面的範例。
    ```
    ====EXECUTE====
    go build -o greeter
    ./greeter hi hello hey
    ====OUTPUT====
    []string{"./greeter", "hi", "hello", "hey"}
    Path: ./greeter
    1st Argument: hi
    2nd Argument: hello
    3rd Argument: hey
    Number of items inside os.Args: 4
    ```
## 命名方式（推薦）
1. 非慣用的命名方式。
    ```
    func Read(buffer *Buffer, inBuffer []byte) (size int, err error) {
      if buffer.empty() {
        buffer.Reset
      }
    }

    size = copy(
      inBuffer,
      buffer.buffer[buffer.offset:])

    buffer.offset += size
    return size, nil
    ```
2. 慣用的命名方式。
    ```
    func Read(b *Buffer, p []byte) (n int, err error) {
      if b.empty() {
        b.Reset
      }
    }

    n = copy(p, b.buffer[b.off:])

    b.off += n
    return n, nil
    ```
3. 很多人批評 Go 的命名神秘難解，那是因為讀太少 Go 的程式碼，多讀一點標準函式庫的 Go 程式碼，能夠幫助你理解這些命名傳統。以下是常用的簡寫。
    ```
    var s string // string
    var i int // index
    var num int // number
    var msg string // message
    var v string // value
    var val string // value
    var fv string // flag value
    var err error // error value
    var args []string // arguments
    var seen boolean // has seen?
    var parsed boolean // parsing ok?
    var buf [] byte // buffer
    var off int // offset
    var op int // operation
    var opRead int // read operation
    var l int // length
    var n int // number or number of
    var m int // another number
    var c int // capacity
    var c int // character
    var a int // array
    var r rune // rune
    var sep string // separator
    var src int // source
    var dst int // destination
    var b byte // byte
    var b []byte // buffer
    var w io.Writer // writer
    var r io.Reader // reader
    var pos int // position
    ```
4. 為什麼命名那麼重要？因為可讀性 = 可維護性。
5. 使用單詞前面的第一個字母，ex: `var fv string // flag value`。
6. 在小範圍裡面使用更少的字母。
    ```
    var bytesRead int // numbers of bytes read (NOT GOOD)
    var n int // numbers of bytes read (GOOD)
    ```
7. 在大範圍的地方使用完整的文字表現意思。
    ```
    package file
    var fileClosed bool
    ```
8. 使用混合駝峰式（mixedCaps），使用 `type PlayerScore struct` 或是 `type playerScore struct` 都是可以的。
9. 對縮寫詞（acronyms）使用全大寫。
    ```
    var localAPI string // GOOD
    var localApi string // NOT GOOD
    ```
10. 不要結巴，也就是說不要重複的使用一個詞。
    ```
    player.PlayerScore // NOT GOOD
    player.Score // GOOD
    ```
11. 不要在名字的地方使用底線。
    ```
    const MAX_TIME int // NOT GOOD
    const MaxTime int // Good
    const N int // Still Good
    ```