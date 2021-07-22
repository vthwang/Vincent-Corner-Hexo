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
1. `fmt.Printf("%q\n", brand)`，第一個 argument `"%q\n"` 決定怎麼和如何 print，這邊的 `%q` 叫做 verb，而 Printf 會用第二個 argument 取代 verb，如果有更多的 verb，它就會傳送更多 value 給 verb 來去取代。這邊的 `\n` 叫做 escape sequence，`\n` 會產生新的行，像 Println 就會自動產生新的行，但是 Printf 不能產生新的行，所以要用 `\n` 來產生新的行，
2. 假設我要 print: total: 2350 success: 543 / 333。
    - Println
        ```
        fmt.Println(
          "total", ops, "success:", ok, "/", fail,
        )
        ```
    - Printf，`%d` 代表預期是 integer。
        ```
        fmt.Printf(
          "total: %d success: %d / %d\n",
          ops, ok, fail,
        )
        ```
3. 整體來說，Printf 更容易查看而且更容易使用。
### 什麼是 escape sequence?
1. 用 `\n` 可以換行，這邊的 `\n` 是 escape sequence 而且是新增行的意思，如果取得 len，就會發現是 5，而不是 6，因為 `\n` 是一個 character。
    ```
    fmt.Printf("hi\nhi")
    ====OUTPUT====
    hi
    hi
    ```
2. 如果想要 print backslash，可以使用 `\\`。
3. 如果想要 print 雙引號，可以使用 `\"`。
4. Escape sequence 有順序問題，比方說，`"hi\\n\"hi\""`，結果會是 `hi\n"hi"`，中間的 `\n` 就會不會換行，因為前面有 `\\`。
### 如何使用 Printf?
1. 你可以使用 `Printf` print 值的類型，`%T` 就是類型。
    ```
    package main

    import "fmt"

    func main() {
      var speed int
      var heat float64
      var off bool
      var brand string

      fmt.Printf("%T\n", speed)
      fmt.Printf("%T\n", heat)
      fmt.Printf("%T\n", off)
      fmt.Printf("%T\n", brand)
    }
    ====OUTPUT====
    int
    float64
    bool
    string
    ```
2. 可以使用 Argument index 來取得 Printf 的 argument，起始值是 1。
    ```
    package main

    import "fmt"

    func main() {
      var (
        planet = "venes"
        distance = 261
        orbital = 224.701
        hasLife = false
      )

      fmt.Printf("Planet: %v\n", planet)
      fmt.Printf("Distance: %v millions kms\n", distance)
      fmt.Printf("Orbital Period: %v days\n", orbital)
      fmt.Printf("Does %v has life? %v\n", planet, hasLife)

      fmt.Printf(
        "%v is %v away. Think! %[2]v kms! %[1]v OMG!\n",
        planet, distance,
      )
    }
    ====OUTPUT====
    Planet: venes
    Distance: 261 millions kms
    Orbital Period: 224.701 days
    Does venes has life? false
    venes is 261 away. Think! 261 kms! venes OMG!
    ```
### Verb 可以做型別保護
1. `%s` 代表 string，`%d` 代表 integer，`%f` 代表 float，`%t` 代表 boolean，使用型別保護可以避免錯誤，建議使用對應的型別 verb，而不是 `%v`。
    ```
    package main

    import "fmt"

    func main() {
      var (
        planet = "venes"
        distance = 261
        orbital = 224.701
        hasLife = false
      )

      fmt.Printf("Planet: %s\n", planet)
      fmt.Printf("Distance: %d millions kms\n", distance)
      fmt.Printf("Orbital Period: %f days\n", orbital)
      fmt.Printf("Does %s has life? %t\n", planet, hasLife)
    }
    ```
2. `%.0f`，這邊的 0 表示精度，如果精度越高顯示越多數字，如以下範例。
    ```
    package main

    import "fmt"

    func main() {
      var (
        orbital = 224.701
      )

      fmt.Printf("Orbital Period: %.0f days\n", orbital)
      fmt.Printf("Orbital Period: %.1f days\n", orbital)
      fmt.Printf("Orbital Period: %.2f days\n", orbital)
      fmt.Printf("Orbital Period: %.3f days\n", orbital)
      fmt.Printf("Orbital Period: %.4f days\n", orbital)
      fmt.Printf("Orbital Period: %.5f days\n", orbital)
    }
    ====OUTPUT====
    Orbital Period: 225 days
    Orbital Period: 224.7 days
    Orbital Period: 224.70 days
    Orbital Period: 224.701 days
    Orbital Period: 224.7010 days
    Orbital Period: 224.70100 days
    ```