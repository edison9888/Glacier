//
//  KLineView.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-12.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KLineModel.h"

@interface KLineView : UIView
- (void)reloadData:(KLineModel *)model;
@end
