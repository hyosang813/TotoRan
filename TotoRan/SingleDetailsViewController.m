//
//  SingleDetailsViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/01.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "SingleDetailsViewController.h"

#define MAX_COUNT 13

//#define HYOUDAI_LABEL_RECT CGRectMake(15, 70, 280, 40)
//#define HOME_LABEL_RECT CGRectMake(30, 115, 160, 35)
//#define DRAW_LABEL_RECT CGRectMake(30, 155, 160, 35)
//#define AWAY_LABEL_RECT CGRectMake(30, 195, 160, 35)
//#define UNIT_LABEL_RECT CGRectMake(15, 240, 70, 35)
//
//#define HOME_TXTFLD_RECT CGRectMake(195, 115, 60, 35)
//#define DRAW_TXTFLD_RECT CGRectMake(195, 155, 60, 35)
//#define AWAY_TXTFLD_RECT CGRectMake(195, 195, 60, 35)
//#define UNIT_TXTFLD_RECT CGRectMake(90, 240, 60, 35)
//
//#define HOME_LABEL_IJOU_RECT CGRectMake(260, 115, 50, 35)
//#define DRAW_LABEL_IJOU_RECT CGRectMake(260, 155, 50, 35)
//#define AWAY_LABEL_IJOU_RECT CGRectMake(260, 195, 50, 35)

#define HYOUDAI_LABEL_RECT CGRectMake(15, 70, (self.view.bounds.size.width / 8) * 7, self.view.bounds.size.height / 12)
#define HOME_LABEL_RECT CGRectMake(30, (self.view.bounds.size.height / 12) * 1 + 70, (self.view.bounds.size.width / 8) * 4, self.view.bounds.size.height / 12)
#define DRAW_LABEL_RECT CGRectMake(30, (self.view.bounds.size.height / 12) * 2 + 70 + 5, (self.view.bounds.size.width / 8) * 4, self.view.bounds.size.height / 12)
#define AWAY_LABEL_RECT CGRectMake(30, (self.view.bounds.size.height / 12) * 3 + 70 + 10, (self.view.bounds.size.width / 8) * 4, self.view.bounds.size.height / 12)
#define UNIT_LABEL_RECT CGRectMake(15, (self.view.bounds.size.height / 12) * 4 + 70 + 20, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)

#define HOME_TXTFLD_RECT CGRectMake((self.view.bounds.size.width / 8) * 4 + 30, (self.view.bounds.size.height / 12) * 1 + 70, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)
#define DRAW_TXTFLD_RECT CGRectMake((self.view.bounds.size.width / 8) * 4 + 30, (self.view.bounds.size.height / 12) * 2 + 70 + 5, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)
#define AWAY_TXTFLD_RECT CGRectMake((self.view.bounds.size.width / 8) * 4 + 30, (self.view.bounds.size.height / 12) * 3 + 70 + 10, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)
#define UNIT_TXTFLD_RECT CGRectMake((self.view.bounds.size.width / 8) * 1.5 + 20, (self.view.bounds.size.height / 12) * 4 + 70 + 20, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)

#define HOME_LABEL_IJOU_RECT CGRectMake((self.view.bounds.size.width / 8) * 5.5 + 35, (self.view.bounds.size.height / 12) * 1 + 70, (self.view.bounds.size.width / 8), self.view.bounds.size.height / 12)
#define DRAW_LABEL_IJOU_RECT CGRectMake((self.view.bounds.size.width / 8) * 5.5 + 35, (self.view.bounds.size.height / 12) * 2 + 70 + 5, (self.view.bounds.size.width / 8), self.view.bounds.size.height / 12)
#define AWAY_LABEL_IJOU_RECT CGRectMake((self.view.bounds.size.width / 8) * 5.5 + 35, (self.view.bounds.size.height / 12) * 3 + 70 + 10, (self.view.bounds.size.width / 8), self.view.bounds.size.height / 12)
#define UNIT_NUM_RECT CGRectMake((self.view.bounds.size.width / 8) * 3 + 25, (self.view.bounds.size.height / 12) * 4 + 70 + 20, (self.view.bounds.size.width / 8) * 0.5, self.view.bounds.size.height / 12)

