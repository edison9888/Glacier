//
//  ServiceModel.h
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject
@property (nonatomic,copy) NSString * gid;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * icon;
@property (nonatomic,copy) NSString * requestUrl;
+ (NSMutableArray *)parseJson:(NSString *)json;
@end
