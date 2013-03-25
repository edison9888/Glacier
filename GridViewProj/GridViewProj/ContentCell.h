//
//  ContentCell.h
//  GridViewProj
//
//  Created by cnzhao on 13-3-25.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCell : UITableViewCell
@property (nonatomic,retain) NSMutableDictionary * viewDict;
@property (nonatomic,assign) CGFloat subViewWith;
- (void)addView:(UIView *)view viewIndex:(int)index;
- (id)findView:(int)index;
@end
