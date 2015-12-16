//
//  ControllDataBase.h
//  TotoRan
//
//  Created by 大山 孝 on 2015/05/22.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//
//  DBアクセス用のクラス
//　DBアクセスは最終的にこのクラスに集約したい

#import <Foundation/Foundation.h>
#import "FMDatabase.h" //FMDB用

@interface ControllDataBase : NSObject

//開催回数テーブルに格納されている最大(最新)開催開始日と現在日付の比較
- (BOOL)kaisaiDataCheck;

//開催回と組み合わせ表の更新(挿入)
- (BOOL)insertKaisaiData:(NSArray *)data;

//支持率データの更新(update) typeはtotoが「0」、bODDSが「1」
- (BOOL)updateShijiRate:(NSArray *)data type:(int)type;

//現在開催中の回数を返す
- (NSString *)returnKaisaiNow;

//支持率データの更新判断ジャッジ　nilか開催回数を返す
- (NSString *)rateUpdateJudge;

//初回起動時にデータが１３件そろってるかどうか確認
- (int)drewCheck:(NSString *)kaisu;

//組み合わせデータを返す
- (NSArray *)returnKumiawase;

//支持率データを返す
- (NSArray *)returnRate:(int)type;

//現在開催中の回があるかないか？
- (int)returnKaisaiYesNo;

//支持率データ取得日時を返す
- (NSString *)returnGetRateTime;

//開催回(kaisu)テーブルのデータチェック
- (int)kaisuDataCountCheck;

//販売終了日を返す
- (NSString *)returnSaleEndDate;

//組合せテーブルと支持率テーブルの内容をDELETE
- (void)deleteTables;

//チーム名マッピング表の更新(挿入)
- (BOOL)insertTeamName:(NSArray *)data;

//チーム名マッピング(abbname)テーブルのデータチェック
- (int)abbNameDataCountCheck;

@end

