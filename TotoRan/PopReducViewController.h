//
//  PopReducViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/31.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTCheckbox.h" //チェックボックス用外部クラス

@interface PopReducViewController : UIViewController

//0の数、toto判定種別の英字、book判定種別の英字が入ってる２次元Array
@property (strong, nonatomic) NSArray *checkArray;

//上記のArrayに対応するBOOL値が入ってるArray
@property (strong, nonatomic) NSArray *checkBoolArray;

@end
