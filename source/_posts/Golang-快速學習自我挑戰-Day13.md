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