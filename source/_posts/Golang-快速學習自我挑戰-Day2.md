---
title: Golang 快速學習自我挑戰 Day2
thumbnail:
  - /images/learning/golang/GolangDay02.jpg
date: 2021-07-21 19:52:07
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay02.jpg">

***
## 章節一
### 什麼是 Raw String Literal?
1. 會分成三步驟學習：Raw String Literal, 字串的連結(Concatenation), 字串長度(String Length)。
2. String Literal，`"hi there, 星"`，使用雙引號只能有一行，而這邊會進行轉譯(interpreted)，如果有新的一行，Go 會轉換成一個新行字符。
3. Raw String Literal，使用抑音符(back quotes) 可以有多行，但是不會進行轉譯，你輸入什麼，它就顯示什麼。
    ```
    `hi 
    there`
    ```
4. 範例，整體來說，用 Raw String Literal，更好閱讀且方便。
    ```
    package main

    import "fmt"

    func main() {
      var s string
      s = "how are you?"
      fmt.Println(s)
      s = `how are you?`
      fmt.Println(s)

      s = "<html>\n\t<body>\"Hello\"</body>\n</html>"
      fmt.Println(s)

      s = `
    <html>
      <body>"Hello""</body>
    </html>`
      fmt.Println(s)

      fmt.Println("c:\\my\\dir\\file")
      fmt.Println(`c:\my\dir\file`)
    }
    ```
### 如何取得 utf-8 的字串長度？
1. 你可以用 `len` 取得字串長度，不過只有英文字能取得字串長度，因為 `len` 真正的作用是取得字串有多少個 byte。
    ```
    package main

    import "fmt"

    func main() {
      name := "carl"

      fmt.Println(len(name))
    }
    ====OUTPUT====
    4
    ```
2. Unicode 的字元每一個可以包含 1-4 個 byte。
    ```
    package main

    import "fmt"

    func main() {
      name := "王霆瑄"

      fmt.Println(len(name))
    }
    ====OUTPUT====
    9
    ```
3. 引入 utf8 套件的 RuneCountInString 可以計算字串長度，`rune` 可以計算英文字串和非英文字串。
    ```
    package main

    import (
      "fmt"
      "unicode/utf8"
    )

    func main() {
      name := "王霆瑄"

      fmt.Println(utf8.RuneCountInString(name))
    }
    ====OUTPUT====
    3
    ```
### 範例：BANGER
1. 輸入一段字，返回這一段文字的大寫，並計算文字有幾個字之後，加上同樣數量的驚嘆號。
2. 這邊會使用到 [string package](https://pkg.go.dev/strings)，提供操作 **string** 的實用函數。
3. 範例答案
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    func main() {
      msg := os.Args[1]
      l := len(msg)

      s := msg + strings.Repeat("!", l)
      s = strings.ToUpper(s)

      fmt.Println(s)
    }
    ```
4. 實作題目：加上 "!" 到 argument 之前，如果輸入 hey，則返回 !!!HEY!!!，這邊只能使用一次 Repeat function。
    ```
    package main

    import (
      "fmt"
      "os"
      "strings"
    )

    func main() {
      msg := os.Args[1]
      l := len(msg)
      ex := strings.Repeat("!", l)

      s := ex + msg + ex
      s = strings.ToUpper(s)

      fmt.Println(s)
    }
    ```
### 常數(Constant)和 iota
1. iota 是 Go 裡面的常數產生器，可以自動加 1。
    ```
    package main

    import "fmt"

    func main() {
      const(
        monday = iota + 1
        tuesday
        wednesday
        thursday
        friday
        saturday
        sunday
      )

      fmt.Println(monday, tuesday, wednesday, thursday, friday, saturday, sunday)
    }
    ====OUTPUT====
    1 2 3 4 5 6 7
    ```
2. 可以使用 `_` 當作 blank identifier，來省略過你不需要用到的常數。
    ```
    package main

    import "fmt"

    func main() {
      const(
        EST = -(5 + iota)
        _
        MST
        PST
      )

      fmt.Println(EST, MST, PST)
    }
    ====OUTPUT====
    -5 -7 -8
    ```
### Golang fmt 套件備忘單
<img src="/images/learning/golang/GoLangfmtPrintingCheatSheet.jpg">

### Println vs Printf


