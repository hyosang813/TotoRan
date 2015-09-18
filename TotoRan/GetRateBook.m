//
//  GetRateBook.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "GetRateBook.h"

#define DATANOTHING 45
#define BODDS 1
#define URLSTRING @"http://tobakushi.net/toto/tototimes/bg_%@.html"

enum {ZERO, ONE, TWO, THREE, SIX = 6, MAX = 39};

@implementation GetRateBook
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
    
    //こうすると参照による影響受けない「値コピー」になる
    NSString *tmpKaisu = [NSString stringWithString:kaisu];
    
    //回数は0が頭についてるが、賭博士のソースは０無しにしなきゃいけない。　めんどくせえ・・・
    if ([[tmpKaisu substringToIndex:1] isEqualToString:@"0"]) tmpKaisu = [tmpKaisu substringWithRange:NSMakeRange(ONE, THREE)];

    //URL通信開始
    NSString *urlString = [NSString stringWithFormat:URLSTRING, tmpKaisu];
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
    
    //DBに登録させるデータ格納Arrayを準備
    NSMutableArray *sendTmpData = [NSMutableArray array];
    
    
    for (HTMLNode *tdNode in tdNodes) {
        if ([[tdNode getAttributeNamed:@"class"] isEqualToString:@"ave"]) {
            //まずは前後トリム
            NSString *tmpData = [[tdNode contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //後ろの「%」を外す
            tmpData = [tmpData substringWithRange:NSMakeRange(ZERO, tmpData.length - ONE)];
            
            //パーセントの値を格納
            [sendTmpData addObject:tmpData];
        }
    }
    
    //DB登録データ用Array
    NSMutableArray *sendData = [NSMutableArray array];
    [sendData addObject:kaiNum];
    
    //bODDSデータがまだ賭博士上に無い場合は「0.0」を登録する仕様に変更（2015.09.04）
    if (sendTmpData.count < DATANOTHING) {
        for (int i = ZERO; i < MAX; i++) {
            [sendData addObject:@"0.0"];
        }
    } else {
        //totoの支持率データを省いてbODDSデータだけにする　「−3」は１４枠のデータが不要なため
        for (int i = ZERO; i < sendTmpData.count - THREE; i++) {
            //modが0,1,2はスルー、3,4,5は格納
            if (i % SIX > TWO) [sendData addObject:sendTmpData[i]];
        }
    }
    
    //DBへ登録
    ControllDataBase *db = [ControllDataBase new];
    if (![db updateShijiRate:sendData type:BODDS]) {
        //登録エラー処理が必要　NOが帰ってきたら？？
    }
}

//エラー時
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"URL CONNECT ERROR!! (%@)", NSStringFromClass([self class]));
}

@end
