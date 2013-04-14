//
//  LineGraphicsBaseView.h
//  StockDoctor
//
//  Created by cnzhao on 13-4-14.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WidthRate (24/30.0)
#define HeightRate (26/30.0)

@interface LineGraphicsBaseView : UIView

- (CGRect)gridRect;

- (CGRect)dataRect;

- (CGRect)leftStringRect;

- (CGRect)buttomStringRect;

- (CGRect)rightStringRect;
@end
