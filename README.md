# LogicDesign_Final Project

---

## 第二十一組期末Project

---

## 示範影片
* [示範影片連結](https://youtu.be/JTiczNOaXB0)
 ![iamge](https://github.com/LCH030/LogicDesign_Final/blob/main/pic.png)
 
---

## 語言環境
* 語言 : SystemVerilog
* 開發環境 : Quartus 13.1

---

## 使用到的 sensor
* 1 bit 按鈕 * 3 : 左右移動、發射雷射光
* 8X8 RGB 顯示器 : 顯示遊戲畫面
* 4 bits LED燈 : 血量條
* 七段顯示器 : 顯示得分
* 蜂鳴器Buzzer : 遊戲配樂
* 1 bit 指撥開關 * 4 : 三個為難度調整、一個為reset鍵

---

## 功能
* 隨機位置掉落敵人飛機（隨機出現一台或兩台）。
* 我方飛機可以使用雷射光攻擊敵人飛機，打到即可加一分，十分即可獲勝。
* 被敵人碰撞後，血量即扣一條，四條血扣完就輸了。
* “ 獲勝 ” 即出現 “ ＧＡＭＥＣＬＥＡＲ ” 字樣在 8*8 RGB顯示器上。
* ” 失敗 “ 即出現 “ ＧＡＭＥＣＬＥＡＲ ” 字樣在 8*8 RGB顯示器上。
* buzzer蜂鳴器的音樂為 “ 星際大戰 黑武士的配樂 ”。
* Easy 開關開啟，即為簡單模式，飛機掉落速度比普通模式更慢。
* Normal 開關開啟，即為普通模式。
* Hard 開關開啟，即為艱難模式，飛機掉落速度變快。
* Reset 開關開啟，即重新遊戲。
