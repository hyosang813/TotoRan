//
//  HanteiStringMaker.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/11.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

//判定データのArrayから数列を作ってStringで返すクラス
class HanteiStringMaker
{
    //メソッド
    static func resultHanteiString(hanteiDataArray: [[AnyObject]]) -> String {
        //返す文字列変数を用意
        var returnString = ""
        
        for arr in hanteiDataArray {
            for var i = 0; i < arr.count; i++ {
                returnString += (String(arr[i]))
                // //5個目と10個目にスペース追加(bODDSがあればその間もスペース)
                switch i {
                case 4,9,12,14: returnString += " "
                default:break
                }
            }
            //改行
            returnString += "\n"
        }
        //さらに改行
        returnString += "\n"
        
        //DBから現在開催回を取得してそれをキーに支持率取得日時の文字列を取得
        let dbControll = ControllDataBase()
        returnString += dbControll.returnGetRateTime()
        
        //返す
        return returnString
    }
}

//クリップボードにコピー
class DataCopy
{
    static func copyAndAlert(resultViewText: String) -> UIAlertController {
        //結果に「＃トトラン！」を付与する
        let copyText = resultViewText + MESSAGE_STR.TOTORAN
        
        //ペーストボードオブジェクト生成
        let pasetBoard = UIPasteboard.generalPasteboard()
        pasetBoard.setValue(copyText, forPasteboardType: URL_STR.COPY_TYPE)
        
        //アラートコントローラー
        let alertController = UIAlertController(title: "", message: MESSAGE_STR.COPY_MESSAGE, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        //アラートコントローラを返すのでプレゼントはそっちで
        return alertController
    }
}
