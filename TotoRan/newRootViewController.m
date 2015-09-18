//
//  newRootViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/09/06.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "newRootViewController.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height

#define LOGO_RECT CGRectMake(WIDTH / 2 - 50, (HEIGHT / 8) - 10, 100, 100)
#define BTNRECT_SINGLE CGRectMake(WIDTH / 2 - ((WIDTH / 2) / 2), (HEIGHT / 8) * 3 - 10, WIDTH / 2, HEIGHT / 10)
#define BTNRECT_MULTI CGRectMake(WIDTH / 2 - ((WIDTH / 2) / 2), (HEIGHT / 8) * 5 - 10, WIDTH / 2, HEIGHT / 10)
#define ENDDATE_LABEL_RECT CGRectMake(WIDTH / 2 - ((WIDTH * 0.75) / 2), (HEIGHT / 8) * 7 - 40, WIDTH * 0.75, 50)
#define ROOP_AN_COUNT 10000
#define ROOP_AN_MESSAGE1 @"何かしらの異常が発生しました\nアプリを再起動してください\n※Jリーグシーズンオフ中の場合はデータがないので起動できません"
#define ROOP_AN_MESSAGE2 @"何かしらの異常が発生しました\nアプリを再起動してください"
#define NOT_KAISAI_MESSAGE @"現在開催中のtotoはありません"

enum {TOTO, BODDS};
enum {SINGLE = 101, MULTI};

@interface newRootViewController ()

@end

@implementation newRootViewController
{
    BOOL abnomalFlg; //何かしらの異常がある場合は次画面への遷移を抑制する
    NSString *abnomalMessage; //何かしらの異常がある場合に次画面遷移を試みた場合に表示するメッセージ
    AppDelegate *appDelegate; //通信とDB失敗データの取得と各種データの格納用
    int fontSizeDispatch; //機種別フォントサイズ
}

//初期化
- (instancetype)init
{
    self = [super init];
    if (self) {
        abnomalFlg = NO;
        abnomalMessage = nil;
        fontSizeDispatch = 0;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //背景色は黄色で黒で縁取り ※黒で縁取ると黒いiPhoneだとただ画面がちっちゃく見えるだけ。。。
    self.view.backgroundColor = [UIColor yellowColor];
    
    //機種を画面サイズ幅で制御 4シリーズと5シリーズは320.0、6は375.0、6+は414.0　※6sシリーズを考慮すっぺ
    float widthSize = self.view.bounds.size.width;
    float HeightSize = self.view.bounds.size.height;
    if (widthSize <= 320.0) {
        if (HeightSize <= 960) {
            fontSizeDispatch = 12;
        } else {
            fontSizeDispatch = 14;
        }
    } else if (widthSize >= 375.0 && 414.0 > widthSize) {
        fontSizeDispatch = 16;
    } else {
        fontSizeDispatch = 18;
    }
    
    //ロゴ
    UIImageView *logo = [[UIImageView alloc] initWithFrame:LOGO_RECT];
    logo.image = [UIImage imageNamed:@"TotoRanLogo.png"];
    [self.view addSubview:logo];
    
    //ボタン
    UIButton *singleBtn = [self makeButton:@"シングル選択" frame:BTNRECT_SINGLE tag:SINGLE];
    UIButton *multiBtn = [self makeButton:@"マルチ選択" frame:BTNRECT_MULTI tag:MULTI];
    [self.view addSubview:singleBtn];
    [self.view addSubview:multiBtn];
}

//ボタン生成メソッド
- (UIButton *)makeButton:(NSString *)titile frame:(CGRect)frame tag:(int)tag
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.tag = tag;
    btn.enabled = NO;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn setTitle:titile forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnPush:) forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:fontSizeDispatch + 12]];
    //縁取り
    [[btn layer] setBorderColor:[[UIColor blackColor] CGColor]]; // 枠線の色
    [[btn layer] setBorderWidth:3.0]; // 枠線の太さ

    return btn;
}

