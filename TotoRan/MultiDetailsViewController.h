//
//  MultiDetailsViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/01.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiResultViewController.h"
#import "GetRandomMulti.h" //ランダムデータ生成
#import "HanteiLogic.h" //判定ロジックかます
#import "AppDelegate.h" //現在回数と起動時回数比較用
#import "ControllDataBase.h" //現在回数と起動時回数比較用

@interface MultiDetailsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

//Uibuttonの二次元Array受け取り用
@property (strong, nonatomic) NSArray *arrayParent;

//前画面から受け取るダブルとトリプルそれぞれの数
@property (nonatomic) int doubleCount; //ダブルの数
@property (nonatomic) int tripleCount; //トリプルの数
@property (nonatomic) int zeroCount;   //ドローを選択した数

@end
