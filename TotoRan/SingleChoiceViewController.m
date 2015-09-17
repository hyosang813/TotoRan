//
//  SingleChoiceViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/04.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "SingleChoiceViewController.h"

#define WIDTH self.view.bounds.size.width

#define SIXPLUS_HEIGHT 700 //6+の画面高さを基準にする
#define BUTTON_HEIGHT 41.75 //ボタンの高さ
#define BUTTON_INTERVAL 5 //ボタンの間隔
#define TAG_INCREMENT 87 //tagの桁数増やし用
#define BASE_POINT 10 //起点
#define TAG_BASE 101 //tagの起点(101)
#define CLEAR_WIDTH 200 //選択解除ボタンwidth
#define CLEAR_HEIGHT 50 //選択解除ボタンheight

@interface SingleChoiceViewController ()

@end

@implementation SingleChoiceViewController
{
    SystemSoundID buttonSound; //ボタンの効果音
    SystemSoundID eraseButtonSound; //全消去ボタンの効果音
    AppDelegate *appDelegate; //情報取得用
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //画面タイトルを設定
    self.title = @"シングル選択";
    
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
    [clearButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"nomal.png"] forState:UIControlStateNormal];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"nomal.png" ] forState:UIControlStateSelected];
    [clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 2]];
    //縁取り
    [[clearButton layer] setBorderColor:[[UIColor blueColor] CGColor]]; // 枠線の色
    [[clearButton layer] setBorderWidth:1.0]; // 枠線の太さ
    [self.view addSubview:clearButton];

}


//ボタン生成メソッド
- (void)makeButton:(int)tag buttonRect:(CGRect)buttonRect teamName:(NSString *)teamName
{
    UIButton *button = [[UIButton alloc] initWithFrame:buttonRect];
    [button setTitle:teamName forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nomal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"select_single.png" ] forState:UIControlStateSelected];
    button.tag = tag;
    [button addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchDown];
    [button.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 2]];
    //縁取り
    [[button layer] setBorderColor:[[UIColor blueColor] CGColor]]; // 枠線の色
    [[button layer] setBorderWidth:1.0]; // 枠線の太さ
    [self.view addSubview:button];
}

//ラジオボタン
- (void)toggle:(UIButton *)button
{
    //自分自身はトグル
    button.selected = !button.selected;
    
    //トグルに合わせて文字色を変更(青か白)
    if (button.selected) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    //自分の仲間の選択があれば解除するために下二桁を取得(下二桁が同一)
    NSString *tagSuffixString = [[NSString stringWithFormat:@"%ld", (long)button.tag] substringFromIndex:1];
    int tagNum = tagSuffixString.intValue + 100;
    
    //お仲間を探すために３回ループ
    for (int i = tagNum; i < 314; i = i + 100) {
        //自分自身じゃ無いボタンを非選択状態にする
        if (i != button.tag) {
            UIButton *targetButton = (UIButton *)[self.view viewWithTag:i];
            targetButton.selected = NO;
            [targetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }
    
    //効果音
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
            [targetButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
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
    //次の画面へボタンの選択状態を伝えるためにUiButtonを格納した２次元Arrayを作成
    NSMutableArray *arrayParent = [NSMutableArray array];
    
    int tag = TAG_BASE; //tag
    int choiceCountCheck = 0; //全て選択されてたらランダム不要だよね
    for (int i = 0; i < 13; i++) {
        NSMutableArray *arrayChiled = [NSMutableArray array];
        for (int j = 0; j < 3; j++) {
            UIButton *targetButton = (UIButton *)[self.view viewWithTag:tag];
            [arrayChiled addObject:targetButton];
            tag = tag + 100;
            if (targetButton.selected) choiceCountCheck++;
        }
        [arrayParent addObject:arrayChiled];
        tag = tag - 299;
    }

    //全て選択されてたらランダム不要だよね
    if (choiceCountCheck == 13) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"もうその組み合わせで買えば？"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    
    SingleDetailsViewController *sdvc = [SingleDetailsViewController new];
    // Tab bar を非表示
    sdvc.hidesBottomBarWhenPushed = YES;
    
    //次の画面へUiButtonの二次元Arrayを受け渡し
    sdvc.buttonArray = arrayParent;

    [self.navigationController pushViewController:sdvc animated:YES];
}

//シングル or マルチ選択画面に戻る
- (void)goBack
{
    //選択画面で何も選択されてなかったら警告無しで戻しちゃっていいんじゃね？
    
    
    
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
