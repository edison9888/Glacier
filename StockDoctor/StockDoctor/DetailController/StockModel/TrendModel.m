//
//  StockModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "TrendModel.h"

@implementation StockBaseInfoModel

+ (StockBaseInfoModel *)parseJson:(NSArray *)jsonArr
{
    StockBaseInfoModel * model = [[StockBaseInfoModel alloc]init];
    model.tradeDate = jsonArr[0];
    model.preClose = jsonArr[1];
    model.openPrice = jsonArr[2];
    model.todayHigh = jsonArr[3];
    model.todayLow = jsonArr[4];
    model.currentPrice = jsonArr[5];
    model.volume = jsonArr[25];
    model.amount = jsonArr[26];
    
    model.volumeRate = jsonArr[28];
    model.pettm = jsonArr[29];
    model.turnoverRate = jsonArr[31];
    model.innerMarket = jsonArr[32];
    model.outterMarket = jsonArr[33];
    return model;
}

- (int)changeState
{
    float price = self.currentPrice.floatValue;
    float pre = self.preClose.floatValue;
    return price == pre ? 0 : (price > pre ? 1 :-1);
}

- (NSString *)changeRatio
{
    float price = self.currentPrice.floatValue;
    float pre = self.preClose.floatValue;
    if (self.changeState > 0)
    {
        return [NSString stringWithFormat:@"+%.2f%%",(price - pre)/pre * 100];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f%%",(price - pre)/pre * 100];
    }
}

- (NSString *)changeValue
{
    float price = self.currentPrice.floatValue;
    float pre = self.preClose.floatValue;
    return [NSString stringWithFormat:@"%.2f",price - pre];
}

@end

@implementation TrendModel
+ (TrendModel *)parseJson:(NSArray *)jsonArr
{
    TrendModel * trendModel = [[TrendModel alloc]init];
    NSMutableArray * cellList = [NSMutableArray array];
    [jsonArr enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL *stop) {
        TrendCellData * cell = [[TrendCellData alloc]init];
        cell.price = obj[0];
        cell.volume = obj[1];
        cell.amount = obj[2];
        [cellList addObject:cell];
    }];
    trendModel.trendCellDataList = cellList;
    return trendModel;
}
@end

@implementation TrendCellData

@end