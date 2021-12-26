---
title: Golang 快速學習自我挑戰 Day14
thumbnail:
  - /images/learning/golang/GolangDay14.jpg
date: 2021-12-10 21:20:08
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay14.jpg">

***
# Section14: Methods: OOP with Go
## Methods：Enhance types with additional behavior
1. Methods
    - Value Receivers
    - Pointer Receivers
    - Non-Struct Methods
2. Interface
    - Type Assertion
    - Type Switch
    - Empty Interface
    - Promoted Methods
3. Famous Interfaces
    - Stringer
    - Marshaler
    - Unmarshaler
    - Reflection
    - io.Reader
4. The book has data but it doesn't have any behavior. Suppose we have `printbook()` and `discount(book, ratio)` two methods. Both of methods take book values and their primary purpose is to work with books. Here we can combine the data and behavior together. Go will pass the value of a book automatically to these methods. (b book) is called "receiver".
    ```
    type book struct {
        title string
        price float64
    }

    func (b book) print book() {
        fmt.Printf("...", b.title, b.price)
    }
    ```
5. You cannot create a function with the same name in the same **package**. However, each type can have its own namespace. The same method name does not cause a conflict with another type.
6. Here is a convention. We use `b` for a `book`, `g` for a `game` and `gt` for a `gameType`.
7. The dot operator selects a name(func, method, field, ...) from a namespace(from a package or type).
8. Example
    - book.go
    ```
    package main

    import "fmt"

    type book struct {
        title string
        price float64
    }

    func (b book) print() {
        fmt.Printf("%-15s: $%.2f\n", b.title, b.price)
    }
    ```
    - game.go
    ```
    package main

    import "fmt"

    type game struct {
        title string
        price float64
    }

    func (g game) print() {
        fmt.Printf("%-15s: $%.2f\n", g.title, g.price)
    }
    ```
    - main.go
    ```
    package main

    func main() {
        mobydick := book{
            title: "moby dick",
            price: 10,
        }

        minecraft := game{
            title: "minecraft",
            price: 20,
        }

        tetris := game{
            title: "tetris",
            price: 5,
        }

        mobydick.print()
        minecraft.print()
        tetris.print()
    }
    ```
## Pointer Receiver: Change the received value
1. Behind the scenes, a method is a function with a receiver as the first parameter. Both `book.print(mobydick)` and `mobydick.print()` pass the mobidick to `print()`, former one manually pass it and latter one automatically pass it.
2. Methods v.s. Funcs: A method is a function that takes a receiver as teh first argument. There is only one difference between a method and a function. A method belongs to a **type**; A function belongs to a **package**.
3. Using pointer to change the struct original value.
    - game.go
    ```
    func (g *game) discount(ratio float64) {
        g.price *= 1 - ratio
    }
    ```
    - main.go
    ```
    // When a method has a pointer receiver, Go can take its address automatically.
    minecraft.discount(.5)
    ```
4. If one of the method use pointer receiver, it's better to use pointer in all other methods.
5. Using pointer is faster in some situations. You can use `time` to check the execution time between using pointer and not using pointer.
    - huge.go
    ```
    package main

    import "fmt"

    type huge struct {
        games [1000000]game
    }

    func (h *huge) addr() {
        fmt.Printf("%p\n", &h)
    }
    ```
    - main.go
    ```
    package main

    func main() {
        var h huge
        for i := 0; i < 10; i++ {
            h.addr()
        }
    }
    ====EXECUTE====
    time go run .
    ====OUTPUT====
    0xc0017f2000
    0xc0017f2010
    0xc0017f2018
    0xc0017f2020
    0xc0017f2028
    0xc0017f2030
    0xc0017f2038
    0xc0017f2040
    0xc0017f2048
    0xc0017f2050
    go run .  0.20s user 0.25s system 133% cpu 0.336 total
    ```
## Non-Structs: Attach methods to almost any type
1. Unlike other OOP language, go doesn't have classes. The methods can be attached to almost any type. It doesn't have to be a struct type. Don't use pointer in the last two items, because they already carry a pointer with themselves.
    - int, string, float64... (primitive types)
    - array, struct
    - slice, map, chan
    - func
2. A slice of game pointers without methods
    - `[]*game`
    - `&minecraft{...}`
    - `&tetris{...}`