#define DEFAULT_TOOLBAR_RECT CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 38.0f)
#define ENABLED_TOOLBAR_RECT CGRectMake(0, self.view.bounds.size.height - 180, self.view.bounds.size.width, 38.0f)

#define DEFAULT_PICKER_RECT CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 162)
#define ENABLED_PICKER_RECT CGRectMake(0, self.view.bounds.size.height - 162, self.view.bounds.size.width, 162);


enum {HOME_TEXT = 101, DRAW_TEXT, AWAY_TEXT, UNIT_TEXT}; //テキストフィールドのtag
enum {HOME_PICKER = 201, DRAW_PICKER, AWAY_PICKER, UNIT_PICKER}; //ピッカービューのtag
enum {LABEL_IJOU_HOME = 301, LABEL_IJOU_DRAW, LABEL_IJOU_AWAY};


@interface SingleDetailsViewController ()
@end

@implementation SingleDetailsViewController
{
    int homeCount; //ホーム(1)の数
    int drawCount; //ドロー(0)の数
    int awayCount; //アウェイ(2)の数
    int unitMax; //口数の最大数
    int toolBarnum; //直前に選択されたピッカー記憶用
//    int maxCount;  //選択できる最大数
    
    NSArray *homePickerArray; //ホームのピッカーラベル
    NSArray *drawPickerArray; //ドローのピッカーラベル
    NSArray *awayPickerArray; //アウェイのピッカーラベル
    NSArray *unitPickerArray; //口数のピッカーラベル
    
    UITextField *homeCountTextField; //ホーム数表示のテキストフィールド
    UITextField *drawCountTextField; //ドロー数表示のテキストフィールド
    UITextField *awayCountTextField; //アウェイ数表示のテキストフィールド
    
    UIPickerView *homeCountPicker; //ホーム数選択ピッカービュー
    UIPickerView *drawCountPicker; //ドロー数選択ピッカービュー
    UIPickerView *awayCountPicker; //アウェイ数選択ピッカービュー
    
    UITextField *unitCountTextField; //口数表示のテキストフィールド
    UIPickerView *unitCountPicker;   //口数選択ピッカービュー
    
    UIToolbar *pickerToolBar; //「OK」ボタンのついたツールバー
    
    NSMutableArray *tapArray;  //タップされた値(NSNumber)を格納するArray
//    NSMutableArray *randArray; //ランダムに抽出された各数を格納するArray
    NSMutableArray *tapCountArray; //タップされたホーム、ドロー、アウェイ、nullのそれぞれの数を格納
    NSMutableArray *pickerCountArray; //ピッカーで選択されたホーム、ドロー、アウェイのそれぞれの数を格納
    
    AppDelegate *appDelegate; //情報取得用
}

