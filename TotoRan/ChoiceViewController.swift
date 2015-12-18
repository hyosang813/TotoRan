//
//  ChoiceViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/07.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class ChoiceViewController: UIViewController, UIScrollViewDelegate {
    
    //効果音のグローバル変数
    var buttonSound: SystemSoundID = UInt32(ManyNum.ZERO) //SystemSoundIDは符号なし整数型
    var eraseButtonSound: SystemSoundID = UInt32(ManyNum.ZERO) //SystemSoundIDは符号なし整数型
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)//組み合わせ情報をAppDelegateから取得
    
    //ベースカラー
    var baseColor: UIColor?
    
    //pngファイル
    var pngFile: UIImage?
    
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
        baseColor = UIColor.clearColor()
        pngFile = UIImage()
    }
    //initセクション　ここまで
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ボタン効果音ファイル読み込み
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(FILE_NAME.BUTTON_PUSH, ofType: "mp3")!)
        AudioServicesCreateSystemSoundID(url, &buttonSound)
        
        //全消去ボタン効果音ファイル読み込み
        let eUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(FILE_NAME.ERASE, ofType: "wav")!)
        AudioServicesCreateSystemSoundID(eUrl, &eraseButtonSound)
        
        //詳細設定画面への遷移ボタンを生成　navigationBarの右側ボタン
        let pushButton = UIBarButtonItem(title: "条件指定", style: .Plain, target: self, action: "push")
        navigationItem.rightBarButtonItem = pushButton
        
        //戻るボタンをカスタマイズ
        let backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "goBack")
        navigationItem.leftBarButtonItem = backButton
        
        //スクロールビューをself.viewにセット
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.yellowColor()
        scrollView.frame = view.frame
        scrollView.contentSize = CGSizeMake(RectMaker.width(), CHOICE.SIXPLUS_HEIGHT)//6+の画面高さを基準にする
        scrollView.delegate = self
        view = scrollView
        
        //選択解除ボタンのy座標を格納する変数
        var clearY: CGFloat = CGFloat(ManyNum.ZERO)
        
        //ボタンのwidthを求める　「30」の内訳：左右の余白10×2、ボタン間隔5×2
        let buttonWidth = (RectMaker.width() - 30) / 3
        
        var tag = CHOICE.TAG_BASE
        var arrayCount = 0
        var xPoint = CHOICE.BASE_POINT
        var yPoint = CHOICE.BASE_POINT
        
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 13; j++ {
                if i == 1 {
                    makeButton(tag, rect: CGRectMake(xPoint, yPoint, buttonWidth, CHOICE.BUTTON_HEIGHT), teamName: "DRAW")
                } else {
                    makeButton(tag, rect: CGRectMake(xPoint, yPoint, buttonWidth, CHOICE.BUTTON_HEIGHT), teamName: String(appDelegate.teamArray[arrayCount]))
                    arrayCount++
                }
                yPoint = yPoint + CHOICE.BUTTON_HEIGHT + CHOICE.BUTTON_INTERVAL
                tag++
            }
            //選択解除ボタンのy座標基準値取得
            clearY = yPoint
            
            //x起点を次の列にずらすのと、y起点のリセット、あとタグの桁を増やす(101,201,301)
            xPoint = xPoint + buttonWidth + CHOICE.BUTTON_INTERVAL
            yPoint = CHOICE.BASE_POINT
            tag += CHOICE.TAG_INCREMENT
        }
        
        //選択解除ボタンを配置
        let clearButton = UIButton(frame: CGRectMake(RectMaker.width() / 2 - 100, clearY + 5, CHOICE.CLEAR_WIDTH, CHOICE.CLEAR_HEIGHT))
        clearButton.setTitle("選択解除", forState: .Normal)
        clearButton.setTitleColor(baseColor, forState: .Normal)
        clearButton.setBackgroundImage(UIImage(named: FILE_NAME.NOMAL_PNG), forState: .Normal)
        clearButton.setBackgroundImage(UIImage(named: FILE_NAME.NOMAL_PNG), forState: .Selected)
        clearButton.addTarget(self, action: "clear", forControlEvents: .TouchDown)
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(appDelegate.fontSize + 2))
        clearButton.tag = CHOICE.CLEARTAG
        
        //縁取り
        clearButton.layer.borderColor = baseColor!.CGColor
        clearButton.layer.borderWidth = 1.0
        
        //配置
        view.addSubview(clearButton)
    }
    
    //ボタン生成メソッド
    func makeButton(tag: Int, rect: CGRect, teamName: String){
        let button = UIButton(frame: rect)
        button.setTitle(teamName, forState: .Normal)
        button.setTitleColor(baseColor, forState: .Normal)
        button.setBackgroundImage(UIImage(named: FILE_NAME.NOMAL_PNG), forState: .Normal)
        button.setBackgroundImage(pngFile, forState: .Selected)
        button.tag = tag
        button.addTarget(self, action: "toggle:", forControlEvents: .TouchDown)
        button.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(appDelegate.fontSize + 2))
        
        //縁取り
        button.layer.borderColor = baseColor!.CGColor
        button.layer.borderWidth = 1.0
        
        //配置
        view.addSubview(button)
    }
    
    //ラジオボタン
    func toggle(button: UIButton) {
        //自分自身はトグル選択
        button.selected = !button.selected
        
        //トグルに合わせて文字色を変更
        if button.selected {
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            button.setTitleColor(baseColor, forState: .Normal)
        }
        
        //ボタン効果音
        AudioServicesPlaySystemSound(buttonSound)
    }
    
    //クリアボタン
    func clear() {

        var tag = CHOICE.TAG_BASE
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 13; j++ {
                let target = view.viewWithTag(tag) as! UIButton
                target.selected = false
                target.setTitleColor(baseColor, forState: .Normal)
                tag++
            }
            tag += CHOICE.TAG_INCREMENT
        }
        
        //ボタン効果音
        AudioServicesPlaySystemSound(eraseButtonSound)
    }
    
    //次画面への遷移
    func push() { /* 面倒だから丸々サブクラスに処理させちゃう */ }
    
    //ベース画面に戻る
    func goBack() {
        
        //選択されたボタンが１つもなければアラートなしで戻る
        var tag = CHOICE.TAG_BASE
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 13; j++ {
                let target = view.viewWithTag(tag) as! UIButton
                if target.selected {
                    alertDisplayYesNo(MESSAGE_STR.BASE_RERTURN)
                    return
                }
                tag++
            }
            tag += CHOICE.TAG_INCREMENT
        }
        backClicked()
    }
    
    //ピッカービューの表示文字列の配列セットメソッド
    func itemSet(initial: Int, max: Int) -> [String] {
        var array: [String] = []
        
        for var i = initial; i <= max; i++ {
            array.append(String(i))
        }
        
        return array
    }
    
    //標準アラートメッセージ表示メソッド
    func alertDisplay(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