3. Example: 
    - list.go
    ```
    package main

    import "fmt"

    type list []*game

    func (l list) print() {
        if len(l) == 0 {
            fmt.Println("Sorry. We're waiting for delivery 🚚.")
            return
        }

        for _, it := range l {
            it.print()
        }
    }
    ```
    - main.go
    ```
    package main

    func main() {
        var (
            minecraft = game{title: "minecraft", price: 20}
            tetris    = game{title: "tetris", price: 5}
        )

        var items []*game
        items = append(items, &minecraft, &tetris)

        my := list(items)

        my = nil

        my.print()
    }
    ```
# Section15: Interfaces: Implicit OOP Way
## Interfaces: Be dynamic
1. All the non-interface types are concrete types.
2. convention: "-er" suffix. "printer" is an interface type. In the interface, it only describes the **expected behavior**(methods). In this case, printer only needs a printing behavior and it doesn't care where the behavior comes from.
    ```
    type printer interface {
        print()
    }
    ```
3. Example.
    - main.go
    ```
    package main

    func main() {
        var (
            mobydick  = book{title: "moby dick", price: 10}
            minecraft = game{title: "minecraft", price: 20}
            tetris    = game{title: "tetris", price: 5}
        )

        var store list
        store = append(store, &mobydick, &minecraft, &tetris)
        store.print()
    }
    ```
    - list.go
    ```
    package main

    import "fmt"

    // an abstract type, a protocol, a contract.
    // no implementation
    type printer interface {
        print()
    }

    type list []printer

    func (l list) print() {
        if len(l) == 0 {
            fmt.Println("Sorry. We're waiting for delivery 🚚.")
            return
        }

        for _, it := range l {
            fmt.Printf("(%-10T) --> ", it)
            it.print()
        }
    }
    ```
## Type Assertion: Extract the dynamic value!
1. The wrapped value inside that interface value is called a dynamic value, because this value can change in the runtime. The type inside the interface is called a dynamic type, because the type can also change in the runtime.
2. Example.
    - main.go
    ```
    package main

    func main() {
        var (
            mobydick  = book{title: "moby dick", price: 10}
            minecraft = game{title: "minecraft", price: 20}
            tetris    = game{title: "tetris", price: 5}
            yoda      = toy{title: "yoda", price: 150}
        )

        var store list
        store = append(store, &mobydick, &minecraft, &tetris, &yoda)

        store.discount(.5)

        store.print()
    }
    ```
    - toy.go (copy from game.go)
    ```
    package main

    import "fmt"

    type toy struct {
        title string
        price money
    }

    func (t *toy) print() {
        fmt.Printf("%-15s: %s\n", t.title, t.price.string())
    }

    func (t *toy) discount(ratio float64) {
        t.price *= money(1 - ratio)
    }
    ```
    - list.go
    ```
    package main

    import "fmt"

    // an abstract type, a protocol, a contract.
    // no implementation
    type printer interface {
        print()
    }

    type list []printer

    func (l list) print() {
        if len(l) == 0 {
            fmt.Println("Sorry. We're waiting for delivery 🚚.")
            return
        }

        for _, it := range l {
            fmt.Printf("(%-10T) --> ", it)
            it.print()
        }
    }

    func (l list) discount(ratio float64) {
        type discounter interface {
            discount(float64)
        }

        for _, it := range l {
            //g, ok := it.(discounter)
            //fmt.Printf("%T game? %v\n", it, ok)
            //if !ok {
            //	continue
            //}
            //g.discount(ratio)
            if it, ok := it.(discounter); ok {
                it.discount(ratio)
            }
        }
    }
    ```
## Empty Interface: Represent any type of value
1. `interface{}` says nothing. It wraps other types in a hidden place.
2. When you have the slice of empty interface, unlike the single interface, you need to use loop to save it. Here is an example.
    ```
    package main

    import "fmt"

    func main() {
        nums := []int{1, 2, 3}

        var any interface{}
        any = nums

        _ = len(any.([]int))

        var many []interface{}

        for _, n := range nums {
            many = append(many, n)
        }
        fmt.Println(many)
    }
    ```
