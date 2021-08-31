---
title: Golang 快速學習自我挑戰 Day12
thumbnail:
  - /images/learning/golang/GolangDay12.jpg
date: 2021-08-21 23:44:32
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay12.jpg">

***
# 第十二章：Structs：Encode 和 Decode JSON
## 什麼是 Struct？
1. Struct 就像 blueprint。
2. Struct 就像 OOP 語言裡面的 class。
3. Struct 可以將相關的資料組裝成一個單一型別。
4. Struct 在 compile-time 是固定的，所以在 runtime 的時候不能新增 field。
5. Struct 可儲存不同型別的資料。
6. Struct fields 在 compile-time 被宣告，而 Struct 值在 runtime 的時候填入。Field 的名字和型別在 compile-time 就被宣告，所以他們在 runtime 的時候是固定而不能改變的。然而，Field 值是屬於 runtime 的，你可以在 runtime 的時候改變它。
7. 總結
    | Slice & Map | Struct |
    |:-:|:-:|
    | Element 只有單一型別 | Fields 有不同型別 |
    | 動態的 Elements 數量 | 固定的 Fields 數量 |
8. Struct 範例
    ```
    type VideoGame struct {
      Title	string
      Genre	string
      Published	bool
    }

    pacman := VideoGame{
      Title:		"Pac-Man",
      Genre: 		"Arcade Game",
      Published: 	true,
    }
    ```
## 建立一個 Struct
1. 建立 Struct 可以有很多方式，可以直接使用 short declaration 或是用 var 定義 Struct。使用 short declaration 最好加上 field name 以避免新增 Struct 的時候，程式碼有問題，如果不加上 field name，會按照默認順序去讀取。
    ```
    package main

    import "fmt"

    func main() {
      type person struct {
        name, lastname		string
        age					int
      }

      picasso := person{
        name: "Pablo",
        lastname: "Picasso",
        age: 91,
      }

      var freud person

      freud.name = "sigmund"
      freud.lastname = "Freud"
      freud.age = 83

      fmt.Printf("\nPicasso: %#v\n", picasso)
      fmt.Printf("Freud : %#v\n", freud)

    }
    ```
## 什麼時候可以比較 Struct 的值？
1. Struct 是 bare value 的型別，就跟 Array 一樣。Struct 不像 Slice 有 backing Array，所以當你複製 Struct 的時候，它會一個一個的複製它的 field。在比較的時候，Go 會一個一個比較 field，如果 field 都一樣，那比較結果就會是一樣的，這邊要注意，type 必須相同才能做比較。
2. Struct 可以直接進行比較。
    ```
    package main

    import "fmt"

    func main() {
      song1 := song{title: "wonderwall", artist: "oasis"}
      song2 := song{title: "super sonic", artist: "oasis"}

      fmt.Printf("song1: %+v\nsong2: %+v\n", song1, song2)
      
      if song1 == song2 {
        fmt.Println("songs are equal.")
      } else {
        fmt.Println("songs are not equal.")
      }
    }
    ```
3. Struct 最好定義在 package 這一層，這樣就可以隨時使用。Struct 裡面如果有不能比較的型別，比方說 Slice、Map 或是 function value，那這個 Struct 就不能進行比較。看到下面的結果就知道在 for 迴圈裡面，s 是複製出來的，並不會變更到本來的 struct 的內容。
    ```
    package main

    import "fmt"

    type song struct {
      title, artist	string
    }

    type playlist struct {
      genre string
      songs []song
    }

    func main() {
      songs := []song{
        {title: "wonderwall", artist: "oasis"},
        {title: "super sonic", artist: "oasis"},
      }

      rock := playlist{genre: "indie rock", songs: songs}

      rock.songs[0].title = "live forever"

      fmt.Printf("%-20s %20s\n", "TITLE", "ARTIST")
      for _, s := range rock.songs {

        s.title = "destroy"

        fmt.Printf("%-20s %20s\n", s.title, s.artist)
      }

      fmt.Printf("%-20s %20s\n", "TITLE", "ARTIST")
      for _, s := range rock.songs {
        fmt.Printf("%-20s %20s\n", s.title, s.artist)
      }
    }
    ====OUTPUT====
    TITLE                              ARTIST
    destroy                             oasis
    destroy                             oasis
    TITLE                              ARTIST
    live forever                        oasis
    super sonic                         oasis
    ```
