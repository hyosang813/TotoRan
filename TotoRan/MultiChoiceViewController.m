//
//  MultiChoiceViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/04.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "MultiChoiceViewController.h"

#define WIDTH self.view.bounds.size.width

#define SIXPLUS_HEIGHT 700 //6+の画面高さを基準にする
#define BUTTON_HEIGHT 41.75 //ボタンの高さ
#define BUTTON_INTERVAL 5 //ボタンの間隔
#define TAG_INCREMENT 87 //tagの桁数増やし用
#define BASE_POINT 10 //起点
#define TAG_BASE 101 //tagの起点(101)
#define CLEAR_WIDTH 200 //選択解除ボタンwidth
#define CLEAR_HEIGHT 50 //選択解除ボタンheight

@interface MultiChoiceViewController ()

@end

@implementation MultiChoiceViewController
{
    SystemSoundID buttonSound; //ボタンの効果音
    SystemSoundID eraseButtonSound; //全消去ボタンの効果音
    AppDelegate *appDelegate; //情報取得用
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"マルチ選択";
    
    //ボタン効果音ファイル読み込み
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kashan01" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &buttonSound);
    
    //全消去ボタン効果音ファイル読み込み
    NSString *ePath = [[NSBundle mainBundle] pathForResource:@"erase" ofType:@"wav"];
    NSURL *eUrl = [NSURL fileURLWithPath:ePath];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(eUrl), &eraseButtonSound);
    
    //詳細設定画面への遷移ボタンを生成　navigationBarの右側ボタン
    UIBarButtonItem *pushButton = [[UIBarButtonItem alloc] initWithTitle:@"条件指定" style:UIBarButtonItemStyleBordered target:self action:@selector(push:)];
    pushButton.tag = 0;
    self.navigationItem.rightBarButtonItem = pushButton;
    
    //戻るボタンをカスタマイズ
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //スクロールビューをself.viewにセット
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor yellowColor];
    scrollView.frame = self.view.frame;
    scrollView.contentSize = CGSizeMake(WIDTH, SIXPLUS_HEIGHT); //6+の画面高さを基準にする
    scrollView.delegate = self;
    self.view = scrollView;
    
    //組み合わせ情報を取得
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSArray *array = appDelegate.teamArray;
    
    //選択解除ボタンのy座標を格納する変数
    int clearY = 0;
    
    //ボタンのwidthを求める 「30」の内訳は、左右の余白１０×２　と　ボタン間隔５×２
    float buttonWidth = (WIDTH - 30) / 3.0;
    
    int tag = TAG_BASE; //tag
    int arrayCount = 0; //teamArrayの添え字用
    int xPoint = BASE_POINT; //起点x
    int yPoint = BASE_POINT; //起点y
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 13; j++) {
            if (i == 1) {
                [self makeButton:tag buttonRect:CGRectMake(xPoint, yPoint, buttonWidth, BUTTON_HEIGHT) teamName:@"DRAW"];
            } else {
                [self makeButton:tag buttonRect:CGRectMake(xPoint, yPoint, buttonWidth, BUTTON_HEIGHT) teamName:array[arrayCount]];
                arrayCount++;
            }
            yPoint = yPoint + BUTTON_HEIGHT + BUTTON_INTERVAL;
            tag++;
        }
        
        //選択解除ボタンのy座標を格納
        clearY = yPoint;
        
        //x起点を次の列にずらすのと、y起点のリセット、あとタグの桁を増やす(101,201,301)
        xPoint = xPoint + buttonWidth + BUTTON_INTERVAL;
        yPoint = BASE_POINT;
        tag += TAG_INCREMENT;
    }
    
    //選択解除ボタンを配置
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 100, clearY + 20, CLEAR_WIDTH, CLEAR_HEIGHT)];
    [clearButton setTitle:@"選択解除" forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"nomal.png"] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"nomal.png" ] forState:UIControlStateSelected];
    [clearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 2]];
    //縁取り
    [[clearButton layer] setBorderColor:[[UIColor redColor] CGColor]]; // 枠線の色
    [[clearButton layer] setBorderWidth:1.0]; // 枠線の太さ
    [self.view addSubview:clearButton];

}

//ボタン生成メソッド
- (void)makeButton:(int)tag buttonRect:(CGRect)buttonRect teamName:(NSString *)teamName
{
    UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
    [button setTitle:teamName forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nomal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_multi.png" ] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchDown];
    [button.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 2]];
    //縁取り
    [[button layer] setBorderColor:[[UIColor redColor] CGColor]]; // 枠線の色
    [[button layer] setBorderWidth:1.0]; // 枠線の太さ
    [self.view addSubview:button];
}

//トグルボタン
- (void)toggle:(UIButton *)button
{
    button.selected = !button.selected;
    
    //トグルに合わせて文字色を変更(黒か白)
    if (button.selected) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

    AudioServicesPlaySystemSound(buttonSound);
}

