//
//  PopReducViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/31.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "PopReducViewController.h"

#define HEIGHT_BASE 30.0
#define WIDTH_BASE 5.0

enum {HOME, DRAW, AWAY, TOTO, BOOK};
enum {PARTCOUNT, SINGLECOUNT};

@interface PopReducViewController ()

@end

@implementation PopReducViewController
{
    AppDelegate *appDelegate; //デリゲート
    NSMutableArray *internalBoolArray; //移し換える
    float heightBase; // = 30;
    float widthBase; // = WIDTH_BASE;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //背景は白
    self.view.backgroundColor = [UIColor whiteColor];
    
    //縁取り
    self.view.layer.borderWidth = 2;
    self.view.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //デリゲート取得
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    //self.reduceBoolArrayはswiftの型なので、boolArrayに一度移し換える
    internalBoolArray = [NSMutableArray new];
    for (NSArray *boolArray in appDelegate.boolArray){
        NSMutableArray *childBoolArray = [NSMutableArray new];
        for (NSNumber *boolNum in boolArray) {
            [childBoolArray addObject:boolNum];
        }
        [internalBoolArray addObject:childBoolArray];
    }
    
    //７掛けよ用にオリジナルの枠を取得
    CGRect original = self.view.frame;
    
    //75%に縮小
    CGRect new = CGRectMake(original.origin.x,
                            original.origin.y,
                            original.size.width * 0.75,
                            original.size.height);
    
    // 新しい枠をセットする
    self.view.frame = new;
    
    //ベースとなる情報
    heightBase = HEIGHT_BASE;
    widthBase = WIDTH_BASE;
    
    //ホーム、ドロー、アウェイのチェックボックスグループ
    [self homeDrawAwayMake:@"◆ホーム(1)の数で絞る" part:HOME tagBase:100];
    [self homeDrawAwayMake:@"◆ドロー(0)の数で絞る" part:DRAW tagBase:200];
    [self homeDrawAwayMake:@"◆アウェイ(2)の数で絞る" part:AWAY tagBase:300];
    
    //toto、bookのチェックボックスグループ
    [self totoBookMake:@"◆大文字判定で絞る" part:TOTO tagBase:400];
    if ([self.checkArray[BOOK] count] > 0)
        [self totoBookMake:@"◆小文字判定で絞る" part:BOOK tagBase:500];
    
    
    //最終枠描画用にオリジナルの枠を取得
    CGRect originalLast = self.view.frame;
    
    //縮小(サイズは目視調整)
    CGRect newLast = CGRectMake(originalLast.origin.x,
                            originalLast.origin.y,
                            originalLast.size.width,
                            heightBase + 40);
    
    // 新しい枠をセットする
    self.view.frame = newLast;

}

//ホーム、ドロー、アウェイのチェックボックスグループ生成メソッド
- (void)homeDrawAwayMake:(NSString *)title part:(int)part tagBase:(int)tagBase {
    
    //ゼロ個数用のチェックボックスの題目ラベル
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightBase, 150, 30)];
    checkLabel.text = title; //@"◆ドロー(0)の数で絞る";
    [checkLabel sizeToFit];
    [self.view addSubview:checkLabel];
    
    heightBase += 20;
    
    //ゼロ個数用のチェックボックス生成
    float lineBreakCount = 0; //改行が必要なカウント
    for (int i = 0; i < [self.checkArray[part][PARTCOUNT] intValue] + 1; i++) {
        //ドローシングル枠の個数一個前まではチェックボックスを作らない
        if (i < [self.checkArray[part][SINGLECOUNT] intValue]) {
            continue;
        }
        
        //２段目
        if (lineBreakCount == 5) {
            widthBase = WIDTH_BASE;
            heightBase += 30;
        }
        
        //ドローシングル枠の個数と同じチェックボックスはenabledをfalseにする
        if (i == [self.checkArray[part][SINGLECOUNT] intValue]) {
            [self checkBoxMake:[NSString stringWithFormat:@"%d", i]
                          rect:CGRectMake(widthBase, heightBase, (self.view.bounds.size.width / 5), 30)
                           tag:i + tagBase
                       checked:[internalBoolArray[part][i] boolValue]
                         color:[UIColor lightGrayColor]
                        enable:NO
                   enableCpunt:0];
        } else {
            [self checkBoxMake:[NSString stringWithFormat:@"%d", i]
                          rect:CGRectMake(widthBase, heightBase, (self.view.bounds.size.width / 5), 30)
                           tag:i + tagBase
                       checked:[internalBoolArray[part][i] boolValue]
                         color:[UIColor blackColor]
                        enable:YES
                   enableCpunt:0];
        }
        
        widthBase += (self.view.bounds.size.width / 5);
        lineBreakCount++;
        
        //ゼロの個数は９個(0~9の10パターン)まで対応
        if (i == 9) break;
    }

    //最後にheightをインクリメントしてwidthbaseをリセット
    heightBase += 50;
    widthBase = WIDTH_BASE;
}

