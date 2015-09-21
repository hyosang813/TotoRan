//
//  SingleResultViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/03.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "SingleResultViewController.h"

#define TEXTVIEW_RECT CGRectMake(20, 70, self.view.bounds.size.width - 40 , (self.view.bounds.size.height / 10) * 5)
#define BTNRECT_COPY CGRectMake(self.view.bounds.size.width / 2 - ((self.view.bounds.size.width / 3) / 2), (self.view.bounds.size.height / 10) * 7, self.view.bounds.size.width / 3, self.view.bounds.size.height / 13)

@interface SingleResultViewController ()

@end

@implementation SingleResultViewController
{
    UITextView *resultView; //結果表示テキストビュー
    AppDelegate *appDelegate; //デリゲート
    NADView * nadView; //NEND広告ビュー
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = @"シングル結果";
    
    //デリゲート取得
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //戻るボタンをカスタマイズ
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //テキストビューを配置
    resultView = [[UITextView alloc] initWithFrame:TEXTVIEW_RECT];
    resultView.editable = NO;
    resultView.contentInset = UIEdgeInsetsMake(-65, 0, 0, 0); //よくわからん余白を消すため
    resultView.font = [UIFont fontWithName:@"Courier" size:appDelegate.fontSize];
    resultView.layer.borderWidth = 2;
    resultView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:resultView];
    
    //データ保存ボタンを配置
    UIButton *copyBtn = [[UIButton alloc] initWithFrame:BTNRECT_COPY];
    [copyBtn setTitle:@"コピー" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [copyBtn addTarget:self action:@selector(dataCopy) forControlEvents:UIControlEventTouchUpInside];
    //縁取り
    [[copyBtn layer] setBorderColor:[[UIColor blackColor] CGColor]]; // 枠線の色
    [[copyBtn layer] setBorderWidth:2.0]; // 枠線の太さ
    [copyBtn.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 8]];
    [self.view addSubview:copyBtn];
    
    //結果文字列に変換
    NSMutableString *resultString = [NSMutableString new];
    for (NSArray *arr in self.hanteiDataArray) {
        for (int i = 0; i < arr.count; i++) {;
            //数値だった時は文字列に変換
            if ([arr[i] isKindOfClass:[NSNumber class]]) {
                [resultString appendString:[NSString stringWithFormat:@"%d", [arr[i] intValue]]];
            } else {
                [resultString appendString:arr[i]];
            }
            
            //5個目と10個目にスペース追加(bODDSがあればその間もスペース)
            if (i == 4 || i == 9 || i == 12 || i == 14) [resultString appendString:@" "];
        }
        //改行
        [resultString appendString:@"\n"];
    }
    
    //DBからら現在開催回を取得してそれをキーに支持率取得日時の文字列を取得
    ControllDataBase *dbControll = [ControllDataBase new];
    [resultString appendString:@"\n"];
    [resultString appendString:[dbControll returnGetRateTime]];
    
    //結果表示
    resultView.text = resultString;
    
    //以下はNEND広告
    //iphone6+の時だけ高さを+10する
    int adHeight = 50;
    if (414.0 <= self.view.bounds.size.width) adHeight += 10;
    nadView = [[NADView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - adHeight, 320, 50) isAdjustAdSize:YES];
    [nadView setIsOutputLog:NO];
//    [nadView setNendID:@"a6eca9dd074372c898dd1df549301f277c53f2b9" spotID:@"3172"];
    [nadView setNendID:@"c8bd9444e4a8061a10c867d45629ce252a17cd82" spotID:@"443087"];
    nadView.delegate = self;
    [nadView setDelegate:self];
    [nadView load];
    [self.view addSubview:nadView];
}

//NEND広告が何かしらのエラーになった場合は広告枠を表示しない
- (void)nadViewDidFailToReceiveAd:(NADView *)adView {
    nadView.hidden = YES;
}

//クリップボードにコピー
- (void)dataCopy
{
    //結果に「＃トトラン！」を付与する
    NSString *copyText = [resultView.text stringByAppendingString:@"\n\n#トトラン！"];
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
