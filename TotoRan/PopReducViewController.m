//
//  PopReducViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/31.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "PopReducViewController.h"

#define CHECKLABELRECT CGRectMake(5, 5, 150, 30)
#define WIDTH_BASE 5.0

enum {ZERO, TOTO, BOOK};
enum {ZEROCOUNT, SDCOUNT};

@interface PopReducViewController ()

@end

@implementation PopReducViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //背景は白
    self.view.backgroundColor = [UIColor whiteColor];
    
    //縁取り
    self.view.layer.borderWidth = 2;
    self.view.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //７掛けよ用にオリジナルの枠を取得
    CGRect original = self.view.frame;
    
    //75%に縮小
    CGRect new = CGRectMake(original.origin.x,
                            original.origin.y,
                            original.size.width * 0.75,
                            original.size.height * 0.70);
    
    // 新しい枠をセットする
    self.view.frame = new;
    
    //ゼロ個数用のチェックボックスの題目ラベル
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CHECKLABELRECT];
    checkLabel.text = @"◆ドロー(0)の数で絞る";
    [checkLabel sizeToFit];
    
    [self.view addSubview:checkLabel];
    
    //ゼロ個数用のチェックボックス生成
    float widthBase = WIDTH_BASE;
    float heightBase = 30;
    for (int i = 0; i < [self.checkArray[ZERO][ZEROCOUNT] intValue] + 1; i++) {
        [self checkBoxMake:[NSString stringWithFormat:@"%d", i]
                      rect:CGRectMake(widthBase, heightBase, (self.view.bounds.size.width / 5), 30)
                       tag:i + 100
                   checked:[self.checkBoolArray[ZERO][i] boolValue]];
        widthBase += (self.view.bounds.size.width / 5);
        if (i == 4 && [self.checkArray[ZERO][ZERO] intValue] >= 5) {
            widthBase = WIDTH_BASE;
            heightBase += 30;
        }
        //ゼロの個数は９個(0~9の10パターン)まで対応
        if (i == 9) break;
    }
    
    //チェックボックスが一種類しかない場合enabledをfalseにする
    if (([self.checkArray[ZERO][ZERO] intValue]) == 0) {
        CTCheckbox *totoBox = (CTCheckbox *)[self.view viewWithTag:100];
        totoBox.enabled = NO;
        [totoBox setCheckboxColor:[UIColor lightGrayColor]];
        totoBox.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    //ドローシングル枠の数だけenabledをfalseにする
    for (int i = 0; i < [self.checkArray[ZERO][SDCOUNT] intValue] + 1; i++) {
        CTCheckbox *totoBox = (CTCheckbox *)[self.view viewWithTag:100+i];
        totoBox.enabled = NO;
        [totoBox setCheckboxColor:[UIColor lightGrayColor]];
        totoBox.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    //大文字判定用のチェックボックスの題目ラベル
    heightBase += 50;
    UILabel *totoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightBase, 150, 30)];
    totoLabel.text = @"◆大文字判定で絞る";
    [totoLabel sizeToFit];
    
    [self.view addSubview:totoLabel];
    
    //大文字判定用のチェックボックス生成
    widthBase = WIDTH_BASE;
    heightBase += 20;
    for (int i = 0; i < [self.checkArray[TOTO] count]; i++) {
        [self checkBoxMake:self.checkArray[TOTO][i]
                      rect:CGRectMake(widthBase, heightBase, self.view.bounds.size.width / 5, 30)
                       tag:i + 200
                   checked:[self.checkBoolArray[TOTO][i] boolValue]];
        widthBase += self.view.bounds.size.width / 5;
        if (i == 4 && [self.checkArray[TOTO] count] >= 6) {
            widthBase = WIDTH_BASE;
            heightBase += 30;
        }
    }
    
    //チェックボックスが一種類しかない場合enabledをfalseにする
    if ([self.checkArray[TOTO] count] == 1) {
        CTCheckbox *totoBox = (CTCheckbox *)[self.view viewWithTag:200];
        totoBox.enabled = NO;
        [totoBox setCheckboxColor:[UIColor lightGrayColor]];
        totoBox.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    //bODDSの処理
    if ([self.checkArray[BOOK] count] > 0) {
        //小文字判定用のチェックボックスの題目ラベル
        heightBase += 50;
        UILabel *bookLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightBase, 150, 30)];
        bookLabel.text = @"◆小文字判定で絞る";
        [bookLabel sizeToFit];
        
        [self.view addSubview:bookLabel];
        
        //小さい文字判定用のチェックボックス生成
        widthBase = WIDTH_BASE;
        heightBase += 20;
        for (int i = 0; i < [self.checkArray[BOOK] count]; i++) {
            [self checkBoxMake:self.checkArray[BOOK][i]
                          rect:CGRectMake(widthBase, heightBase, self.view.bounds.size.width / 5, 30)
                           tag:i + 300
                       checked:[self.checkBoolArray[BOOK][i] boolValue]];
            widthBase += self.view.bounds.size.width / 5;
            if (i == 4) {
                widthBase = WIDTH_BASE;
                heightBase += 30;
            }
            
        }
        
        //チェックボックスが一種類しかない場合enabledをfalseにする
        if ([self.checkArray[BOOK] count] == 1) {
            CTCheckbox *totoBox = (CTCheckbox *)[self.view viewWithTag:300];
            totoBox.enabled = NO;
            [totoBox setCheckboxColor:[UIColor lightGrayColor]];
            totoBox.textLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
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

//チェックボックス生成メソッド
- (void)checkBoxMake:(NSString *)name rect:(CGRect)rect tag:(int)tag checked:(BOOL)checked
{
    CTCheckbox *box = [CTCheckbox new];
    box.frame = rect;
    box.tag = tag;
    box.textLabel.text = name;
    box.checked = checked;
    [box addTarget:self action:@selector(boxChecked:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:box];
}

//チェックボックスが押されたらチェック状態把握BOOLArrayの値を変更
- (void)boxChecked:(CTCheckbox *)box
{
    if (100 <= box.tag && box.tag <= 109) {
        BOOL checkStatus = [self.checkBoolArray[ZERO][box.tag - 100] boolValue];
        checkStatus = !checkStatus;
        self.checkBoolArray[ZERO][box.tag - 100] = [NSNumber numberWithBool:checkStatus];
    } else if ((200 <= box.tag && box.tag <= 206)) {
        BOOL checkStatus = [self.checkBoolArray[TOTO][box.tag - 200] boolValue];
        checkStatus = !checkStatus;
        self.checkBoolArray[TOTO][box.tag - 200] = [NSNumber numberWithBool:checkStatus];
    } else {
        BOOL checkStatus = [self.checkBoolArray[BOOK][box.tag - 300] boolValue];
        checkStatus = !checkStatus;
        self.checkBoolArray[BOOK][box.tag - 300] = [NSNumber numberWithBool:checkStatus];
    }
    
}

////チェックボックスの内容をBOOL対応Arrayに反映　｜｜　上のメソッドよりこっちで一括したほうがいいかと思ったけどとりまやめとこ
//- (void)viewWillDisappear:(BOOL)animated{}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}


@end
