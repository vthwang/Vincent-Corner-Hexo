---
title: Jenkins 快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/jenkins/jenkinsday1.png
date: 2017-09-02 23:49:25
categories: Study Note
tags: Jenkins
---
<img src="/images/learning/jenkins/jenkinsday1.png">

***
### 介紹 Jenkins
#### 課程介紹
1. 目標
    - 了解關鍵知識
    - 使用 Jenkins 來設置自動建立
    - 熟悉基礎 Jenkins
    - 強烈的起始點
2. 課程簡介
    - 介紹 & 核心觀念
    - 快速安裝
    - Jenkins UI 概覽
    - Jenkins 基礎 (自由型式工作)
    - Maven 專案
    - 超越基礎
    - 結論 / Bonus
#### 課程重點和方法
1. 課程重點
    - Mac OS X
    - 初學者
    - Java / Maven
    - Git & Github
    - Jenkins
        - 相同的系統
        - 簡單
2. 課程方法
    - 最少量的理論 / 核心觀念
    - 一步一步實際練習範例
    - 補充內容
    - 影片：短且針對重點
    - 暫停和跟隨
    - 加入討論
#### 什麼是 Jenkins？為什麼使用 Jenkins？
1. 什麼是 Jenkins？
    - 持續整合 / 建立 Server
        - 自動軟體建立
        - Orchestration
    - 免費 (開源)
        - 商業支援可用
    - Powered by Java / Jetty
        - WAR for Java Web Containers (像是 Tomcat)
    - [Jenkins.io](https://jenkins.io/)
2. 為什麼使用 Jenkins？
    - 剛開始
        - 手動的
        - 每一個開發者
    - 在自己的機器運作
        - 不需要 Scale
        - 非常危險
    - 建立 Servers
        - 監控改變
        - 建立 code
            - 自動地
            - 定期地
    - Jenkins
        - 非常熱門
        - 強大的
        - 強壯的社群支持
        - 極度有彈性的
#### Jenkins 架構
1. Host System 裡面會有用 Jetty (預設) 執行的 Container，Jetty 可以存取 JDK tools
2. 會有一個叫做 service 的程式，他負責啟動、停止和監控 Jetty
3. 而在 Container 裡面會執行 Jenkins，在 Jenkins 裡面則會放置 View (依照分組或目錄分類)，View 裡面會放置 Project，提供如何建立軟體的指引，Project 會把工作放到 View 外面的 Job Queue，最後由 Executor 來協助 Job Queue 完成
### 快速安裝
#### 快速安裝概覽
1. 安裝流程
    - 支援多個技能等級
    - 快速安裝流程 (這一部分)
    - 完整安裝流程 (Bonus)
2. Mac OS X 或 mac OS
    - 應該支援部多數最新版本
3. Git
    - Apple - Command Line Tools
4. 任意文字編輯器
    - TextMate 2 (包含教學)
    - Atom
    - Sublime
5. Java Software Development Kit (JDK)
6. Apache Maven 3
7. Jenkins 2
8. Mac OS Launch Daemon Service
    - 啟動 / 暫停 / 重新啟動 Jenkins
9. 安裝流程的文字教程
    - 有些人比較喜歡這個方法
#### Jenkins 快速安裝
1. 安裝 [JDK](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
2. 在 .zshrc 加上這一行
```
export JAVA_HOME=`/usr/libexec/java_home`
```
3. [下載 Maven](http://maven.apache.org/)，下載 tar.gz 版本
4. 使用 Command Line 解壓縮
`tar -xvzf apache-maven-3.5.0-bin.tar.gz`
5. 在 .zshrc 加上這兩行
```
plugins=(mvn)
export MAVEN_HOME=~/Development/maven
export PATH="${PATH}:${MAVEN_HOME}/bin"
```
6. [下載 LTS 版本](https://jenkins.io/download/)
    - 安裝完成之後，可以在 http://localhost:8080 看到
    - Service Daemon
#### MacOS 上的 Jenkins 服務
1. 重新啟動 Jenkins
`http://localhost:8080/restart` 
2. unload 移除組態設定
`sudo launchctl unload /Library/LaunchDaemons/org.jenkins-ci.plist`
3. load 會重新載入組態設定
`sudo launchctl load /Library/LaunchDaemons/org.jenkins-ci.plist`