3. Using empty interface may let your programs become brittle and hard to maintain, so do not use it unless really necessary. Example.
    - book.go
    ```
    package main

    import (
        "fmt"
        "strconv"
        "time"
    )

    type book struct {
        title     string
        price     money
        published interface{}
    }

    func (b book) print() {
        p := format(b.published)
        fmt.Printf("%-15s: %s - (%v)\n", b.title, b.price.string(), p)
    }

    func format(v interface{}) string {
        if v == nil {
            return "unknown"
        }

        var t int
        if v, ok := v.(int); ok {
            t = v
        }

        if v, ok := v.(string); ok {
            t, _ = strconv.Atoi(v)
        }

        u := time.Unix(int64(t), 0)
        return u.String()
    }
    ```
    - main.go
    ```
    package main

    func main() {
        store := list{
            book{title: "moby dick", price: 10, published: 118281600},
            book{title: "odyssey", price: 10, published: "733622400"},
            book{title: "hobbit", price: 10},
            &game{title: "minecraft", price: 20},
            &game{title: "tetris", price: 5},
            puzzle{title: "rubik's cube", price: 5},
            &toy{title: "yoda", price: 150},
        }

        store.print()
    }
    ```
## Type Switch: Detect and extract multiple values
1. Type switch detects and extracts the dynamic value from an interface value.
2. Example.
    - Rewrite book.go
    ```
    func format(v interface{}) string {
        var t int

        switch v := v.(type) {
        case int:
            t = v
        case string:
            t, _ = strconv.Atoi(v)
        default:
            return "unknown"
        }

        const layout = "2006/01"

        u := time.Unix(int64(t), 0)
        return u.Format(layout)
    }
    ```
## Promoted Methods: Let's make a little bit of refactoring
1. Example.
    - product.go
    ```
    package main

    import "fmt"

    type product struct {
        title string
        price money
    }

    func (p *product) print() {
        fmt.Printf("%-15s: %s\n", p.title, p.price.string())
    }

    func (p *product) discount(ratio float64) {
        p.price *= money(1 - ratio)
    }
    ```
    - book.go
    ```
    package main

    import (
        "fmt"
        "strconv"
        "time"
    )

    type book struct {
        product
        published interface{}
    }

    func (b *book) print() {
        b.product.print()
        p := format(b.published)
        fmt.Printf("\t - (%v)\n", p)
    }

    func format(v interface{}) string {
        var t int

        switch v := v.(type) {
        case int:
            t = v
        case string:
            t, _ = strconv.Atoi(v)
        default:
            return "unknown"
        }

        const layout = "2006/01"

        u := time.Unix(int64(t), 0)
        return u.Format(layout)
    }
    ```
    - game.go
    ```
    package main

    type game struct {
        product
    }
    ```
    - puzzle.go
    ```
    package main

    type puzzle struct {
        product
    }
    ```
    - toy.go
    ```
    package main

    type toy struct {
        product
    }
    ```
    - list.go
    ```
    package main

    import "fmt"

    // an abstract type, a protocol, a contract.
    // no implementation
    type item interface {
        print()
        discount(ratio float64)
    }

    type list []item

    func (l list) print() {
        if len(l) == 0 {
            fmt.Println("Sorry. We're waiting for delivery 🚚.")
            return
        }

        for _, it := range l {
            fmt.Printf("(%-10T) --> ", it)
            it.print()
        }
    }

    func (l list) discount(ratio float64) {
        type discounter interface {
            discount(float64)
        }

        for _, it := range l {
            it.discount(ratio)
        }
    }
    ```
# Section16: Interfaces; Marshaler, Sorter, and so on
## Don't interface everything!
1. Prefer to work directly with concrete types.
    - Leads to a simple and easy to understand code.
    - Abstractions (interfaces) can unnecessarily complicate your code.
2. Separating responsibilities is critical.
    - **Timestamp** type can represent, store, and print a UNIX timestamp.
3. When a type **anonymously embeds** a type, it can use the methods of the embedded type as its own.
    - **Timestamp** embeds a **time.Time**.
    - So you can call the methods of the **time.Time** through a timestamp value.
