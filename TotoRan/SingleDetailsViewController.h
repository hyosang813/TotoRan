//
//  SingleDetailsViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/01.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleResultViewController.h"
#import "GetRandomSingle.h" //ランダムロジッククラス
#import "HanteiLogic.h" //判定ロジッククラス
#import "AppDelegate.h" //現在回数と起動時回数比較用
#import "ControllDataBase.h" //現在回数と起動時回数比較用

@interface SingleDetailsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

//Uibuttonの二次元Array受け取り用
@property (strong, nonatomic) NSArray *buttonArray;

@end
