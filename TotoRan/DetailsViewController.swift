//
//  DetailsViewController.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/09.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{    
    let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate) //組み合わせ情報をAppDelegateから取得
    var pickerItemArray: [[String]] = [] //前画面から渡されるダブルとトリプルそれぞれのピッカーアイテムArray
    var toolBarnum = 0 //直前に選択されたピッカー記憶用
    var labelText: [String] = [] //ラベルテキストArray
    var labelRect: [CGRect] = [] //ラベルのRect情報Array
    var textRect: [CGRect] = [] //テキストフィールドのRect情報Array
    var pickArray:[UIPickerView] = [] //ピッカービューのArray
    var textArray:[UITextField] = []  //テキストフィールドArray
    let pickerToolBar:UIToolbar = UIToolbar() //ツールバー
    
    
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
        
        //navigationBarのボタン
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "判定", style: .Plain, target: self, action: "push")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "戻る", style: .Plain, target: self, action: "goBack")
        
        //ラベル生成
        for var i = 0; i < labelText.count; i++ {
            makeLabel(labelRect[i], text: labelText[i], tag: 999)
        }
        
        //テキストフィールドとピッカービューの生成と配置
        for var i = 0; i < textRect.count; i++ {
            textArray.append(makeTextField(textRect[i], tag: TAG.HOME_T + i, initial: Int(pickerItemArray[i][0])!))
            pickArray.append(makePicker(TAG.HOME_P + i))
        }
        
        //ピッカービューの上にOKボタンのついたツールバーを配置
        pickerToolBar.frame = RectMaker.defaultTBRect()
        pickerToolBar.tintColor = UIColor.whiteColor()
        pickerToolBar.barStyle = .BlackTranslucent
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "閉じる", style: .Done, target: self, action: "hidePicker")
        pickerToolBar.setItems([space, done], animated: true)
        view.addSubview(pickerToolBar)

        //テキストフィールドのインプットIFをピッカービューにする
        for var i = 0; i < textArray.count; i++ {
            textArray[i].inputView = pickArray[i]
            textArray[i].inputAccessoryView = pickerToolBar
        }
    }
    
    //ラベル生成メソッド
    func makeLabel(labelRect: CGRect, text: String, tag: Int) {
        let label = UILabel(frame: labelRect)
        label.backgroundColor = UIColor.yellowColor()
        label.text = text
        label.tag = tag
        label.font = UIFont.systemFontOfSize(CGFloat(appDelegate.fontSize + Int32(3)))
        view.addSubview(label)
    }
    
    //テキストフィールド生成メソッド
    func makeTextField(textRect: CGRect, tag: Int, initial: Int) -> UITextField {
        let txtFld = UITextField(frame: textRect)
        txtFld.delegate = self
        txtFld.tag = tag
        txtFld.backgroundColor = UIColor.whiteColor()
        txtFld.textColor = UIColor.blackColor()
        txtFld.text = String(initial)
        txtFld.textAlignment = .Center
        txtFld.font = UIFont.systemFontOfSize(CGFloat(appDelegate.fontSize + Int32(3)))
        //縁取り
        txtFld.layer.borderColor = UIColor.blackColor().CGColor
        txtFld.layer.borderWidth = 2
        
        view.addSubview(txtFld)
        
        return txtFld
    }
    
    //ピッカービュー生成メソッド
    func makePicker(tag: Int) -> UIPickerView {
        let picker = UIPickerView(frame: RectMaker.defaultPKRect())
        picker.delegate = self
        picker.dataSource = self
        picker.tag = tag
        picker.showsSelectionIndicator = true
        picker.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(picker)
        
        return picker
    }
    
    //テキストフィールドをタップした時にキーボードを出さないで、代わりにピッカーを出すメソッド（textFieldのdelegateメソッド）
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        showPicker(textField.tag)
        return false
    }
    
    //タップされたテキストフィールドと対になるピッカーを表示
    func showPicker(tag: Int) {
        
        //直前に選択されたピッカーと違うピッカーが選択された時は一旦ツールバーをしまう
        if toolBarnum != tag {
            pickerToolBar.frame = RectMaker.defaultTBRect()
        }
        
        //直前に選択されたピッカーを記憶
        toolBarnum = tag
        
        //選択されたピッカーだけ表示してあとはしまう
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationDelegate(self)
        for pick in pickArray {
            pick.frame = pick.tag == tag + 100 ? RectMaker.enabledPKRect() : RectMaker.defaultPKRect()
        }
        pickerToolBar.frame = RectMaker.enabledTBRect()
        UIView.commitAnimations()
    }
    
    //全ピッカービューをしまう
    func hidePicker() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationDelegate(self)
        for pick in pickArray {
            pick.frame = RectMaker.defaultPKRect()
        }
        pickerToolBar.frame = RectMaker.defaultTBRect()
        UIView.commitAnimations()
    }
    
    //次画面への遷移
    func push() {
        
        //ピッカーをしまう
        hidePicker()
        
        //現在開催回数と起動時開催回数が違う場合は警告表示
        let dbControll = ControllDataBase()
        if appDelegate.kaisu != dbControll.returnKaisaiNow() {
            alertDisplay(MESSAGE_STR.BUY_EXPIERD)
            return
        }
    }
    
    //前画面への遷移
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //標準アラートメッセージ表示メソッド
    func alertDisplay(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }


//以下はピッカービューのデリゲートメソッド
    
    //行の高さ
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    //ドラム数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItemArray[pickerView.tag - 201].count
    }
    
    //各行のセル内容
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let cell = UIView(frame: RectMaker.cellRect())
        let label = UILabel(frame: RectMaker.cellRect())
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        label.text = pickerItemArray[pickerView.tag - 201][row]
        cell.addSubview(label)
        return cell
    }
    
    //選択値をテキストフィールドにセット
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textArray[pickerView.tag - 201].text = pickerItemArray[pickerView.tag - 201][row]
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}
