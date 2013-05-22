//
//  SinaBaseDataModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-10.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SinaBaseDataModel.h"

@implementation SinaBaseDataModel
+ (NSArray *)extractModelList:(NSString *)inputStr
{
    NSMutableArray * output = [NSMutableArray array];
    
    NSArray * respArr = [inputStr componentsSeparatedByString:@";"];
    [respArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        if (obj.length > 1)
        {
            SinaBaseDataModel * model = [[SinaBaseDataModel alloc]init];
            NSRange start = [obj rangeOfString:@"hq_str_"];
            int startIndex = start.location + start.length;
            NSString * name = [obj substringWithRange:NSMakeRange(startIndex,8)];
            model.fullCode = name;
            NSString * baseData = [obj substringWithRange:NSMakeRange(startIndex + 10,obj.length - startIndex - 11)];
            NSArray * subArr = [baseData componentsSeparatedByString:@","];
            if (subArr.count > 10)
            {
                model.shortName = subArr[0];
                model.preClosePrice = subArr[2];
                model.currentPrice = subArr[3];
                [output addObject:model];
            }
        }
    }];
    return output;
}

- (int)changeState
{
    float price = self.currentPrice.floatValue;
    float pre = self.preClosePrice.floatValue;
    if (price == 0)
    {
        return 0;
    }
    else
    {
        return price == pre ? 0 : (price > pre ? 1 : -1);
    }
}

- (NSString *)change
{
    float price = self.currentPrice.floatValue;
    float pre = self.preClosePrice.floatValue;
    if (pre)
    {
        if(price == 0)
        {
            return @"+0.00%";
        }
        else
        {
            if (self.changeState > 0)
            {
                return [NSString stringWithFormat:@"+%.2f%%",(price - pre)/pre * 100];
            }
            else
            {
                return [NSString stringWithFormat:@"%.2f%%",(price - pre)/pre * 100];
            }
        }
    }
    else
    {
        return @"--";
    }
}
@end