4. Example
    - main.go
    ```
    package main

    func main() {
        l := list{
            {title: "moby dick", price: 10, released: toTimestamp(118281600)},
            {title: "odyssey", price: 15, released: toTimestamp("733622400")},
            {title: "hobbit", price: 25},
        }

        l.discount(.5)
        l.print()
    }
    ```
    - timestamp.go
    ```
    package main

    import (
        "strconv"
        "time"
    )

    type timestamp struct {
        time.Time
    }

    func (ts timestamp) string() string {
        if ts.IsZero() {
            return "unknown"
        }

        const layout = "2006/01"
        return ts.Format(layout)
    }

    func toTimestamp(v interface{}) (ts timestamp) {
        var t int

        switch v := v.(type) {
        case int:
            t = v
        case string:
            t, _ = strconv.Atoi(v)
        }

        ts.Time = time.Unix(int64(t), 0)
        return ts
    }
    ```
    - product.go
    ```
    package main

    import (
        "fmt"
    )

    type product struct {
        title    string
        price    money
        released timestamp
    }

    func (p *product) print() {
        fmt.Printf("%s: %s (%s)\n", p.title, p.price.string(), p.released.string())
    }

    func (p *product) discount(ratio float64) {
        p.price *= money(1 - ratio)
    }
    ```
    - list.go
    ```
    package main

    import "fmt"

    // an abstract type, a protocol, a contract.
    // no implementation
    type item interface {
        print()
        discount(ratio float64)
    }

    type list []*product

    func (l list) print() {
        if len(l) == 0 {
            fmt.Println("Sorry. We're waiting for delivery 🚚.")
            return
        }

        for _, p := range l {
            p.print()
        }
    }

    func (l list) discount(ratio float64) {
        type discounter interface {
            discount(float64)
        }

        for _, p := range l {
            p.discount(ratio)
        }
    }
    ```
## Stringer: Grant a type the ability to represent itself as a string
1. fmt.Stringer **has one method: String()**.
    - That returns a **string**.
    - It is better to be an fmt.Stringer instead of printing directly.
2. **Implement the String()** on a type and the type can represent itself as a **string**.
    - Bonus: The functions in the **fmt package** can print your type.
    - They use **type assertion** to detect if a type implements a **String()** method.
3. **strings.Builder** can **efficiently** combine multiple string values.
4. Example.
    - money.go
    ```
    package main

    import "fmt"

    type money float64

    func (m money) String() string {
        return fmt.Sprintf("$%.2f", m)
    }
    ```
    - timestamp.go
    ```
    package main

    import (
        "strconv"
        "time"
    )

    type timestamp struct {
        time.Time
    }

    func (ts timestamp) String() string {
        if ts.IsZero() {
            return "unknown"
        }

        const layout = "2006/01"
        return ts.Format(layout)
    }

    func toTimestamp(v interface{}) (ts timestamp) {
        var t int

        switch v := v.(type) {
        case int:
            t = v
        case string:
            t, _ = strconv.Atoi(v)
        }

        ts.Time = time.Unix(int64(t), 0)
        return ts
    }
    ```
    - product.go
    ```
    package main

    import (
        "fmt"
    )

    type product struct {
        title    string
        price    money
        released timestamp
    }

    func (p *product) String() string {
        return fmt.Sprintf("%s: %s (%s)", p.title, p.price, p.released)
    }

    func (p *product) discount(ratio float64) {
        p.price *= money(1 - ratio)
    }
    ```
    - list.go
    ```
    package main

    import (
        "strings"
    )

    type item interface {
        print()
        discount(ratio float64)
    }

    type list []*product

    func (l list) String() string {
        if len(l) == 0 {
            return "Sorry. We're waiting for delivery 🚚.\n"
        }

        var str strings.Builder
        for _, p := range l {
            str.WriteString("* ")
            str.WriteString(p.String())
            str.WriteRune('\n')
        }
        return str.String()
    }

    func (l list) discount(ratio float64) {
        type discounter interface {
            discount(float64)
        }

        for _, p := range l {
            p.discount(ratio)
        }
    }
    ```
    - main.go
    ```
    package main

    import "fmt"

    func main() {
        l := list{
            {title: "moby dick", price: 10, released: toTimestamp(118281600)},
            {title: "odyssey", price: 15, released: toTimestamp("733622400")},
            {title: "hobbit", price: 25},
        }

        l.discount(.5)
        fmt.Print(l)
    }
    ```
