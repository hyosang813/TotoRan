//
//  GetTeamNameMapList.swift
//  TotoRan
//
//  Created by 大山 孝 on 2015/12/16.
//  Copyright © 2015年 raksam.com. All rights reserved.
//

import Foundation

class GetTeamNames: NSObject, NSURLConnectionDataDelegate
{
    var receiveData: NSMutableData = NSMutableData() //取得するrawデータ
    var receiveString: NSString = "" //rawデータをStringに変換して格納する
    var teamNameArray: [[String]] = [] //fullnameとabbnameがセットになったArray
    
    //初期化　このクラスをインスタンス化しただけで取得処理開始しようかね
    override init() {
        super.init()
        let request = NSURLRequest(URL: NSURL(string: URL_STR.TEAM_NAME_URL)!)
        let connection = NSURLConnection(request: request, delegate: self)
        
        if (connection == nil) {
            //NSLog(@"Connection error")
        }
    }
    
    //データを受信する度に呼び出される　※受信データは完全な形ではなく断片で届くため、このメソッド内で適切にデータを保持し結合する必要がある
    @objc func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        receiveData.appendData(data)
    }
    
    //データ受信完全終了時
    @objc func connectionDidFinishLoading(connection: NSURLConnection) {
        //取得したrawデータをString(html)に変換
        receiveString = NSString(bytes: receiveData.bytes, length: receiveData.length, encoding: NSUTF8StringEncoding)!
        
        //パース処理の下準備 エラー処理が面倒だから「try!」キーワード付与しちゃってる　本当はdo catchしてエラー処理が基本
        let parser = try! HTMLParser(string: receiveString as String)
        
        //パース開始
        let bodyNode = parser.body()
        
        //tdタグで絞り込み
        let tdNodes = bodyNode.findChildTags("td")
        
        //最終的にDB登録する2次元arrayにセット
        for var i = 0; i < tdNodes.count; i += 2 {
            teamNameArray.append([String(tdNodes[i].contents!!), String(tdNodes[i + 1].contents!!)]) //contentsはNSData?!型（二重Optional型）なので使用時に二重アンラップ(!!)してあげる必要あり
        }
        
        //DBに登録
        let dbControll = ControllDataBase()
        if dbControll.insertTeamName(teamNameArray) {
             //登録エラー処理が必要　NOが帰ってきたら？？
        }
    }
}