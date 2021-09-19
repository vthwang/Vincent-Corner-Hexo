---
title: Golang 快速學習自我挑戰 Day14
thumbnail:
  - /images/learning/golang/GolangDay14.jpg
date: 2021-09-19 19:07:09
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay14.jpg">

***
# 第十三章：Functions, Pointers 和 Addressability
## 什麼是 Pointer？
1. Pointer 會儲存值的記憶體位置。
2. `&` 可以找到地址，`*` 可以找到值， `*Type` 表示 Pointer 的類型。
3. `var counter byte = 100`，`P := &counter`，這邊可以知道 P 的型別是 *byte，`V := *P`，V 的型別會是 byte。
4. 如果寫 `V = 200`，V 會直接變成 200。
5. 如果 counter 等於 100，寫 `P := &counter`、`counter++`，取得 *P 的值，會是 101。
6. 如果 counter 等於 100，寫 `P := &counter`、`*P = 25`，取得 counter 的值，就會是 25。
7. 總結
    - `var P *byte`：`*Type` 表示 Pointer 的類型。
    - `&counter`：`&` 可以找到地址。
    - `*P`：`*` 可以找到值。
    - P 的型別就是 *byte，counter 的型別就是 byte。
    - 每一種型別都有對應的 Pointer 型別。
        - byte -> *byte
        - int -> *int
        - struct { n bool } -> *struct { n bool }
## 學習 Pointer 的機制
1. Function 會新增新的 Pointer 變數來指向同樣的位置。這個新增的 Pointer 在 runtime 不會被刪除，只有執行完畢之後，確認不會再使用才會被永久刪除。
2. 範例。
    ```
    package main

    import "fmt"

    func main() {
      var (
        counter int
        V		int
        P 		*int
      )

      counter = 100
      P = &counter
      V = *P

      fmt.Printf("counter: %-13d addr: %-13p\n", counter, &counter)
      fmt.Printf("P      : %-13p addr: %-13p *P: %-13d\n", P, &P, *P)
      fmt.Printf("V      : %-13d addr: %-13p\n", V, &V)

      fmt.Println("\n.... change counter")

      counter = 10

      fmt.Printf("counter: %-13d addr: %-13p\n", counter, &counter)

      fmt.Println("\n.... change counter in passVal()")
      counter = passVal(counter)
      fmt.Printf("counter: %-13d addr: %-13p\n", counter, &counter)

      fmt.Println("\n.... change counter in passPtrVal()")
      passPtrVal(&counter)
      passPtrVal(&counter)
      passPtrVal(&counter)
      fmt.Printf("counter: %-13d addr: %-13p\n", counter, &counter)
    }

    func passVal(n int) int {
      n = 50
      fmt.Printf("n      : %-13d addr: %-13p\n", n, &n)
      return n
    }

    func passPtrVal(pn *int) {
      fmt.Printf("pn     : %-13p addr: %-13p *pn: %-13d\n", pn, &pn, *pn)

      *pn++

      fmt.Printf("pn     : %-13p addr: %-13p *pn: %-13d\n", pn, &pn, *pn)

      // It doesn't affect the counter.
      // pn = nil
    }
    ====OUTPUT====
    counter: 100           addr: 0xc0000b2008 
    P      : 0xc0000b2008  addr: 0xc0000ac018  *P: 100          
    V      : 100           addr: 0xc0000b2010 

    .... change counter
    counter: 10            addr: 0xc0000b2008 

    .... change counter in passVal()
    n      : 50            addr: 0xc0000b2018 
    counter: 50            addr: 0xc0000b2008 

    .... change counter in passPtrVal()
    pn     : 0xc0000b2008  addr: 0xc0000ac028  *pn: 50           
    pn     : 0xc0000b2008  addr: 0xc0000ac028  *pn: 51           
    pn     : 0xc0000b2008  addr: 0xc0000ac030  *pn: 51           
    pn     : 0xc0000b2008  addr: 0xc0000ac030  *pn: 52           
    pn     : 0xc0000b2008  addr: 0xc0000ac038  *pn: 52           
    pn     : 0xc0000b2008  addr: 0xc0000ac038  *pn: 53           
    counter: 53            addr: 0xc0000b2008 
    ```
