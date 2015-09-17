//
//  AppDelegate.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/19.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h" //通信状態確認用
#import "ControllDataBase.h"  //DB操作クラス
#import "GetKaisu.h" //開催回取得クラス
#import "GetRateToto.h" //Toto支持率取得クラス


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *teamArray; //組み合わせチーム情報
@property (strong, nonatomic) NSArray *rateArrayToto; //toto支持率情報
@property (strong, nonatomic) NSArray *rateArrayBook; //bODDS支持率情報
@property (strong, nonatomic) NSString *kaisu; //起動時の回数文字列情報
@property (strong, nonatomic) NSString *abnomalMessage; //通信とDB作成失敗メッセージ
@property (nonatomic) BOOL abnomalFlg; //通信とDB作成失敗判断フラグ
@property (nonatomic) BOOL bootFlg; //起動判断フラグ
@property (nonatomic) int fontSize; //画面サイズ別フォントサイズ
@end

