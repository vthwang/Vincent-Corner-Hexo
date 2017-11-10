---
title: UI 網頁設計快速學習自我挑戰 Day1
thumbnail:
  - /images/learning/ui/UIDay1.png
date: 2017-11-09 17:30:02
categories: 學習歷程
tags: 
    - UI
    - Illustrator
---
<img src="/images/learning/ui/UIDay1.png">

***
#### 修改 Illustrator 環境
1. Illustrator CC => Preferences => Units，把 General、Stroke 和 Type 改為 Pixels
2. Window => Workspace，選擇 Web，如果有問題，選擇 Reset Web
#### 在 Illustrator 新增 sitemap
1. New => 選擇 A4
2. 打開 Adobe Muse => New => 直接新增
3. 修改 Muse 背景：Preferences => Color theme 挑一個
4. 用 Command + Shift + 4 截圖，把檔案貼到 Illustrator
#### Desktop、Tablet、Mobile 網頁設計用什麼螢幕尺寸
1. [了解裝置大小](http://mydevice.io/devices)
2. New => 選擇 Web => Common size => 將 width 改為 1200 => 新增
3. 開啟左邊選單列的 artboard tool => 選擇 New Artboard => 將寬度調為 768 px
4. 按住 Option 鍵 => 按鈕會變成有陰影的箭頭 => 拖移也可以產生新的 Artboard
5. Window => Artboard => Artboard 出現在右邊選單，將 Artboard 改為以下
    - Desktop 1200px
    - Tablet 768px
    - Mobile 400px
6. Save => 按照預設值即可
#### 什麼是 Grid System 和 Responsive Mobile & Tablet Design？
1. 12 個 column，不能用 13，因為難以切割
#### 如何在 Illustrator 製作 12 個 column 的 responsive grid？
1. 先選擇 Rectangle Tool => 內部選擇 None => 外部選擇黑色 => 把 Desktop 部分框起來
2. 選擇 Object => Path => Split Into Grid => Column number 選擇 12 => Gutter 選擇 30px =>  Add Guides 要打勾 => 點選 OK
3. 選擇出現的 object => 按滑鼠右鍵 ungroup => 把畫面往下移動
4. View => Make Guides => View => Lock Guides，然後線條就鎖住了
5. 把所有的線框起來 => 刪掉
6. 點選左邊選單的 Artboard，把左右兩邊邊界拉大
7. Tablet 和 Mobile 步驟都跟上面一樣，但是 Tablet Column number 選擇 6，Mobile Column 選擇 2
#### 建立 Wireframe
1. `Command + ;` 可以關閉和開啟 Guides
2. 新增 Logo，左上角佔用 4 個 column
3. 新增 Navigation，右上角佔用 6 個 column
4. 新增 Hero box，放到 Logo 下方，佔用 12 個 column
5. 在 Hero box 裡面的第二個 column 新增佔用 5 個 column 的文字
6. `Command + Shift + .` 放大字體，`Command + Shift + ,` 縮小字體
7. 全選文字 => 點選右方段落 => 取消勾選 Hyphenate
8. 在文字下方新增佔用 3 個 column 的 button，文字打入 AMAZING CALL TO ACTION
9. 在 Hero box 下方新增 4 個 column 的區塊，裡面要打上叉叉，先用 Line Segment Tool 新增一條斜線，再用 Object => Transform => Reflect，產生相反的線，用 Transform 對齊，最後把區塊和叉叉組合在一起 => Object => Group
10. 最後複製三個 4 column 區塊，然後對齊，並間隔一個位置。
#### 建立 Tablet 和 Mobile Wireframe
1. 把 Guides 延長的方法：View => Guides => Unlock Guides => 把下面的線框起來 => 選擇 Direct Selection Tool => 把線拉長並按住 Shift (可以保持直線) => View => Guides => Lock Guides
2. Mobile Hamburger Bar：用 Line Segment Tool 拉出直線 => 設定 Stroke 線為黑色且寬度設為 4px => 複製三個 => 用 transform 的 Vertical Distribute Center
3. 剩下的按照位置移動，並調整大小即可。
#### 網頁設計的靈感
1. [AWWWARDS](https://www.awwwards.com/)
#### 使用 Illustrator 模板開始網頁設計
1. New => Web => TEMPLATES => 選擇需要的下載
2. 打開 Creative Cloud => Assets => Market => 選擇需要的 => Add to Library
#### 將 Vector Logo 放到版面編排
1. 使用 svg 再放大也不會失真，所以最好使用 svg
2. 用 Rectangle Tool 拉出背景，選擇黑色，透明度選擇 81%，把位置放到最後面 => 按滑鼠右鍵 => Arrange => Send to Back
3. 放上 Navigation 文字 => ABOUT ME、CONTACT ME
#### 使用 Adobe 顏色
1. [Adobe 顏色選擇器](https://color.adobe.com/create/color-wheel/)
2. 進去網頁之後 => 選擇 Explore => 選擇喜歡的色盤 => 按下 Save => 選擇要存入的 Library => 就可以在 Illustrator 看到了
#### 使用 Adobe Illustrator 來對應品牌顏色
1. 把 Google Logo 放到頁面裡面 => 使用 Eyedropper Tool 點需要的顏色 => 在畫面左上方顏色選擇器的地方選擇 New Swatch => 輸入名稱 => 儲存到 Library