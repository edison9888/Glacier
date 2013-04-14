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
    
    NSDictionary * dict = [responseString objectFromJSONString];
    
    NSNumber * code = dict[@"code"];
    
    if (code.intValue == 0)
    {
        NSDictionary * dataDict = dict[@"data"];
        NSDictionary * codeDict = dataDict.allValues[0];
        NSArray * arr = codeDict.allValues[0];
        
        
        [arr enumerateObjectsUsingBlock:^(NSArray * subArr, NSUInteger idx, BOOL *stop)
         {
             
             KLineCellData * cellData = [[KLineCellData alloc]init];
             cellData.date = subArr[0];
             cellData.open = subArr[1];
             cellData.close = subArr[2];
             cellData.high = subArr[3];
             cellData.low = subArr[4];
             cellData.volume = subArr[5];
             [cellDataList addObject:cellData];
         }];
        
        model.cellDataList = cellDataList;
        return model;
    }
    else
        return nil;
   
}

- (NSArray *)generateMAData:(int)range WithCount:(int)count
{
    NSMutableArray * arr = [NSMutableArray array];
    
    
    for (int i = 0; i < count; i++)
    {
        if (i + range < self.cellDataList.count)
        {
            double totalClose = 0;
            for (int j = i; j < i + range; j++)
            {
                KLineCellData * cellData = self.cellDataList[j];
                
                totalClose += cellData.close.floatValue;
            }
            [arr addObject:@(totalClose / range)];
        }
        
    }
    return arr;
}
@end

@implementation KLineCellData

@end

@implementation MADataModel

@end