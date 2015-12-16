//
//  RectMaker.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/09.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit


struct RectMaker {
    
    static func width() -> CGFloat { return UIScreen.mainScreen().bounds.size.width } //横幅サイズ
    static func height() -> CGFloat { return UIScreen.mainScreen().bounds.size.height } //縦幅サイズ
    
    //シングル of マルチ選択画面セクション******************************************************ここから
    
    //ロゴマーク
    static func logoRect() -> CGRect {
        return CGRectMake(RectMaker.width() / 2 - 50, (RectMaker.height() / 8) - 10, 100, 100)
    }

    //シングルボタン
    static func singleBtnRect() -> CGRect {
        return CGRectMake(RectMaker.width() / 2 - ((RectMaker.width() / 2) / 2), (RectMaker.height() / 8) * 3 - 10, RectMaker.width() / 2, RectMaker.height() / 10)
    }
    
    //マルチボタン
    static func multiBtnRect() -> CGRect {
        return CGRectMake(RectMaker.width() / 2 - ((RectMaker.width() / 2) / 2), (RectMaker.height() / 8) * 4.2 - 10, RectMaker.width() / 2, RectMaker.height() / 10)
    }
    
    //リロードボタン
    static func reloadBtnRect() -> CGRect {
        return CGRectMake(RectMaker.width() / 2 - ((RectMaker.width() / 2) / 2), (RectMaker.height() / 8) * 5.4 - 10, RectMaker.width() / 2, RectMaker.height() / 10)
    }
    
    //回数ラベル
    static func kaisuLabelRect() -> CGRect {
        return CGRectMake(RectMaker.width() / 2 - ((RectMaker.width() * 0.75) / 2), (RectMaker.height() / 8) * 7 - 40, RectMaker.width() * 0.75, 50)
    }

    //シングル of マルチ選択画面セクション******************************************************ここまで
    
    
    //詳細指定画面セクション(共通)*************************************************************ここから
    
    //表題ラベル
    static func titleLabelRect() -> CGRect {
        return CGRectMake(15, 70, (RectMaker.width() / 8) * 7, RectMaker.height() / 12)
    }
    
    //ツールバー(デフォルト)
    static func defaultTBRect() -> CGRect {
        return CGRectMake(0, RectMaker.height(), RectMaker.width(), 38.0)
    }
    
    //ツールバー(表示)
    static func enabledTBRect() -> CGRect {
        return CGRectMake(0, RectMaker.height() - 180, RectMaker.width(), 38.0)
    }
    
    //ピッカー(デフォルト)
    static func defaultPKRect() -> CGRect {
        return CGRectMake(0, RectMaker.height(), RectMaker.width(), 162)
    }
    
    //ピッカー(表示)
    static func enabledPKRect() -> CGRect {
        return CGRectMake(0, RectMaker.height() - 162, RectMaker.width(), 162)
    }
    
    //ピッカー内のセル
    static func cellRect() -> CGRect {
        return CGRectMake(0, 0, 40, 30)
    }
    
    //詳細指定画面セクション(共通)*************************************************************ここまで
    
    
    //詳細指定画面セクション(シングル)*************************************************************ここから
    
    //ホームラベル
    static func homeLabelRect() -> CGRect {
        return CGRectMake(30, (RectMaker.height() / 12) * 1 + 70, (RectMaker.width() / 8) * 4, RectMaker.height() / 12)
    }
    
    //ドローラベル
    static func drawLabelRect() -> CGRect {
        return CGRectMake(30, (RectMaker.height() / 12) * 2 + 70 + 5, (RectMaker.width() / 8) * 4, RectMaker.height() / 12)
    }

    //アウェイラベル
    static func awayLabelRect() -> CGRect {
        return CGRectMake(30, (RectMaker.height() / 12) * 3 + 70 + 10, (RectMaker.width() / 8) * 4, RectMaker.height() / 12)
    }
    
    //口数ラベル
    static func unitLabelRect() -> CGRect {
        return CGRectMake(15, (RectMaker.height() / 12) * 4 + 70 + 20, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //ホームテキスト
    static func homeTextRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 4 + 30, (RectMaker.height() / 12) * 1 + 70, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //ドローテキスト
    static func drawTextRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 4 + 30, (RectMaker.height() / 12) * 2 + 70 + 5, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //アウェイテキスト
    static func awayTextRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 4 + 30, (RectMaker.height() / 12) * 3 + 70 + 10, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //口数テキスト
    static func unitTextRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 1.5 + 20, (RectMaker.height() / 12) * 4 + 70 + 20, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //ホーム以上ラベル
    static func homeILRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 5.5 + 35, (RectMaker.height() / 12) * 1 + 70, (RectMaker.width() / 8), RectMaker.height() / 12)
    }
    
