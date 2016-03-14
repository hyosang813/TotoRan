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

        //マルチの結果文字列を作っていくと同時にプチ削減に必要なカウント情報を集めていきます
        var multiResultString = ""
        var homeCount = 0
        var drawCount = 0
        var awayCount = 0
        var homeSingleCount = 0
        var drawSingleCount = 0
        var awaySingleCount = 0
        
        for var i = 0; i < randomArrayInt.count; i++ {
            
            var singleFlg = false
            
            //この枠がシングルか否かを判定
            if randomArrayInt[i].filter({$0 == 9}).count == 2 { singleFlg = true }
            
            //それぞれ存在すればカウントアップ
            if randomArrayInt[i].filter({$0 == 1}).count > 0 {
                homeCount++
                if singleFlg { homeSingleCount++ }
            }
            if randomArrayInt[i].filter({$0 == 0}).count > 0 {
                drawCount++
                if singleFlg { drawSingleCount++ }
            }
            if randomArrayInt[i].filter({$0 == 2}).count > 0 {
                awayCount++
                if singleFlg { awaySingleCount++ }
            }
            
            //一行分のランダム結果文字列を作成 [1-2]みたいな
            let tempRandPartString = " [\(randomArrayInt[i][0])" + "\(randomArrayInt[i][1])" + "\(randomArrayInt[i][2])]\n"
            var randPartString = ""
            for char in tempRandPartString.characters {
                if char == "9" {
                    let temp: Character = "-"
                    randPartString.append(temp)
                }
                else {
                    randPartString.append(char)
                }
            }
            
            //一行分の文字列を作成例：「1 浦 和 - G大阪 [1-2]」
            multiResultString += String(NSString(format: "%02d", i + 1)) + " " + String(teamArray[i]) + " － " + String(teamArray[i + 13]) + randPartString
        }

        //結果をテキストビューに表示
        resultView.text = multiResultString
        
        //102の数とシングル枠数をreduceArrayに追加
        reduceArray.append([homeCount, homeSingleCount])
        reduceArray.append([drawCount, drawSingleCount])
        reduceArray.append([awayCount, awaySingleCount])
        
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
            let forCount = partCount <= 2 ? (rd.firstObject as! Int) + 1 : rd.count
            for var i = 0; i < forCount; i++ {
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
