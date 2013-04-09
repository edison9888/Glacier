//
//  SearchModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-7.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+ (NSArray *) extractModelList:(NSString *)inputStr
{
    NSMutableArray * output = [NSMutableArray array];
    NSArray * arr = [inputStr componentsSeparatedByString:@"\""];
    if (arr.count > 1)
    {
        NSString * contentStr = arr[1];
        NSArray * contentArr = [contentStr componentsSeparatedByString:@";"];
        
        [contentArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            NSArray * cellArr = [obj componentsSeparatedByString:@","];
            
            if (cellArr.count > 5)
            {
                SearchModel * model = [[SearchModel alloc]init];
                model.keyword1 = cellArr[0];
                model.type = cellArr[1];
                model.shortCode = cellArr[2];
                model.fullCode = cellArr[3];
                model.shortName = cellArr[4];
                model.keyword2 = cellArr[5];
                if ([model.type isEqualToString:@"11"]) //只显示AB股和指数
                {
                    [output addObject:model];
                }
            }
        }];
    }
    
    return output;
}
@end
