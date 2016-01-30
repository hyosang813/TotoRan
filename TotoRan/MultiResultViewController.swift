//
//  MultiViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/11.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class MultiResultViewController: ResultViewController
{
    //ランダムの結果を受け取るプロパティ
    var randomArray: [AnyObject] = []
    
    //削減用　その１(0の数、toto判定種別の英字、book判定種別の英字が入ってる２次元Array)
    var reduceArray: [AnyObject] = []
    
    //削減用　その２(上記のArrayに対応するBOOL値が入ってるArray)
    var reduceBoolArray: [[Bool]] = []
    
    //init
    override func setup() {
        partsArray = [
            ["プチ削減", NSValue(CGRect: RectMaker.multiReduceButton()), "popupReduction"],
            ["判定表示", NSValue(CGRect: RectMaker.multiPopupButton()), "popupHanteiView"],
            ["コピー", NSValue(CGRect: RectMaker.multiCopyButtonRect()), "dataCopy"]
        ]
    }

    override func viewDidLoad() {
       super.viewDidLoad()

        //画面タイトルを設定
        self.title = "マルチ選択"
        
        //結果表示テキストビューのフォントサイズとアライメントを調整
        resultView.font = UIFont(name: "Courier", size: CGFloat(appDelegate.fontSize + 5))
        resultView.textAlignment = .Center
        
        //組み合わせチーム情報を取得、チーム名が1文字だったら左右に、チーム名が2文字だったら真ん中にスペース追加
        let teamArray: [String] = appDelegate.teamArray as! [String]
        for var teamName in teamArray {
            if teamName.characters.count == 1 {
                teamName = " " + teamName + " "
            } else if teamName.characters.count == 2 {
                teamName.insert(" ", atIndex: teamName.startIndex.advancedBy(1))
            }
        }
        
        //Int32だとiOS8で落ちるからIntで扱ってくれ！！！！
        let randomArrayInt = randomArray as! [[Int]]
        
        //マルチの結果文字列を作っていきます
        var multiResultString = ""
        var zeroCount = 0
        var drawSingleCount = 0

        for var i = 0; i < randomArrayInt.count; i++ {

            //ドローだけでシングルの枠はプチ削減対象外にしなきゃいけない
            var drawSingleFlg = false
            var drawSingleCountDetail = 0

            //一行分のランダム結果文字列を作成 [1-2]みたいな
            var randPartString = " ["
            for var j = 0; j < 3; j++ {
                //9は-に、数値は文字列に変換
                if randomArrayInt[i][j] == 9 {
                    randPartString += "-"
                } else {
                    randPartString += String(randomArrayInt[i][j])
                    drawSingleCountDetail++
                    if randomArrayInt[i][j] == 0 {
                        zeroCount++
                        drawSingleFlg = true
                    }
                }
            }

            //かっこを閉じる
            randPartString += "]\n"
            
            //この枠がドローシングルだったらカウントアップ
            if drawSingleFlg && drawSingleCountDetail == 1 {
                drawSingleCount++
            }
            

            //フラグを初期化
            drawSingleFlg = false
            drawSingleCountDetail = 0
            
            //一行分の文字列を作成例：「1 浦 和 - G大阪 [1-2]」
            //multiResultString += String(i + 1) + " " + teamArray[i] + " － " + teamArray[i + 13] + randPartString
            multiResultString += String(NSString(format: "%02d", i + 1)) + " " + String(teamArray[i]) + " － " + String(teamArray[i + 13]) + randPartString
            //コード補完を使うとSourceKitServiceがCPUを200%占有とかしちゃう
            //teamArray[i]とteamArray[i + 13]を明示的にStringでキャストしてあげるだけで随分CPU食わなくなった
        }

        //結果をテキストビューに表示
        resultView.text = multiResultString
        
        //0の数とドローシングル枠数をreduceArrayに追加
        reduceArray.append([zeroCount, drawSingleCount])
        
        //判定英字を抽出して格納
        var totoEiji :[String] = []
        var bookEiji :[String] = []
        for var arr in hanteiDataArray {
            totoEiji.append(arr[13] as! String)
            if arr.count > 15 {
                bookEiji.append(arr[15] as! String)
            }
        }
        reduceArray.append(totoEiji.unique())
        reduceArray.append(bookEiji.unique())
        
        //プチ削減用にreduceArrayに対応するBoolArrayも生成する
        var partCount = 0
        for rd in reduceArray {
            var boolArray: [Bool] = []
            partCount = partCount == 0 ? (rd.firstObject as! Int) + 1 : rd.count
            for var i = 0; i < partCount; i++ {
                boolArray.append(true)
            }
            reduceBoolArray.append(boolArray)
            partCount++
        }
        
        appDelegate.boolArray = reduceBoolArray
    }
    
    //プチ削減ボタン押下時のアクションメソッド
    func popupReduction() {
        let prc = PopReducViewController()
        prc.checkArray = reduceArray
        presentPopupViewController(prc, animationType: MJPopupViewAnimationFade)
    }
    
    //判定結果ボタン押下時のアクションメソッド
    func popupHanteiView() {
        let phc = PopHanteiViewController()
        phc.hanteiDataArray = hanteiDataArray
        phc.checkArray = reduceArray
        presentPopupViewController(phc, animationType: MJPopupViewAnimationFade)
    }
 }

//重複削除のメソッドをArrayに追加
extension Array where Element: Hashable {
    
    func unique() -> [Element] {
        var r = [Element]()
        for i in self { r += !r.contains(i) ? [i]:[] }
        return r
    }
    
    mutating func uniqueInPlace() {
        self = self.unique()
    }
}
