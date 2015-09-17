//
//  SingleChoiceViewController.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/04.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h> //ボタン効果音用
#import "SingleDetailsViewController.h" //条件指定画面
#import "ControllDataBase.h" //DB操作
#import "AppDelegate.h" //組み合わせデータをAppDelegateから取得するため

@interface SingleChoiceViewController : UIViewController<UIScrollViewDelegate, UIAlertViewDelegate>

@end
