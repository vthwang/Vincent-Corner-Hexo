---
title: Golang 快速學習自我挑戰 Day3
thumbnail:
  - /images/learning/golang/GolangDay03.jpg
date: 2021-07-22 23:07:43
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay03.jpg">

***
# 章節一
## IF statement
1. Go 裡面的 if statement 不需要括號，直接在 if 後面輸入你的條件就可以了。
    ```
    package main

    import "fmt"

    func main() {
      score, valid := 5, true

      if score > 3 && valid {
        fmt.Println("good")
      }
    }
    ```
## Else 和 Else if
1. else if 是可以無限新增的，不一定要有，else 只能用一遍，但是也不一定要有。
    ```
    package main

    import "fmt"

    func main() {
      score := 2

      if score > 3 {
        fmt.Println("good")
      } else if score == 3 {
        fmt.Println("on the edge")
      } else if score == 2 {
        fmt.Println("meh...")
      } else {
        fmt.Println("low")
      }
    }
    ```
## 小挑戰：驗證一個單一用戶
1. 題目
    ```
    CHALLENGE #1
    Create a user/password protected program.

    EXAMPLE USER
    username: jack
    password: 1888

    EXPECTED OUTPUT
    go run main.go
    Usage: [username] [password]

    go run main.go albert
    Usage: [username] [password]

    go run main.go hacker 42
    Access denied for "hacker".

    go run main.go jack 6475
    Invalid password for "jack".

    go run main.go jack 1888
    Access granted to "jack".
    ```
2. 答案
    ```
    package main

    import (
      "fmt"
      "os"
    )

    const (
      usage    = "Usage: [username] [password]"
      errUser  = "Access denied for %q.\n"
      errPwd   = "Invalid password for %q.\n"
      accessOK = "Access granted to %q.\n"
      user     = "jack"
      pass     = "1888"
    )

    func main() {
      args := os.Args

      if len(args) != 3 {
        fmt.Println(usage)
        return
      }

      u, p := args[1], args[2]

      if u != user {
        fmt.Printf(errUser, u)
      } else if p != pass {
        fmt.Printf(errPwd, u)
      } else {
        fmt.Printf(accessOK, u)
      }
    }
    ```
## 小挑戰：驗證多用戶
1. 題目
    ```
    CHALLENGE #2
    Add one more user to the PassMe program below.

    EXAMPLE USERS
    username: jack
    password: 1888

    username: inanc
    password: 1879

    EXPECTED OUTPUT
    go run main.go
    Usage: [username] [password]

    go run main.go hacker 42
    Access denied for "hacker".

    go run main.go jack 1888
    Access granted to "jack".

    go run main.go inanc 1879
    Access granted to "inanc".

    go run main.go jack 1879
    Invalid password for "jack".

    go run main.go inanc 1888
    Invalid password for "inanc".
    ```
2. 答案
    ```
    package main

    import (
      "fmt"
      "os"
    )

    const (
      usage    = "Usage: [username] [password]"
      errUser  = "Access denied for %q.\n"
      errPwd   = "Invalid password for %q.\n"
      accessOK = "Access granted to %q.\n"
      user, user2     = "jack", "inanc"
      pass, pass2     = "1888", "1879"
    )

    func main() {
      args := os.Args

      if len(args) != 3 {
        fmt.Println(usage)
        return
      }

      u, p := args[1], args[2]

      if u != user && u !=user2 {
        fmt.Printf(errUser, u)
      } else if u == user && p == pass {
        fmt.Printf(accessOK, u)
      } else if u == user2 && p == pass2 {
        fmt.Printf(accessOK, u)
      } else {
        fmt.Printf(errPwd, u)
      }
    }
    ```
## 什麼是 nil 值？
1. **nil** 值表示的是值尚未初始化。
2. nil 很常被用在錯誤處理，範例展示 nil 用在錯誤處理。
    ```
    err := do()

    if err != nil {
      // error
      // handle it!
      // terminate!
    }

    // success
    // continue...
    ```
