//
//  GetKaisuDetail.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "GetKaisuDetail.h"

#define FOUR_PLACE 4
#define TWO_PLACE 2
#define YEAR_ORDER 0
#define MONTH_ORDER 5
#define DAY_ORDER 8
#define HOUR_ORDER_START 14
#define HOUR_ORDER_END 19
#define MINUTE_ORDER_START 17
#define MINUTE_ORDER_END 22
#define ZERO 0

#define URLSTRING_DETAIL @"http://www.toto-dream.com/dci/I/IPA/IPA01.do?op=disptotoLotInfo&holdCntId="

enum {START, END, TEAM, TEAM_END=28};


@implementation GetKaisuDetail
{
    NSMutableData *receivedData; //html取得データ
    NSString *htmlString;
    NSString *kaiNum;
    BOOL totoFlg;
}

//初期化メソッド
- (instancetype)init
{
    self = [super init];
    if (self) {
        receivedData = [NSMutableData new];
        totoFlg = NO;
        kaiNum = nil;
    }
    return self;
}

- (void)parseDate:(NSString *)kaisu;
{
    kaiNum = kaisu;
    NSString *urlString = [URLSTRING_DETAIL stringByAppendingString:kaisu];
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

    //当該開催回でtotoがあるか確認
    NSArray *aNodes = [bodyNode findChildTags:@"a"];
    for (HTMLNode *node in aNodes) {
        if ([[node getAttributeNamed:@"href"] isEqualToString:@"#toto"]) {
            totoFlg = YES; //変な改行が入ってるから取っ払ってやらないとだめ　めんどくせえ！！！！！！
            break;
        }
    }
    
    //totoの開催がなければ終了
    if (!totoFlg) return;
    
    //DBに登録させるデータ格納Arrayに最初は開催回数を格納
    NSMutableArray *sendData = [NSMutableArray array];
    [sendData addObject:kaiNum];
    
    //tdタグで絞って販売開始日時と販売終了日時、組み合わせを取得する準備をする
    NSArray *bNodes = [bodyNode findChildTags:@"td"];
    int arrayCount = ZERO;

    for (HTMLNode *bnode in bNodes) {
        if ([[bnode getAttributeNamed:@"class"] isEqualToString:@"type5"] || [[bnode getAttributeNamed:@"width"] isEqualToString:@"185"]) {
            //まずは前後トリム
            NSString *tmpData = [[bnode contents] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //日時の整形
            if (arrayCount <= END) {
                //次にsqliteのdatetime型に合うように整形
                NSString *year = [tmpData substringWithRange:NSMakeRange(YEAR_ORDER, FOUR_PLACE)];
                NSString *month = [tmpData substringWithRange:NSMakeRange(MONTH_ORDER, TWO_PLACE)];
                NSString *day = [tmpData substringWithRange:NSMakeRange(DAY_ORDER, TWO_PLACE)];
                NSString *hour = nil;
                NSString *minute = nil;
                
                //ここから開始時分と終了時分で処理分ける
                if (arrayCount == START) {
                    hour = [tmpData substringWithRange:NSMakeRange(HOUR_ORDER_START, TWO_PLACE)];
                    minute = [tmpData substringWithRange:NSMakeRange(MINUTE_ORDER_START, TWO_PLACE)];
                } else {
                    hour = [tmpData substringWithRange:NSMakeRange(HOUR_ORDER_END, TWO_PLACE)];
                    minute = [tmpData substringWithRange:NSMakeRange(MINUTE_ORDER_END, TWO_PLACE)];
                }
                
                //整形後に格納
                [sendData addObject:[NSString stringWithFormat:@"%@-%@-%@ %@:%@", year, month, day, hour, minute]];
            }
            
            //4番目から２９番目のデータまではそのまま取得
            if (arrayCount > TEAM) [sendData addObject:tmpData];
            
            //最終枠の格納が終わったらループを抜ける
            if (arrayCount >= TEAM_END) break;
            arrayCount++;
        }
    }
    
    //DBへ登録
    ControllDataBase *db = [ControllDataBase new];
    if (![db insertKaisaiData:sendData]) {
        //登録エラー処理が必要　NOが帰ってきたら？？
        
    }
    
    //当該インスタンスが現在開催中のデータだったら支持率も取得する　タイミングによっては現在開催回のSELECTがWARNING起こすが、マルチスレッドの関係上しゃーない
    if ([[db returnKaisaiNow] isEqualToString:kaiNum]) {
        GetRateToto *toto = [GetRateToto new];
        [toto parseRate:kaiNum];
    }
}

//エラー時
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"URL CONNECT ERROR!! (%@)", NSStringFromClass([self class]));
}

@end
