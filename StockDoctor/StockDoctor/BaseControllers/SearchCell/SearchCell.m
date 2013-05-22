//
//  SearchCell.m
//  StockDoctor
//
//  Created by cnzhao on 13-4-9.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _selectImg.highlighted = highlighted;
}
@end
