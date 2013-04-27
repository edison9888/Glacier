//
//  KLineModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "KLineModel.h"
#import "DateHelpers.h"

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

- (float)todayAvePrice:(int)range
{
    if (range < self.cellDataList.count)
    {
        double totalClose = 0;
        for (int j = 0; j < range; j++)
        {
            KLineCellData * cellData = self.cellDataList[j];
            
            totalClose += cellData.close.floatValue;
        }
        return totalClose / range;
    }
    else
    {
        return 0;
    }
}

- (NSArray *)generateVerSepIndexList
{
    NSMutableArray * arr = [NSMutableArray array];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    int last = INT_MIN;
    NSDate * lastDate= nil;
    
    for (int idx = 0; idx< self.cellDataList.count; idx++)
    {
        KLineCellData * obj = self.cellDataList[idx];
        NSDate * date = [formatter dateFromString:obj.date];
        NSDateComponents * comp = dateComponentFrom(date);
        
        if ([self.freq isEqualToString:@"month"])
        {
            if (last > 0  && comp.year != last)
            {
                [arr addObject:@(idx)];
            }
            last = comp.year;
        }
        else if([self.freq isEqualToString:@"week"])
        {
            if (last > 0  && comp.month != last && (!lastDate || ABS(monthsBetween(date, lastDate))>=6))
            {
                [arr addObject:@(idx)];
                lastDate = date;
            }
            
            last = comp.month;
        }
        else
        {
            if (last > 0  && comp.month != last)
            {
                [arr addObject:@(idx)];
            }
            last = comp.month;
        }
    }
    
    return arr;
}

@end

@implementation KLineCellData

@end