//初期化
- (instancetype)init
{
    self = [super init];
    if (self) {
        //インスタンス変数の初期化
        homeCount = 0;
        drawCount = 0;
        awayCount = 0;
        unitMax = 10;
        toolBarnum = 0;
        
        //デリゲート取得
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= @"シングル条件指定";
    self.view.backgroundColor = [UIColor yellowColor];

    //結果画面への遷移ボタンを生成　navigationBarの右側ボタン
    UIBarButtonItem *pushButton = [[UIBarButtonItem alloc] initWithTitle:@"判定" style:UIBarButtonItemStyleBordered target:self action:@selector(push:)];
    self.navigationItem.rightBarButtonItem = pushButton;
    
    //戻るボタンをカスタマイズ
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    

    
    //選択されてない枠が１個(３パターン)か２個(９パターン)の場合を想定
    int rareCaseCount = 0;
    
    //選択画面で選択されたそれぞれの数を格納
    tapArray = [NSMutableArray array];
    
    for (NSArray *ary in self.buttonArray) {
        int nonSelectedCount = 0;
        for (UIButton *btn in ary) {
            if (btn.selected) {
                int dispatchNum = (int)btn.tag - 14;
                if (dispatchNum < 100) {
                    [tapArray addObject:[NSNumber numberWithInt:1]];
                    homeCount++;
                } else if (100 < dispatchNum && dispatchNum < 200) {
                    [tapArray addObject:[NSNumber numberWithInt:0]];
                    drawCount++;
                } else {
                    [tapArray addObject:[NSNumber numberWithInt:2]];
                    awayCount++;
                }
                rareCaseCount++;
                break;
            } else {
                nonSelectedCount++;
                if (nonSelectedCount == 3) {
                    [tapArray addObject:[NSNull null]];
                    nonSelectedCount = 0;
                    break;
                }
            }
        }
    }
    
    //タップされたそれぞれの数を格納
    tapCountArray = [NSMutableArray array];
    [tapCountArray addObject:[NSNumber numberWithInt:homeCount]];
    [tapCountArray addObject:[NSNumber numberWithInt:drawCount]];
    [tapCountArray addObject:[NSNumber numberWithInt:awayCount]];
    [tapCountArray addObject:[NSNumber numberWithInt:MAX_COUNT - (homeCount + drawCount + awayCount)]];
    
    //口数のmax値を設定
    if (rareCaseCount == 13) {
        unitMax = 1;
    } else if (rareCaseCount == 12) {
        unitMax = 3;
    } else if (rareCaseCount == 11) {
        unitMax = 9;
    }
    
    //各ドラムに表示するセル数用配列の値をセット
    homePickerArray = [self itemSet:homeCount max:MAX_COUNT - (drawCount + awayCount)];
    drawPickerArray = [self itemSet:drawCount max:MAX_COUNT - (homeCount + awayCount)];
    awayPickerArray = [self itemSet:awayCount max:MAX_COUNT - (homeCount + drawCount)];
    unitPickerArray = [self itemSet:1 max:unitMax];
    
    
    //「1,0,2」の数ラベルの配置
    [self makeLabel:HYOUDAI_LABEL_RECT text:@"■「ホーム,ドロー,アウェイ」の数" tag:0]; //大表題
    [self makeLabel:HOME_LABEL_RECT text:@"・「ホーム」の数" tag:0]; //1の数
    [self makeLabel:DRAW_LABEL_RECT text:@"・「ドロー」の数" tag:0]; //2の数
    [self makeLabel:AWAY_LABEL_RECT text:@"・「アウェイ」の数" tag:0]; //3の数
    [self makeLabel:UNIT_LABEL_RECT text:@"■口数" tag:0]; //口数
    
    //「〜以上」ラベルの配置　※「〜口」も
    [self makeLabel:HOME_LABEL_IJOU_RECT text:@"以上" tag:LABEL_IJOU_HOME];
    [self makeLabel:DRAW_LABEL_IJOU_RECT text:@"以上" tag:LABEL_IJOU_DRAW];
    [self makeLabel:AWAY_LABEL_IJOU_RECT text:@"以上" tag:LABEL_IJOU_AWAY];
    [self makeLabel:UNIT_NUM_RECT text:@"口" tag:0];
    
    //テキストフィールド(ピッカービュー)の配置
    homeCountTextField = [self makeTextField:HOME_TXTFLD_RECT tag:HOME_TEXT initial:homeCount]; //1の数
    drawCountTextField = [self makeTextField:DRAW_TXTFLD_RECT tag:DRAW_TEXT initial:drawCount]; //2の数
    awayCountTextField = [self makeTextField:AWAY_TXTFLD_RECT tag:AWAY_TEXT initial:awayCount]; //3の数
    unitCountTextField = [self makeTextField:UNIT_TXTFLD_RECT tag:UNIT_TEXT initial:1]; //口数
    
    [self.view addSubview:homeCountTextField];
    [self.view addSubview:drawCountTextField];
    [self.view addSubview:awayCountTextField];
    [self.view addSubview:unitCountTextField];
    
    homeCountPicker = [self makePicker:HOME_PICKER]; //1の数
    drawCountPicker = [self makePicker:DRAW_PICKER]; //2の数
    awayCountPicker = [self makePicker:AWAY_PICKER]; //3の数
    unitCountPicker = [self makePicker:UNIT_PICKER]; //口数
    
    [self.view addSubview:homeCountPicker];
    [self.view addSubview:drawCountPicker];
    [self.view addSubview:awayCountPicker];
    [self.view addSubview:unitCountPicker];
    
    //ピッカービューの上に「OK」ボタンのついたバーを表示
    pickerToolBar = [[UIToolbar alloc] initWithFrame:DEFAULT_TOOLBAR_RECT];
    pickerToolBar.tintColor = [UIColor whiteColor];
    pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStyleDone target:self action:@selector(hidePicker)];
    [pickerToolBar setItems:@[spaceBarItem, doneBarItem]];
    
    [self.view addSubview:pickerToolBar];
    
    //テキストフィールドのインプットをピッカーに
    homeCountTextField.inputView = homeCountPicker;
    drawCountTextField.inputView = drawCountPicker;
    awayCountTextField.inputView = awayCountPicker;
    unitCountTextField.inputView = unitCountPicker;
    homeCountTextField.inputAccessoryView = pickerToolBar;
    drawCountTextField.inputAccessoryView = pickerToolBar;
    awayCountTextField.inputAccessoryView = pickerToolBar;
    unitCountTextField.inputAccessoryView = pickerToolBar;
}

