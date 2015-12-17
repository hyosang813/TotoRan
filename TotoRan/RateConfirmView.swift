//
//  RateConfirmView.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/17.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

//対戦カードを羅列するUIView
class teamListView: UIView
{
    var teamListArray: [[String]] = [] //親のビューコントローラから受け渡されるチーム名リストを格納する
    var fontSize: CGFloat! //AppDelegateに格納されているfontsizeより5pt少ない値をセットしてみる
    
    //init
    init(frame: CGRect, teamNameArray: [String], fontSize: CGFloat) {
        super.init(frame: frame)
        //こっちのインスタンス変数に入れる
        self.fontSize = fontSize - 5
        
        //処理しやすいように13×3の二次元配列にしよう
        teamListArray.append(Array(teamNameArray[0...12]))
        var vsString: [String] = []
        for _ in 0..<13 {
            vsString.append("vs")
        }
        teamListArray.append(vsString)
        teamListArray.append(Array(teamNameArray[13...25]))
    }
    
    //Storyboardから生成されたら呼ばれるからほっとこ
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    //init
    
    //描画
    override func drawRect(rect: CGRect) {
        
        //インクリメント単位数を取得
        let widthNum1 = rect.size.width / 7
        let widthNum2 = widthNum1 * 3
        let heightNum = rect.size.height / 13
        
        //箱のサイズを取得
        let nameRectSize = CGSizeMake(widthNum2, heightNum) //チーム名
        let vsRectSize = CGSizeMake(widthNum1, heightNum) //vs
        
        //箱の中で縦方向に中央寄せするプロパティがないからyの値を計算
        let boxMidY = (heightNum / 2) - fontSize / 2
        
        //箱のサイズ
        var boxWidth = nameRectSize.width
        var boxHeight = nameRectSize.height
        
        //こういう感じの使おうじゃねえの！！！！
        for i in 0..<3 {
            
            //箱のサイズを変える
            if i == 1 {
                boxWidth = vsRectSize.width
                boxHeight = vsRectSize.height
            } else {
                boxWidth = nameRectSize.width
                boxHeight = nameRectSize.height
            }
            
            //横の起点を変える
            var baseX: CGFloat = 0
            if i == 1 {
                baseX = widthNum2
            } else if i == 2 {
                baseX = widthNum2 + widthNum1
            }
            
            for j in 0..<13 {
                
                //縦の起点
                let baseY = heightNum * CGFloat(j)
                
                //箱
                let box = UIBezierPath(rect: CGRectMake(baseX, baseY, boxWidth, boxHeight))
                UIColor.blackColor().setStroke()
                box.lineWidth = 0.5
                box.stroke()
                
                //文字
                let para = NSMutableParagraphStyle()
                para.alignment = NSTextAlignment.Center
                let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(fontSize), NSParagraphStyleAttributeName:para]
                teamListArray[i][j].drawInRect(CGRectMake(baseX, baseY + boxMidY, boxWidth, boxHeight), withAttributes: attrs)
            }
        }
    }
}



//支持率を表示するUIView
class rateListView: UIView
{
    //ホーム、ドロー、アウェイの支持率が１３枠分入った2次元Array(toto or book)
    var rateArray :[[String]]!
    
    //フォントサイズ
    var fontSize: CGFloat!
    
    //init
    init(frame: CGRect, rateArray: [[String]], fontSize: CGFloat) {
        super.init(frame: frame)
        //こっちの変数に移しかえる
        self.rateArray = rateArray
        self.fontSize = fontSize - 5

    }
    
    //Storyboardから生成されたら呼ばれるからほっとこ
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    //init
    
    
    //描画
    override func drawRect(rect: CGRect) {
        
        //最初に全体を黒で囲う
        let all = UIBezierPath(rect: rect)
        UIColor.blackColor().setStroke()
        all.lineWidth = 1
        all.stroke()

        //インクリメント単位数を取得
        let heightNum = rect.size.height / 13 //13枠で支持率数(%)表示部分と棒グラフ部分があるから合計26個
        let heightNumHalf = heightNum / 2
        let rateWidth = rect.size.width //支持率数を書くところはViewの横幅いっぱい
        
        //箱の中で縦方向に中央寄せするプロパティがないからyの値を計算
        let boxMidY = (heightNumHalf / 2) - fontSize / 2
        
        //支持率グラフの色
        let graphColors = [UIColor.redColor(), UIColor.yellowColor(), UIColor.blueColor()]
        
        //13枠分ループ
        for i in 0..<13 {
        
            //縦の起点
            var baseY = heightNum * CGFloat(i)
            
            //支持率数の箱
            let box = UIBezierPath(rect: CGRectMake(0, baseY, rateWidth, heightNumHalf))
            UIColor.blackColor().setStroke()
            box.lineWidth = 0.5
            box.stroke()
            
            //どうせ使うし数値に変換しとこかね
            var floatRate: [CGFloat] = []
            for j in 0..<3 {
                floatRate.append(CGFloat((rateArray[i][j] as NSString).doubleValue))
            }
            
            //ホームとドローの位置を交換
            floatRate.insert(floatRate[1], atIndex: 0)
            floatRate.removeAtIndex(2)
            
            //支持率の文字列生成
            let rateString = "\(String(format: "%05.2f", Float(floatRate[0])))%        \(String(format: "%05.2f", Float(floatRate[1])))%        \(String(format: "%05.2f", Float(floatRate[2])))%"
            
            //支持率文字列の配置
            let para = NSMutableParagraphStyle()
            para.alignment = NSTextAlignment.Center
            let attrs = [NSFontAttributeName:UIFont.systemFontOfSize(fontSize), NSParagraphStyleAttributeName:para]
            rateString.drawInRect(CGRectMake(0, baseY + boxMidY, rateWidth, heightNumHalf), withAttributes: attrs)
            
            //縦の起点を半分増やす
            baseY += heightNumHalf
            
            //各レートをwidthに置き換える
            let rateWidthArray = floatRate.map({ ($0 * 0.01) * rateWidth })
            
            //横の起点は増やしていくから記憶変数用意
            var widthInc: CGFloat = 1.0
            for k in 0..<3 {
                //支持率数の箱
                let box = UIBezierPath(rect: CGRectMake(widthInc, baseY, rateWidthArray[k], heightNumHalf - 1))
                graphColors[k].setStroke()
                graphColors[k].setFill()
                box.lineWidth = 0.5
                box.stroke()
                box.fill()
                widthInc += rateWidthArray[k]
            }
        }
    }

}
