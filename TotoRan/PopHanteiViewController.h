//
//  PopupViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/28.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllDataBase.h" //支持率取得日時を知る為
#import "AppDelegate.h" 

@interface PopHanteiViewController : UIViewController

//判定用の元データ
@property (strong,nonatomic) NSArray *hanteiDataArray;

//0の数、toto判定種別の英字、book判定種別の英字が入ってる２次元Array
@property (strong, nonatomic) NSArray *checkArray;

//上記のArrayに対応するBOOL値が入ってるArray
@property (strong, nonatomic) NSArray *checkBoolArray;

@end
