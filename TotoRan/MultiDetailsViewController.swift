//
//  MultiDetailsViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/09.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class MultiDetailsViewController: DetailsViewController
{
    //前画面から渡される親Array
    var arrayParent: [[Int]] = []
    
    //init
    override func setup() {
        labelText = ["■「ダブル,トリプル」の数", "・「ダブル」の数", "・「トリプル」の数"]
        labelRect = [RectMaker.titleLabelRect(), RectMaker.doubleLabelRect(), RectMaker.tripleLabelRect()]
        textRect = [RectMaker.doubleTextRect(), RectMaker.tripleTextRect()]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "マルチ条件指定"
    }

    //次画面への遷移
    override func push() {
        super.push()
        
        //ダブルトリプルの整合性チェック
        if doubleTripleCheck(Int(textArray[0].text!)!, tripleCount: Int(textArray[1].text!)!) {
            alertDisplay(MESSAGE_STR.DT_CHECK)
            return
        }
        
        //ランダムロジックをかます
        let grm = GetRandomMulti()
        var randomArray = grm.returnRandomValue( //この戻り値はAnyObjectで帰ってきてるからrandomArrayやhanteiArrayの中身を利用するときはキャストが必要かも？？？？？？？？？？？？？？？？？
            arrayParent,
            tapCountDouble: Int32(pickerItemArray[0][0])!,
            tapCounTriple: Int32(pickerItemArray[1][0])!,
            pickCountDouble: Int32(textArray[0].text!)!,
            pickCounTriple: Int32(textArray[1].text!)!
        )

        //判定ロジックをかますためにrandomArrayをコピーして「9」(ノータップの箇所、Obj−C版だとnil)を削除する
        var hanteiFactArray: [[Int]] = []
        var combiCount = 1
        for var i = 0; i < randomArray.count; i++ {
            let hanteiData = (randomArray[i] as! [Int]).filter({ (val: Int) -> Bool in return val != 9})
            hanteiFactArray.append(hanteiData)
            combiCount *= hanteiData.count
        }
        
        //判定用２次元配列生成ロジックの理解から始めよう！！！！！！！　　　　よくわからんから完成後にデバッグして動作確認する！！！！！！！！！！！！！！
        var hanteiArray: [[Int]] = []
        var p = 0, s = 0 // p:商, s:余り
        
        // (3) 組み合わせをcombiCount回求める（i：組み合わせ番号）
        for var i = 0; i < combiCount; i++ {
            var hanteiChildArray: [Int] = []
            
            //p(商)の初期値はiの値を与える
            p = i
            for var j = 0; j < hanteiFactArray.count; j++ {
                s = p % hanteiFactArray[j].count
                p = (p - s) / hanteiFactArray[j].count
                
                hanteiChildArray.append(hanteiFactArray[j][s])
            }
            hanteiArray.append(hanteiChildArray)
        }
        
        //判定ロジッククラスをnew
        let ht = HanteiLogic()
        
        //結果表示画面(マルチ)をnew
        let mrvc = MultiResultViewController()
        
        //SwiftのArray型であるrondomArrayをNSMutableArrayに変換して判定ロジックをかまし、帰ってくるNSMutableArrayデータをNSArrayを仲介して[[AnyObject]]?型に変換
        let hanteiDataRaw = ht.returnHantei(NSMutableArray(array: hanteiArray)) as NSArray as? [[AnyObject]]
        
        //判定ロジッククラスからの戻り値を結果表示画面に送る
        mrvc.hanteiDataArray = hanteiDataRaw!
        
        //ランダム抽出結果を結果表示画面に送る
        mrvc.randomArray = randomArray
        
        //画面遷移
        navigationController?.pushViewController(mrvc, animated: true)
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

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
