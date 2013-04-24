//
//  TrendGraphView.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//
#import "LineGraphicsBaseView.h"
#import "TrendModel.h"

@interface TrendGraphView : LineGraphicsBaseView
@property (nonatomic,strong) TrendModel * trendModel;
@property (nonatomic,strong) StockBaseInfoModel * stockBaseInfoModel;
- (void)reloadData:(TrendModel *)model;
@end 
