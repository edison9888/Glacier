//
//  ServiceModel.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ServiceModel.h"

@implementation ServiceModel
+ (NSMutableArray *)parseJson:(NSString *)json
{
    NSMutableArray * output = [NSMutableArray array];
    NSDictionary * dict = [json objectFromJSONString];
    NSArray * arr =  dict[@"services"];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        ServiceModel * model = [[ServiceModel alloc]init];
        model.gid = obj[@"id"];
        model.name = obj[@"name"];
        model.icon = obj[@"icon"];
        [output addObject:model];
    }];
    return output;
}
@end
