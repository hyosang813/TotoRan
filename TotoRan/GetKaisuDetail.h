//
//  GetKaisuDetail.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h" //html解析
#import "ControllDataBase.h" //DB操作クラス
#import "GetRateToto.h" //支持率取得クラス

@interface GetKaisuDetail : NSObject<NSURLConnectionDataDelegate> //htmlソースをデータで受け取る用のデリゲート

- (void)parseDate:(NSString *)kaisu;

@end
