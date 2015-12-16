//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

//common
#import "AppDelegate.h" //AppDelegateクラス
#import "ControllDataBase.h"  //DB操作クラス

//newRootViewController.swift
#import "SVProgressHUD.h" //インジケータ用外部ライブラリ
#import "GetKaisu.h" //開催回取得クラス
#import "GetRateToto.h" //Toto支持率取得クラス

//SingleChoiceViewController.swift
#import <AudioToolbox/AudioToolbox.h> //ボタン効果音用

//DetailViewController.swift
#import "HanteiLogic.h"
#import "GetRandomMulti.h"
#import "GetRandomSingle.h"

//ResultViewContrller.swift
#import "UIViewController+MJPopupViewController.h" //ポップアップ用
#import "NADView.h" //NEND
#import "PopHanteiViewController.h" //ポップアップ判定用
#import "PopReducViewController.h" //ポップアップ削減用


