//
//  SingleDetailsViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/09.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class SingleDetailsViewController: DetailsViewController
{
    //「以上」ラベルのRect情報Array
    let labelRectIJ: [CGRect] = [RectMaker.homeILRect(), RectMaker.drawILRect(), RectMaker.awayILRect()]
    
    //前画面から渡される親Array
    var arrayParent: [Int] = []
    
    //init
    override func setup() {
        labelText = ["■「ホーム,ドロー,アウェイ」の数", "・「ホーム」の数", "・「ドロー」の数", "・「アウェイ」の数", "■口数"]
        labelRect = [RectMaker.titleLabelRect(), RectMaker.homeLabelRect(), RectMaker.drawLabelRect(), RectMaker.awayLabelRect(), RectMaker.unitLabelRect()]
        textRect = [RectMaker.homeTextRect(), RectMaker.drawTextRect(), RectMaker.awayTextRect(), RectMaker.unitTextRect()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "シングル条件指定"
        
        //シングルは以上ラベルをさらに配置
        makeLabel(RectMaker.homeILRect(), text: "以上", tag: TAG.HOME_I)
        makeLabel(RectMaker.drawILRect(), text: "以上", tag: TAG.DRAW_I)
        makeLabel(RectMaker.awayILRect(), text: "以上", tag: TAG.AWAY_I)
        makeLabel(RectMaker.unitNLRect(), text: "口", tag: 999)
    }
    
    //次画面への遷移
    override func push() {
        super.push()
        
        //選択合計数字が「１３以上」だったら警告
        if Int(textArray[0].text!)! + Int(textArray[1].text!)! + Int(textArray[2].text!)! > Int(ManyNum.WAKU_COUNT) {
            alertDisplay(MESSAGE_STR.OVER_THIRTEEN)
            return
        }
        
        //そりゃオール１やオール２やオール０も判定したいべよ
//        //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１３で全部同じ結果」
//        if Int(textArray[0].text!)! == Int(ManyNum.WAKU_COUNT) || Int(textArray[1].text!)! == Int(ManyNum.WAKU_COUNT) || Int(textArray[2].text!)! == Int(ManyNum.WAKU_COUNT) {
//            alertDisplay(MESSAGE_STR.ALL_IS_NONRANDOM)
//            return
//        }
        
        //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１３で口数が２以上」
        if Int(textArray[0].text!)! + Int(textArray[1].text!)! + Int(textArray[2].text!)! == Int(ManyNum.WAKU_COUNT) && Int(textArray[3].text!)! > 1 {
            alertDisplay(MESSAGE_STR.THIRTEEN_FOR_ONE)
            return
        }
        
        //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１２で口数が４以上」
        if Int(textArray[0].text!)! + Int(textArray[1].text!)! + Int(textArray[2].text!)! == Int(ManyNum.WAKU_COUNT - 1) && Int(textArray[3].text!)! > 3 {
            alertDisplay(MESSAGE_STR.TWENTY_FOR_TWO)
            return
        }
        
        //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１１で口数が１０」
        if Int(textArray[0].text!)! + Int(textArray[1].text!)! + Int(textArray[2].text!)! == Int(ManyNum.WAKU_COUNT - 2) && Int(textArray[3].text!)! > 9 {
            alertDisplay(MESSAGE_STR.ELEVEN_FOR_THREE)
            return
        }
        
        //前画面でタップされたそれぞれの数と現時点のピッカー選択値をArrayに格納
        var tapCountArray: [String] = []
        var pickChooseArray: [String] = []
        var nonTapCount = ManyNum.WAKU_COUNT
        var nonChooseCount = ManyNum.WAKU_COUNT
        
        for var i = 0; i < 3; i++ {
            let tapData = pickerItemArray[i][0]
            let pickData = textArray[i].text
            tapCountArray.append(tapData)
            pickChooseArray.append(pickData!)
            nonTapCount -= Int(tapData)!
            nonChooseCount -= Int(pickData!)!
        }
        //それぞれに非選択数も格納
        tapCountArray.append(String(nonTapCount))
        pickChooseArray.append(String(nonChooseCount))
        
        //ランダムロジックをかます
        let grs = GetRandomSingle()
        let randomArray = grs.returnRandomValue(
            NSMutableArray(array: arrayParent),
            tapCountArray: tapCountArray as [AnyObject],
            pickerCountArray: pickChooseArray as [AnyObject],
            unitNum: Int32((textArray.last?.text)!)!
        )

        //判定ロジッククラスをnew
        let ht = HanteiLogic()
        
        //結果表示画面(シングル)をnew
        let srvc = SingleResultViewController()
        
        //SwiftのArray型であるrondomArrayをNSMutableArrayに変換して判定ロジックをかまし、帰ってくるNSMutableArrayデータをNSArrayを仲介して[[AnyObject]]?型に変換
        let hanteiDataRaw = ht.returnHantei(NSMutableArray(array: randomArray)) as NSArray as? [[AnyObject]]
        
        //判定ロジッククラスからの戻り値を結果表示画面に送る
        srvc.hanteiDataArray = hanteiDataRaw!
        
        //画面遷移
        navigationController?.pushViewController(srvc, animated: true)
    }
    
    //画面遷移した時点で１３枠すべてわかってたら「以上」をhiddenにしなきゃね　ジョークって言われたからこれも考慮しなきゃね
    override func viewWillAppear(animated: Bool) {
        hiddenCheck()
    }
    
    //上を考慮して以上ラベルのhiddenチェックをぴっかデリゲートメソッドから切り出し
    func hiddenCheck() {
        //合計数が13以上だった場合は「以上」ラベルをhidden
        var maxVal = 0
        for var i = 0; i < textArray.count - 1; i++ {
            maxVal += Int(textArray[i].text!)!
        }
        ijouLabelHidden(maxVal)
    }
    
//以下はピッカービューのデリゲートメソッド(override分のみ)
    
    //選択値をテキストフィールドにセット
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
        hiddenCheck()
    }
    
    //合計数が13以上だった場合は「以上」ラベルをhiddenするメソッド
    func ijouLabelHidden(maxVal: Int) {
        let homeILabel = view.viewWithTag(TAG.HOME_I)
        let drawILabel = view.viewWithTag(TAG.DRAW_I)
        let awayILabel = view.viewWithTag(TAG.AWAY_I)
        
        if maxVal < Int(ManyNum.WAKU_COUNT) {
            homeILabel?.hidden = false
            drawILabel?.hidden = false
            awayILabel?.hidden = false
        } else {
            homeILabel?.hidden = true
            drawILabel?.hidden = true
            awayILabel?.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