//viewdidloadで画面描画終了後にこっちで色々ロジック回す
- (void)viewDidAppear:(BOOL)animated
{
    //appDelegateをインスタンス化
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    //appDelegateにフォントサイズを格納
    appDelegate.fontSize = fontSizeDispatch;
    
    //初回起動時以外はデータ取得しない
    if (appDelegate.bootFlg) return;
    
    //appdelegateで通信かDB作成が失敗してたら終了
    if (appDelegate.abnomalFlg) {
        [self alertDisplay:appDelegate.abnomalMessage];
        abnomalFlg = YES;
        abnomalMessage = appDelegate.abnomalMessage;
        return;
    }
    
    //データ取得中はインジケータ回し始める
    [SVProgressHUD showWithStatus:@"データ取得中..."];
    
    //別スレッドで各データの取得処理を行う
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        
        //とりあえずデータ取得猶予を持たせるために3秒スリープ
        [NSThread sleepForTimeInterval:3.0];
        
        //DBインスタンス生成
        ControllDataBase *dbControll = [ControllDataBase new];
        
        //kaisuテーブルにデータがないパターン
        //1.テーブルへのinsert処理が始まってない（テーブルデータ０件）
        //2.テーブルへのinsert処理が終わってない（テーブルデータ？件　※該当する開催回データがない）
        //3.totoが開催してない（テーブルデータ？件　※シーズン中にスポット的　レアケース）
        //3.totoが開催してない（テーブルデータ０件　※シーズンオフ）
        
        //シーズンオフ中はデータinsert時に色づけしたデータをテーブルに格納して、それをベースに例外処理する？？？？
        //現時点では楽天サイトがシーズンオフ中にどうなるかわかんないから
        
        
        //現在開催中のtoto有無判断（開催中じゃなかったらメッセージ表示して終了）
        int abnomalCount = 0;
        while (YES) {
            if ([dbControll kaisuDataCountCheck] != 0) {
                //kaisuテーブルにinsertが始まってから少し猶予を持たせるためにさらに２秒スリープ
                [NSThread sleepForTimeInterval:2.0];
                if (![dbControll returnKaisaiYesNo]) {
                    [self alertDisplay:NOT_KAISAI_MESSAGE];
                    abnomalFlg = YES;
                    abnomalMessage = NOT_KAISAI_MESSAGE;
                    return;
                }
                break;
            }
            abnomalCount++;
            //ループが１万回まわっても終わらなかったら異常として終了させる
            if (abnomalCount > ROOP_AN_COUNT) {
                [self alertDisplay:ROOP_AN_MESSAGE1];
                abnomalFlg = YES;
                abnomalMessage = ROOP_AN_MESSAGE1;
                return;
            }
        }
        
        //DBにデータがある状態で以降の処理が必要なのでチェックロジックでループ
        NSString *kaisu = nil;
        abnomalCount = 0;
        while (YES) {
            kaisu = [dbControll returnKaisaiNow];
            if ([kaisu length] > 0) {
                int drewCheck = [dbControll drewCheck:kaisu];
                if (drewCheck == 13) break;
            }
            abnomalCount++;
            //ループが１万回まわっても終わらなかったら異常として終了させる
            if (abnomalCount > ROOP_AN_COUNT) {
                [self alertDisplay:ROOP_AN_MESSAGE2];
                abnomalFlg = YES;
                abnomalMessage = ROOP_AN_MESSAGE2;
                return;
            }
        }
        
        //現在開催回数
        appDelegate.kaisu = kaisu;
        
        //DBから現在開催回を取得してそれをキーに組み合わせデータ取得　※戻り値データはホームチーム１３チームの後にアウェイチーム１３チームの系２６オブジェクト
        appDelegate.teamArray = [dbControll returnKumiawase];
        
        //DBから現在開催回を取得してそれをキーに組み合わせtoto支持率データ取得　枠順(ホーム、ドロー、アウェイ)の３９オブジェクト
        appDelegate.rateArrayToto = [dbControll returnRate:TOTO];
        
        //DBから現在開催回を取得してそれをキーに組み合わせbODDS支持率データ取得　※まだデータがない時は「--.--」が返ってくる
        appDelegate.rateArrayBook = [dbControll returnRate:BODDS];
        
        //起動フラグをYESにする
        appDelegate.bootFlg = YES;
        
        //データ取得が正常終了したらメインスレッドで以下の処理を行う
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //インジケータ終了
            [SVProgressHUD showSuccessWithStatus:@"データ取得完了！"];
            
            //ボタンを選択可能に
            for (int i = SINGLE; i <= MULTI; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:i];
                button.enabled = YES;
            }
            
            //現在の回数と販売終了日を表示してあげようかね？
            UILabel *kaisuLabel = [[UILabel alloc] initWithFrame:ENDDATE_LABEL_RECT];
            kaisuLabel.backgroundColor = [UIColor clearColor];
            kaisuLabel.textColor = [UIColor blackColor];
            kaisuLabel.numberOfLines = 2;
            kaisuLabel.textAlignment = NSTextAlignmentCenter;
            kaisuLabel.text = [NSString stringWithFormat:@"第%@回 toto\n%@", [kaisu substringWithRange:NSMakeRange(1,3)], [dbControll returnSaleEndDate]];
            [kaisuLabel setFont:[UIFont systemFontOfSize:fontSizeDispatch - 3]];
            
            [self.view addSubview:kaisuLabel];
            
        });
    });
}

//ボタンプッシュ時の動作
- (void)btnPush:(UIButton *)button
{
    //異常発生時は警告表示で画面遷移しない
    if (abnomalFlg) {
        [self alertDisplay:abnomalMessage];
        return;
    }

    //それぞれの画面に遷移
    UINavigationController *ngcl;
    if (button.tag == SINGLE) {
        SingleChoiceViewController *scvc = [SingleChoiceViewController new];
        ngcl = [[UINavigationController alloc] initWithRootViewController:scvc];
    } else {
        MultiChoiceViewController *mcvd = [MultiChoiceViewController new];
        ngcl = [[UINavigationController alloc] initWithRootViewController:mcvd];
    }
    [self presentViewController:ngcl animated:YES completion:nil];;
}

//異常の場合はアラート表示
- (void)alertDisplay:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:message
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
   
    //インジケータは即終了
    [SVProgressHUD dismiss];
    
    //ボタンを選択可能に
    for (int i = SINGLE; i <= MULTI; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i];
        button.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
