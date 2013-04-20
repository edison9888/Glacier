//
//  DetailController.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-8.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "GlacierController.h"
#import "SearchModel.h"
#import "KLineModel.h"
#import "TrendModel.h"

@interface DetailController : GlacierController
@property (nonatomic,strong) SearchModel * searchModel;
@property (strong, nonatomic) NSMutableDictionary * trendKLineModelDict;
@property (strong, nonatomic) StockBaseInfoModel * stockBaseInfoModel;
@end
