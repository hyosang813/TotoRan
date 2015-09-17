//
//  HanteiLogic.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/18.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h" //支持率データをAppDelegateから取得するため

@interface HanteiLogic : NSObject

//口数×102の羅列(13個:NSNumber)の２次元配列が引数で、戻り値はそれに判定結果をつけたもの
- (NSMutableArray *)returnHantei:(NSMutableArray *)returnArray;

@end
