//
//  newRootViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/03.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class newRootViewController: UIViewController
{
    var abnomalFlg = false //何かしらの異常がある場合は次画面への遷移を抑制する
    var abnomalMessage = "" //何かしらの異常がある場合に次画面遷移を試みた場合に表示するメッセージ
    var appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)//通信とDB失敗データの取得と各種データの格納用
    var fontSizeDispatch: Int32 = ManyNum.ZERO //機種別フォントサイズ
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //背景色は黄色
        view.backgroundColor = UIColor.yellowColor()
        
        //機種を画面サイズ幅で制御 4シリーズと5シリーズは320.0、6は375.0、6+は414.0　※6sシリーズを考慮すっぺ
        if RectMaker.width() <= DisplaySize.FOUR_WIDTH {
            if RectMaker.height() <= DisplaySize.FIVE_HEIGHT {
                fontSizeDispatch = FontSize.FOUR_FONT
            } else {
                fontSizeDispatch = FontSize.FIVE_FONT
            }
        } else if RectMaker.width() >= DisplaySize.SIX_WIDTH && DisplaySize.SIXPLUS_WIDTH > RectMaker.width() {
            fontSizeDispatch = FontSize.SIX_FONT
        } else {
            fontSizeDispatch = FontSize.SIXPLUS_FONT
        }
        
        //ロゴ
        let logo = UIImageView.init(frame: RectMaker.logoRect())
        logo.image = UIImage(named: FILE_NAME.LOGO)
        view.addSubview(logo)
        
        //ボタン
        let singleBtn = makeButton("シングル選択", frame: RectMaker.singleBtnRect(), tag: TAG.SINGLE, color: UIColor.blackColor())
        let multiBtn = makeButton("マルチ選択", frame: RectMaker.multiBtnRect(), tag: TAG.MULTI, color: UIColor.blackColor())
        let confirmBtn = makeButton("支持率確認", frame: RectMaker.confirmBtnRect(), tag: TAG.CONFIRM, color: UIColor.blueColor())
        let reloadBtn = makeButton("データ再取得", frame: RectMaker.reloadBtnRect(), tag: TAG.RELOAD, color: UIColor.redColor())
        view.addSubview(singleBtn)
        view.addSubview(multiBtn)
        view.addSubview(confirmBtn)
        view.addSubview(reloadBtn)
        
        //appDelegateにフォントサイズを格納
        appDelegate.fontSize = fontSizeDispatch
    }
    
    
    //画面描画処理が終わったらこっちで色々処理
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //appdelegateで通信かDB作成が失敗してたら終了
        if appDelegate.abnomalFlg {
            alertDisplay(appDelegate.abnomalMessage)
            abnomalFlg = true;
            abnomalMessage = appDelegate.abnomalMessage;
            return
        }
        
        //初回起動時以外はデータ取得しない ※強制再取得は別
        if appDelegate.bootFlg { return }
        
        //データ再取得ボタン設置のため、取得処理を切り出した
        fetchProcess()
    }
    
    //データ再取得ボタン設置のため、取得処理を切り出したメソッド
    func fetchProcess() {
        //データ取得中はインジケータ回し始める
        SVProgressHUD.showWithStatus(MESSAGE_STR.DATA_GETING, maskType: .Black)
        
        //DBインスタンス生成
        let dbControll = ControllDataBase()
        
        //開催データの取得判断
        if !dbControll.kaisaiDataCheck() {
            let kaisaiData = GetKaisu()
            kaisaiData.returnSourceString(URL_STR.KAISAI_URL)
            _ = GetTeamNames()  //結果が不要な場合は「_ = 」をつける　気持ち悪い
        }
        
        //支持率データの取得判断
        if let judgeData = dbControll.rateUpdateJudge() {
            let toto = GetRateToto()
            toto.parseRate(judgeData)
        }
        
        //別スレッドで各データの取得処理を行う
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            //3秒スリープ
            NSThread.sleepForTimeInterval(ManyNum.SLEEP)
            
            //現在開催中のtoto有無判断（開催中じゃなかったらメッセージ表示して終了）
            var abnomalCount = ManyNum.ZERO
            
            while true {
                if dbControll.kaisuDataCountCheck() != ManyNum.ZERO && dbControll.abbNameDataCountCheck() >= 50 { //少なくともabbnameテーブルの件数が50件以上あるかどうか？（J1+J2+J3だと50は上回る）
                    NSThread.sleepForTimeInterval(ManyNum.SLEEP)
                    if dbControll.returnKaisaiYesNo() == ManyNum.ZERO {
                        //クロージャの外側メソッドを呼ぶのでselfを付与
                        self.alertDisplay(MESSAGE_STR.NOT_KAISAI_MESSAGE)
                        self.abnomalFlg = true
                        self.abnomalMessage = MESSAGE_STR.NOT_KAISAI_MESSAGE
                        //インジケータ終了
                        SVProgressHUD.showSuccessWithStatus("")
                        return
                    }
                    break
                }
                abnomalCount++
                //ループが１万回まわっても終わらなかったら異常として終了させる
                if abnomalCount > ManyNum.ROOP_AN_COUNT {
                    //クロージャの外側メソッドを呼ぶのでselfを付与
                    self.alertDisplay(MESSAGE_STR.ROOP_AN_MESSAGE1)
                    self.abnomalFlg = true
                    self.abnomalMessage = MESSAGE_STR.ROOP_AN_MESSAGE1
                    //インジケータ終了
                    SVProgressHUD.showSuccessWithStatus("")
                    return
                }
            }
            
            //DBにデータがある状態(13枠分のデータ)で以降の処理が必要なのでチェックロジックでループ
            abnomalCount = ManyNum.ZERO
            while true {
                if let kaisu = dbControll.returnKaisaiNow() {
                    if dbControll.drewCheck(kaisu) == ManyNum.WAKU_COUNT {
                        //現在開催回数だけはわざわざ変数宣言して格納する必要がないようにここで格納しとく
                        self.appDelegate.kaisu = kaisu
                        break
                    }
                }
                abnomalCount++
                //ループが１万回まわっても終わらなかったら異常として終了させる
                if abnomalCount > ManyNum.ROOP_AN_COUNT {
                    //クロージャの外側メソッドを呼ぶのでselfを付与
                    self.alertDisplay(MESSAGE_STR.ROOP_AN_MESSAGE2)
                    self.abnomalFlg = true
                    self.abnomalMessage = MESSAGE_STR.ROOP_AN_MESSAGE2
                    //インジケータ終了
                    SVProgressHUD.showSuccessWithStatus("")
                    return
                }
                
            }
            
            //DBから現在開催回を取得してそれをキーに組み合わせデータ取得　※戻り値データはホームチーム１３チームの後にアウェイチーム１３チームの系２６オブジェクト
            self.appDelegate.teamArray = dbControll.returnKumiawase()
            
            //DBから現在開催回を取得してそれをキーに組み合わせtoto支持率データ取得　枠順(ホーム、ドロー、アウェイ)の３９オブジェクト
            self.appDelegate.rateArrayToto = dbControll.returnRate(ODDS.TOTO)
            
            //DBから現在開催回を取得してそれをキーに組み合わせbODDS支持率データ取得　※まだデータがない時は「--.--」が返ってくる
            self.appDelegate.rateArrayBook = dbControll.returnRate(ODDS.BOOK)
            
            //起動フラグをYESにする
            self.appDelegate.bootFlg = true
            
            //メインスレッドに処理を戻す
            dispatch_async(dispatch_get_main_queue(), {
                
                //インジケータ終了
                SVProgressHUD.showSuccessWithStatus(MESSAGE_STR.DATA_GETED)
                
                //現在の回数と販売終了日を表示してあげようかね？
                let kaisuLabel = UILabel(frame: RectMaker.kaisuLabelRect())
                kaisuLabel.backgroundColor = UIColor.clearColor()
                kaisuLabel.textColor = UIColor.blackColor()
                kaisuLabel.numberOfLines = 2
                kaisuLabel.textAlignment = .Center
                kaisuLabel.text = "対象回：第\((self.appDelegate.kaisu as NSString).substringFromIndex(1))回 toto\n\(dbControll.returnSaleEndDate())"
                kaisuLabel.font = UIFont.systemFontOfSize(CGFloat(self.fontSizeDispatch - FontSize.SYSTEMSIZE))
                self.view.addSubview(kaisuLabel)
            })
        })
    }

    //ボタン生成メソッド
    func makeButton(title: String, frame: CGRect, tag: Int, color: UIColor) -> UIButton
    {
        let btn = UIButton(frame: frame)
        btn.tag = tag
        btn.setTitleColor(color, forState: .Normal)
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: "btnPush:", forControlEvents: .TouchUpInside)
        btn.titleLabel?.font = UIFont.systemFontOfSize(CGFloat(fontSizeDispatch + FontSize.FOUR_FONT))
        
        //縁取り
        btn.layer.borderColor = color.CGColor
        btn.layer.borderWidth = DisplaySize.BOARD_WITH
        
        return btn
    }
    
    //ボタンプッシュアクションメソッド
    func btnPush(button: UIButton) {
        //異常発生時は警告表示で画面遷移しない
        if abnomalFlg {
            alertDisplay(abnomalMessage)
            return
        }
        
        //それぞれの画面に遷移かデータ再取得
        var ngcl: UINavigationController!
        if button.tag == TAG.SINGLE {
            let scvc = SingleChoiceViewController()
            ngcl = UINavigationController(rootViewController: scvc)
        } else if button.tag == TAG.MULTI {
            let mcvc = MultiChoiceViewController()
            ngcl = UINavigationController(rootViewController: mcvc)
        } else if button.tag == TAG.CONFIRM {
            let rcvc = RateConfirmViewController()
            rcvc.modalTransitionStyle = .FlipHorizontal
            ngcl = UINavigationController(rootViewController: rcvc)
        } else if button.tag == TAG.RELOAD {
            //DBインスタンス生成してkaisuテーブル、kumiawaseテーブルのデータ削除
            let dbControll = ControllDataBase()
            dbControll.deleteTables()
            
            //データを再取得
            fetchProcess()
            
            //画面遷移はなし
            return
        }
        
        self.presentViewController(ngcl, animated: true, completion: nil)
    }
    
    //アラートメッセージ表示メソッド
    func alertDisplay(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
}
