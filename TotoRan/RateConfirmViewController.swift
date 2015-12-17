//
//  RateConfirmViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/17.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

//大元のViewController
class RateConfirmViewController: UIViewController {
    
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)//組み合わせ情報をAppDelegateから取得
    let titleString: [String] = ["支持率(toto)", "支持率(book)"] //タイトルArray
    var rateArray: [[[String]]] = [] //AppDelegateから取得するtoto支持率とbook支持率の3次元Array
    
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
        //表示に必要なArrayをAppdelegateから取得しとく
        rateArray.append(appDelegate.rateArrayToto as! [[String]])
        rateArray.append(appDelegate.rateArrayBook as! [[String]])
    }
    //initセクション　ここまで

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellowColor()

        //タイトル
        self.title = titleString.first
        
        //戻るボタン
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "goBack")
        
        //支持率取得日時ラベル
        let dbControll = ControllDataBase()
        let dateLabel = UILabel(frame: RectMaker.dateLabelRect())
        dateLabel.backgroundColor = UIColor.clearColor()
        dateLabel.textColor = UIColor.blackColor()
        dateLabel.textAlignment = .Center
        dateLabel.text = dbControll.returnGetRateTime()
        dateLabel.font = UIFont.systemFontOfSize(CGFloat(appDelegate.fontSize))
        view.addSubview(dateLabel)
        
        //セグメントコントロール
        let uiSegmentedControl: UISegmentedControl = UISegmentedControl(items: titleString as [AnyObject])
        uiSegmentedControl.frame = RectMaker.segRect()
        uiSegmentedControl.selectedSegmentIndex = 0
        uiSegmentedControl.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(uiSegmentedControl)
        
        //対戦リスト表示View
        let tlv = teamListView(frame: RectMaker.teamListRect(), teamNameArray: appDelegate.teamArray as! [String], fontSize: CGFloat(appDelegate.fontSize))
        tlv.backgroundColor = UIColor.whiteColor()
        view.addSubview(tlv)
        
        //支持率棒グラフ表示View 初期表示はtoto
        let rlv = rateListView(frame: RectMaker.rateViewRect(), rateArray: rateArray[0], fontSize: CGFloat(appDelegate.fontSize))
        rlv.backgroundColor = UIColor.whiteColor()
        rlv.tag = 777
        view.addSubview(rlv)
    }
    
    //セグメントコントロール選択時のアクション
    func segmentChanged(seg: UISegmentedControl){
        //もしbODDSデータがまだない場合はメッセージ表示して切り替え表示をしない
        if seg.selectedSegmentIndex == 1 && rateArray[1][0][0] == "--.--" {
            alertDisplay(MESSAGE_STR.NODATA_BOOK)
            seg.selectedSegmentIndex = 0 //totoに戻す
            return
        }
        
        //タイトルを変更
        self.title = titleString[seg.selectedSegmentIndex]
        
        //描画も変更
        let rateView = view.viewWithTag(777) as! rateListView
        rateView.rateArray = rateArray[seg.selectedSegmentIndex]
        rateView.setNeedsDisplay()
    }

    //ベース画面に戻る
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //アラートメッセージ表示メソッド
    func alertDisplay(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}