## 學習如何在 Composite Types 使用 Pointer
1. Slice Header 已經有指向 backing Array 的 Pointer，所以不需要對 Slice 使用 Pointer 來改變 element。
2. 在實務上，不要使用 Pointer 來指向 Slice。
3. 跟 Slice 一樣，Map 的值已經是一個 Pointer 了，所以不要對 Map 使用 Pointer。
4. 範例可以看到 Map 也不能取得 element 的地址，因為 Go runtime 是不能更改 Map element 的地址的。另外，在儲存的時候地址會是連續的，這樣存取的效率會很好。
    ```
    package main

    import (
      "fmt"
      "strings"
    )

    func main() {
      fmt.Println("... ARRAYS")
      arrays()

      fmt.Println("... SLICES")
      slices()

      fmt.Println("... MAPS")
      maps()

      fmt.Println("... STRUCTS")
      structs()
    }

    type house struct {
      name  string
      rooms int
    }

    func structs() {
      myHouse := house{name: "My house", rooms: 5}

      addRoom(myHouse)

      //fmt.Printf("%+v\n", myHouse)
      fmt.Printf("structs()       : %p %+v\n", &myHouse, myHouse)

      addRoomPtr(&myHouse)

      fmt.Printf("structs()       : %p %+v\n", &myHouse, myHouse)
    }

    func addRoom(h house) {
      h.rooms++
      fmt.Printf("structs()       : %p %+v\n", &h, h)
    }

    func addRoomPtr(h *house) {
      h.rooms++ // same: (*h).rooms++
      fmt.Printf("addRoomPtr()    : %p %+v\n", h, h)
      fmt.Printf("&myHouse.name() : %p\n", &h.name)
      fmt.Printf("&myHouse.rooms(): %p\n", &h.rooms)
    }

    func maps() {
      confused := map[string]int{"one": 2, "two": 1}
      fix(confused)
      fmt.Println(confused)

      // &confused["one"]
    }

    func fix(m map[string]int) {
      m["one"] = 1
      m["two"] = 2
      m["three"] = 3
    }

    func slices() {
      dirs := []string{"up", "down", "left", "right"}

      up(dirs)
      fmt.Printf("slices list     : %p %q\n", &dirs, dirs)

      upPtr(&dirs)
      fmt.Printf("slices list     : %p %q\n", &dirs, dirs)
    }

    func up(list []string) {
      for i := range list {
        list[i] = strings.ToUpper(list[i])
        fmt.Printf("up.list[%d]      : %p\n", i, &list[i])
      }

      list = append(list, "HEISEN BUG")

      fmt.Printf("up list         : %p %q\n", &list, list)
    }

    func upPtr(list *[]string) {
      lv := *list

      for i := range lv {
        lv[i] = strings.ToUpper(lv[i])
      }

      *list = append(*list, "HEISEN BUG")

      fmt.Printf("up list         : %p %q\n", list, list)
    }

    func arrays() {
      nums := [...]int{1, 2, 3}

      incr(nums)
      fmt.Printf("array nums      : %p\n", &nums)
      fmt.Println(nums)

      incrByPtr(&nums)
      fmt.Println(nums)
    }

    func incr(nums [3]int) {
      fmt.Printf("incr nums       : %p\n", &nums)
      for i := range nums {
        nums[i]++
        fmt.Printf("up.list[%d]      : %p\n", i, &nums[i])
      }
    }

    func incrByPtr(nums *[3]int) {
      fmt.Printf("incrByPtr nums  : %p\n", &nums)
      for i := range nums {
        nums[i]++
      }
    }
    ====OUTPUT====
    ... ARRAYS
    incr nums       : 0xc0000b6018
    up.list[0]      : 0xc0000b6018
    up.list[1]      : 0xc0000b6020
    up.list[2]      : 0xc0000b6028
    array nums      : 0xc0000b6000
    [1 2 3]
    incrByPtr nums  : 0xc0000ac020
    [2 3 4]
    ... SLICES
    up.list[0]      : 0xc0000b0040
    up.list[1]      : 0xc0000b0050
    up.list[2]      : 0xc0000b0060
    up.list[3]      : 0xc0000b0070
    up list         : 0xc0000a4030 ["UP" "DOWN" "LEFT" "RIGHT" "HEISEN BUG"]
    slices list     : 0xc0000a4018 ["UP" "DOWN" "LEFT" "RIGHT"]
    up list         : 0xc0000a4018 &["UP" "DOWN" "LEFT" "RIGHT" "HEISEN BUG"]
    slices list     : 0xc0000a4018 ["UP" "DOWN" "LEFT" "RIGHT" "HEISEN BUG"]
    ... MAPS
    map[one:1 three:3 two:2]
    ... STRUCTS
    structs()       : 0xc0000a40c0 {name:My house rooms:6}
    structs()       : 0xc0000a40a8 {name:My house rooms:5}
    addRoomPtr()    : 0xc0000a40a8 &{name:My house rooms:6}
    &myHouse.name() : 0xc0000a40a8
    &myHouse.rooms(): 0xc0000a40b8
    structs()       : 0xc0000a40a8 {name:My house rooms:6}
    ```
