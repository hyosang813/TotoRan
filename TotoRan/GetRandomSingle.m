//
//  GetRandomSingle.m
//  TotoRan
//
//  Created by 大山 孝 on 2015/08/19.
//  Copyright (c) 2015年 raksam.com. All rights reserved.
//

#import "GetRandomSingle.h"

enum {HOME, DRAW, AWAY};
enum {DRAW_VAL, HOME_VAL, AWAY_VAL};

@implementation GetRandomSingle

- (NSMutableArray *)returnRandomValue:(NSMutableArray *)tapArray tapCountArray:(NSArray *)tapCountArray pickerCountArray:(NSArray *)pickerCountArray unitNum:(int)unitNum
{
    //ランダムが必要な最高基本数を取得
    int maxBase = [[tapCountArray lastObject] intValue];
    
    //各３種類の最低基本数を取得
    int minBaseHome = [pickerCountArray[HOME] intValue] - [tapCountArray[HOME] intValue];
    int minBaseDraw = [pickerCountArray[DRAW] intValue] - [tapCountArray[DRAW] intValue];
    int minBaseAway = [pickerCountArray[AWAY] intValue] - [tapCountArray[AWAY] intValue];
    
    //返す親Arrayを生成
    NSMutableArray *returnArrayParent = [NSMutableArray array];
    
    //口数分ループでランダム数列生成
    for (int i = 0; i < unitNum; i++) {

        //各ランダムの合計が最高基本数と等しくなるまで繰り返し
        int sum = 0;
        int randHome = 0;
        int randDraw = 0;
        int randAway = 0;

        while (sum != maxBase) {
            randHome = (arc4random() % ((maxBase - minBaseHome) + 1)) + minBaseHome;
            randDraw = (arc4random() % ((maxBase - minBaseDraw) + 1)) + minBaseDraw;
            randAway = (arc4random() % ((maxBase - minBaseAway) + 1)) + minBaseAway;
            sum = randHome + randDraw + randAway;
        }

        //ランダム値用のArrayを生成
        NSMutableArray *randArray = [NSMutableArray array];

        //各値を格納
        for (int i = 0; i < randHome; i++) {
            [randArray addObject:[NSNumber numberWithInt:HOME_VAL]];
        }

        for (int i = 0; i < randDraw; i++) {
            [randArray addObject:[NSNumber numberWithInt:DRAW_VAL]];
        }

        for (int i = 0; i < randAway; i++) {
            [randArray addObject:[NSNumber numberWithInt:AWAY_VAL]];
        }

        //ランダム値をシャッフル
        for (int i = (int)randArray.count - 1; i > 0; i--) {
            int randomNum = arc4random() % i;
            [randArray exchangeObjectAtIndex:i withObjectAtIndex:randomNum];
        }

        //tapArrayを値コピー
        NSMutableArray *returnArrayChild = [tapArray mutableCopy];

        //tapArrayのnilの箇所にシャッフルしたランダム値をセットしていく ※nilじゃなくて9に変更
        int setCount = 0;
        for (int i = 0; i < returnArrayChild.count; i++) {
            if ([returnArrayChild[i] intValue] == 9) {
                [returnArrayChild replaceObjectAtIndex:i withObject:randArray[setCount]];
                setCount++;
            }
        }
        
        //返すArrayにaddobjectsする
        [returnArrayParent addObject:returnArrayChild];
    }
    
    return returnArrayParent;
}

@end
