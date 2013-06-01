//
//  DistrictModel.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "DistrictModel.h"

@implementation DistrictModel
+ (NSMutableArray *)parseJson:(NSString *)json
{
    NSMutableArray * output = [NSMutableArray array];
    NSDictionary * dict = [json objectFromJSONString];
    NSArray * arr =  dict[@"distracts"];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        DistrictModel * model = [[DistrictModel alloc]init];
        model.gid = obj[@"id"];
        model.name = obj[@"name"];
        model.icon = obj[@"icon"];
        [output addObject:model];
    }];
    return output;
}
@end