## 使用 Pointer 重構 Log 解析器
1. 如果不需要修改值的 func 就不需要使用 Pointer。
2. 修改後的內容。
    - main.go
    ```
    package main

    import (
      "bufio"
      "fmt"
      "os"
      "sort"
      "strings"
    )

    func main() {
      p := newParser()

      // Scan the standard-in line by line
      in := bufio.NewScanner(os.Stdin)
      for in.Scan() {
        parsed, err := parse(&p, in.Text())
        if err != nil {
          fmt.Println(err)
          return
        }

        update(&p, parsed)
      }

      summarize(p)

      // Let's handle the error
      if err := in.Err(); err != nil {
        fmt.Println("> Err:", err)
      }
    }

    func summarize(p parser) {
      // Print the visits per domain
      sort.Strings(p.domains)

      fmt.Printf("%-30s %10s\n", "DOMAIN", "VISITS")
      fmt.Println(strings.Repeat("-", 45))

      for _, domain := range p.domains {
        parsed := p.sum[domain]
        fmt.Printf("%-30s %10d\n", domain, parsed.visits)
      }

      // Print the total visits for all domains
      fmt.Printf("\n%-30s %10d\n", "TOTAL", p.total)
    }
    ```
    - parser.go
    ```
    package main

    import (
      "fmt"
      "strconv"
      "strings"
    )

    // result stores the parsed result for a domain
    type result struct {
      domain string
      visits int
      // add more metrics if needed
    }

    // parser keep tracks of the parsing
    type parser struct {
      sum     map[string]result // metrics per domain
      domains []string          // unique domain names
      total   int               // total visits for all domains
      lines   int               // number of parsed lines (for the error messages)
    }

    // newParser constructs, initializes and returns a new parser
    func newParser() parser {
      return parser{sum: make(map[string]result)}
    }

    // parse() parses a log line and returns the parsed result with an error
    func parse(p *parser, line string) (parsed result, err error) {
      p.lines++

      fields := strings.Fields(line)
      if len(fields) != 2 {
        err = fmt.Errorf("wrong input: %v (line #%d)", fields, p.lines)
        return
      }

      parsed.domain = fields[0]

      parsed.visits, err = strconv.Atoi(fields[1])
      if parsed.visits < 0 || err != nil {
        err = fmt.Errorf("wrong input: %q (line #%d)", fields[1], p.lines)
        return
      }

      return
    }

    func update(p *parser, parsed result) {
      domain, visits := parsed.domain, parsed.visits

      // Collect the unique domains
      if _, ok := p.sum[domain]; !ok {
        p.domains = append(p.domains, domain)
      }

      // Keep track of total and per domain visits
      p.total += visits

      // create and assign a new copy of `visit`
      p.sum[domain] = result{
        domain: domain,
        visits: visits + p.sum[domain].visits,
      }
    }
    ```
