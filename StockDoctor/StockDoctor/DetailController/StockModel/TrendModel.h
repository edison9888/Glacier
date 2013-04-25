//
//  TrendModel.h
//  StockDoctor
//  分时线模型
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockBaseInfoModel : NSObject
@property (nonatomic,strong) NSString * tradeDate;
@property (nonatomic,strong) NSString * preClose;
@property (nonatomic,strong) NSString * openPrice;
@property (nonatomic,strong) NSString * todayHigh;
@property (nonatomic,strong) NSString * todayLow;
@property (nonatomic,strong) NSString * currentPrice;
@property (nonatomic,strong) NSString * volume;
@property (nonatomic,strong) NSString * amount;
@property (nonatomic,strong) NSString * volumeRate; //量比
@property (nonatomic,strong) NSString * pettm; //市盈率
@property (nonatomic,strong) NSString * turnoverRate; //换手率
@property (nonatomic,strong) NSString * innerMarket; //内盘
@property (nonatomic,strong) NSString * outterMarket; //外盘
@property (nonatomic,readonly) NSString * changeValue; //涨跌值
@property (nonatomic,readonly) NSString * changeRatio; //涨跌幅
@property (nonatomic,readonly) int changeState;

+ (StockBaseInfoModel *)parseJson:(NSArray *)jsonArr;
@end

@interface TrendModel : NSObject
//分时数据列表
@property (nonatomic,strong) NSArray * trendCellDataList;

+ (TrendModel *)parseJson:(NSArray *)jsonArr;
@end

@interface TrendCellData : NSObject
//价格
@property (nonatomic,strong) NSString * price;

//成交量
@property (nonatomic,strong) NSString * volume;

//成交额
@property (nonatomic,strong) NSString * amount;
@end