//ラベル生成メソッド
- (void)makeLabel:(CGRect)labelRect text:(NSString *)text tag:(int)tag
{
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.backgroundColor = [UIColor yellowColor];
    label.text = text;
    label.tag = tag;
    [label setFont:[UIFont systemFontOfSize:appDelegate.fontSize + 3]];

    [self.view addSubview:label];
}

//テキストフィールド生成メソッド
- (UITextField *)makeTextField:(CGRect)textRect tag:(int)tag initial:(int)initial
{
    UITextField *txtfld = [[UITextField alloc] initWithFrame:textRect];
    txtfld.delegate = self;
    txtfld.tag = tag;
    txtfld.backgroundColor = [UIColor whiteColor];
    txtfld.textColor = [UIColor blackColor];
    txtfld.text = [NSString stringWithFormat:@"%d", initial];
    txtfld.textAlignment = NSTextAlignmentCenter;
    txtfld.font = [UIFont systemFontOfSize:appDelegate.fontSize + 3];
    //縁取り
    [[txtfld layer] setBorderColor:[[UIColor blackColor] CGColor]]; // 枠線の色
    [[txtfld layer] setBorderWidth:2.0]; // 枠線の太さ
    
    return txtfld;
}

//ピッカービュー生成メソッド
- (UIPickerView *)makePicker:(int)tag
{
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:DEFAULT_PICKER_RECT];
    picker.delegate = self;
    picker.dataSource = self;
    picker.tag = tag;
    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor whiteColor];
    
    return picker;
}

//ピッカービューの表示文字列の配列セットメソッド
- (NSArray *)itemSet:(int)inital max:(int)max
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = inital; i <= max; i++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    return array;
}


//テキストフィールドタップ時にキーボードを出さ無いメソッド
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showPicker:(int)textField.tag];
    return NO;
}

//該当のピッカービューを出す
- (void)showPicker:(int)tag {
    
    //tagで該当するテキストフィールド(ピッカービュー)をセット　選択されたピッカー以外は隠す
    UIPickerView *picker = nil;
    UIPickerView *hidePicker1 = nil;
    UIPickerView *hidePicker2 = nil;
    UIPickerView *hidePicker3 = nil;
    
    switch (tag) {
        case HOME_TEXT:
            picker = homeCountPicker;
            hidePicker1 = drawCountPicker;
            hidePicker2 = awayCountPicker;
            hidePicker3 = unitCountPicker;
            break;
        case DRAW_TEXT:
            picker = drawCountPicker;
            hidePicker1 = homeCountPicker;
            hidePicker2 = awayCountPicker;
            hidePicker3 = unitCountPicker;
            break;
        case AWAY_TEXT:
            picker = awayCountPicker;
            hidePicker1 = drawCountPicker;
            hidePicker2 = homeCountPicker;
            hidePicker3 = unitCountPicker;
            break;
        case UNIT_TEXT:
            picker = unitCountPicker;
            hidePicker1 = drawCountPicker;
            hidePicker2 = homeCountPicker;
            hidePicker3 = awayCountPicker;
            break;
        default:
            break;
    }
    
    //直前と違うピッカーが選択された時だけツールバーを一旦しまう
    if (toolBarnum != tag) {
        pickerToolBar.frame = DEFAULT_TOOLBAR_RECT;
    }
    //直前に選択されたピッカーを記憶
    toolBarnum = tag;
    
    // ピッカーが下から出るアニメーション
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    picker.frame = ENABLED_PICKER_RECT;
    hidePicker1.frame = DEFAULT_PICKER_RECT;
    hidePicker2.frame = DEFAULT_PICKER_RECT;
    hidePicker3.frame = DEFAULT_PICKER_RECT;
    pickerToolBar.frame = ENABLED_TOOLBAR_RECT;
    [UIView commitAnimations];
}

