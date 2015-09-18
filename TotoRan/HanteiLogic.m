//
//  HanteiLogic.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/18.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "HanteiLogic.h"

#define BASE 0.000000627 //基準値
#define S_HANTEI 50.0
#define A_HANTEI 30.0
#define B_HANTEI 10.0
#define C_HANTEI 5.0
#define D_HANTEI 1.0
#define E_HANTEI 0.01

#define HOME 1
#define DRAW 0
#define AWAY 2

@implementation HanteiLogic

//口数×102の羅列(13個:NSNumber)の２次元配列が引数で、戻り値はそれに判定結果をつけたもの
- (NSMutableArray *)returnHantei:(NSMutableArray *)returnArray
{
    
    //支持率データをAppDelegateから取得する「appDelegete.rateArrayToto　appDelegete.rateArrayBook」
    AppDelegate *appDelegete = [[UIApplication sharedApplication] delegate];
    
    float averageToto = 1; //基準値で割る前のtoto支持率積算用
    float averageBook = 1; //基準値で割る前のbook支持率積算用
    
    //判定
    for (NSMutableArray *hanteiTaisyou in returnArray) {
        for (int i = 0; i < hanteiTaisyou.count; i++) {
            int hanteiTaisyouIntValue = [hanteiTaisyou[i] intValue];
            averageToto = averageToto * ([appDelegete.rateArrayToto[i][hanteiTaisyouIntValue] floatValue] / 100);
            
            //bODDSは数値があれば同じように処理
            if (![appDelegete.rateArrayBook[i][hanteiTaisyouIntValue] isEqualToString:@"--.--"]) {
                averageBook = averageBook * ([appDelegete.rateArrayBook[i][hanteiTaisyouIntValue] floatValue] / 100);
            }
        }
        
        //判定結果を付与(Toto)
        float rateToto = averageToto / BASE;
        
        if(rateToto >= S_HANTEI){
            [hanteiTaisyou addObject:@"S"];
        }else if(rateToto >= A_HANTEI){
            [hanteiTaisyou addObject:@"A"];
        }else if(rateToto >= B_HANTEI){
            [hanteiTaisyou addObject:@"B"];
        }else if(rateToto >= C_HANTEI){
            [hanteiTaisyou addObject:@"C"];
        }else if(rateToto >= D_HANTEI){
            [hanteiTaisyou addObject:@"D"];
        }else if(rateToto >= E_HANTEI){
            [hanteiTaisyou addObject:@"E"];
        }else{
            [hanteiTaisyou addObject:@"F"];
        }
        
        //判定結果によって小数点の桁数を調整して判定対象に判定結果を付与
        if (rateToto > D_HANTEI) {
            [hanteiTaisyou addObject:[NSString stringWithFormat:@"[%d]", (int)rateToto]];
        } else {
            //小数点がある場合は四捨五入されちゃうので切り捨てしょりしないとおかしくなる　本当はE[0.9]にしたいのにE[1.0]になっちゃう
            NSString *roundUpString = [NSString stringWithFormat:@"%f", rateToto];
            
            //最初に0と.以外が出てくる桁数を取得する
            int notZero = 0;
            for (int i = 0; i < roundUpString.length; i++) {
                if ([[roundUpString substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"0"] || [[roundUpString substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"."]) {
                    notZero++;
                    continue;
                }
                notZero++;
                break;
            }
            
            //小数点第４位でも0だったら「0」、それより大きかったら該当箇所で切り捨て
            if (notZero > 6) {
                roundUpString = @"0";
            } else {
                roundUpString = [roundUpString substringWithRange:NSMakeRange(0, notZero)];
            }
            
            //前後にカッコを付与
            roundUpString = [[@"[" stringByAppendingString:roundUpString] stringByAppendingString:@"]"];
            [hanteiTaisyou addObject:roundUpString];
        }
        
        //ソート用の数値を先頭に追加
        [hanteiTaisyou insertObject:[NSNumber numberWithFloat:rateToto] atIndex:0];
        
        //average変数の初期化
        averageToto = 1;
        
        //bODDSがあればbODDS判定もやる
        if (averageBook != 1) {
            //判定結果を付与(Book)
            float rateBook = averageBook / BASE;
            
            if(rateBook >= S_HANTEI){
                [hanteiTaisyou addObject:@"s"];
            }else if(rateBook >= A_HANTEI){
                [hanteiTaisyou addObject:@"a"];
            }else if(rateBook >= B_HANTEI){
                [hanteiTaisyou addObject:@"b"];
            }else if(rateBook >= C_HANTEI){
                [hanteiTaisyou addObject:@"c"];
            }else if(rateBook >= D_HANTEI){
                [hanteiTaisyou addObject:@"d"];
            }else if(rateBook >= E_HANTEI){
                [hanteiTaisyou addObject:@"e"];
            }else{
                [hanteiTaisyou addObject:@"f"];
            }

            //判定結果によって小数点の桁数を調整して判定対象に判定結果を付与
            if (rateBook > D_HANTEI) {
                [hanteiTaisyou addObject:[NSString stringWithFormat:@"[%d]", (int)rateBook]];
            } else {
                //小数点がある場合は四捨五入されちゃうので切り捨てしょりしないとおかしくなる　本当はE[0.9]にしたいのにE[1.0]になっちゃう
                NSString *roundUpString = [NSString stringWithFormat:@"%f", rateBook];
                
                //最初に0と.以外が出てくる桁数を取得する
                int notZero = 0;
                for (int i = 0; i < roundUpString.length; i++) {
                    if ([[roundUpString substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"0"] || [[roundUpString substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"."]) {
                        notZero++;
                        continue;
                    }
                    notZero++;
                    break;
                }
                
                //小数点第４位でも0だったら「0」、それより大きかったら該当箇所で切り捨て
                if (notZero > 6) {
                    roundUpString = @"0";
                } else {
                    roundUpString = [roundUpString substringWithRange:NSMakeRange(0, notZero)];
                }
                
                //前後にカッコを付与
                roundUpString = [[@"[" stringByAppendingString:roundUpString] stringByAppendingString:@"]"];
                [hanteiTaisyou addObject:roundUpString];
            }
            
            //average変数の初期化
            averageBook = 1;
        }
    }
 
    //データが２個以上の場合はソート
    if (returnArray.count > 1) {
        
        //teratailで教えてもらったスマートなソート方法
        NSArray *sortArray = [returnArray sortedArrayUsingComparator:^(id obj1, id obj2) {
            NSArray *a = (NSArray*)obj1;
            NSArray *b = (NSArray*)obj2;
            return [[b firstObject] compare:[a firstObject]];
        }];
        
        //ソート後のArrayをreturnArrayに戻す
        returnArray = [sortArray mutableCopy];
    }
    
    //ソート用の先頭データを削除
    for (NSMutableArray *arr in returnArray) {
        [arr removeObjectAtIndex:0];
    }
    return returnArray;
}

@end
