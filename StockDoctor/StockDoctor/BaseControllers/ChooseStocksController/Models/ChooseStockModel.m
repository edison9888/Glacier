//
//  ChooseStockModel.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-18.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ChooseStockModel.h"

@implementation ChooseStockModel
- (NSString *)shortCode
{
    if (self.fullCode.length == 8)
    {
        return [self.fullCode substringFromIndex:2];
    }
    else
    {
        return nil;
    }
}

+ (NSArray *)parseChooseStockModels:(NSArray *)json tag:(int)tag
{
    NSArray * arr = @[@"huanshou",@"gailv",@"renqi"];
    NSMutableArray * output = [NSMutableArray array];
    [json enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        ChooseStockModel * model = [[ChooseStockModel alloc]init];
        model.name = obj[@"name"];
        model.fullCode = obj[@"code"];
        NSString * str = arr[tag];
        model.indicator = obj[str];
        
        [output addObject:model];
    }];
    return output;
}

- (SearchModel *)generateSearchModel
{
    SearchModel * model = [[SearchModel alloc]init];
    model.shortCode = self.shortCode;
    model.fullCode = self.fullCode;
    model.shortName = self.name;
    return model;
}
@end
