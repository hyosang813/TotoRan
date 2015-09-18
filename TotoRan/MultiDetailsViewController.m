//
//  MultiDetailsViewController.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/06/01.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "MultiDetailsViewController.h"

#define MAX_COUNT 13
#define MAX_COUNT_DOUBLE 8
#define MAX_COUNT_TRIPLE 5

#define HYOUDAI_LABEL_RECT CGRectMake(15, 70, (self.view.bounds.size.width / 8) * 6, self.view.bounds.size.height / 12)
#define DOUBLE_LABEL_RECT CGRectMake(30, (self.view.bounds.size.height / 12) * 1 + 70, (self.view.bounds.size.width / 8) * 4, self.view.bounds.size.height / 12)
#define TRIPLE_LABEL_RECT CGRectMake(30, (self.view.bounds.size.height / 12) * 2 + 70 + 5, (self.view.bounds.size.width / 8) * 4, self.view.bounds.size.height / 12)
#define DOUBLE_TXTFLD_RECT CGRectMake((self.view.bounds.size.width / 8) * 4 + 30, (self.view.bounds.size.height / 12) * 1 + 70, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)
#define TRIPLE_TXTFLD_RECT CGRectMake((self.view.bounds.size.width / 8) * 4 + 30, (self.view.bounds.size.height / 12) * 2 + 70 + 5, (self.view.bounds.size.width / 8) * 1.5, self.view.bounds.size.height / 12)

#define DEFAULT_TOOLBAR_RECT CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 38.0f)
#define ENABLED_TOOLBAR_RECT CGRectMake(0, self.view.bounds.size.height - 180, self.view.bounds.size.width, 38.0f)

#define DEFAULT_PICKER_RECT CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 162)
#define ENABLED_PICKER_RECT CGRectMake(0, self.view.bounds.size.height - 162, self.view.bounds.size.width, 162)

enum {DOUBLE_TEXT = 101, TRIPLE_TEXT}; //テキストフィールドのtag
enum {DOUBLE_PICKER = 201, TRIPLE_PICKER}; //ピッカービューのtag

@interface MultiDetailsViewController ()

@end

@implementation MultiDetailsViewController
{
    int toolBarnum; //直前に選択されたピッカー記憶用
    
    NSArray *doublePickerArray; //ダブルのピッカーラベル
    NSArray *triplePickerArray; //トリプルのピッカーラベル
    
    UITextField *doubleCountTextField; //ダブル表示のテキストフィールド
    UITextField *tripleCountTextField; //トリプル表示のテキストフィールド
    
    UIPickerView *doubleCountPicker; //ダブル選択ピッカービュー
    UIPickerView *tripleCountPicker; //トリプル選択ピッカービュー
    
    UIToolbar *pickerToolBar; //「OK」ボタンのついたツールバー
    AppDelegate *appDelegate; //情報取得用
}

//初期化
- (instancetype)init
{
    self = [super init];
    if (self) {
        //インスタンス変数初期化
        toolBarnum = 0;
        
        //デリゲート取得
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"マルチ条件指定";
    self.view.backgroundColor = [UIColor yellowColor];

    //結果画面への遷移ボタンを生成　navigationBarの右側ボタン
    UIBarButtonItem *pushButton = [[UIBarButtonItem alloc] initWithTitle:@"判定" style:UIBarButtonItemStyleBordered target:self action:@selector(push:)];
    self.navigationItem.rightBarButtonItem = pushButton;
    
    //戻るボタンをカスタマイズ
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"戻る" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //各ドラムに表示するセル数用配列の値をセット
    doublePickerArray = [self itemSet:self.doubleCount max:MAX_COUNT_DOUBLE];
    triplePickerArray = [self itemSet:self.tripleCount max:MAX_COUNT_TRIPLE];
    
    //ラベルとテキストフィールド(ピッカービュー)の配置
    [self makeLabel:HYOUDAI_LABEL_RECT text:@"■「ダブル,トリプル」の数" tag:999]; //大表題
    [self makeLabel:DOUBLE_LABEL_RECT text:@"・「ダブル」の数" tag:999]; //ダブルの数
    [self makeLabel:TRIPLE_LABEL_RECT text:@"・「トリプル」の数" tag:999]; //トリプルの数
    
    doubleCountTextField = [self makeTextField:DOUBLE_TXTFLD_RECT tag:DOUBLE_TEXT initial:self.doubleCount]; //ダブルの数
    tripleCountTextField = [self makeTextField:TRIPLE_TXTFLD_RECT tag:TRIPLE_TEXT initial:self.tripleCount]; //トリプルの数
    
    [self.view addSubview:doubleCountTextField];
    [self.view addSubview:tripleCountTextField];

    doubleCountPicker = [self makePicker:DOUBLE_PICKER];
    tripleCountPicker = [self makePicker:TRIPLE_PICKER];
    
    [self.view addSubview:doubleCountPicker];
    [self.view addSubview:tripleCountPicker];
    
    //ピッカービューの上に「OK」ボタンのついたバーを表示
    pickerToolBar = [[UIToolbar alloc] initWithFrame:DEFAULT_TOOLBAR_RECT];
    pickerToolBar.tintColor = [UIColor whiteColor];
    pickerToolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStyleDone target:self action:@selector(hidePicker)];
    [pickerToolBar setItems:@[spaceBarItem, doneBarItem]];
    
    [self.view addSubview:pickerToolBar];
    
    //テキストフィールドの入力をピッカーに
    doubleCountTextField.inputView = doubleCountPicker;
    tripleCountTextField.inputView = tripleCountPicker;

    doubleCountTextField.inputAccessoryView = pickerToolBar;
    tripleCountTextField.inputAccessoryView = pickerToolBar;
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
    
    switch (tag) {
        case DOUBLE_TEXT:
            picker = doubleCountPicker;
            hidePicker1 = tripleCountPicker;
            break;
        case TRIPLE_TEXT:
            picker = tripleCountPicker;
            hidePicker1 = doubleCountPicker;
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
    pickerToolBar.frame = ENABLED_TOOLBAR_RECT;
    [UIView commitAnimations];
}

//ピッカーしまう
- (void)hidePicker {
    // ピッカーが下に隠れるアニメーション
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    //ディスパッチが面倒だから全てのピッカーを対象に元に戻しちゃう
    doubleCountPicker.frame = DEFAULT_PICKER_RECT;
    tripleCountPicker.frame = DEFAULT_PICKER_RECT;
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
        case DOUBLE_PICKER:
            returnValue = (MAX_COUNT_DOUBLE + 1) - self.doubleCount;
            break;
        case TRIPLE_PICKER:
            returnValue = (MAX_COUNT_TRIPLE + 1) - self.tripleCount;
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
        case DOUBLE_PICKER:
            [label setText:[NSString stringWithFormat:@"%@", doublePickerArray[row]]];
            break;
        case TRIPLE_PICKER:
            [label setText:[NSString stringWithFormat:@"%@", triplePickerArray[row]]];
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
        case DOUBLE_PICKER:
            doubleCountTextField.text = [NSString stringWithFormat:@"%@", doublePickerArray[row]];
            break;
        case TRIPLE_PICKER:
            tripleCountTextField.text = [NSString stringWithFormat:@"%@", triplePickerArray[row]];
            break;
        default:
            break;
    }
    
}


