//
//  LineGraphicsBaseView.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-14.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LineGraphicsBaseView : UIView

- (CGRect)gridRect;

- (CGRect)dataRect;

- (CGRect)leftStringRect;

- (CGRect)buttomStringRect;

- (CGRect)rightStringRect;

- (CGRect)volumeGridRect;

//量线数据区域
- (CGRect)volumeDataRect;

//左边量线文本区域
- (CGRect)leftStringVolumeRect;
//右边量线文本区域
- (CGRect)rightStringVolumeRect;
@end