//toto、bookのチェックボックスグループ生成メソッド
- (void)totoBookMake:(NSString *)title part:(int)part tagBase:(int)tagBase {

    UILabel *totoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightBase, 150, 30)];
    totoLabel.text = title;
    [totoLabel sizeToFit];
    [self.view addSubview:totoLabel];
    
    //小さい文字判定用のチェックボックス生成
    widthBase = WIDTH_BASE;
    heightBase += 20;
    for (int i = 0; i < [self.checkArray[part] count]; i++) {
        [self checkBoxMake:self.checkArray[part][i]
                      rect:CGRectMake(widthBase, heightBase, self.view.bounds.size.width / 5, 30)
                       tag:i + tagBase
                   checked:[internalBoolArray[part][i] boolValue]
                     color:[UIColor blackColor]
                    enable:YES
               enableCpunt:(int)[self.checkArray[part] count]];
        widthBase += self.view.bounds.size.width / 5;
        if (i == 4) {
            widthBase = WIDTH_BASE;
            heightBase += 30;
        }
    }
    
    //最後にheightをインクリメントしてwidthbaseをリセット
    heightBase += 50;
    widthBase = WIDTH_BASE;
}


//チェックボックス生成メソッド
- (void)checkBoxMake:(NSString *)name rect:(CGRect)rect tag:(int)tag checked:(BOOL)checked color:(UIColor *)color enable:(BOOL)enable enableCpunt:(int)enableCount
{
    CTCheckbox *box = [CTCheckbox new];
    box.frame = rect;
    box.tag = tag;
    box.textLabel.text = name;
    box.checked = checked;
    box.enabled = enable;
    [box setCheckboxColor:color];
    box.textLabel.textColor = color;
    
    //もし一個しかなかったら非選択
    if (enableCount == 1) {
        box.enabled = NO;
        [box setCheckboxColor:[UIColor lightGrayColor]];
        box.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    [box addTarget:self action:@selector(boxChecked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:box];
}

//チェックボックスが押されたらチェック状態把握BOOLArrayの値を変更
- (void)boxChecked:(CTCheckbox *)box
{
    if (100 <= box.tag && box.tag <= 109) {
        BOOL checkStatus = [internalBoolArray[HOME][box.tag - 100] boolValue];
        checkStatus = !checkStatus;
        internalBoolArray[HOME][box.tag - 100] = [NSNumber numberWithBool:checkStatus];
    } else if ((200 <= box.tag && box.tag <= 209)) {
        BOOL checkStatus = [internalBoolArray[DRAW][box.tag - 200] boolValue];
        checkStatus = !checkStatus;
        internalBoolArray[DRAW][box.tag - 200] = [NSNumber numberWithBool:checkStatus];
    } else if ((300 <= box.tag && box.tag <= 309))  {
        BOOL checkStatus = [internalBoolArray[AWAY][box.tag - 300] boolValue];
        checkStatus = !checkStatus;
        internalBoolArray[AWAY][box.tag - 300] = [NSNumber numberWithBool:checkStatus];
    } else if ((400 <= box.tag && box.tag <= 409))  {
        BOOL checkStatus = [internalBoolArray[TOTO][box.tag - 400] boolValue];
        checkStatus = !checkStatus;
        internalBoolArray[TOTO][box.tag - 400] = [NSNumber numberWithBool:checkStatus];
    } else {
        BOOL checkStatus = [internalBoolArray[BOOK][box.tag - 500] boolValue];
        checkStatus = !checkStatus;
        internalBoolArray[BOOK][box.tag - 500] = [NSNumber numberWithBool:checkStatus];
    }

}

-(void)viewDidDisappear:(BOOL)animated
{
    //BoolArray情報をデリゲートに送信
    appDelegate.boolArray = internalBoolArray;
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


@end
