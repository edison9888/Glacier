//
//  TrendModel.h
//  StockDoctor
//  分时线模型
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrendModel : NSObject
//昨收
@property (nonatomic,strong) NSString * preClosePrice;

//分时数据列表
@property (nonatomic,strong) NSArray * trendCellDataList;
@end

@interface TrendCellData : NSObject
//价格
@property (nonatomic,strong) NSString * price;

//成交量
@property (nonatomic,strong) NSString * volume;

//成交额
@property (nonatomic,strong) NSString * amount;
@end