//
//  MultiChoiceViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/07.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class MultiChoiceViewController: ChoiceViewController
{
    //init
    override func setup() {
        //ボタン類のベースカラーを指定
        baseColor = UIColor.redColor()
        
        //pngファイルを指定
        pngFile = UIImage(named: FILE_NAME.MULTI_PNG)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //画面タイトルを設定
        self.title = "マルチ選択"
    }
    
    //次画面への遷移
    override func push() {
        
        //次の画面に渡すダブルの数とトリプルの数、それにプチ削減のためドロー(ゼロ)の数をカウント
        var doubleCount = 0
        var tripleCount = 0

        
        //次画面へボタンの選択状態を渡す２次元Arrayを作成
        var arrayParent: [[Int]] = []
        var tag = CHOICE.TAG_BASE
        for var i = 0; i < 13; i++ {
            var arrayChild: [Int] = []
            var typeCount = 0
            for var j = 0; j < 3; j++ {
                let target = view.viewWithTag(tag) as! UIButton
                if target.selected {
                    switch j {
                    case 0:
                        arrayChild.append(1)
                    case 1:
                        arrayChild.append(0)
                    case 2:
                        arrayChild.append(2)
                    default: break
                    }
                    typeCount++
                } else {
                    arrayChild.append(9) //前のバージョンではここでNSnullを格納してたけど、nilは扱いたくないから「9」にしたので次画面での対応が必要!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                }
                tag = tag + 100
            }
            if typeCount == 2 {
                doubleCount++
            } else if typeCount == 3 {
                tripleCount++
            }
            arrayChild.append(typeCount)
            arrayParent.append(arrayChild)
            tag = tag - 299
        }
        
        //ダブル数とトリプル数の生合成チェック
        if doubleTripleCheck(doubleCount, tripleCount: tripleCount) {
            alertDisplay(MESSAGE_STR.DT_CHECK)
            return
        }
        
        //次画面へ遷移
        let mdvc = MultiDetailsViewController()
        mdvc.hidesBottomBarWhenPushed = true
        
        //3×13のInt(1 or 0 or 2 or 9)の二次元配列
        mdvc.arrayParent = arrayParent
        
        //ダブルとトリプルそれぞれのピッカーに表示する数列文字列の２次元配列
        mdvc.pickerItemArray = [itemSet(doubleCount, max: ManyNum.DOUBLE_MAX), itemSet(tripleCount, max: ManyNum.TRIPLE_MAX)]
        
        navigationController?.pushViewController(mdvc, animated: true)
    }
    
    //ダブル数とトリプル数の生合成チェック　マルチのみのメソッド アウトの場合は「true」を返す
    func doubleTripleCheck(doubleCount: Int, tripleCount: Int) -> Bool {
        if doubleCount > 8 { return true } //wは最高8個まで
        if tripleCount > 5 { return true } //tは最高5個まで
        if doubleCount == 0 && tripleCount > 5 { return true } //wが0の時はtは5まで
        if doubleCount == 1 && tripleCount > 5 { return true } //wが1の時はtは5まで
        if doubleCount == 2 && tripleCount > 4 { return true } //wが2の時はtは4まで
        if doubleCount == 3 && tripleCount > 3 { return true } //wが3の時はtは3まで
        if doubleCount == 4 && tripleCount > 3 { return true } //wが4の時はtは3まで
        if doubleCount == 5 && tripleCount > 2 { return true } //wが5の時はtは2まで
        if doubleCount == 6 && tripleCount > 1 { return true } //wが6の時はtは1まで
        if doubleCount == 7 && tripleCount > 1 { return true } //wが7の時はtは1まで
        if doubleCount == 8 && tripleCount > 0 { return true } //wが8の時はtは0まで
        return false
    }
 }