//タッチでピッカーをしまう
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self hidePicker];
//}

//ピッカーしまう
- (void)hidePicker {
    // ピッカーが下に隠れるアニメーション
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //ディスパッチが面倒だから全てのピッカーを対象に元に戻しちゃう
    homeCountPicker.frame = DEFAULT_PICKER_RECT;
    drawCountPicker.frame = DEFAULT_PICKER_RECT;
    awayCountPicker.frame = DEFAULT_PICKER_RECT;
    unitCountPicker.frame = DEFAULT_PICKER_RECT;
    pickerToolBar.frame = DEFAULT_TOOLBAR_RECT;

    [UIView commitAnimations];
}


#pragma - mark ピッカービューデリゲート
//行の高さ取得
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

// ドラム数(componentの数）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int returnValue = 0;
    
    //前画面で選択された内容をベースに各ピッカーの中身を変える
    switch (pickerView.tag) {
        case HOME_PICKER:
            returnValue = (MAX_COUNT + 1 - (drawCount + awayCount)) - homeCount;
            break;
        case DRAW_PICKER:
            returnValue = (MAX_COUNT + 1 - (homeCount + awayCount)) - drawCount;
            break;
        case AWAY_PICKER:
            returnValue = (MAX_COUNT + 1 - (homeCount + drawCount)) - awayCount;
            break;
        case UNIT_PICKER:
            returnValue = unitMax;
            break;
        default:
            break;
    }
    return returnValue;
}

//行のセルの取得
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UILabel *label = [UILabel new];
    [label setFrame:CGRectMake(0, 0, 40, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    
    switch (pickerView.tag) {
        case HOME_PICKER:
            [label setText:[NSString stringWithFormat:@"%@", homePickerArray[row]]];
            break;
        case DRAW_PICKER:
            [label setText:[NSString stringWithFormat:@"%@", drawPickerArray[row]]];
            break;
        case AWAY_PICKER:
            [label setText:[NSString stringWithFormat:@"%@", awayPickerArray[row]]];
            break;
        case UNIT_PICKER:
            [label setText:[NSString stringWithFormat:@"%@", unitPickerArray[row]]];
            break;
        default:
            break;
    }
    
    [cell addSubview:label];
    
    return cell;
}

//選択値をテキストフィールドにセット
- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case HOME_PICKER:
            homeCountTextField.text = [NSString stringWithFormat:@"%@", homePickerArray[row]];
            break;
        case DRAW_PICKER:
            drawCountTextField.text = [NSString stringWithFormat:@"%@", drawPickerArray[row]];
            break;
        case AWAY_PICKER:
            awayCountTextField.text = [NSString stringWithFormat:@"%@", awayPickerArray[row]];
            break;
        case UNIT_PICKER:
            unitCountTextField.text = [NSString stringWithFormat:@"%@", unitPickerArray[row]];
            break;
        default:
            break;
    }
    
    //合計数が１３以上だった場合は「〜以上」ラベルを消す
    int maxVal = [homeCountTextField.text intValue] + [drawCountTextField.text intValue] + [awayCountTextField.text intValue];
    [self ijouLabelDispatch:maxVal];
    
}

