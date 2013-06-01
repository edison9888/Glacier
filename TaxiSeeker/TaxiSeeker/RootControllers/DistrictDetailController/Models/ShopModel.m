//
//  CommunityModel.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
+ (NSMutableArray *)parseJson:(NSString *)json key:(NSString *)keyStr
{
    NSMutableArray * output = [NSMutableArray array];
    NSDictionary * dict = [json objectFromJSONString];
    NSArray * arr =  dict[keyStr];
    [arr enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL *stop) {
        ShopModel * model = [[ShopModel alloc]init];
        model.gid = obj[@"id"];
        model.name = obj[@"name"];
        model.icon = obj[@"icon"];
        model.address = obj[@"address"];
        model.lon = obj[@"lon"];
        model.lat = obj[@"lon"];
        model.neardy = obj[@"neardy"];
        model.star = obj[@"star"];
        model.price = obj[@"price"];
        model.neardyself = obj[@"neardyself"];
        model.phone = obj[@"phone"];
        [output addObject:model];
    }];
    return output;
}
@end
