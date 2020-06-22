---
title: Mac 開發環境建置
thumbnail:
  - /images/technique/MacEnvironment.jpg
date: 2017-09-13 21:07:44
categories: Skill Share
tags: Mac
toc: true
---
<img src="/images/technique/MacEnvironment.jpg">

***
### 內建工具
#### 1. Xcode
1. 到 App Store 下載
2. 記得要打開 Xcode，並且同意服務條款

### 生產力工具
#### 1. Alfred + Powerbank (付費)
[直接從官方網站下載應用](https://www.alfredapp.com/)
#### 2. iTerm2
[直接從官方網站下載應用](https://www.iterm2.com/)
##### 設定：
1. 把字體改大
    - iTerm2 => Preferences => Profiles => Text => Font => 20px
2. 讓 iTerm2 可以無限的往回滾動
    - iTerm2 => Preferences => Profiles => Terminal => Scrollback Buffer => Unlimited scrollback
3. 修改主題 - [下載 Dracula 主題](https://draculatheme.com/iterm/)
    - iTerm2 => Preferences => Profiles => Color => 找到右下角的 Color Presets => Import => 選擇 Dracula
#### 3. Wunderlist
[直接從官方網站下載應用](https://www.wunderlist.com/)
#### 4. Dropbox
[直接從官方網站下載應用](https://www.dropbox.com/downloading)
#### 5. MoneyPro (付費軟體)
[直接從官方網站下載應用](http://ibearmoney.com/tw/pro/overview-mac.html)
#### 6. Filezilla
[直接從官方網站下載應用](https://filezilla-project.org/download.php?type=client)
#### 7. Zoom
[直接從官方網站下載應用](https://zoom.us/download)
#### 8. VirtualBox
[直接從官方網站下載應用](https://www.virtualbox.org/wiki/Downloads)
#### 9. WebStorm
[直接從官方網站下載應用](https://www.jetbrains.com/webstorm/download/#section=mac)
#### 10. PhpStorm
[直接從官方網站下載應用](https://www.jetbrains.com/phpstorm/download/#section=mac)
#### 11. Visual Studio Code
[直接從官方網站下載應用](https://code.visualstudio.com/)
##### 設定：
1. 常用套件
    - Auto Close Tag
    - Beautify
    - ESLint
    - Git History
    - HTML Snippets
    - Material Icon Theme
    - Material Theme Kit
2. 打開自動存檔 File => Auto Save
3. 字體放大 Code => Preferences => Setting => "editor.fontSize": 16
4. 修改佈景主題 Command+Shift+P => theme => Solarized Light
#### 12. Enpass (密碼管理工具)
[直接從官方網站下載應用](https://www.enpass.io/downloads/)
#### 13. Anki
[直接從官方網站下載應用](https://apps.ankiweb.net/)
#### 14. Slack
[直接從官方網站下載應用](https://slack.com/downloads/osx)
#### 15. Karabiner (修改鍵盤工具)
[直接從官方網站下載應用](https://pqrs.org/osx/karabiner/)

### 套件 & 指令
#### 1. zsh
1. 安裝指令
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
`
2. 修改佈景主題
`vim ~/.zshrc`
修改 ZSH_THEME="cloud"
[相關主題參考](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes)
#### 2. Homebrew
1. 安裝指令
`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
`
#### 3. nvm
1. 安裝指令
[參考官方網站](https://github.com/creationix/nvm)
`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
`
2. 列出所有版本
`nvm ls-remote`
3. 安裝 TLS 版本
`nvm install 6.11.3`
#### 4. Git
1. 安裝指令
`brew update && brew install git`
2. 設定全域 username 和 email
`git config --global user.name "tingsyuanwang"`
`git config --global user.email "dtvgood202@gmail.com"`
#### 5. Hexo (部落格套件)
1. 安裝指令
`npm install -g hexo-cli`
#### 6. Composer
[進去 Composer 網站按照指令安裝](https://getcomposer.org/download/)
#### 7. Docker
[直接從官方網站下載應用](https://store.docker.com/editions/community/docker-ce-desktop-mac)
#### 8. Kubectl (Kubernetes 指令)
1. 安裝指令
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/darwin/amd64/kubectl
```

### React Native 環境
1. 安裝 node watchman
`brew install node`
`brew install watchman`
2. 安裝 React Native CLI
`npm install -g react-native-cli`
3. Java Development Kit
[從官方網站下載](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
4. Android Studio
[從官方網站下載](https://developer.android.com/studio/index.html)
5. 加到 .zshrc
```
# JDK configuration
export JAVA_HOME=`/usr/libexec/java_home`

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```
6. React Native Debugger
`brew update && brew cask install react-native-debugger`