## Go OOP：Struct Embedding
1. Go 不使用繼承(Inheritance)，Go 使用 Embedding。
2. 這邊有兩個魔術方法，第一、如果欄位是匿名的，它會從它的 type 取得它的名字。第二，可以直接用 `moby.words` 取得下層的同名的值，等同於 ``moby.text.words`，但是如果剛好名稱有衝突的，會優先取得 parent type 的值。
    ```
    package main

    import "fmt"

    func main() {
      type text struct {
        title string
        words int
      }

      type book struct {
        text
        isbn 	string
        title	string
      }

      moby := book{
        text: text{title: "moby dick", words: 206052},
        isbn: "102030",
      }

      moby.text.words = 1000
      moby.words++

      fmt.Printf("%s has %d words (isbn: %s)\n",
        moby.text.title, moby.words, moby.isbn)

      fmt.Printf("%#v\n", moby)
    }
    ====OUTPUT====
     has 1001 words (isbn: 102030)
    main.book{text:main.text{title:"moby dick", words:1001}, isbn:"102030", title:""}
    ```
## 將值編碼為 JSON
1. 使用 `Marshal` 語法可以直接編寫成 JSON 格式，語法的第一個參數是 empty interface，代表你可以傳送任何型態的值給它。而 json 套件只編碼輸出的欄位，輸出的欄位的首字母必須要是大寫才能輸出。可以直接使用 `go run main.go > users.json` 將回傳的 JSON 直接存到檔案。field 標籤是 Struct 型別的一部份，它們是 compile-time 的常數，用來關聯 field 固定的 string metadata，大部分是用來控制編碼和解碼的行為，傳統來說，它有 key 和 value，json 就是 key 的名字，用來表示套件的名稱，這邊只有 json 的套件會讀取這個標籤，而 `perms,omitempty` 是 json 的 value，用逗點來區隔，第一個用來改變欄位編碼的名稱，第二個是如果 field 為 zero-value 的時候省略這個 field。
    ```
    package main

    import (
      "encoding/json"
      "fmt"
    )

    type permissions map[string]bool

    type user struct {
      Name 		string		`json:"username"`
      Password 	string		`json:"-"`
      Permissions	permissions	`json:"perms,omitempty"`
    }

    func main() {
      users := []user{
        {"inanc", "1234", nil},
        {"god", "42", permissions{"admin": true}},
        {"devil", "666", permissions{"admin": true}},
      }

      out, err := json.MarshalIndent(users, "", "\t")
      if err != nil {
        fmt.Println(err)
        return
      }

      fmt.Println(string(out))
    }
    ====OUTPUT====
    [
        {
                "username": "inanc"
        },
        {
                "username": "god",
                "perms": {
                        "admin": true
                }
        },
        {
                "username": "devil",
                "perms": {
                        "admin": true
                }
        }
    ]
    ```
## 從 JSON 解碼值
1. `&` 會找到值的記憶體位置，後面會說更多關於 pointer 的話題。使用 `Unmarshal` 就可以解碼 JSON 的內容。
    ```
    package main

    import (
      "bufio"
      "encoding/json"
      "fmt"
      "os"
    )

    type user struct {
      Name		string			`json:"username"`
      Permissions map[string]bool	`json:"perms"`
    }

    func main() {
      var input []byte
      for in := bufio.NewScanner(os.Stdin); in.Scan(); {
        input = append(input, in.Bytes()...)
      }

      var users []user
      err := json.Unmarshal(input, &users)
      if err != nil {
        fmt.Println(err)
        return
      }

      fmt.Println(users)

      for _, user := range users {
        fmt.Print("+ ", user.Name)

        switch p := user.Permissions; {
        case p == nil:
          fmt.Print(" has no power.")
        case p["admin"]:
          fmt.Print(" is an admin.")
        case p["write"]:
          fmt.Print(" can write.")
        }
        fmt.Println()
      }
    }
    ```