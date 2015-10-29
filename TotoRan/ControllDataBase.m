//
//  ControllDataBase.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/22.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "ControllDataBase.h"

#define DBNAME @"toto.db"
#define DELETE_QUERY_KAISU @"delete from kaisu"
#define DELETE_QUERY_KUMIAWASE @"delete from kumiawase"
#define KAISAI_CHECK_QUERY @"select count(*) from kaisu where start_date > datetime('now', 'localtime')"
#define INSERT_QUERY_KAISU @"insert into kaisu values ('%@', '%@', '%@')"
#define INSERT_QUERY_KUMIAWASE @"insert into kumiawase (kaisu, id, home_team, away_team) values ('%@', '%d', replace('%@', ' ', ''), replace('%@', ' ', ''))"
#define UPDATE_QUERY_KUMIAWASE_TOTO @"update kumiawase set get_date = datetime('now', 'localtime'), home_rate = '%@', draw_rate = '%@', away_rate = '%@' where id = %d and kaisu = '%@'"
#define UPDATE_QUERY_KUMIAWASE_BOOK @"update kumiawase set get_date = datetime('now', 'localtime'), home_rate_b = '%@', draw_rate_b = '%@', away_rate_b = '%@' where id = %d and kaisu = '%@'"
#define SELECT_QUERY_NOW @"select * from kaisu where open_number in (select open_number from kaisu where start_date < datetime('now', 'localtime') and end_date > datetime('now', 'localtime')) order by open_number limit 1"
#define SELECT_QUERY_ACQ @"select count(*) from kumiawase where kaisu = '%@' and (get_date is null or strftime('%@', get_date) != (select strftime('%@', datetime('now', 'localtime'))))"
#define SELECT_QUERY_DREW @"select count(*) from kumiawase where kaisu = '%@' and home_rate is not null and home_rate_b is not null"
//#define SELECT_QUERY_HOME @"select * from kumiawase left join abbname on (kumiawase.home_team = abbname.fullname) where kaisu = '%@' order by id"
//#define SELECT_QUERY_AWAY @"select * from kumiawase left join abbname on (kumiawase.away_team = abbname.fullname) where kaisu = '%@' order by id"
#define SELECT_QUERY_HOME @"select * from kumiawase left join abbname on (kumiawase.home_team like '%%'||abbname.fullname||'%%') where kaisu = '%@' order by id"
#define SELECT_QUERY_AWAY @"select * from kumiawase left join abbname on (kumiawase.away_team like '%%'||abbname.fullname||'%%') where kaisu = '%@' order by id"
#define SELECT_QUERY_RATE @"select * from kumiawase where kaisu = '%@' order by id"
#define SELECT_QUERY_NOW_KAISAI @"select count(*) from kaisu where (start_date < datetime('now', 'localtime') and end_date > datetime('now', 'localtime'))"
#define SELECT_QUERY_GETDATE @"select strftime('%@', get_date) as gettime from kumiawase where kaisu = '%@' limit 1"
#define SELECT_QUERY_KAISU_COUNT @"select count(*) from kaisu"
#define SELECT_QUERY_SALEEND @"select strftime('%@', end_date) as enddate from kaisu where open_number = '%@'"
#define DATEFORMAT1 @"%Y-%m-%d %H:00:00"
#define DATEFORMAT2 @"%Y年%m月%d日 %H時00分時点"
#define DATEFORMAT3 @"%Y年%m月%d日 %H時%M分締切"

enum {KAISU, START_DATE, END_DATE, TEAM_START, TEAM_END = 28};
enum {TOTO, BODDS};
enum {ZERO, ONE, TWO, THREE, MAX = 39};


@implementation ControllDataBase
{
    NSString *path; //dbファイルのパス
    NSArray *typeHome; //totoかbODDSかの区別用
    NSArray *typeDraw; //totoかbODDSかの区別用
    NSArray *typeAway; //totoかbODDSかの区別用
}

//初期化メソッド
- (instancetype)init
{
    self = [super init];
    if (self) {
        // パスの取得
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [arr[ZERO] stringByAppendingPathComponent:DBNAME];
        
        //totoかbODDSかの区別用データ準備
        typeHome = @[@"home_rate", @"home_rate_b"];
        typeDraw = @[@"draw_rate", @"draw_rate_b"];
        typeAway = @[@"away_rate", @"away_rate_b"];
    }
    return self;
}

