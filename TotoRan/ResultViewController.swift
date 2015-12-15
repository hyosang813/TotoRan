//
//  ResultViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/11.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, NADViewDelegate
{
    
    var hanteiDataArray:[[AnyObject]] = [] //判定データの二次元Array受け取り用
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate) //組み合わせ情報をAppDelegateから取得
    var resultView: UITextView! //結果表示テキストビュー implicitly unwrapped optional(!)を使ってみましょう
    var partsArray: [[AnyObject]]! //ボタンタイトル、ボタンRect、ターゲットセレクタをまとめる２次元配列
//        var buttonArray: [UIButton]! //ボタンの配列　シングルは１つでマルチは３つ
    
    //initセクション　UIViewControllerで引数なしinitを呼ぶには引数なしの方を convenience にして、そっちから指定イニシャライザを呼んでやる
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
    }
    //initセクション　ここまで


    override func viewDidLoad() {
        super.viewDidLoad()

        //下地は黄色
        view.backgroundColor = UIColor.yellowColor()
        
        //戻るボタン
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "goBack")
        
        //結果表示テキストビューの生成と配置
        resultView = UITextView(frame: RectMaker.textViewRect())
        resultView.editable = false
        resultView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0) //よくわからんが余白を消すためにインセット調整
        resultView.font = UIFont(name: "Courier", size: CGFloat(appDelegate.fontSize))
        resultView.layer.borderWidth = 2
        resultView.layer.borderColor = UIColor.blackColor().CGColor
        view.addSubview(resultView) //implicitly unwrapped optionalだからforced unwrapped「!」要らず
        
        //ボタンの生成と配置
        for var i = 0; i < partsArray.count; i++ {
            makeButton(partsArray[i][0] as! String, frame: (partsArray[i][1] as! NSValue).CGRectValue(), sel: Selector(partsArray[i][2] as! String))
        }
        
        //NEND配置
        let nadView = NADView(frame: RectMaker.nendRect(), isAdjustAdSize: true)
        nadView.isOutputLog = false
        nadView.setNendID(NENDKEY.SET_ID, spotID: NENDKEY.SPOT_ID)
        nadView.delegate = self
        nadView.load()
        view.addSubview(nadView)
        
        //以下はシングルとマルチそれぞれの処理
        
        //シングル
        //結果文字列に変換して、DBから現在開催回を取得してそれをキーに支持率取得日時の文字列を取得して結合（シングル）
        //    ※だけどマルチの判定ボタン押下時も結局同じロジックだからクラス化して部品にする？？？？？？？？？？？？？？？？？
        
        //マルチ
        //結果文字列に変換して表示
        //プチ削減用のデータ収集
    }
    
    //NENDデリゲートメソッド（エラー発生時）
    func nadViewDidFailToReceiveAd(adView: NADView!) {
        adView.hidden = true //NEND広告が何かしらのエラーになった場合は広告枠を表示しない
    }

    //ボタン生成メソッド
    func makeButton(title: String, frame: CGRect, sel: Selector) {
        let button = UIButton(frame: frame)
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        button.addTarget(self, action: sel, forControlEvents: .TouchUpInside)
        //縁取り
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 2.0
        button.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(appDelegate.fontSize + 4))
        view.addSubview(button)
    }
    
    //コピーボタン押下時のアクションメソッド
    func dataCopy() {
        //クリップボードにコピーしてアラートコントローラを表示
        presentViewController(DataCopy.copyAndAlert(resultView.text), animated: true, completion: nil)
    }
    
    //前画面への遷移
    func goBack() {
        alertDisplayYesNo(MESSAGE_STR.RETURN_MESSAGE)
    }
    
    //選択アラートメッセジ表示メソッド
    func alertDisplayYesNo(message: String) {
        let alertController = UIAlertController(title: "確認", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "いいえ", style: .Default, handler:nil))
        alertController.addAction(UIAlertAction(title: "はい", style: .Default, handler:{(action:UIAlertAction!) -> Void in self.backClicked()}))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //選択アラートで「はい」を押されたら前画面に戻る
    func backClicked() {
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
