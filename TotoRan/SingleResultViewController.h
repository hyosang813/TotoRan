//
//  SingleResultViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControllDataBase.h" //支持率取得日時を知る為
#import "AppDelegate.h"
#import "NADView.h" //NEND

@interface SingleResultViewController : UIViewController<NADViewDelegate>

//判定データの二次元Array受け取り用
@property (strong, nonatomic) NSArray *hanteiDataArray;

@end
