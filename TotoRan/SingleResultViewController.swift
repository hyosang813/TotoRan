//
//  SingleResultViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/11.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class SingleResultViewController: ResultViewController
{
    
    //init
    override func setup() {
        partsArray = [["コピー", NSValue(CGRect: RectMaker.singleCopyButtonRect()), "dataCopy"]]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //画面タイトルを設定
        self.title = "シングル結果"
        
        //判定結果を表示する文字列を生成してテキストビューに表示
        resultView.text = HanteiStringMaker.resultHanteiString(hanteiDataArray)
    }

}
