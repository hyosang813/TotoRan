//
//  MultiResultViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "MultiResultViewController.h"

#define TEXTVIEW_RECT CGRectMake(20, 70, self.view.bounds.size.width - 40 , (self.view.bounds.size.height / 10) * 5)

//#define BTNRECT_RDC CGRectMake(self.view.bounds.size.width / 2 - 75, (self.view.bounds.size.height / 10) * 7, 150, 30)
//#define BTNRECT_POP CGRectMake(self.view.bounds.size.width / 2 - 75, (self.view.bounds.size.height / 10) * 7.5, 150, 30)
//#define BTNRECT_COPY CGRectMake(self.view.bounds.size.width / 2 - 75, (self.view.bounds.size.height / 10) * 8, 150, 30)

#define BTNRECT_RDC CGRectMake((self.view.bounds.size.width / 4) / 4, (self.view.bounds.size.height / 10) * 7, self.view.bounds.size.width / 4, self.view.bounds.size.height / 15)
#define BTNRECT_POP CGRectMake(((self.view.bounds.size.width / 4) / 4) * 2 + (self.view.bounds.size.width / 4), (self.view.bounds.size.height / 10) * 7, self.view.bounds.size.width / 4, self.view.bounds.size.height / 15)
#define BTNRECT_COPY CGRectMake(((self.view.bounds.size.width / 4) / 4) * 3 + ((self.view.bounds.size.width / 4) * 2), (self.view.bounds.size.height / 10) * 7, self.view.bounds.size.width / 4, self.view.bounds.size.height / 15)

#define TOTOHANTEI 13
#define BOOKHANTEI 15

@interface MultiResultViewController ()

@end

@implementation MultiResultViewController
{
    NSMutableArray *zeroCountArray; //ゼロの数とシングルドローの枠数格納用
    NSMutableArray *totoHanteiCategory; //判定結果の対象英字
    NSMutableArray *bookHanteiCategory; //判定結果の対象英字
    NSMutableArray *zeroCountBool; //ゼロの数(BOOL)
    NSMutableArray *totoHanteiCategoryBool; //判定結果の対象英字(BOOL)
    NSMutableArray *bookHanteiCategoryBool; //判定結果の対象英字(BOOL)
    UITextView *resultView; //結果表示のテキストビュー
    AppDelegate *appDelegate; //デリゲート
    NADView * nadView; //NEND広告ビュー
}