//次画面への遷移
- (void)push:(UIButton *)button
{
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


    //ダブルとトリプルの数整合性チェック
    if ([self doubleTripleCheck:[doubleCountTextField.text intValue] tripleCount:[tripleCountTextField.text intValue]]) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"以下の組合わせを超える事は出来ません\n※合計486口を超える事はできません\nダブル:0 トリプル:5\nダブル:1 トリプル:5\nダブル:2 トリプル:4\nダブル:3 トリプル:3\nダブル:4 トリプル:3\nダブル:5 トリプル:2\nダブル:6 トリプル:1\nダブル:7 トリプル:1\nダブル:8 トリプル:0"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        //以降のスキップ
        return;
    }
    
    //ランダムロジックかます
    GetRandomMulti *grm = [GetRandomMulti new];
    NSArray *randArray = [grm returnRandomValue:self.arrayParent
                                 tapCountDouble:self.doubleCount
                                  tapCounTriple:self.tripleCount
                                pickCountDouble:[doubleCountTextField.text intValue]
                                 pickCounTriple:[tripleCountTextField.text intValue]];

    //ランダム結果を別Arrayに退避
    NSMutableArray *randomArray = [NSMutableArray array];
    for (NSArray *arr in randArray) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arr];
        [randomArray addObject:tempArray];
    }
    
    //NSNullを省いた２次元配列にすると同時に組み合わせ数を取得
    int combiCount = 1;
    for (NSMutableArray *arr in randArray) {
        for (int i = 0; i < arr.count; i++) {
            if ([arr[i] isEqual:[NSNull null]]) {
                [arr removeObject:arr[i]];
            }
        }
        combiCount *= arr.count;
    }
    
    //判定用二次元配列生成
    NSMutableArray *hanteiArray = [NSMutableArray array];
    int p = 0, s = 0;// p:商, s:余り
    
    // (3) 組み合わせをcombiCount回求める（i：組み合わせ番号）
    for (int i = 0; i < combiCount; i++) {
        NSMutableArray *childArray = [NSMutableArray array];
        
        //pの初期値はiの数を与える
        p = i;
        for (int j = 0; j < randArray.count; j++) {
            //p ÷ j番目の配列の要素数 = 新しいp・・・余りs
            s = p % [randArray[j] count];
            p = (p - s) / [randArray[j] count];
            
            //j番目の配列からは、s番目の値を組み合わせに使う
            [childArray addObject:randArray[j][s]];
        }
        [hanteiArray addObject:childArray];
    }
    
    //判定ロジックをかます
    HanteiLogic *ht = [HanteiLogic new];
    
    //結果表示画面
    MultiResultViewController *mrvc = [MultiResultViewController new];
    
    //判定結果を結果表示画面へ渡す
    mrvc.hanteiDataArray = [ht returnHantei:hanteiArray];
    
    //ランダム抽出結果を結果表示画面へ渡す
    mrvc.randomArray = randomArray;
    
    [self.navigationController pushViewController:mrvc animated:YES];
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

//前の画面に戻る
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

@end
