//
//  SingleChoiceViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/07.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class SingleChoiceViewController: ChoiceViewController
{
    //init
    override func setup() {
        //ボタン類のベースカラーを指定
        baseColor = UIColor.blueColor()
        
        //pngファイルを指定
        pngFile = UIImage(named: FILE_NAME.SINCLE_PNG)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面タイトルを設定
        self.title = "シングル選択"
    }
    
    //ボタン選択時の挙動　シングルのみ同一枠内で１つしか選択できないロジック追加
    override func toggle(button: UIButton) {
        //同一部分の処理は親クラスのメソッド機能を呼び出す
        super.toggle(button)
        
        //同一枠を識別するためのtag下２桁を抽出
        let tagSuffixString = (button.tag.description as NSString).substringFromIndex(1)
        let tagNum = Int(tagSuffixString)! + CHOICE.TAGMAXBASE
        
        //同一枠をループ指定
        for var i = tagNum; i < CHOICE.TAGMAX; i = i + CHOICE.TAGMAXBASE {
            //自分以外の同一枠を非選択状態にする
            if i != button.tag {
                let target = view.viewWithTag(i) as! UIButton
                target.selected = false
                target.setTitleColor(baseColor, forState: .Normal)
            }
        }
    }
    
    //次画面への遷移
    override func push() {
        //次画面へボタンの選択状態を渡す1次元Arrayを作成
        var arrayParent: [Int] = []
        var tag = CHOICE.TAG_BASE
        
        //１枠内で選択されてた場合はその値(1,0,2)を、選択されてなかった場合は「9」をセットする
        for var i = 0; i < 13; i++ {
            //１枠内の３つの数字を一時的に格納する
            var threeValArray: [Int] = []
            for var j = 0; j < 3; j++ {
                //ボタンを取得
                let target = view.viewWithTag(tag) as! UIButton
                var setTag = 9
                if target.selected {
                    let tagStr = String(tag)
                    setTag = Int(String(tagStr[tagStr.startIndex]))!
                    if setTag == 2 {
                        setTag = 0
                    } else if setTag == 3 {
                        setTag = 2
                    }
                }
                threeValArray.append(setTag)
                tag += 100
            }
            //9しかなければ9を、それ以外があればその値をarrayParentに格納
            threeValArray = NSOrderedSet(array: threeValArray).array as! [Int] //まずは重複削除
            arrayParent.append(threeValArray.sort(<).first!) //昇順ソートして最初の要素を格納
            tag -= 299
        }
        
        //非選択枠の数を取得
        let nonTapCount = arrayParent.filter({ (val: Int) -> Bool in return val == 9}).count
        
        
        //全て選択されてたらランダム処理は不要　ジョークアプリって言われちまったよ！！！！！www
//        if nonTapCount == 0 {
//            alertDisplay(MESSAGE_STR.ALL_SELECTED)
//            return
//        }
        
        //各選択枠の数を取得
        let homeCount = arrayParent.filter({ (val: Int) -> Bool in return val == 1}).count
        let drawCount = arrayParent.filter({ (val: Int) -> Bool in return val == 0}).count
        let awayCount = arrayParent.filter({ (val: Int) -> Bool in return val == 2}).count
        
        //口数のmax値を算出
        var unitMax = 10
        if nonTapCount == 0 {
            unitMax = 1
        } else if nonTapCount == 1 {
            unitMax = 3
        } else if nonTapCount == 2 {
            unitMax = 9
        }
        
        //詳細画面への遷移
        let sdvc = SingleDetailsViewController()
        sdvc.hidesBottomBarWhenPushed = true
        
        //13のInt(1 or 0 or 2 or 9)の一次元配列
        sdvc.arrayParent = arrayParent
        
        //ダブルとトリプルそれぞれのピッカーに表示する数列文字列の２次元配列
        sdvc.pickerItemArray = [
            itemSet(homeCount, max: arrayParent.count - (drawCount + awayCount)),
            itemSet(drawCount, max: arrayParent.count - (homeCount + awayCount)),
            itemSet(awayCount, max: arrayParent.count - (homeCount + drawCount)),
            itemSet(1, max: unitMax)
        ]

        navigationController?.pushViewController(sdvc, animated: true)
    }
}