    //ドロー以上ラベル
    static func drawILRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 5.5 + 35, (RectMaker.height() / 12) * 2 + 70 + 5, (RectMaker.width() / 8), RectMaker.height() / 12)
    }
    
    //アウェイ以上ラベル
    static func awayILRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 5.5 + 35, (RectMaker.height() / 12) * 3 + 70 + 10, (RectMaker.width() / 8), RectMaker.height() / 12)
    }
    
    //口数ラベル（？口）
    static func unitNLRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 3 + 25, (RectMaker.height() / 12) * 4 + 70 + 20, (RectMaker.width() / 8) * 0.5, RectMaker.height() / 12)
    }
    
    //詳細指定画面セクション(シングル)*************************************************************ここまで
    
    
    //詳細指定画面セクション(マルチ)*************************************************************ここから
    
    //ダブルラベル
    static func doubleLabelRect() -> CGRect {
        return CGRectMake(30, (RectMaker.height() / 12) * 1 + 70, (RectMaker.width() / 8) * 4, RectMaker.height() / 12)
    }
    
    //トリプルラベル
    static func tripleLabelRect() -> CGRect {
        return CGRectMake(30, (RectMaker.height() / 12) * 2 + 70 + 5, (RectMaker.width()  / 8) * 4, RectMaker.height() / 12)
    }
    
    //ダブルテキスト
    static func doubleTextRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 4 + 30, (RectMaker.height() / 12) * 1 + 70, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //トリプルテキスト
    static func tripleTextRect() -> CGRect {
        return CGRectMake((RectMaker.width() / 8) * 4 + 30, (RectMaker.height() / 12) * 2 + 70 + 5, (RectMaker.width() / 8) * 1.5, RectMaker.height() / 12)
    }
    
    //詳細指定画面セクション(マルチ)*************************************************************ここまで
    

    
    //結果表示画面セクション(共通)*************************************************************ここから
    
    //結果表示のテキストビュー
    static func textViewRect() -> CGRect {
        return CGRectMake(20, 70, RectMaker.width() - 40 , (RectMaker.height() / 10) * 5)
    }
    
    //NEND広告
    static func nendRect() -> CGRect {
        var adHeight = ManyNum.BASE_AD_HEIGHT //広告の高さは基本50pt
        //5.5インチサイズの場合だけ高さを+10ptする
        if RectMaker.width() >= DisplaySize.SIXPLUS_WIDTH {
            adHeight += ManyNum.INCREMENT_AD_HEIGHT
        }
        
        return CGRectMake(0, RectMaker.height() - adHeight, 320, 50)
    }
    
    //結果表示画面セクション(共通)*************************************************************ここまで
    
    
    //結果表示画面セクション(シングル)*************************************************************ここから
    
    //シングル画面のコピーボタン
    static func singleCopyButtonRect() -> CGRect {
        return CGRectMake(RectMaker.width() / 2 - ((RectMaker.width() / 3) / 2), (RectMaker.height() / 10) * 7 , RectMaker.width() / 3, RectMaker.height() / 13)
    }
    
    //結果表示画面セクション(シングル)*************************************************************ここまで
    
    //結果表示画面セクション(マルチ)*************************************************************ここから
    
    //マルチ画面の削減ボタン
    static func multiReduceButton() -> CGRect {
        return CGRectMake(((RectMaker.width() / 4) / 4) , (RectMaker.height() / 10) * 7, RectMaker.width() / 4, RectMaker.height() / 15)
    }
    
    //マルチ画面のポップアップボタン
    static func multiPopupButton() -> CGRect {
        return CGRectMake(((RectMaker.width() / 4) / 4) * 2 + (RectMaker.width() / 4), (RectMaker.height() / 10) * 7, RectMaker.width() / 4, RectMaker.height() / 15)
    }
    
    //マルチ画面のコピーボタン
    static func multiCopyButtonRect() -> CGRect {
        return CGRectMake(((RectMaker.width() / 4) / 4) * 3 + ((RectMaker.width() / 4) * 2), (RectMaker.height() / 10) * 7, RectMaker.width() / 4, RectMaker.height() / 15)
    }
    
    //こいつらなんか冗長だなああああああああああああああああああああああああああああああああああああああああああああああああああああ！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    
    //結果表示画面セクション(マルチ)*************************************************************ここまで
    
    
    
    

}