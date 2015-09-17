//
//  MultiResultViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h" //組み合わせチームデータ取得用
#import "UIViewController+MJPopupViewController.h" //ポップアップ用
#import "PopHanteiViewController.h" //ポップアップ判定用
#import "PopReducViewController.h" //ポップアップ削減用
#import "NADView.h" //NEND

@interface MultiResultViewController : UIViewController<NADViewDelegate>

//判定データの二次元Array受け取り用
@property (strong, nonatomic) NSArray *hanteiDataArray;

//ランダムデータの二次元Array受け取り用
@property (strong, nonatomic) NSArray *randomArray;

//削減機能の元データ二次元Array受け渡し用
@property (strong, nonatomic) NSMutableArray *reductArray;

//削減機能の元データに対応するBOOL値格納用の二次元Array
@property (strong, nonatomic) NSMutableArray *reductBoolArray;

@end
