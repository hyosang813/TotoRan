//
//  GetRateToto.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "GetRateToto.h"

#define PERCENT_LOC 5
#define TOTO 0
#define URLSTRING @"http://www.toto-dream.com/dci/I/IPC/IPC01.do?op=initVoteRate&holdCntId=%@&commodityId=01"

enum {ZERO, ONE, TWO, THREE, FOUR, SIX = 6, MAX = 39};

@implementation GetRateToto
{
    NSMutableData *receivedData; //html取得データ
    NSString *htmlString;
    NSString *kaiNum;
}

//初期化メソッド
- (instancetype)init
{
    self = [super init];
    if (self) {
        receivedData = [NSMutableData new];
        kaiNum = nil;
    }
    return self;
}


- (void)parseRate:(NSString *)kaisu;
{
    kaiNum = kaisu;
    NSString *urlString = [NSString stringWithFormat:URLSTRING, kaisu];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        //NSLog(@"Connection error");
    }
}

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

    //tdタグで絞り込み
    NSArray *tdNodes = [bodyNode findChildTags:@"td"];
    
    //DBに登録させるデータ格納Arrayに最初は開催回数を格納
    NSMutableArray *sendData = [NSMutableArray array];
    [sendData addObject:kaiNum];
    
    for (HTMLNode *tdNode in tdNodes) {
        if ([[tdNode getAttributeNamed:@"width"] isEqualToString:@"135"]) {
            
            //まずは前後トリム
            NSString *tmpData = [[tdNode contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //「%」の位置を把握
            NSRange persentLoc = [tmpData rangeOfString:@"%"];
            tmpData = [tmpData substringWithRange:NSMakeRange(persentLoc.location - PERCENT_LOC, PERCENT_LOC)];
            
            //「（」が最初にあったら取り除いてあげる処理が必要(一桁支持率処理)
            if ([[tmpData substringToIndex:ONE] isEqualToString:@"（"]) tmpData = [tmpData substringWithRange:NSMakeRange(ONE, FOUR)];
            
            //パーセントの値を格納
            [sendData addObject:tmpData];
        }
    }

    //DBへ登録
    ControllDataBase *db = [ControllDataBase new];
    if (![db updateShijiRate:sendData type:TOTO]) {
        //登録エラー処理が必要　NOが帰ってきたら？？
        
    }
    
    //bODDDSを取得しにいきまーす
    GetRateBook *bODDS = [GetRateBook new];
    [bODDS parseRate:kaiNum];
}

//エラー時
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"URL CONNECT ERROR!! (%@)", NSStringFromClass([self class]));
}

@end
