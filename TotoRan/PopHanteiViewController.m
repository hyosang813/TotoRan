//
//  PopupViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/28.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "PopHanteiViewController.h"

#define TEXTVIEW_RECT CGRectMake(5, 5, self.view.bounds.size.width - 10, self.view.bounds.size.height - 100)
#define BTNRECT_COPY CGRectMake(self.view.bounds.size.width / 2 - 75, self.view.bounds.size.height - 75, 150, 50)

enum {HOME, DRAW, AWAY, TOTO, BOOK};

@interface PopHanteiViewController ()

@end

@implementation PopHanteiViewController
{
    NSMutableArray *drawArray; //絞り込みドロー数Array
    NSMutableString *resultString; //最終的に表示する文字列
    AppDelegate *appDelegate; //デリゲート
    UITextView *resultView; //テキストビュー
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //デリゲート取得
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    //BoolArray情報をデリゲートから取得
    self.checkBoolArray = appDelegate.boolArray;
    
    //背景は黄色
    self.view.backgroundColor = [UIColor yellowColor];
    
    //結果文字列に変換
    resultString = [NSMutableString new];

    int reduceCount = 0;
    for (NSArray *arr in self.hanteiDataArray) {
        //絞り込み対象かどうかを判定
        if ([self decDisplayTarget:arr]) continue;
        //絞り込み対象じゃなかった場合は最終的に削減数を表示するためのカウントアップ
        reduceCount++;
        
        for (int i = 0; i < arr.count; i++) {
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
    
    //条件に合致したデータがない場合はボタン選択できなくする
    BOOL dataNothing = YES;
    
    //プチ削減しすぎて結果が０件だった場合はメッセージ追加
    if (resultString.length > 0) {
        [resultString appendString:@"\n"];
        [resultString appendString:[NSString stringWithFormat:@"削減前:%d口\n削減後:%d口\n\n", (int)self.hanteiDataArray.count, reduceCount]];
        [resultString appendString:[dbControll returnGetRateTime]];
        dataNothing = NO;
    } else {
        resultString = [@"条件に合致するデータ無し\n" mutableCopy];
    }
    
    //70%縮小サイズのheightと大体の必要heightを取得
    float seventhHeight = self.view.bounds.size.height * 0.70;
    float maxHeight = 150 + ((appDelegate.fontSize - 1) * 1.65) * reduceCount + ((appDelegate.fontSize - 1) * 2);
    
    //元のサイズに７掛けしたサイズより小さい場合は高さを低く調整する
    if (seventhHeight > maxHeight) seventhHeight = maxHeight;
    

    // オリジナルの枠を取得
    CGRect original = self.view.frame;
    
    //75%に縮小
    CGRect new = CGRectMake(original.origin.x,
                            original.origin.y,
                            original.size.width * 0.75,
                            seventhHeight);
    
    // 新しい枠をセットする
    self.view.frame = new;

    //テキストビューを配置
    resultView = [[UITextView alloc] initWithFrame:TEXTVIEW_RECT];
    resultView.editable = NO;
    resultView.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0); //よくわからん余白を消すため
    resultView.font = [UIFont fontWithName:@"Courier" size:(appDelegate.fontSize - 3)];
    resultView.layer.borderWidth = 2;
    resultView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.view addSubview:resultView];
    
    //結果表示
    resultView.text = resultString;
    
    //データ保存ボタンを配置
    UIButton *copyBtn = [[UIButton alloc] initWithFrame:BTNRECT_COPY];
    [copyBtn setTitle:@"コピー" forState:UIControlStateNormal];
    if (dataNothing) {
        [copyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [copyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        //縁取り
        [[copyBtn layer] setBorderColor:[[UIColor lightGrayColor] CGColor]]; // 枠線の色
    } else {
        [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [copyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [copyBtn addTarget:self action:@selector(dataCopy) forControlEvents:UIControlEventTouchUpInside];
        //縁取り
        [[copyBtn layer] setBorderColor:[[UIColor blackColor] CGColor]]; // 枠線の色
    }
    [[copyBtn layer] setBorderWidth:2.0]; // 枠線の太さ
    [copyBtn.titleLabel setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 8]];
    [self.view addSubview:copyBtn];
    
    
    //可変ドロー数のArrayを解放
    [drawArray removeAllObjects];
}

//絞り込み対象判定結果返却メソッド
- (BOOL)decDisplayTarget:(NSArray *)arr
{
    //それぞれの数を数えましょう
    int homeCount = 0;
    int drawCount = 0;
    int awayCount = 0;
    for (int i = 0; i < 13; i++) {
        switch ([arr[i] intValue]) {
            case 1:
                homeCount++;
                break;
            case 0:
                drawCount++;
                break;
            case 2:
                awayCount++;
                break;
            default:
                break;
        }
    }

    if (![self.checkBoolArray[HOME][homeCount] boolValue]) return YES; //この1の数は表示対象かな？
    if (![self.checkBoolArray[DRAW][drawCount] boolValue]) return YES; //この0の数は表示対象かな？
    if (![self.checkBoolArray[AWAY][awayCount] boolValue]) return YES; //この2の数は表示対象かな？
    
    //次は該当する判定対象(大文字)は表示対象かな？
    int boolIndexToto = (int)[self.checkArray[TOTO] indexOfObject:arr[13]];
    if (![self.checkBoolArray[TOTO][boolIndexToto] boolValue]) return YES;
    
    //bODDSデータはあるかな？
    if ([self.checkArray[BOOK] count] > 0) {
        //次は該当する判定対象(小文字)は表示対象かな？
        int boolIndexBook = (int)[self.checkArray[BOOK] indexOfObject:arr[15]];
        if (![self.checkBoolArray[BOOK][boolIndexBook] boolValue]) return YES;
    }
    
    //NOなら表示対象です
    return NO;
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

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
