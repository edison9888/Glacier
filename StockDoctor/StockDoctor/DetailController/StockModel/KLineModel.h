//
//  KLineModel.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineModel : NSObject
@property (nonatomic,strong) NSString * freq;
@property (nonatomic,strong) NSArray * cellDataList;
+ (KLineModel *)parseData:(NSString *)responseString;
@end

@interface KLineCellData : NSObject
@property (nonatomic,strong) NSString * date;
@property (nonatomic,strong) NSString * open;
@property (nonatomic,strong) NSString * high;
@property (nonatomic,strong) NSString * low;
@property (nonatomic,strong) NSString * close;
@property (nonatomic,strong) NSString * volume;
@end