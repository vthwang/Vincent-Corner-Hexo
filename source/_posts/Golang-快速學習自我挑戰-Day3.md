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
## 章節一
### IF statement
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
### Else 和 Else if
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
### 小挑戰：驗證一個單一用戶
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
### 小挑戰：驗證多用戶
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
### 


