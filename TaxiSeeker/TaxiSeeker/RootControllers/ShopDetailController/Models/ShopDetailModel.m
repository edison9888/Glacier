//
//  ShopModel.m
//  DirShanghai
//
//  Created by spring sky on 13-5-11.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//

#import "ShopDetailModel.h"

@implementation ShopDetailModel
+ (ShopDetailModel *)parseJson:(NSString *)json
{
    NSDictionary * obj = [json objectFromJSONString];
    ShopDetailModel * model = [[ShopDetailModel alloc]init];
    model.gid = obj[@"id"];
    model.name = obj[@"name"];
    model.feature = obj[@"feature"];
    model.icon = obj[@"icon"];
    model.address = obj[@"address"];
    model.lon = obj[@"lon"];
    model.lat = obj[@"lat"];
    model.neardy_metro = obj[@"neardy_metro"];
    model.star = obj[@"star"];
    model.price = obj[@"price"];
    model.neardyself = obj[@"neardyself"];
    model.phone = obj[@"phone"];
    return model;
}

- (NSString *)featureText
{
    __block NSString * text = @"";
    if ([self.feature isKindOfClass:[NSArray class]])
    {
        [self.feature enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
            if (idx == self.feature.count - 1)
            {
                text = [text stringByAppendingFormat:@"%@",obj];
            }
            else
            {
                text = [text stringByAppendingFormat:@"%@;",obj];
            }
        }];

    }
    return text;
}

@end