//開催回数テーブルに格納されている最大(最新)開催開始日と現在日付の比較
- (BOOL)kaisaiDataCheck
{
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    // SQL文の生成
    FMResultSet *result = [mydb executeQuery:KAISAI_CHECK_QUERY];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    if([result intForColumnIndex:ZERO] == ZERO){
        // 登録データ数が０、もしくはすべての開催データが古い場合は取得し直すのでテーブルデータを全削除しておく
        if (![mydb executeUpdate:DELETE_QUERY_KAISU]) //NSLog(@"kaisu table delete error!!!");
        if (![mydb executeUpdate:DELETE_QUERY_KUMIAWASE]) //NSLog(@"kaisu table delete error!!!");
        
        [mydb close];
        [result close];
        return NO;
    }
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return YES;

}

//開催回と組み合わせ表の更新(挿入)
- (BOOL)insertKaisaiData:(NSArray *)data
{
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    //KAISUテーブルにインサート（開催回数、開始日時、終了日時）
    NSString *insertQueryKaisu = [NSString stringWithFormat:INSERT_QUERY_KAISU, data[KAISU], data[START_DATE], data[END_DATE]];
    if (![mydb executeUpdate:insertQueryKaisu]) {
        //NSLog(@"kaisu table insert error!!!");
        return NO;
    }
    
    //KUMIAWASEテーブルにインサート（開催回数、枠番号、ホームチーム名、アウェイチーム名）
    int wakuCount = ONE;
    for (int i = TEAM_START; i <= TEAM_END; i += TWO) {
        NSString *insertQueryKumiawase = [NSString stringWithFormat:INSERT_QUERY_KUMIAWASE, data[KAISU], wakuCount, data[i], data[i + ONE]];
        if (![mydb executeUpdate:insertQueryKumiawase]) {
            //NSLog(@"kumiawase table insert error!!!");
            return NO;
        }
        wakuCount++;
    }

    [mydb close];
    
    return YES;

}

//支持率データの更新(update)
- (BOOL)updateShijiRate:(NSArray *)data type:(int)type
{
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    //支持率データをアップデート
    int wakuCount = 1;
    
    //totoなのかbODDSなのかをディスパッチ
    NSString *shijiType = type == TOTO ? UPDATE_QUERY_KUMIAWASE_TOTO : UPDATE_QUERY_KUMIAWASE_BOOK;

    
    for (int i = ONE; i <= MAX; i += THREE) {
        NSString *updateQueryKumiawase = [NSString stringWithFormat:shijiType, data[i], data[i + ONE], data[i + TWO], wakuCount, data[KAISU]];
        if (![mydb executeUpdate:updateQueryKumiawase]) {
            //NSLog(@"kumiawase table update error!!!");
            return NO;
        }
        wakuCount++;
    }
    
    [mydb close];
    
    return YES;
}


//現在開催中の回数を返す
- (NSString *)returnKaisaiNow
{
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    //現在開催中の開催回を取得
    FMResultSet *result = [mydb executeQuery:SELECT_QUERY_NOW];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    //返すNSString
    NSString *returnString = [result stringForColumn:@"open_number"];
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnString;
}

//現在開催中の回はある？
- (int)returnKaisaiYesNo
{
    int returnValue = ZERO;
    
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    //現在開催中の有無を取得
    FMResultSet *result = [mydb executeQuery:SELECT_QUERY_NOW_KAISAI];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    //返すNSString
    returnValue = [result intForColumnIndex:ZERO];
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnValue;
}

//支持率データの更新判断ジャッジ　nilか開催回数を返す
- (NSString *)rateUpdateJudge
{
    //まずは現在開催中の回数を取得
    NSString *returnData = [self returnKaisaiNow];
    
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    // SQL文の生成
    FMResultSet *result = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_ACQ, returnData, DATEFORMAT1, DATEFORMAT1]];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    //取得日が埋まってたり、同日だった場合はnilを返して支持率データは取得しない
    if([result intForColumnIndex:ZERO] == ZERO){
        [mydb close];
        [result close];
        return nil;
    }
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnData;
}

//初回起動時にデータが１３件そろってるかどうか確認
- (int)drewCheck:(NSString *)kaisu
{
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    // SQL文の生成
    FMResultSet *result = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_DREW, kaisu]];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];

    //返す結果を変数に格納
    int returnInt = [result intForColumnIndex:ZERO];
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnInt;
}

