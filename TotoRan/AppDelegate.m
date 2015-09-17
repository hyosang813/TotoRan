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


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊不要不要不要不要不要不要不要不要不要不要不要不要不要不要不要不要不要
//    //tabとnavigation共存用
//    _window= [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊不要不要不要不要不要不要不要不要不要不要不要不要不要不要不要不要不要
    
//    //まずは通信可能判断
//    if (![self checkReachability]) {
//        [[[UIAlertView alloc] initWithTitle:@"通信不可" message:@"通信ができないためデータ取得ができません" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return YES; //以下の処理をさせたくないだけなので正常終了の意味でYESを返す
//    }
//    
//    //DB有る無し判断(初回起動)
//    if (![self createDataBase:@"toto.db"]) {
//        [[[UIAlertView alloc] initWithTitle:@"DB作成失敗" message:@"DBの作成に失敗しました" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//        return YES; //以下の処理をさせたくないだけなので正常終了の意味でYESを返す
//    }
    
    //プロパティの初期化
    self.bootFlg = NO;
    self.abnomalFlg = NO;
    self.abnomalMessage = nil;
    
    //まずは通信可能判断
    if (![self checkReachability]) {
        self.abnomalFlg = YES;
        self.abnomalMessage = NOT_COMU_MESSAGE;
        return YES;
    }
    
    //DB有る無し判断(初回起動)
    if (![self createDataBase:@"toto.db"]) {
        self.abnomalFlg = YES;
        self.abnomalMessage = NOT_DB_MESSAGE;
        return YES;
    }

    //DBインスタンス生成
    ControllDataBase *dbControll = [ControllDataBase new];
    
    //開催データ取得判断
    if (![dbControll kaisaiDataCheck]){
        //開催データの取得
        GetKaisu *kaisaiData = [GetKaisu new];
        [kaisaiData returnSourceString:KAISAI_URL];
    }
    
    //支持率データ取得判断
    NSString *judgeData = [dbControll rateUpdateJudge];
    if (judgeData) {
        GetRateToto *toto = [GetRateToto new];
        [toto parseRate:judgeData];
    }
    
    
    
//    この下全部いらん！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    
    
//
//    //別スレッドで非同期通信で取得したデータの登録完了チェック
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        
//        
//        
//        
//      
//        //データのDB格納が終了したら(メインスレッドで)初期画面描画開始
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            //現在開催中のtoto有無判断（開催中じゃなかったらメッセージ表示して終了）
//            if (![dbControll returnKaisaiYesNo]) {
//                [[[UIAlertView alloc] initWithTitle:@""
//                                            message:@"現在開催中のtotoはありません"
//                                           delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil] show];
//            } else {
//                
//                //タブコントローラをインスタンス化
//                tabController = [UITabBarController new];
//                
//                //親となるタブバーコントローラーの配置
//                tab1 = [SingleChoiceViewController new]; // タブ1
//                tab2 = [MultiChoiceViewController new];  // タブ2
//                
//                //タブバーの画像変更
//                tab1.tabBarItem.image = [[UIImage imageNamed:@"tab1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                tab2.tabBarItem.image = [[UIImage imageNamed:@"tab2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//                
//                //タブバー画像の位置調整
//                tab1.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//                tab2.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
//                
//                
//                //それぞれにナビゲーションコントローラーをセット
//                UINavigationController *SingleNavigationController = [[UINavigationController alloc] initWithRootViewController:tab1];
//                UINavigationController *MultiNavigationController = [[UINavigationController alloc] initWithRootViewController:tab2];
//                
//                //タブバーコントローラーにナビゲーションコントローラーをセット
//                tabController.viewControllers = @[SingleNavigationController, MultiNavigationController];
//                
//                //ウインドウにタブバーコントローラーをセット
//                [self.window setRootViewController:tabController];
//                [self.window makeKeyAndVisible];
//                
//    //            //ラベルとボタンの大きさ決定のために以下のサイズ情報を取得（画面サイズ、ステータスバー、ナビゲーションバー、タブバー）
//    //            float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    //            float naviHeight = SingleNavigationController.navigationBar.frame.size.height;
//    //            float tabHeight = tabController.tabBar.frame.size.height;
//    //
//    //            NSLog(@"%f %f %f", statusHeight, naviHeight, tabHeight);
//    //            NSLog(@"%f %f", [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
//    //
//    //            //有効画面サイズと起点となる高さをpropertyにセット
//    //            self.screenSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - (statusHeight + naviHeight + tabHeight));
//    //            self.heightPoint = statusHeight + naviHeight;
//    //            
//    //            NSLog(@"%f %f %f", self.screenSize.width, self.screenSize.height, self.heightPoint);
//            }
//        });
//    });
    
    return YES;
}

////異常の場合はアラート表示
//- (void)alertDisplay:(NSString *)title message:(NSString *)message
//{
//    [[[UIAlertView alloc] initWithTitle:@""
//                                message:message
//                               delegate:self
//                      cancelButtonTitle:@"OK"
//                      otherButtonTitles:nil] show];
//}

#pragma mark - 通信可能判断メソッド
- (BOOL)checkReachability
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
- (BOOL)createDataBase:(NSString *)dbName
{
    // データベース名
    NSString *databaseName = dbName;
    
    // データベースファイルを格納するために文書フォルダーを取得
    NSString *workPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
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