//クリアボタン
- (void)clear:(UIButton *)button
{
    int tag = TAG_BASE; //tag
    for (int i = 0; i < 13; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *targetButton = (UIButton *)[self.view viewWithTag:tag];
            targetButton.selected = NO;
            [targetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            tag = tag + 100;
        }
        tag = tag - 299;
    }
    
    //効果音
    AudioServicesPlaySystemSound(eraseButtonSound);
}

//次画面への遷移
- (void)push:(UIButton *)button
{
    //次の画面に渡すダブルの数とトリプルの数、それにプチ削減のためドロー(ゼロ)の数をカウント
    int doubleCount = 0;
    int tripleCount = 0;
    int zeroCount = 0;
    
    //次の画面へボタンの選択状態を伝えるためにUiButtonを格納した２次元Arrayを作成
    NSMutableArray *arrayParent = [NSMutableArray array];
    int tag = TAG_BASE; //tag
    for (int i = 0; i < 13; i++) {
        NSMutableArray *arrayChiled = [NSMutableArray array];
        int typeCount = 0;
        for (int j = 0; j < 3; j++) {
            UIButton *targetButton = (UIButton *)[self.view viewWithTag:tag];
            if (targetButton.selected) {
                switch (j) {
                    case 0:
                        [arrayChiled addObject:[NSNumber numberWithInt:1]];
                        break;
                    case 1:
                        [arrayChiled addObject:[NSNumber numberWithInt:0]];
                        zeroCount++;
                        break;
                    case 2:
                        [arrayChiled addObject:[NSNumber numberWithInt:2]];
                        break;
                    default:
                        break;
                }
                typeCount++;
            } else {
                [arrayChiled addObject:[NSNull null]];
            }
            tag = tag + 100;
        }
        if (typeCount == 2) {
            doubleCount++;
        } else if (typeCount == 3) {
            tripleCount++;
        }
        
        [arrayChiled addObject:[NSNumber numberWithInt:typeCount]];
        [arrayParent addObject:arrayChiled];
        tag = tag - 299;
    }
    
    //ダブルとトリプルの数整合性チェック
    if ([self doubleTripleCheck:doubleCount tripleCount:tripleCount]) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"以下の組合わせを超える事は出来ません\n※合計486口を超える事はできません\nダブル:0 トリプル:5\nダブル:1 トリプル:5\nダブル:2 トリプル:4\nダブル:3 トリプル:3\nダブル:4 トリプル:3\nダブル:5 トリプル:2\nダブル:6 トリプル:1\nダブル:7 トリプル:1\nダブル:8 トリプル:0"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    MultiDetailsViewController *mdvc = [MultiDetailsViewController new];
    
    // Tab bar を非表示
    mdvc.hidesBottomBarWhenPushed = YES;
    
    //次の画面へUiButtonの二次元Arrayを受け渡し
    mdvc.arrayParent = arrayParent;
    mdvc.doubleCount = doubleCount;
    mdvc.tripleCount = tripleCount;
    mdvc.zeroCount = zeroCount;
    
    [self.navigationController pushViewController:mdvc animated:YES];
}

//ダブルの数とトリプルの数の整合性チェック
- (BOOL)doubleTripleCheck:(int)doubleCount tripleCount:(int)tripleCount
{
    if (doubleCount > 8) return YES; //wは最高8個まで
    if (tripleCount > 5) return YES; //tは最高5個まで
    if (doubleCount == 0 && tripleCount > 5) return YES; //wが0の時はtは5まで
    if (doubleCount == 1 && tripleCount > 5) return YES; //wが1の時はtは5まで
    if (doubleCount == 2 && tripleCount > 4) return YES; //wが2の時はtは4まで
    if (doubleCount == 3 && tripleCount > 3) return YES; //wが3の時はtは3まで
    if (doubleCount == 4 && tripleCount > 3) return YES; //wが4の時はtは3まで
    if (doubleCount == 5 && tripleCount > 2) return YES; //wが5の時はtは2まで
    if (doubleCount == 6 && tripleCount > 1) return YES; //wが6の時はtは1まで
    if (doubleCount == 7 && tripleCount > 1) return YES; //wが7の時はtは1まで
    if (doubleCount == 8 && tripleCount > 0) return YES; //wが8の時はtは0まで
    
    return NO;
}

//シングル or マルチ選択画面に戻る前に警告
- (void)goBack
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                    message:@"前画面に戻ると現在の選択状態が破棄されますが、よろしいですか？"
                                                   delegate:self
                                          cancelButtonTitle:@"いいえ"
                                          otherButtonTitles:@"はい", nil];
    alert.delegate = self;
    [alert show];
}

//はいが押されたらシングル or マルチ選択画面に戻る
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex) [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


@end
