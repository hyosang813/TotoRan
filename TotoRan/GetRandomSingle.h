//
//  GetRandomSingle.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/19.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetRandomSingle : NSObject

- (NSMutableArray *)returnRandomValue:(NSMutableArray *)tapArray tapCountArray:(NSMutableArray *)tapCountArray pickerCountArray:(NSMutableArray *)pickerCountArray unitNum:(int)unitNum;

@end
