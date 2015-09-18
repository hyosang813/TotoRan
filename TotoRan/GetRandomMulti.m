//
//  GetRandomDouble.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/27.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "GetRandomMulti.h"

@implementation GetRandomMulti

- (NSArray *)returnRandomValue:(NSMutableArray *)arrayParent tapCountDouble:(int)tapCountDouble tapCounTriple:(int)tapCountTriple pickCountDouble:(int)pickCountDouble pickCounTriple:(int)pickCountTriple
{
    //大元のarrayParentに影響を及ぼさないようにコピー
    NSMutableArray *arrayParentCopy = [NSMutableArray array];
    for (NSArray *arr in arrayParent) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:arr];
        [arrayParentCopy addObject:tempArray];
    }
    
    //ノータップ枠を無くす
    for (NSMutableArray *arr in arrayParentCopy) {
        if ([[arr lastObject] intValue] == 0) {
            int randomVal = arc4random() % 3;
            switch (randomVal) {
                case 0:
                    arr[0] = [NSNumber numberWithInt:1];
                    break;
                case 1:
                    arr[1] = [NSNumber numberWithInt:0];
                    break;
                case 2:
                    arr[2] = [NSNumber numberWithInt:2];
                    break;
                default:
                    break;
            }
            arr[3] = [NSNumber numberWithInt:1];
        }
    }
    
    //タップトリプル以上のピッカートリプルが必要な場合はランダムでトリプル枠を増やす
    if (tapCountTriple != pickCountTriple) {
        //抽選枠数を抽出
        int lotNum = pickCountTriple - tapCountTriple;
        
        //抽選用Arrayを生成
        NSMutableArray *lotArray = [NSMutableArray array];
        for (NSMutableArray *arr in arrayParentCopy) {
            if ([[arr lastObject] intValue] != 3) {
                [lotArray addObject:arr];
            }
        }
        
        //トリプル枠への昇格抽選
        NSMutableArray *promNumArray = [NSMutableArray array];
        for (int i = 0; i < lotNum; i++) {
            [promNumArray addObject:lotArray[arc4random() % (lotArray.count)]];
            //重複回避
            if (i > 0) {
                for (int j = 0; j < promNumArray.count - 1; j++) {
                    if (promNumArray[j] == [promNumArray lastObject]) {
                        [promNumArray removeLastObject];
                        i--;
                        break;
                    }
                }
                
            }
        }
        
        //トリプル枠への昇格
        for (NSMutableArray *arr in promNumArray) {
            //昇格対象がダブルだった場合はタップダブルのカウントを減らす
            if ([arr[3] intValue] == 2) tapCountDouble--;
            
            for (int i = 0; i < arr.count; i++) {
                switch (i) {
                    case 0:
                        arr[0] = [NSNumber numberWithInt:1];
                        break;
                    case 1:
                        arr[1] = [NSNumber numberWithInt:0];
                        break;
                    case 2:
                        arr[2] = [NSNumber numberWithInt:2];
                        break;
                    case 3:
                        arr[3] = [NSNumber numberWithInt:3];
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    //タップダブル(トリプル昇格して減る場合もあり)以上のピッカーダブルが必要な場合はランダムでトリプル枠を増やす
    if (tapCountDouble != pickCountDouble) {
       
        //抽選枠数を抽出
        int lotNum = pickCountDouble - tapCountDouble;
        
        //抽選用Arrayを生成
        NSMutableArray *lotArray = [NSMutableArray array];
        for (NSMutableArray *arr in arrayParentCopy) {
            if ([[arr lastObject] intValue] == 1) {
                [lotArray addObject:arr];
            }
        }
        
        //ダブル枠への昇格抽選
        NSMutableArray *promNumArray = [NSMutableArray array];
        for (int i = 0; i < lotNum; i++) {
            [promNumArray addObject:lotArray[arc4random() % (lotArray.count)]];
            //重複回避
            if (i > 0) {
                for (int j = 0; j < promNumArray.count - 1; j++) {
                    if (promNumArray[j] == [promNumArray lastObject]) {
                        [promNumArray removeLastObject];
                        i--;
                        break;
                    }
                }
            }
        }
        
        //ダブル枠への昇格（昇格させるためのホーム、ドロー、アウェイ抽選あり）
        for (int i = 0; i < promNumArray.count; i++) {
            
            //102抽選してその場所がNULLじゃなかったら再抽選
            int promNum = arc4random() % 3;
            if (![promNumArray[i][promNum] isEqual:[NSNull null]]) {
                i--;
                continue;
            }
            
            switch (promNum) {
                case 0:
                    promNumArray[i][promNum] = [NSNumber numberWithInt:1];
                    break;
                case 1:
                    promNumArray[i][promNum] = [NSNumber numberWithInt:0];
                    break;
                case 2:
                    promNumArray[i][promNum] = [NSNumber numberWithInt:2];
                    break;
                default:
                    break;
            }
            //ダブルへの昇格
            promNumArray[i][3] = [NSNumber numberWithInt:2];
        }
    }
    
    //データ数は不要なので削除
    for (NSMutableArray *arr in arrayParentCopy) {
        [arr removeLastObject];
    }
    
    return arrayParentCopy;
}

@end
