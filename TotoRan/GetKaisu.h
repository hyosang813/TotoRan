//
//  GetKaisu.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLParser.h" //html解析
#import "GetKaisuDetail.h" //回数詳細取得用クラス

@interface GetKaisu : NSObject<NSURLConnectionDataDelegate> //htmlソースをデータで受け取る用のデリゲート

- (void)returnSourceString:(NSString *)urlString; //ソース取得開始用メソッド

@end