//合計数が１３以上だった場合は「〜以上」ラベルを消す
- (void)ijouLabelDispatch:(int)maxVal
{
    UILabel *homeLabel = (UILabel *)[self.view viewWithTag:LABEL_IJOU_HOME];
    UILabel *drawLabel = (UILabel *)[self.view viewWithTag:LABEL_IJOU_DRAW];
    UILabel *awayLabel = (UILabel *)[self.view viewWithTag:LABEL_IJOU_AWAY];
    
    if (maxVal>= MAX_COUNT) {
        homeLabel.hidden = YES;
        drawLabel.hidden = YES;
        awayLabel.hidden = YES;
    } else {
        homeLabel.hidden = NO;
        drawLabel.hidden = NO;
        awayLabel.hidden = NO;
    }
}

//次画面への遷移
- (void)push:(UIButton *)button
{
    //ピッカーをしまう
    [self hidePicker];
    
    //現在開催回数と起動時開催回数が違う場合は警告表示
    ControllDataBase *dbControll = [ControllDataBase new];
    if (![appDelegate.kaisu isEqualToString:[dbControll returnKaisaiNow]]) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"表示中の回は購入締切期限切れです\nアプリを再起動してください"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //選択合計数字が「１３以上」だったら警告
    if (([homeCountTextField.text intValue] + [drawCountTextField.text intValue] + [awayCountTextField.text intValue]) > MAX_COUNT) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"選択された合計数が「１３試合」を超えてます"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１３で全部同じ結果」
    if ([homeCountTextField.text intValue] == MAX_COUNT || [drawCountTextField.text intValue] == MAX_COUNT || [awayCountTextField.text intValue] == MAX_COUNT) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"オールならランダムの必要なくね？"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１３で口数が２以上」
    if (([homeCountTextField.text intValue] + [drawCountTextField.text intValue] + [awayCountTextField.text intValue]) == MAX_COUNT && [unitCountTextField.text intValue] > 1) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"選択された合計数が「１３試合」の場合は１口までです"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１２で口数が４以上」
    if (([homeCountTextField.text intValue] + [drawCountTextField.text intValue] + [awayCountTextField.text intValue]) == 12 && [unitCountTextField.text intValue] > 3) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"選択された合計数が「１２試合」の場合は３口までです"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //選択合計数字と口数の整合性が合わなかったら警告　「選択合計数字が１１で口数が１０」
    if (([homeCountTextField.text intValue] + [drawCountTextField.text intValue] + [awayCountTextField.text intValue]) == 11 && [unitCountTextField.text intValue] > 9) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"選択された合計数が「１１試合」の場合は９口までです"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //ピッカーで選択された数を格納
    pickerCountArray = [NSMutableArray array];
    [pickerCountArray addObject:[NSNumber numberWithInt:[homeCountTextField.text intValue]]];
    [pickerCountArray addObject:[NSNumber numberWithInt:[drawCountTextField.text intValue]]];
    [pickerCountArray addObject:[NSNumber numberWithInt:[awayCountTextField.text intValue]]];
    [pickerCountArray addObject:[NSNumber numberWithInt:MAX_COUNT - ([homeCountTextField.text intValue] + [drawCountTextField.text intValue] + [awayCountTextField.text intValue])]];
    
    //ランダム値を取得
    GetRandomSingle *grs = [GetRandomSingle new];
    NSMutableArray *randomValue = [grs returnRandomValue:tapArray tapCountArray:tapCountArray pickerCountArray:pickerCountArray unitNum:[unitCountTextField.text intValue]];
        
//    NSLog(@"=======================================================");
//    NSLog(@"%@", randomValue);
    
    //判定ロジックをかます
    HanteiLogic *ht = [HanteiLogic new];
    
    //結果表示画面
    SingleResultViewController *srvc = [SingleResultViewController new];
    
    //判定結果を結果表示画面へ渡す
    srvc.hanteiDataArray = [ht returnHantei:randomValue];
    
    //結果表示画面へ遷移
    [self.navigationController pushViewController:srvc animated:YES];
}

//前の画面に戻る
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
