---
title: Golang 快速學習自我挑戰 Day13
thumbnail:
  - /images/learning/golang/GolangDay13.jpg
date: 2021-09-13 20:59:37
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay13.jpg">

***
# 第十三章：Functions, Pointers 和 Addressability
## 學習 Function 的基礎
1. Function 用 `func` 這個 keyword，init 和 main 是特殊名字，不用在 Function 的名字使用它們。
2. 一個 Function 可以有零到多個輸入參數，`func sum(a int, b int) {}` 和 `func sum(a, b int) {}` 是一樣的。
3. 如果你不需要回傳任何內容，最後一行直接加上 `return` 就可以了，`return` 可以立刻讓 Function 停止和終止。
4. 回傳參數的設置 `func name(inputParams) (resultParams) {}`，`resultParams` 就是回傳的結果。在實際場景中，最佳的實踐是，回傳的最後一個參數設置為 error。
5. 如果回傳參數只有一個，就不要放到括號裡面 `func name(inputParams) singleParam {}`。
6. 使用 Function 只會複製本來的變數，而不會覆蓋本來的變數，比方說輸入變數有 a，在 Function 內經過改變之後，再回傳 a，也不會改變到外部調用 Function 之前的 a，回傳出來的結果會複製到新的變數上。
7. 呼叫不同檔案裡的 Function，如果執行 `go run main.go` 會出現錯誤，要使用 `go run .` 執行目錄下所有的 go 檔案，並須要使用 `go mod init` 來新增 go.mod 檔案才能正常執行。而在全局的地方使用 N 變數是最差的實踐，因為所有的 package main 都可以使用這個變數，被誰改變了都不知道。
    - main.go
    ```
    package main

    // N is a package level variable
    // It belongs to the main package
    var N int

    func main() {
      incrN()
      incrN()
      showN()
    }
    ```
    - bad.go
    ```
    package main

    import "fmt"

    func showN() {
      if N == 0 {
        return
      }
      fmt.Printf("showN      : N is %d\n", N)
    }

    func incrN() {
      N++
    }
    ```
## 對 Function 限制變數
1. 在上個段落，在全局使用 N 變數會很難除錯。解決方案就是盡可能新增更多的變數在局部的 Function。
2. 使用局部變數的範例。
    ```
    package main

    import (
      "fmt"
      "strconv"
    )

    func main() {
      local := 10
      show(local)

      incrWrong(local)
      fmt.Printf("main -> local = %d\n", local)

      local = incr(local)
      fmt.Printf("local = %d\n", local)

      local = incrBy(local, 5)
      show(local)

      _, err := incrByStr(local, "TWO")
      if err != nil {
        fmt.Printf("err -> %s\n", err)
      }

      local, _ = incrByStr(local, "2")
      show(local)

      show(incrBy(local, 2))
      show(local)

      // show(incrByStr(local, "2"))

      local = sanitize(incrByStr(local, "2"))
      show(local)

      local = limit(incrBy(local, 5), 500)
      show(local)
    }

    func show(n int) {
      fmt.Printf("show -> n = %d\n", n)
    }

    func incrWrong(n int) {
      // n := main's local variable's value
      n++
    }

    func incr(n int) int {
      // n := main's local variable's value
      n++
      return n
    }

    func incrBy(n, factor int) int {
      return n * factor
    }

    func incrByStr(n int, factor string) (int, error) {
      m, err := strconv.Atoi(factor)
      n = incrBy(n, m)
      return n, err
    }

    func sanitize(n int, err error) int {
      if err != nil {
        return 0
      }
      return n
    }

    func limit(n, lim int) (m int) {
      // var m int
      m = n
      if m >= lim {
        m = lim
      }
      return
      // equals to: return m
    }
    ```
## 使用 Function 重構 Log 解析器
1. 使用**動詞**來找到**獨特的責任**：Functions。
2. Log Parser 範例。
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
        p.lines++

        parsed, err := parse(p, in.Text())
        if err != nil {
          fmt.Println(err)
          return
        }

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

      // Let's handle the error
      if err := in.Err(); err != nil {
        fmt.Println("> Err:", err)
      }
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
    func parse(p parser, line string) (parsed result, err error) {
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
    ```
## 學習 Pass By Value 
1. Go 使用 Pass By Value 的方式，只要有經過 Function 就會複製一個新的變數，但是 Map 是指向記憶體位置的，所以如果 Map 變更，其它指向同一個地方的 Map 也會跟著變更資料。 
2. 所以只要有傳送到 Function 的變數一定要 return 回來，才能取得變數。
3. Log Parser 優化。
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
        p.lines++

        parsed, err := parse(p, in.Text())
        if err != nil {
          fmt.Println(err)
          return
        }

        p = update(p, parsed)
      }

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

      // Let's handle the error
      if err := in.Err(); err != nil {
        fmt.Println("> Err:", err)
      }
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
    func parse(p parser, line string) (parsed result, err error) {
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

    func update(p parser, parsed result) parser {
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

      return p
    }
    ```
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