//初期化
- (instancetype)init
{
    self = [super init];
    if (self) {
        //プチ削減用二次元Arrayの初期化
        self.reductArray = [NSMutableArray array];
        zeroCountArray = [NSMutableArray array];
        totoHanteiCategory = [NSMutableArray array];
        bookHanteiCategory = [NSMutableArray array];
        
        [self.reductArray addObject:zeroCountArray];
        [self.reductArray addObject:totoHanteiCategory];
        [self.reductArray addObject:bookHanteiCategory];
        
        //プチ削減用二次元Arrayの初期化（対応BOOL）
        self.reductBoolArray = [NSMutableArray array];
        zeroCountBool = [NSMutableArray array];
        totoHanteiCategoryBool = [NSMutableArray array];
        bookHanteiCategoryBool = [NSMutableArray array];
        
        [self.reductBoolArray addObject:zeroCountBool];
        [self.reductBoolArray addObject:totoHanteiCategoryBool];
        [self.reductBoolArray addObject:bookHanteiCategoryBool];
        
        //デリゲート取得
        appDelegate = [[UIApplication sharedApplication] delegate];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"マルチ結果";
    
    //戻るボタンをカスタマイズ
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //テキストビューを配置
    resultView = [[UITextView alloc] initWithFrame:TEXTVIEW_RECT];
    resultView.textAlignment = NSTextAlignmentCenter;
    resultView.editable = NO;
    resultView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0); //よくわからん余白を消すため
    resultView.font = [UIFont fontWithName:@"Courier" size:appDelegate.fontSize + 5];
    resultView.layer.borderWidth = 2;
    resultView.layer.borderColor = [[UIColor blackColor] CGColor];
    resultView.scrollEnabled = NO;
    [self.view addSubview:resultView];
    
    //各ボタンを配置
    UIButton *reducBtn = [self makeButton:@"プチ削減" frame:BTNRECT_RDC sel:@selector(popupReduction)];
    UIButton *popBtn = [self makeButton:@"判定表示"  frame:BTNRECT_POP sel:@selector(popupHanteiView)];
    UIButton *copyBtn = [self makeButton:@"コピー" frame:BTNRECT_COPY sel:@selector(dataCopy)];
    [self.view addSubview:reducBtn];
    [self.view addSubview:popBtn];
    [self.view addSubview:copyBtn];
    
    
    //組み合わせチーム情報を取得
    NSArray *teamArray = appDelegate.teamArray;
    
    //まずは組み合わせチーム名情報の結合
    NSMutableString *teamString = [NSMutableString new];
    int teamCount = 0;
    int zeroCount = 0;
    int drawSingleCount = 0;
    
    for (int i = 0; i < self.randomArray.count; i++) {
        //まずは枠番号を書いてスペース1つ
        [teamString appendString:[NSString stringWithFormat:@"%02d", i + 1]];
        [teamString appendString:@" "];
        
        NSMutableString *teamNameHome = [teamArray[teamCount] mutableCopy];
        //チーム名が１文字と２文字の場合はスペース追加
        if (teamNameHome.length <= 2) [teamNameHome insertString:@"　" atIndex:1];
        if (teamNameHome.length == 2) [teamNameHome insertString:@"　" atIndex:0];
        
        //次はホームチーム書いてスペース2つ
        [teamString appendString:teamNameHome];
        [teamString appendString:@" － "];
        
        NSMutableString *teamNameAway = [teamArray[teamCount + 13] mutableCopy];
        //チーム名が１文字と２文字の場合はスペース追加
        if (teamNameAway.length <= 2) [teamNameAway insertString:@"　" atIndex:1];
        if (teamNameAway.length == 2) [teamNameAway insertString:@"　" atIndex:0];
        
        //次はアウェイチーム書いてスペース
        [teamString appendString:teamNameAway];
        [teamString appendString:@" "];
        
        
        //まずは「[」で囲い始め
        [teamString appendString:@"["];
        
        //ドローだけでシングルの枠はプチ削減対象外にしなきゃいけない
        BOOL drawSingleFlg = NO;
        int drawSingleCountDetail = 0;
        
        //次は枠ごとのランダム結果
        for (int j = 0; j < 3; j++) {
            //nullは[-]に、数値は文字列に変換
            if ([self.randomArray[i][j] isEqual:[NSNull null]]) {
                [teamString appendString:@"-"];
            } else {
                [teamString appendString:[NSString stringWithFormat:@"%d", [self.randomArray[i][j] intValue]]];
                drawSingleCountDetail++;
                //０だったらカウントアップ
                if ([self.randomArray[i][j] intValue] == 0) {
                    zeroCount++;
                    drawSingleFlg = YES;
                }
            }
        }
        
        //この枠がドローシングルだったらカウントアップ
        if (drawSingleFlg && drawSingleCountDetail == 1) drawSingleCount++;
        
        //フラグを初期化
        drawSingleFlg = NO;
        drawSingleCountDetail = 0;
        
        //最後に「]」で囲って改行
        [teamString appendString:@"]"];
        [teamString appendString:@"\n"];
        teamCount++;
    }
    
    //結果表示
    resultView.text = teamString;
    
    //0の数とドローシングル枠数をArrayに追加
    [zeroCountArray addObject:[NSNumber numberWithInt:zeroCount]];
    [zeroCountArray addObject:[NSNumber numberWithInt:drawSingleCount]];
    
    //プチ削減用の判定英字対象チェック
    for (NSArray *arr in self.hanteiDataArray) {
        
        //２個目以降は重複チェック
        if (!(totoHanteiCategory.count > 0 && [totoHanteiCategory containsObject:arr[TOTOHANTEI]])) [totoHanteiCategory addObject:arr[TOTOHANTEI]];
        
        //bODDSデータもあれば同様のロジックで判定種別データ収集
        if (arr.count <= BOOKHANTEI) continue;
        if (!(bookHanteiCategory.count > 0 && [bookHanteiCategory containsObject:arr[BOOKHANTEI]])) [bookHanteiCategory addObject:arr[BOOKHANTEI]];
    }
    
    //プチ削減用に対応BOOLArrayを生成
    for (int i = 0; i < self.reductArray.count; i++) {
        switch (i) {
            case 0:
                for (int j = 0; j <= [self.reductArray[0][i] intValue]; j++) {
                    [zeroCountBool addObject:[NSNumber numberWithBool:YES]];
                }
                break;
            case 1:
                for (int k = 0; k < [self.reductArray[i] count]; k++) {
                    [totoHanteiCategoryBool addObject:[NSNumber numberWithBool:YES]];
                }
                break;
            case 2:
                for (int l = 0; l < [self.reductArray[i] count]; l++) {
                    [bookHanteiCategoryBool addObject:[NSNumber numberWithBool:YES]];
                }
                break;
            default:
                break;
        }
    }
    
    //以下はNEND広告
    //iphone6+の時だけ高さを+10する
    int adHeight = 50;
    if (414.0 <= self.view.bounds.size.width) adHeight += 10;
    nadView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - adHeight, 320, 50) isAdjustAdSize:YES];
    [nadView setIsOutputLog:NO];
    [nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"];
//    [nadView setNendID:@"c8bd9444e4a8061a10c867d45629ce252a17cd82" spotID:@"443087"]; リリース時は上のテストキーと取り替えること！！！！！！！！！！！！！！！！！！！
    nadView.delegate = self;
    [nadView setDelegate:self];
    [nadView load];
    [self.view addSubview:nadView];
}

