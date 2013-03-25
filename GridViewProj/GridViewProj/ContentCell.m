//
//  ContentCell.m
//  GridViewProj
//
//  Created by cnzhao on 13-3-25.
//  Copyright (c) 2013年 cnzhao. All rights reserved.
//

#import "ContentCell.h"

@implementation ContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        self.viewDict = dict;
    }
    return self;
}

- (void)addView:(UIView *)aView viewIndex:(int)index
{
    UIView * view = self.viewDict[@(index)];
    if (view)
    {
        [view removeFromSuperview];
    }
    CGRect rect = aView.frame;
    rect.origin.x = index * self.subViewWith;
    rect.size.width = self.subViewWith;
    aView.frame = rect;
    [self.contentView addSubview:aView];
    [self.viewDict setObject:aView forKey:@(index)];
}

- (id)findView:(int)index
{
    return self.viewDict[@(index)];
}
@end
