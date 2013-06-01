//
//  CommunityModel.h
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

//社区模型
@interface ShopModel : NSObject
@property (nonatomic,copy) NSString * gid;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * lat;
@property (nonatomic,copy) NSString * lon;
@property (nonatomic,copy) NSString * neardy;
@property (nonatomic,copy) NSString * neardyself;
@property (nonatomic,copy) NSString * star;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * phone;

+ (NSMutableArray *)parseJson:(NSString *)json key:(NSString *)keyStr;
@end
