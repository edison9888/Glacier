//
//  KLineView.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "LineGraphicsBaseView.h"
#import "KLineModel.h"

@interface KLineView : LineGraphicsBaseView
- (void)reloadData:(KLineModel *)model;
@end
