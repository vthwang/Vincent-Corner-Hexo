---
title: Golang 快速學習自我挑戰 Day5
thumbnail:
  - /images/learning/golang/GolangDay05.jpg
date: 2021-07-24 22:44:22
categories: Study Note
tags: Golang
toc: true
---
<img src="/images/learning/golang/GolangDay05.jpg">

***
## 章節一
### 在 Go 只有一種迴圈
1. 在 Go 只有 for 迴圈，沒有 while 和 until 迴圈。
2. for 迴圈就是重複**一段**程式碼**當**條件是 **true**。
3. `i := 1` 是 init statement。`i <= 5` 是 condition statement，它是 bool expression，當它等於 false 的時候，迴圈結束。`i++` 是 post statement。
    ```
    for i := 1; i <= 5; i++ {
      sum += i
    }
    ```
### 如何中斷一個 for 迴圈？
1. 