## Sorter: let a type know how to sort itself
1. sort.Sort() **can sort any type that implements the sort.Interface**.
2. sort.Interface has three methods: Len(), Less(), Swap()
    - Len() returns the length of a collection.
    - Less(i, j) should return **true** when an element comes before another one.
    - Swap(i, j)s the elements when the Less() return **true**.
3. sort.Reverse() can reverse sort a type that satisfies the sort.Interface.
4. You can customize the sorting:
    - **Either** by implementing the sort.Interface methods or by **anonymously embedding** a type that already satisfies the sort.Interface and adding a Less() method.
5. **Anonymous embedding** means **auto-forwarding** method calls to an embedded type.
    - Check out the source-code for detail.
6. Example.
    - list.go, add the following three lines to the bottom of list.go. It implements the sort interface methods.
    ```
    func (l list) Len() int           { return len(l) }
    func (l list) Less(i, j int) bool { return l[i].title < l[j].title }
    func (l list) Swap(i, j int)      { l[i], l[j] = l[j], l[i] }
    ```
    - main.go
    ```
    package main

    import (
        "fmt"
        "sort"
    )

    func main() {
        l := list{
            {title: "moby dick", price: 10, released: toTimestamp(118281600)},
            {title: "odyssey", price: 15, released: toTimestamp("733622400")},
            {title: "hobbit", price: 25},
        }

        sort.Sort(l)

        l.discount(.5)
        fmt.Print(l)
    }
    ```
7. Custom sort example.
    - list.go
    ```
    type byRelease struct {
        list
    }

    func (br byRelease) Less(i, j int) bool {
        return br.list[i].released.Before(br.list[j].released.Time)
    }

    func byReleaseDate(l list) sort.Interface {
        return &byRelease{l}
    }
    ```
## Marshalers: Customize JSON encoding and decoding of a type
1. json.Marsahl() and json.MarsahllIndent() can only encode primitive types.
    - Custom types can tell the encoder how to encode.
    - To do that satisfy the json.Marshaler interface.
2. json.Unmarshal() can only decode primitive types.
    - Custom types can tell the decoder how to decode.
    - To do that satisfy the json.Unmarshal interface.
3. strconv.AppendInt() can append an **int** value to a **[]byte**.
    - There are several other functions in the **strconv package** for other primitive types as well.
    - Do not make unnecessary **string <-> []byte** conversions.
4. log.Fatal(0 can print the given error message and terminate the program.
    - Use it only from the **main()**. Do not use it in other functions.
    - **main()** is should be the main driver of a program.
5. Marshal Example.
    - main.go
    ```
    package main

    import (
        "encoding/json"
        "fmt"
        "log"
    )

    func main() {
        l := list{
            {Title: "moby dick", Price: 10, Released: toTimestamp(118281600)},
            {Title: "odyssey", Price: 15, Released: toTimestamp("733622400")},
            {Title: "hobbit", Price: 25},
        }

        data, err := json.MarshalIndent(l, "", " ")
        if err != nil {
            log.Fatal(err)
        }
        fmt.Println(string(data))
    }
    ```
    - timestamp.go
    ```
    func (ts timestamp) MarshalJSON() (data []byte, _ error) {
        // ts -> integer -> ts.Unix() -> integer
        // data <- integer -> strconv.AppendInt(data, integer, 10)
        return strconv.AppendInt(data, ts.Unix(), 10), nil
    }
    ```
5. Unmarshal Example.
    - main.go
    ```
    package main

    import (
        "encoding/json"
        "fmt"
        "log"
    )

    const data = `[
    {
    "Title": "moby dick",
    "Price": 10,
    "Released": 118281600
    },
    {
    "Title": "odyssey",
    "Price": 15,
    "Released": 733622400
    },
    {
    "Title": "hobbit",
    "Price": 25,
    "Released": -62135596800
    }
    ]`

    func main() {
        var l list
        err := json.Unmarshal([]byte(data), &l)
        if err != nil {
            log.Fatal(err)
        }
        fmt.Print(l)
    }
    ```
    - timestamp.go
    ```
    func (ts *timestamp) UnmarshalJSON(data []byte) error {
        *ts = toTimestamp(string(data))
        return nil
    }
    ```