//組み合わせデータを返す
- (NSArray *)returnKumiawase
{
    //まずは現在開催中の回数を取得
    NSString *returnData = [self returnKaisaiNow];
    
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    //データ格納Arrayを準備
    NSMutableArray *returnArray = [NSMutableArray array];
    
    // ホームチーム取得SQL文の生成
    FMResultSet *resultHome = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_HOME, returnData]];
    
    //Whileで回しながらホームチームデータを取得　※fullnameがマッチしなかったら「不明」をセット
    while ([resultHome next]) {
        [returnArray addObject:[resultHome stringForColumn:@"name"] != nil ? [resultHome stringForColumn:@"name"] : @"不明"];
    }
    
    //ホームチームresultセットのクローズ
    [resultHome close];
    
    // アウェイチーム取得SQL文の生成
    FMResultSet *resultAway = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_AWAY, returnData]];
    
    //Whileで回しながらアウェイチームデータを取得　※fullnameがマッチしなかったら「不明」をセット
    while ([resultAway next]) {
        [returnArray addObject:[resultAway stringForColumn:@"name"] != nil ? [resultAway stringForColumn:@"name"] : @"不明"];
    }
    
    //アウェイチームresultセットのクローズ
    [resultAway close];
    
    //データベースのクローズ
    [mydb close];
    
    return returnArray;
}

//支持率データを返す type:0はtoto、1はbODDS
- (NSArray *)returnRate:(int)type
{
    //まずは現在開催中の回数を取得
    NSString *returnData = [self returnKaisaiNow];
    
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    //データ格納Arrayを準備
    NSMutableArray *returnArray = [NSMutableArray array];

    // 現在開催中データ取得SQL文の生成
    FMResultSet *result = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_RATE, returnData]];
    
    //Whileで回しながら支持率データを取得　※「0.0」が返ってきたら「--.--」をセット
    while ([result next]) {
        NSMutableArray *returnArrayDetail = [NSMutableArray array];
        
        //添え字とhome:1・・・を合わせるために並びをDRAWを最初にした
        [returnArrayDetail addObject:[[result stringForColumn:typeDraw[type]] isEqualToString:@"0.0"] ? @"--.--" : [result stringForColumn:typeDraw[type]]];
        [returnArrayDetail addObject:[[result stringForColumn:typeHome[type]] isEqualToString:@"0.0"] ? @"--.--" : [result stringForColumn:typeHome[type]]];
        [returnArrayDetail addObject:[[result stringForColumn:typeAway[type]] isEqualToString:@"0.0"] ? @"--.--" : [result stringForColumn:typeAway[type]]];

        [returnArray addObject:returnArrayDetail];
    }
    
    //resultセットのクローズ
    [result close];
    
    //データベースのクローズ
    [mydb close];
    
    return returnArray;
}

//支持率データ取得日時を返す
- (NSString *)returnGetRateTime
{
    //まずは現在開催中の回数を取得
    NSString *kaisu = [self returnKaisaiNow];
    
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    // SQL文の生成
    FMResultSet *result = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_GETDATE, DATEFORMAT2, kaisu]];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    NSString *returnDate = [result stringForColumn:@"gettime"];
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnDate;
}

//開催回(kaisu)テーブルのデータチェック
- (int)kaisuDataCountCheck
{
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    // SQL文の生成
    FMResultSet *result = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_KAISU_COUNT]];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    //返す結果を変数に格納
    int returnInt = [result intForColumnIndex:ZERO];
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnInt;
}

//販売終了日を返す
- (NSString *)returnSaleEndDate
{
    //まずは現在開催中の回数を取得
    NSString *kaisu = [self returnKaisaiNow];
    
    // データベースオブジェクトの作成
    FMDatabase *mydb = [FMDatabase databaseWithPath:path];
    
    // データベースのオープン
    [mydb open];
    
    // SQL文の生成
    FMResultSet *result = [mydb executeQuery:[NSString stringWithFormat:SELECT_QUERY_SALEEND, DATEFORMAT3, kaisu]];
    
    //結果を１件に絞ってるのでwhileで回す必要なし
    [result next];
    
    NSString *returnDate = [result stringForColumn:@"enddate"];
    
    //ResultSetとデータベースのクローズ
    [result close];
    [mydb close];
    
    return returnDate;
}

@end