//NEND広告が何かしらのエラーになった場合は広告枠を表示しない
- (void)nadViewDidFailToReceiveAd:(NADView *)adView {
    nadView.hidden = YES;
}

//ボタン生成
- (UIButton *)makeButton:(NSString *)title frame:(CGRect)frame sel:(SEL)sel
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];

    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    //縁取り
    [[button layer] setBorderColor:[[UIColor blackColor] CGColor]]; // 枠線の色
    [[button layer] setBorderWidth:2.0]; // 枠線の太さ
    [button.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 4]];
    
    return button;
}

//判定結果ポップアップ
- (void)popupHanteiView
{
    PopHanteiViewController *pvc = [PopHanteiViewController new];
    
    //判定データの受け渡し
    pvc.hanteiDataArray = self.hanteiDataArray;
    
    //絞り込み用データの受け渡し
    pvc.checkArray = self.reductArray;
    pvc.checkBoolArray = self.reductBoolArray;
    
    [self presentPopupViewController:pvc animationType:MJPopupViewAnimationFade];
    
}

//プチ削減ポップアップ
- (void)popupReduction
{
    PopReducViewController *prc = [PopReducViewController new];
    
    prc.checkArray = self.reductArray;
    prc.checkBoolArray = self.reductBoolArray;
    
    [self presentPopupViewController:prc animationType:MJPopupViewAnimationFade];
}

//クリップボードにコピー
- (void)dataCopy
{
    //結果に「＃トトラン！」を付与する
    NSString *copyText = [resultView.text stringByAppendingString:@"\n#トトラン！"];
    UIPasteboard *pastebd = [UIPasteboard generalPasteboard];
    [pastebd setValue:copyText forPasteboardType:@"public.utf8-plain-text"];
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"クリップボードに保存しました\n以下のような場所にご使用ください\n・twitter\n・FaceBook\n・某巨大掲示板"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

//戻るボタン押下時の挙動
- (void)goBack:(UIButton *)button
{
    [[[UIAlertView alloc] initWithTitle:@"確認"
                                message:@"前画面に戻ると現在のランダム抽出データが破棄されますが、よろしいですか？"
                               delegate:self
                      cancelButtonTitle:@"いいえ"
                      otherButtonTitles:@"はい", nil] show];
}

// アラートのボタンが押された時に呼ばれるデリゲートメソッド
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            //「いいえ」選択時はなにもしない
            break;
        case 1:
            //「はい」選択時は前画面に戻る
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
