//
//  TabButton.m
//  TaxiSeeker
//
//  Created by cnzhao on 13-6-1.
//  Copyright (c) 2013年 glacier. All rights reserved.
//

#import "TabButton.h"

@implementation TabButton
{
    IBOutlet UIImageView *_tabImg;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [_tabImg setHighlighted:highlighted];
}

@end