## 什麼是錯誤值？
1. 如果 error value 是 nil，表示成功，如果有錯誤，就千萬不要用回傳的值，因為是錯誤的。所以當 function 回傳 error value，一定要處理它。
    ```
    package main

    import (
      "fmt"
      "os"
      "strconv"
    )

    func main() {
      n, err := strconv.Atoi(os.Args[1])

      fmt.Println("Converted number:", n)
      fmt.Println("Returned error value:", err)
    }
    ====EXECUTE====
    go run main.go 42
    ====OUTPUT====
    Converted number: 42
    Returned error value: <nil>
    ====EXECUTE====
    go run main.go hahaha
    ====OUTPUT====
    Converted number: 0
    Returned error value: strconv.Atoi: parsing "hahaha": invalid syntax
    ```
## 錯誤處理範例
1. 用 if, else 就可以簡單地做錯誤處理。
    ```
    package main

    import (
      "fmt"
      "os"
      "strconv"
    )

    func main() {
      age := os.Args[1]

      n, err := strconv.Atoi(age)
      if err != nil {
        fmt.Println("Error:", err)
        return
      }
      fmt.Printf("SUCCESS: Converted %q to %d.\n", age, n)
    }
    ====EXECUTE====
    go run main.go 42
    ====OUTPUT====
    SUCCESS: Converted "42" to 42.
    ====EXECUTE====
    go run main.go hello
    ====OUTPUT====
    Error: strconv.Atoi: parsing "hello": invalid syntax
    ```
## 挑戰：轉換 Feet 為 Meter
1. 題目
    ```
    ====EXECUTE====
    go run main.go hello
    ====OUTPUT====
    error: "hello" is not the number.
    ====EXECUTE====
    go run main.go 100
    ====OUTPUT====
    100 feet is 30.48 meters.
    ```
2. 答案。另外測試小數點和科學數字都是可以轉換的。
    ```
    package main

    import (
      "fmt"
      "os"
      "strconv"
    )

    func main() {
      arg := os.Args[1]

      feet, err := strconv.ParseFloat(arg, 64)
      if err != nil {
        fmt.Printf("err: %q is not the number.\n", arg)
        return
      }
      meters := feet * 0.3048

      fmt.Printf("%g feet is %g meters.\n", feet, meters)
    }
    ====EXECUTE====
    go run main.go .5
    ====OUTPUT====
    0.5 feet is 0.1524 meters.
    ====EXECUTE====
    go run main.go 1e3
    ====OUTPUT====
    1000 feet is 304.8 meters.
    ```
## 什麼是 Simple Statement(Short Statement)?
1. Short if：轉換成 short if 之後，裡面的 n 和 err 只能在這邊的 if 和接下來的 branches 使用。
    ```
    n, err := strconv.Atoi("42")

    if err == nil {
      fmt.Println("There was no error, n is", n)
    }
    ====轉換成 short if====
    if n, err := strconv.Atoi("42"); err == nil {
      fmt.Println("There was no error, n is", n)
    }
    ```
## Simple Statement 的 Scope
1. 前面有 declare 的變數，後面才能使用，也不能在 if statement 之外的地方使用。
    ```
    package main

    import (
      "fmt"
      "os"
      "strconv"
    )

    func main() {
      if a := os.Args; len(a) != 2 {
        // only a variable
        fmt.Println("Give me a number.")
      } else if n, err := strconv.Atoi(a[1]); err != nil {
        // only: a, n and err variables
        fmt.Printf("Cannot convert %q\n", a[1])
      } else {
        // all the variables in the if statement
        fmt.Printf("%s * 2 is %d\n", a[1], n*2)
      }
    }
    ```
## 有名的 Shadowing 陷阱
1. Shadowing 是 Gopher 非常常陷入的陷阱。
2. 如果在 if function 外面新增一個 n 和 err 的變數，在 if 裡面的變數，不會讓外面的變數改變，因為外面這個 n 被 if statement 的 n shadowed，所以如果要讓 if statement 裡面的值給外面讀到，要把 `:=` 改成 `=` 就可以避免 shadowed 的問題，在 vs code 上面也可以安裝插件解決這個問題。
    ```
    package main

    import (
      "fmt"
      "os"
      "strconv"
    )

    func main() {
      var (
        n int
        err error
      )

      if a := os.Args; len(a) != 2 {
        fmt.Println("Give me a number.")
      } else if n, err := strconv.Atoi(a[1]); err != nil {
        fmt.Printf("Cannot convert %q\n", a[1])
      } else {
        fmt.Printf("%s * 2 is %d\n", a[1], n*2)
      }

      fmt.Printf("n is %d. You've been shadowed\n", n)
    }
    ```