3. 這邊有一個問題，比方說要修改 visits 的值，使用 `p.sum[domain].visits += visits` 是不能使用的，因為 `&p.sum[domain]` 是Map element，是不能取得地址的。但是如果我使用 `clone := p.sum[domain]`，然後使用 `&clone` 是可以取得地址的，因為 clone 是複製 Map element 裡面的內容所產生的新東西，它是 addressable value（你可以找到他的地址）。
## 要使用 Pointer 還是 Value？要一致。
1. 範例裡面，parser 的 struct 都使用 Pointer，就要全部改用 Pointer，result 的 struct 都不使用 Pointer 就全部不使用 Pointer。
    - main.go
    ```
    package main

    import (
      "bufio"
      "fmt"
      "os"
      "sort"
      "strings"
    )

    func main() {
      p := newParser()

      // Scan the standard-in line by line
      in := bufio.NewScanner(os.Stdin)
      for in.Scan() {
        parsed := parse(p, in.Text())
        update(p, parsed)
      }

      summarize(p)
      dumpErr([]error{in.Err(), err(p)})
    }

    func dumpErr(errs []error) {
      for _, err := range errs {
        if err != nil {
          fmt.Println("> Err:", err)
        }
      }
    }

    func summarize(p *parser) {
      // Print the visits per domain
      sort.Strings(p.domains)

      fmt.Printf("%-30s %10s\n", "DOMAIN", "VISITS")
      fmt.Println(strings.Repeat("-", 45))

      for _, domain := range p.domains {
        fmt.Printf("%-30s %10d\n", domain, p.sum[domain].visits)
      }

      // Print the total visits for all domains
      fmt.Printf("\n%-30s %10d\n", "TOTAL", p.total)
    }
    ```
    - parser.go
    ```
    package main

    import (
      "fmt"
      "strconv"
      "strings"
    )

    // result stores the parsed result for a domain
    type result struct {
      domain string
      visits int
      // add more metrics if needed
    }

    // parser keep tracks of the parsing
    type parser struct {
      sum     map[string]result // metrics per domain
      domains []string          // unique domain names
      total   int               // total visits for all domains
      lines   int               // number of parsed lines (for the error messages)
      lerr    error
    }

    // newParser constructs, initializes and returns a new parser
    func newParser() *parser {
      return &parser{sum: make(map[string]result)}
    }

    // parse() parses a log line and returns the parsed result with an error
    func parse(p *parser, line string) (r result) {
      if p.lerr != nil {
        return
      }
      p.lines++

      fields := strings.Fields(line)
      if len(fields) != 2 {
        p.lerr = fmt.Errorf("wrong input: %v (line #%d)", fields, p.lines)
        return
      }

      var err error

      r.domain = fields[0]
      r.visits, err = strconv.Atoi(fields[1])

      if r.visits < 0 || err != nil {
        p.lerr = fmt.Errorf("wrong input: %q (line #%d)", fields[1], p.lines)
        return
      }

      return
    }

    func update(p *parser, r result) {
      if p.lerr != nil {
        return
      }

      // Collect the unique domains
      if _, ok := p.sum[r.domain]; !ok {
        p.domains = append(p.domains, r.domain)
      }

      // Keep track of total and per domain visits
      p.total += r.visits

      // create and assign a new copy of `visit`
      p.sum[r.domain] = result{
        domain: r.domain,
        visits: r.visits + p.sum[r.domain].visits,
      }
    }

    func err(p *parser) error {
      return p.lerr
    }
    ```