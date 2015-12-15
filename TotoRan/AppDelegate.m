//
//  AppDelegate.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/19.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "AppDelegate.h"

#define KAISAI_URL @"https://toto.rakuten.co.jp/toto/schedule/"
#define NOT_COMU_MESSAGE @"通信不良でデータが取得できません\n通信可能な状態でアプリを再起動してください"
#define NOT_DB_MESSAGE @"DBの作成に失敗しました\nアプリを再起動してください"
#define DBNAME @"toto.db"
#define ZERO 0

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //プロパティの初期化
    self.bootFlg = NO;
    self.abnomalFlg = NO;
    self.abnomalMessage = nil;
    
    //まずは通信可能判断
    if (![[self class] checkReachability]) {
        self.abnomalFlg = YES;
        self.abnomalMessage = NOT_COMU_MESSAGE;
        return YES;
    }
    
    //DB有る無し判断(初回起動)
    if (![[self class ]createDataBase:DBNAME]) {
        self.abnomalFlg = YES;
        self.abnomalMessage = NOT_DB_MESSAGE;
        return YES;
    }

//    //DBインスタンス生成
//    ControllDataBase *dbControll = [ControllDataBase new];
//    
//    //開催データ取得判断
//    if (![dbControll kaisaiDataCheck]){
//        //開催データの取得
//        GetKaisu *kaisaiData = [GetKaisu new];
//        [kaisaiData returnSourceString:KAISAI_URL];
//    }
//    
//    //支持率データ取得判断
//    NSString *judgeData = [dbControll rateUpdateJudge];
//    if (judgeData) {
//        GetRateToto *toto = [GetRateToto new];
//        [toto parseRate:judgeData];
//    }
    
    return YES;
}

#pragma mark - 通信可能判断メソッド
+ (BOOL)checkReachability
{
    //通信可能チェック
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    
    switch (netStatus) {
        case NotReachable:  //圏外
            return NO; //とりあえずNOを返してみようか
            break;
        default: //圏外じゃない
            break;
    }
    return YES;
}

#pragma mark - DB作成メソッド
// 初期値を持ちつつ書き込めるデータベースを作る
+ (BOOL)createDataBase:(NSString *)dbName
{
    // データベース名
    NSString *databaseName = dbName;
    
    // データベースファイルを格納するために文書フォルダーを取得
    NSString *workPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[ZERO];
    
    // データベースファイルパスの取得
    NSString *databasePath = [workPath stringByAppendingPathComponent:databaseName];
    
    // NSFileManagerオブジェクトの取得
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 文書フォルダにデータベースファイルが存在しているかチェック
    if( ![manager fileExistsAtPath:databasePath] ){
        
        NSError *error = nil;
        
        // 文書フォルダが存在しない場合は、データベースの複製元をリソースから取得する
        NSString *templatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        // リソースから取得したデータベースファイルを文書フォルダにコピーします
        // リソースにあるファイルには書き込みができないためこのファイルをそのまま使うとデータの追加が行えません
        if( ![manager copyItemAtPath:templatePath toPath:databasePath error:&error] ) return NO; //コピー失敗
    }
    
    return YES;
}


#pragma mark - デフォルトメソッド
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}


@end
