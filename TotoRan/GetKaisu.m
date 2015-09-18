//
//  GetKaisu.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "GetKaisu.h"

#define FOUR 4
#define SCHELENGTH 15
#define SCHESTRING @"/toto/schedule/"

@implementation GetKaisu
{
    NSMutableData *receivedData; //html取得データ
    NSString *htmlString;
}

//初期化メソッド
- (instancetype)init
{
    self = [super init];
    if (self) {
        receivedData = [NSMutableData new];
    }
    return self;
}


- (void)returnSourceString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (!connection) {
        //NSLog(@"Connection error");
    }
}

/*
 URLConnection系のクラスに分けようか？
 URLを引数にするとNSStringのソースを返すクラス
 引数に開催回数を与えるとか、ソースは解析済みのNSStringを返すとかの機能をつけるかどうかは要検討
 */

#pragma mark - URLConnection系のデリゲートメソッド
//Connection成功時
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //html取得データ格納インスタンス変数の初期化
    receivedData = [NSMutableData new];
}

//データを受信する度に呼び出される　※受信データは完全な形ではなく断片で届くため、このメソッド内で適切にデータを保持し結合する必要がある
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

//データ受信完全終了時
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    htmlString = [[NSString alloc] initWithBytes:receivedData.bytes length:receivedData.length encoding:NSUTF8StringEncoding];

    //パース処理の下準備
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) {
        //NSLog(@"Error: %@", error);
        return;
    }
    
    //パース開始
    HTMLNode *bodyNode = [parser body];
    NSArray *aNodes = [bodyNode findChildTags:@"a"];
    
    //抽出した「回数」を格納するArray
    NSMutableArray *kaisu = [NSMutableArray new];
    
    //条件に合致したら回数を抽出してArrayに格納
    for (HTMLNode *node in aNodes) {
        NSString *tmpText = [node getAttributeNamed:@"href"];
        if ([tmpText hasPrefix:SCHESTRING] && tmpText.length > SCHELENGTH) {
            [kaisu addObject:[tmpText substringWithRange:NSMakeRange(SCHELENGTH, FOUR)]];
        }
    }
    
    //重複排除とソート
    NSSet *tmpSet = [NSSet setWithArray:kaisu];
    NSArray *sendArray = [tmpSet allObjects];
    sendArray = [sendArray sortedArrayUsingSelector:@selector(compare:)];
    
    //開催回数ごとのデータ取得
    for (NSString *kaisu in sendArray) {
        GetKaisuDetail *detail = [GetKaisuDetail new];
        [detail parseDate:kaisu];
    }
}

//エラー時
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"URL CONNECT ERROR!! (%@)", NSStringFromClass([self class]));
}

@end
