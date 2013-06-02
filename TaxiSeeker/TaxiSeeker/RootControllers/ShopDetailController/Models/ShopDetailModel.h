//
//  ShopModel.h
//  DirShanghai
//
//  Created by spring sky on 13-5-11.
//  Copyright (c) 2013年 spring sky. All rights reserved.
//



@interface ShopDetailModel : NSObject
@property (nonatomic,copy) NSString * gid;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSArray * feature;
@property (nonatomic,readonly) NSString * featureText;

@property (nonatomic,copy) NSArray * recommend;
@property (nonatomic,copy) NSArray * promotion;
@property (nonatomic,copy) NSArray * neardy_metro;
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * lat;
@property (nonatomic,copy) NSString * lon;
@property (nonatomic,copy) NSString * neardyself;
@property (nonatomic,copy) NSString * star;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * love;
@property (nonatomic,copy) NSString * grade_excellent;
@property (nonatomic,copy) NSString * grade_verygood;
@property (nonatomic,copy) NSString * grade_average;
@property (nonatomic,copy) NSString * grade_poor;
@property (nonatomic,copy) NSString * grad_terrible;
@property (nonatomic,copy) NSString * comment_count;
@property (nonatomic,copy) NSString * comment_title;
@property (nonatomic,copy) NSString * comment_star;
@property (nonatomic,copy) NSString * comment_content;


+ (ShopDetailModel *)parseJson:(NSString *)json;
@end
