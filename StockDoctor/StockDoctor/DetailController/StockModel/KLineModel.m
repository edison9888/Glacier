//
//  KLineModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "KLineModel.h"

@implementation KLineModel
+ (KLineModel *)parseData:(NSString *)responseString
{
    KLineModel * model = [[KLineModel alloc]init];
    
    NSMutableArray * cellDataList = [NSMutableArray array];
    
    NSArray * arr = [responseString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop)
    {
        if (idx > 0 && obj.length > 0)
        {
            NSArray * subArr = [obj componentsSeparatedByString:@","];
            KLineCellData * cellData = [[KLineCellData alloc]init];
            cellData.date = subArr[0];
            cellData.open = subArr[1];
            cellData.high = subArr[2];
            cellData.low = subArr[3];
            cellData.close = subArr[4];
            cellData.volume = subArr[5];
            cellData.adjClose = subArr[6];
            [cellDataList addObject:cellData];
        }
    }];
    
    model.cellDataList = cellDataList;
    return model;
}
@end

@implementation KLineCellData

@end