//
//  StockInfoView.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-11.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "TrendModel.h"

@interface StockInfoView : UIView
@property (strong, nonatomic) IBOutlet UIButton *diagnosisButton;
@property (strong, nonatomic) StockBaseInfoModel * stockBaseInfoModel;
- (void)reloadData;
@end
